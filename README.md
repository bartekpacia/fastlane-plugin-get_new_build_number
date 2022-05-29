# get_new_build_number plugin

[![fastlane Plugin
Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-get_new_build_number)

I've often found myself wanting to assign

Every service provides app's build number in a bit different format, which makes
the job annoying.

This is my take at automating this.

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To
get started with `fastlane-plugin-get_new_build_number`, add it to your project
by running:

```bash
fastlane add_plugin get_new_build_number
```

## About get_new_build_number

Retrieves the new build number for your app.

This plugin provides a single action, `get_new_build_number`. For now, see
source code to learn how to use it. I might write some docs later.

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this
plugin. Try it by cloning the repo, running `fastlane install_plugins` and
`bundle exec fastlane test`.

**Note to author:** Please set up a sample project to make it easy for users to
explore what your plugin does. Provide everything that is necessary to try out
the plugin in this project (including a sample Xcode/Android project if
necessary)

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use

```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this
repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins
Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/)
guide.
