require 'fastlane/action'
require 'tmpdir'

require_relative '../helper/get_new_build_number_helper'

module Fastlane
  module Actions
    class GetNewBuildNumberAction < Action
      def self.run(params)
        print_summary(params)

        use_temp_build_number = params[:use_temp_build_number] || true
        file_path = temp_file_path

        latest_build_number = use_temp_build_number ? fetch_or_create_temp_build_number(file_path, params) : fetch_build_number(params)

        validate_and_increment_build_number(latest_build_number)
      end

      def self.print_summary(params)
        FastlaneCore::PrintTable.print_values(
          config: params,
          title: "Summary for GetNewBuildNumber #{GetNewBuildNumber::VERSION}"
        )
      end

      def self.temp_file_path
        File.join(Dir.tmpdir, "latest_build_number.txt")
      end

      def self.fetch_or_create_temp_build_number(file_path, params)
        if File.exist?(file_path)
          UI.message("Found temporary build number file at: #{file_path}")
          File.read(file_path).to_i
        else
          UI.important("Temporary file not found. Retrieving new build number.")
          create_temp_build_number(file_path, params)
        end
      end

      def self.create_temp_build_number(file_path, params)
        latest_build_number = fetch_build_number(params)
        File.write(file_path, "#{latest_build_number}\n")
        UI.message("Saved build number #{latest_build_number} to: #{file_path}")
        latest_build_number
      end

      def self.fetch_build_number(params)
        Helper::GetNewBuildNumberHelper.get_latest_build_number_from_params(params)
      end

      def self.validate_and_increment_build_number(latest_build_number)
        if latest_build_number.is_a?(Integer)
          new_build_number = latest_build_number + 1
          UI.success("New build number (latest + 1): #{new_build_number}")
          new_build_number
        else
          UI.error("Invalid build number (not an Integer): #{latest_build_number}")
          nil
        end
      end

      def self.description
        "Retrieves the new build number for your app."
      end

      def self.authors
        ["Bartek Pacia"]
      end

      def self.return_value
        "An integer representing a new build number, calculated as the latest build number plus one."
      end

      def self.details
        "Fetches the latest build number from multiple services and increments it by 1."
      end

      def self.available_options
        [
          config_item(:bundle_identifier, "iOS bundle identifier"),
          config_item(:package_name, "Android package name"),
          config_item(:google_play_json_key_path, "Path to the Google Play Android Developer JSON key"),
          config_item(:app_store_initial_build_number, "Build number to use if there's nothing in App Store"),
          config_item(:firebase_json_key_path, "Path to the Firebase Admin JSON key"),
          config_item(:firebase_app_ios, "Firebase iOS app ID"),
          config_item(:firebase_app_android, "Firebase Android app ID"),
          config_item(:use_temp_build_number, "Cache the build number across multiple runs of this action", type: Boolean)
        ]
      end

      def self.config_item(key, description, type: String, optional: true)
        FastlaneCore::ConfigItem.new(
          key: key,
          env_name: key.to_s.upcase,
          description: description,
          optional: optional,
          type: type
        )
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
