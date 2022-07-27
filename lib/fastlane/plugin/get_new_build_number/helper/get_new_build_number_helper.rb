require 'fastlane_core/ui/ui'
require 'tmpdir'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?(:UI)

  module Helper
    class GetNewBuildNumberHelper
      def self.get_latest_build_number(
        bundle_identifier: nil,
        package_name: nil,
        google_play_json_key_path: nil,
        app_store_initial_build_number: nil,
        firebase_json_key_path: nil,
        firebase_app_ios: nil,
        firebase_app_android: nil
      )
        if bundle_identifier.nil? && package_name.nil?
          UI.error("Both bundle_identifier and package_name are nil")
          return nil
        end

        if package_name.nil? && google_play_json_key_path.nil?
          UI.error("Both package_name and google_play_json_key_path are nil")
          return nil
        end

        app_store_build_number = 0
        unless bundle_identifier.nil?
          app_store_build_number = Fastlane::Actions::AppStoreBuildNumberAction.run(
            app_identifier: bundle_identifier,
            platform: "IOS",
            initial_build_number: app_store_initial_build_number || 1
          )

          UI.message("Latest build number (App Store): #{app_store_build_number}")
        end

        google_play_build_number_prod = get_google_play_build_number(
          track: "production",
          package_name:,
          json_key: google_play_json_key_path
        )

        google_play_build_number_beta = get_google_play_build_number(
          track: "beta",
          package_name:,
          json_key: google_play_json_key_path
        )

        google_play_build_number_alpha = get_google_play_build_number(
          track: "alpha",
          package_name:,
          json_key: google_play_json_key_path
        )

        google_play_build_number_internal = get_google_play_build_number(
          track: "internal",
          package_name:,
          json_key: google_play_json_key_path
        )

        google_play_build_number = [
          google_play_build_number_prod,
          google_play_build_number_beta,
          google_play_build_number_alpha,
          google_play_build_number_internal
        ].max

        UI.message("Latest build number (Google Play Store): #{google_play_build_number}")
        
        fad_build_number_ios = 0
        begin
          unless firebase_app_ios.nil?
            response = Fastlane::Actions::FirebaseAppDistributionGetLatestReleaseAction.run(
              app: firebase_app_ios,
              service_credentials_file: firebase_json_key_path
            )

            unless response.nil?
              fad_build_number_ios = response[:buildVersion].to_i
            end

            UI.message("Latest build (Firebase App Distribution iOS): #{fad_build_number_ios}")
          end
        rescue StandardError => e
          UI.error("Error getting latest build number (Firebase App Distribution iOS): #{e.message}")
        end

        fad_build_number_android = 0
        begin
          unless firebase_app_android.nil?
            response = Fastlane::Actions::FirebaseAppDistributionGetLatestReleaseAction.run(
              app: firebase_app_android,
              service_credentials_file: firebase_json_key_path
            )

            unless response.nil?
              fad_build_number_android = response[:buildVersion].to_i
            end

            UI.message("Latest build (Firebase App Distribution Android): #{fad_build_number_android}")
          end
        rescue StandardError => e
          UI.error("Error getting latest build number (Firebase App Distribution Android): #{e.message}")
        end

        return [
          app_store_build_number,
          google_play_build_number,
          fad_build_number_ios,
          fad_build_number_android
        ].max
      end

      # Returns the latest build number ("version code", in Android terminology)
      # for the given Google Play track.
      def self.get_google_play_build_number(track:, package_name:, json_key:)
        begin
          codes = Fastlane::Actions::GooglePlayTrackVersionCodesAction.run(
            track:,
            package_name:,
            json_key:
          )

          return codes.max
        rescue StandardError
          UI.message("No build numbers found for track #{track} (Google Play Store)")
          return 0
        end
      end

      # TODO: Don't duplicate so much code
      # def self.get_firebase_app_distribution_build_number()
    end
  end
end
