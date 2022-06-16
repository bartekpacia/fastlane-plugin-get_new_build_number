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

### Features

Supported services:

- [x] App Store (via [app_store_build_number][app-store])
- [x] TestFlight (via [latest_testflight_build_number][testflight])
- [x] Google Play (via [google_play_track_version_codes][google-play])
- [x] Firebase App Distribution (via
      [firebase_app_distribution_get_latest_release][fad])
- [ ] App Center (via [appcenter_fetch_version_number][app-center])

The _latest_ build number is persisted in
[$TMPDIR][ruby-tmpdir]`/latest_build_number.txt`, so you can use it across
`fastlane` invocations. For example, you could safely do:

```bash
$ cd ios && bundle exec fastlane prod && cd ..
$ cd android && bundle exec fastlane prod && cd ..
$ cd symbian && bundle exec fastlane prod && cd .. # lol
```

The first `fastlane` invocation retrieves the _latest_ build number. Then, the 2
subsequent invocations simply reuse the _latest_ build number from the file.

The _new_ build number is derived using this complex forumla:

```
new_build_number = latest_build_number + 1
```

## Usage

### Example 1

Simple use case. This will only take the latest version from Google Play. This
might not seem very useful at first, but is _is_ when you have different version
codes for different tracks (`production`, `beta`, `alpha`, `internal`).

Let's say that your Play Console looks like this:

- `production` is at version code `60`
- `beta` is at version code `61`
- `alpha` is at 2 version codes: `64` and `65` (becasue you're doing some fancy
  testing)

In this case, `get_new_build_number` action would return `66` (because it is
newer/higher/bigger than all the other build numbers).

```ruby
# android/fastlane/Fastfile

default_platform(:android)

platform :android do
  desc "Deploy a new beta version to Google Play"
  lane :beta do
    build_number = get_new_build_number(
      package_name: ENV["APP_PACKAGE_NAME"], # e.g com.example.yourapp
      google_play_json_key_path: ENV["GOOGLE_PLAY_JSON_KEY_PATH"], # path to JSON key for authenticating with Google Play Android Developer API
    ).to_s

    build_android_app(
      task: "bundleRelease",
      project_dir: "..",
      properties: {
        "android.injected.version.code" => build_number,
      },
    )

    upload_to_play_store(
      track: "beta",
      aab: "./build/outputs/bundle/release/android-release.aab",
      json_key: ENV["GOOGLE_PLAY_JSON_KEY_PATH"],
    )
  end
end
```

### Example 2

If you provide more parameters, the plugin will take them into account. For
example, if you pass `bundle_identifier` to `get_new_build_number`:

```ruby
platform :android do
  desc "Deploy a new beta version to Google Play"
  lane :beta do
    build_number = get_new_build_number(
      bundle_identifier: ENV["APP_BUNDLE_ID"], # e.g com.example.yourApp
      package_name: ENV["APP_PACKAGE_NAME"], # e.g com.example.yourapp
      google_play_json_key_path: ENV["GOOGLE_PLAY_JSON_KEY_PATH"], # path to JSON key for authenticating with Google Play Android Developer API
    ).to_s

    build_android_app(
      task: "bundleRelease",
      project_dir: "..",
      properties: {
        "android.injected.version.code" => build_number,
      },
    )

    upload_to_play_store(
      track: "beta",
      aab: "./build/outputs/bundle/release/android-release.aab",
      json_key: ENV["GOOGLE_PLAY_JSON_KEY_PATH"],
    )
  end
end
```

then also build numbers in App Store will be taken into account.

Building on the previous example, let's say that your Play Console looks like
this (same as before):

- `production` is at version code `60`
- `beta` is at version code `61`
- `alpha` is at 2 version codes: `64` and `65` (becasue you're doing some fancy
  testing)

And let's say that you App Store looks like this:

- production is live at version code `81`

In this case, `get_new_build_number` action would return `82` (because it is
newer/higher/bigger than all the other build numbers). Of course, you have to be
authenticated to App Store using
[app_store_connect_api_key][app-store-connect-api-key].

This makes it easy to keep version codes in sync in your app across different
app stores.

### Important note

Please note that this action is simple and has no protection against concurrent
builds. Is is probably unsafe to use in an environment when many releases happen
in a short time frame.

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
[ruby-tmpdir]: https://ruby-doc.org/stdlib-2.5.1/libdoc/tmpdir/rdoc/Dir.html#method-c-tmpdir
[app-store]: https://docs.fastlane.tools/actions/app_store_build_number
[testflight]: https://docs.fastlane.tools/actions/latest_testflight_build_number
[google-play]: https://docs.fastlane.tools/actions/google_play_track_version_codes
[fad]: https://github.com/fastlane/fastlane-plugin-firebase_app_distribution/blob/master/lib/fastlane/plugin/firebase_app_distribution/actions/firebase_app_distribution_get_latest_release.rb
[app-center]: https://github.com/microsoft/fastlane-plugin-appcenter/blob/master/lib/fastlane/plugin/appcenter/actions/appcenter_fetch_version_number.rb
[app-store-connect-api-key]: https://docs.fastlane.tools/actions/app_store_connect_api_key
