# get_new_build_number plugin

[![fastlane Plugin Badge][fastlane-plugin-badge]][fastlane-plugin]

I've often found myself wanting to _just assign new build number_ to my apps.
This simple task turns out to be harder that it seems at first. There's a
production build number (on App Store and Google Play), you might also have
separate build numbers for beta, alpha, and other versions of your app.

Fortunately, all of these services provide fastlane actions to get the latest
build number.

Unfortunately, every service provides app's build number in a bit different
format, which makes it not-so-straightforward to get the latest-latest version
number.

This is my take at automating this.

Supported services:

- [x] App Store (via [app_store_build_number][app-store])
- [x] TestFlight (via [latest_testflight_build_number][testflight])
- [x] Google Play (via [google_play_track_version_codes][google-play])
- [x] Firebase App Distribution (via
      [firebase_app_distribution_get_latest_release][fad])
- [ ] App Center (via [appcenter_fetch_version_number][app-center])

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To
get started with `fastlane-plugin-get_new_build_number`, add it to your project
by running:

```
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

[fastlane-plugin-badge]: https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg
[fastlane-plugin]: https://rubygems.org/gems/fastlane-plugin-get_new_build_number
[app-store]: https://docs.fastlane.tools/actions/app_store_build_number
[testflight]: https://docs.fastlane.tools/actions/latest_testflight_build_number
[google-play]: https://docs.fastlane.tools/actions/google_play_track_version_codes
[fad]: https://github.com/fastlane/fastlane-plugin-firebase_app_distribution/blob/master/lib/fastlane/plugin/firebase_app_distribution/actions/firebase_app_distribution_get_latest_release.rb
[app-center]: https://github.com/microsoft/fastlane-plugin-appcenter/blob/master/lib/fastlane/plugin/appcenter/actions/appcenter_fetch_version_number.rb
