require 'fastlane_core/ui/ui'
require 'tmpdir'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class GetNewBuildNumberHelper

      def self.get_highest_build_number(
        bundle_identifier:nil,
        package_name:nil,
        google_play_json_key_path:nil,
        firebase_json_key_path:nil,
        firebase_app_ios:nil,
        firebase_app_android:nil
      )
        if bundle_identifier.nil? && package_name.nil?
          UI.error "Both bundle_identifier and package_name are nil"
          return nil
        end

        if package_name.nil? && google_play_json_key_path.nil?
          UI.error "Both package_name and google_play_json_key_path are nil"
          return nil
        end

        app_store_build_number = 0
        unless bundle_identifier.nil?
          app_store_build_number = Fastlane::Actions::AppStoreBuildNumberAction.run(
            app_identifier: bundle_identifier,
            platform: "IOS",
          )  

          UI.message "build number (App Store): #{app_store_build_number}"
        end

        google_play_build_number_prod = get_version_code(
          track: "production",
          package_name: package_name,
          json_key: google_play_json_key_path,
        )

        google_play_build_number_beta = get_version_code(
          track: "beta",
          package_name: package_name,
          json_key: google_play_json_key_path,
        )

        google_play_build_number_alpha = get_version_code(
          track: "alpha",
          package_name: package_name,
          json_key: google_play_json_key_path,
        )

        google_play_build_number_internal = get_version_code(
          track: "internal",
          package_name: package_name,
          json_key: google_play_json_key_path,
        )

        google_play_build_number = [
          google_play_build_number_prod,
          google_play_build_number_beta,
          google_play_build_number_alpha,
          google_play_build_number_internal,
        ].max

        UI.message "build number (Google Play Store): #{google_play_build_number}"

        fad_build_number_ios = 0
        unless firebase_app_ios.nil?
          fad_build_number_ios = Fastlane::Actions::FirebaseAppDistributionGetLatestReleaseAction.run(
            app: firebase_app_ios,
            service_credentials_file: firebase_json_key_path,
          )[:buildVersion].to_i
          
          UI.message "build number (Firebase App Distribution iOS): #{fad_build_number_ios}"
        end

        fad_build_number_android = 0
        unless firebase_app_android.nil?
          fad_build_number_android = Fastlane::Actions::FirebaseAppDistributionGetLatestReleaseAction.run(
            app: firebase_app_android,
            service_credentials_file: firebase_json_key_path,
          )[:buildVersion].to_i

          UI.message "build number (Firebase App Distribution Android): #{fad_build_number_android}"
        end

        return [
          app_store_build_number,
          google_play_build_number,
          fad_build_number_ios,
          fad_build_number_android,
        ].max
      end

      # Returns highest build number for the given track.
      def self.get_version_code(track:, package_name:, json_key:)
        begin
          codes = Fastlane::Actions::GooglePlayTrackVersionCodesAction.run(
            track: track,
            package_name: package_name,
            json_key: json_key,
          )

          return codes.max
        rescue
          UI.message "Version code not found for track #{track}"
          return 0
        end
      end
    end
  end
end
