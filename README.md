# I/O FLIP

[![I/O FLIP Header][logo]][io_flip_link]

[![io_flip][build_status_badge]][workflow_link]
![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

An AI-designed card game built with [Flutter][flutter_link] and [Firebase][firebase_link] for [Google I/O 2023][google_io_link].

[Try it now][io_flip_link] and [learn about how it's made][how_its_made].

_Built by [Very Good Ventures][very_good_ventures_link] in partnership with Google_

_Created using [Very Good CLI][very_good_cli_link] 🤖_

---

## Getting Started 🚀

This project contains 3 flavors:

- development
- staging
- production

To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
# Development
$ flutter run --flavor development --target lib/main_development.dart

# Staging
$ flutter run --flavor staging --target lib/main_staging.dart

# Production
$ flutter run --flavor production --target lib/main_production.dart
```

_\*I/O FLIP works on Web for desktop and mobile._

## Loading initial data into database

Check [the data loader docs](api/tools/data_loader) for documentation on how the initial data is loaded.

## Running the loading testing bot locally

[Flop](./flop) is a loading testing bot written in Flutter that runs on web meant to help testing
the scaling of the backend of the game.

To execute it in the staging environment, open a terminal an execute:

```bash
./scripts/start_flop_webserver.sh <ENCRYPTION_KEY> <ENCRYPTION_IV> <RECAPTCHA_KEY> <APPCHECK_DEBUG_TOKEN>
```

You will be able to open the url where Flop started and check the progress of the bot run.

Which page represents one instance of Flop, to start several instance at the same time,
the `scripts/spam_flop.sh` can be used, this scripts needs to receive the port where Flop
started, so assuming that flop is running on `http://localhost:54678`, run:

```bash
./scripts/spam_flop.sh 54678
```

The same can be accomplished by using the `army.html` page that is bundled in the in it.
When loaded you will be able to select how many Flop instances to load, and it is also possible
to autoload instances of the bot by adding a # with the number of desired bots to spawn.

---

## Running Tests 🧪

To run all unit and widget tests use the following command:

```sh
$ flutter test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

---

## Working with Translations 🌐

This project relies on [flutter_localizations][flutter_localizations_link] and follows the [official internationalization guide for Flutter][internationalization_link].

### Adding Strings

1. To add a new localizable string, open the `app_en.arb` file at `lib/l10n/arb/app_en.arb`.

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

2. Then add a new key/value and description

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    },
    "helloWorld": "Hello World",
    "@helloWorld": {
        "description": "Hello World Text"
    }
}
```

3. Use the new string

```dart
import 'package:io_flip/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.helloWorld);
}
```

### Adding Supported Locales

Update the `CFBundleLocalizations` array in the `Info.plist` at `ios/Runner/Info.plist` to include the new locale.

```xml
    ...

    <key>CFBundleLocalizations</key>
	<array>
		<string>en</string>
		<string>es</string>
	</array>

    ...
```

### Adding Translations

1. For each supported locale, add a new ARB file in `lib/l10n/arb`.

```
├── l10n
│   ├── arb
│   │   ├── app_en.arb
│   │   └── app_es.arb
```

2. Add the translated strings to each `.arb` file:

`app_en.arb`

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

`app_es.arb`

```arb
{
    "@@locale": "es",
    "counterAppBarTitle": "Contador",
    "@counterAppBarTitle": {
        "description": "Texto mostrado en la AppBar de la página del contador"
    }
}
```

[build_status_badge]: https://github.com/VGVentures/top_dash/actions/workflows/main.yaml/badge.svg
[coverage_badge]: coverage_badge.svg
[firebase_link]: https://firebase.google.com/
[flutter_link]: https://flutter.dev
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[google_io_link]: https://io.google/2023/
[how_its_made]: https://flutter.dev/flip
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[io_flip_link]: https://flip.withgoogle.com/
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[logo]: art/readme_header.png
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
[very_good_ventures_link]: https://verygood.ventures/
[workflow_link]: https://github.com/VGVentures/top_dash/actions/workflows/main.yaml
