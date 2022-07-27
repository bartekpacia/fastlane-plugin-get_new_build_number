require 'fastlane/action'

module Fastlane
  module Actions
    class GetNewBuildNameAction < Action
      def self.run(params)
        build_name = sh("git describe --tags --abbrev=0 | cut -c 2-").strip
        UI.success("New build name: #{build_name}")
        return build_name
      end

      def self.description
        "Retrieves the new build number for your app."
      end

      def self.authors
        ["Bartek Pacia"]
      end

      def self.return_value
        "A string representing a new build name. It's the latest git tag with the first " \
          "character stripped (so v4.2.0 becomes 4.2.0)"
      end
    end
  end
end
