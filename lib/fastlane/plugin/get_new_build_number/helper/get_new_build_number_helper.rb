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
        firebase_json_key_path: nil,
        firebase_app_ios: nil,
        firebase_app_android: nil,
        appcenter_app_owner: nil,
        appcenter_app_name: nil
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
          app_store_build_number = get_appstore_build_number(
            app_identifier: bundle_identifier,
            platform: "IOS"
          )

          UI.message("Latest build number (App Store): #{app_store_build_number}")
        end

        google_play_build_number_prod = 0
        google_play_build_number_beta = 0
        google_play_build_number_alpha = 0
        google_play_build_number_internal = 0
        google_play_build_number_prod = get_google_play_build_number(
          track: "production",
          package_name: package_name,
          json_key: google_play_json_key_path
        )

        google_play_build_number_beta = get_google_play_build_number(
          track: "beta",
          package_name: package_name,
          json_key: google_play_json_key_path
        )

        google_play_build_number_alpha = get_google_play_build_number(
          track: "alpha",
          package_name: package_name,
          json_key: google_play_json_key_path
        )

        google_play_build_number_internal = get_google_play_build_number(
          track: "internal",
          package_name: package_name,
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
        unless firebase_app_ios.nil?
          fad_build_number_ios = get_fad_build_number(
            app: firebase_app_ios,
            service_credentials_file: firebase_json_key_path
          )

          UI.message("Latest build (Firebase App Distribution iOS): #{fad_build_number_ios}")
        end

        fad_build_number_android = 0
        unless firebase_app_android.nil?
          fad_build_number_android = get_fad_build_number(
            app: firebase_app_android,
            service_credentials_file: firebase_json_key_path
          )

          UI.message("Latest build (Firebase App Distribution Android): #{fad_build_number_android}")
        end

        appcenter_build_number = 0
        unless appcenter_app_owner.nil? && appcenter_app_name.nil?
          appcenter_build_number = get_appcenter_build_number(
            app_name: appcenter_app_name,
            app_owner: appcenter_app_owner
          )
        end

        return [
          app_store_build_number,
          google_play_build_number,
          fad_build_number_ios,
          fad_build_number_android,
          appcenter_build_number
        ].max
      end

      def self.get_appstore_build_number
        build_number = Fastlane::Actions::AppStoreBuildNumberAction.run(
          app_identifier: bundle_identifier,
          platform: "IOS"
        )

        return build_number
      end

      def self.get_fad_build_number(app:, service_credentials_file:)
        build_number = Fastlane::Actions::FirebaseAppDistributionGetLatestReleaseAction.run(
          app: app,
          service_credentials_file: service_credentials_file
        )[:buildVersion].to_i

        return build_number
      end

      def self.get_appcenter_build_number(
        app_name:,
        owner_name:,
        version:
      )

        data = Fastlane::Actions::AppcenterFetchVersionNumberAction.run(
          app_name: app_name,
          owner_name: owner_name,
          version: version
        )

        build_number = data["build_number"]

        return build_number
      rescue StandardError
        UI.message("No build number found for app #{app_name}")
        return 0
      end

      # Returns the latest build number ("version code", in Android terminology)
      # for the given Google Play track.
      def self.get_google_play_build_number(track:, package_name:, json_key:)
        codes = Fastlane::Actions::GooglePlayTrackVersionCodesAction.run(
          track: track,
          package_name: package_name,
          json_key: json_key
        )

        return codes.max
      rescue StandardError
        UI.message("No build numbers found for track #{track}")
        return 0
      end
    end
  end
end
