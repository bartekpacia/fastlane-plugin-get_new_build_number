lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/get_new_build_number/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-get_new_build_number'
  spec.version       = Fastlane::GetNewBuildNumber::VERSION
  spec.author        = 'Bartek Pacia'
  spec.email         = 'barpac02@gmail.com'

  spec.summary       = 'Retrieves the new build number for your mobile app.'
  spec.homepage      = "https://github.com/bartekpacia/fastlane-plugin-get_new_build_number"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 3.1'

  # Don't add a dependency to fastlane or fastlane_re
  # since this would cause a circular dependency

  # spec.add_dependency 'your-dependency', '~> 1.0.0'

  spec.add_development_dependency('bundler')
  spec.add_development_dependency('fastlane', '>= 2.208.0')
  spec.add_development_dependency('pry')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('rspec_junit_formatter')
  spec.add_development_dependency('rubocop', '1.32.0')
  spec.add_development_dependency('rubocop-performance')
  spec.add_development_dependency('rubocop-require_tools')
  spec.add_development_dependency('simplecov')

  spec.add_dependency("fastlane-plugin-firebase_app_distribution")
  spec.metadata['rubygems_mfa_required'] = 'true'
end
