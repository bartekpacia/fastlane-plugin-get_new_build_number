require 'fastlane/action'
require 'tmpdir'

require_relative '../helper/get_new_build_number_helper'

module Fastlane
  module Actions
    class GetNewBuildNumberAction < Action
      def self.run(params)
        FastlaneCore::PrintTable.print_values(
          config: params,
          title: "Summary for get_new_build_number #{GetNewBuildNumber::VERSION}"
        )
        
        useTempBuildNumber = defined?(params[:use_temp_build_number]) ? params[:use_temp_build_number] : true
        file = File.join(Dir.tmpdir, "latest_build_number.txt")
        
        if useTempBuildNumber
          UI.message("Looking for temporary build number file at: #{file}")
          if File.exist?(file)
            UI.message("Found temporary build number file")
            latest_build_number = File.read(file).to_i
          else 
            UI.important("File with new build number does not exist. New build number will be " \
                         "retrieved and temporary file with it will be created.")
            latest_build_number = Helper::GetNewBuildNumberHelper.get_latest_build_number_from_params(
              params
            )
  
            File.open(file, "w") do |f|
              f.write("#{latest_build_number}\n")
              UI.message("Wrote #{latest_build_number} to #{file}")
            end
          end
        else
          latest_build_number = Helper::GetNewBuildNumberHelper.get_latest_build_number_from_params(
            params
          )
        end

        UI.message("Latest build number: #{latest_build_number}")

        if latest_build_number.kind_of?(Integer)
          new_latest_build_number = latest_build_number + 1
          UI.success("New build number (latest + 1): #{new_latest_build_number}")
          return new_latest_build_number
        else
          UI.error("Latest build number is not an Integer (#{latest_build_number})")
          return nil

        end
      end

      def self.description
        "Retrieves the new build number for your app."
      end

      def self.authors
        ["Bartek Pacia"]
      end

      def self.return_value
        "An integer representing a new build number. It's the latest build " \
          "number collected from all services (e.g App Store, Google Play, App " \
          "Center) plus 1."
      end

      def self.details
        # Optional:
        ""
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :bundle_identifier,
            env_name: "APP_BUNDLE_ID",
            description: "iOS bundle identifier",
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :package_name,
            env_name: "APP_PACKAGE_NAME",
            description: "Android package name",
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :google_play_json_key_path,
            env_name: "GOOGLE_PLAY_JSON_KEY_PATH",
            description: "Path to the Google Play Android Developer JSON key",
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :app_store_initial_build_number,
            env_name: "APP_STORE_INITIAL_BUILD_NUMBER",
            description: "Build number to use if there's nothing in App Store",
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :firebase_json_key_path,
            env_name: "FIREBASE_JSON_KEY_PATH",
            description: "Path to the Firebase Admin JSON key",
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :firebase_app_ios,
            env_name: "FIREBASE_APP_IOS",
            description: "Firebase iOS app ID",
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :firebase_app_android,
            env_name: "FIREBASE_APP_ANDROID",
            description: "Firebase Android app ID",
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :use_temp_build_number,
            env_name: "USE_TEMP_BUILD_NUMBER",
            description: "Cache the build number across multiple runs of this action",
            optional: true,
            type: Boolean
          )
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
