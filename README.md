# Lokalise Flutter SDK

The `lokalise_flutter_sdk` package provides support for over-the-air translation updates from 
[lokalise.com](https://lokalise.com).


### Features
- `.arb` to `.dart` file processor, inspired by and following in the footsteps of `flutter gen-l10n`.
- Custom localization class based on `AppLocalizations` by `flutter gen-l10n` for seamless replacement.
- Over-The-Air functionality to deliver your text updates faster.

> 📘 Note on `.arb` file management
>
> This SDK does not cover managing (downloading and uploading) the `.arb` files. For that,
> we recommend our [Lokalise CLIv2](https://github.com/lokalise/lokalise-cli-2-go).

### Getting started
You need to have a working Flutter project.
To get started with Flutter internationalization, check out 
[the official documentation](https://docs.flutter.dev/development/accessibility-and-localization/internationalization).

Enabling the Over-The-Air functionality in your project requires the following actions:
1. [Prepare your Lokalise project](https://developers.lokalise.com/docs/flutter-sdk).
2. [Prepare your Flutter project](#preparing-your-flutter-project).
3. [Integrate the SDK into your application](#integrating-the-sdk-in-your-app).


## Preparing your Flutter project

### 1. Update `pubspec.yaml`

Add the `intl` and `lokalise_flutter_sdk` packages to the `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:        # Add this line
    sdk: flutter                # Add this line   
  intl: any                     # Add this line 
  lokalise_flutter_sdk: ^1.3.0  # Add this line
```

And enable the `generate` flag, it is found in the flutter section:
```yaml
# The following section is specific to Flutter.
flutter:
  generate: true # Add this line
```
> 📘 `generate` flag clarification
>
> The `generate` flag is required for enabling the `synthetic-package` customization 
> option. For more information on how to use this option, please refer to the customization
> section below.

### 2. Add the `.arb` files to the `lib/l10n/` directory

Add the ARB files to the `lib/l10n/` directory of your Flutter project. We recommend that 
you download them from Lokalise. 

On the Download section, select the `Flutter (.arb)` format, enable the
`File structure` -> `One file per language. Bundle structure:` option,
and set the value to `intl_%LANG_ISO%.%FORMAT%`.

`Flutter` is considered to be an `Other` platform on Lokalise. Therefore, assign your
keys appropriately to the `Other` platform
([learn how](https://docs.lokalise.com/en/articles/1400489-keys-and-platforms#assigning-platforms)).

> 📘 Example `.arb` file for test purposes
> 
> For testing purposes, you can manually add an `intl_en.arb` file. For example:
> 
> ```arb
> {
>    "@@locale": "en",
>    "helloWorld": "Hello World!",
>    "@helloWorld": {
>      "description": "The conventional newborn programmer greeting"
>    },
>    "title": "Yes, this is a title!"
> }
> ```
> 
> Add one ARB file for each locale that you need to support in your Flutter app.
> Name them using the following pattern: `intl_LOCALE.arb`. Here's an example of using
> an `intl_es.arb` file:
> 
> ```arb
> {
>    "helloWorld": "¡Hola Mundo!"
> }
> ```

### 3. Set up the project and generate `.dart` files

Install dependencies by running:
```
flutter pub get
```

Generate the `.dart` files from the provided `.arb` files:
```
dart run lokalise_flutter_sdk:gen-lok-l10n
```

You should see the generated files in the `lib/l10n/generated/` directory.


## Integrating the SDK in your app

The package provides `Lokalise` and `Lt` classes. The `Lt` class is generated and
the name is customizable.

`Lt` is used to:
- Configure the localization in the app using `Lt.delegate`, `Lt.supportedLocales` 
and `Lt.localizationsDelegates` parameters.
- Retrieve the translations using `Lt.of(context)` calls.

`Lokalise` is used to:
- Configure a Lokalise project to use with the help of the `Lokalise.init` method.
- Retrieve the latest translations using the `Lokalise.instance.update()` method.

### 1. Import all necessary packages and classes
```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lokalise_flutter_sdk/lokalise_flutter_sdk.dart';
import 'l10n/generated/l10n.dart';
```

### 2. Configure the Lokalise project in the `main` function
```dart
void main() async { // Due to some implementation details, we require the `main` function to be `async`.
    WidgetsFlutterBinding.ensureInitialized();
    await Lokalise.init(
        projectId: 'Project ID',
        sdkToken: 'Lokalise SDK Token', // Make sure that the `sdkToken` is an SDK token (not an API token or JWT).
        preRelease: true, // Add this only if you want to use prereleases. Use the Bundle freeze functionality in production
    );
    runApp(const MyApp());
}
```

### 3. Configure localization in the app widget
```dart
class MyApp extends StatelessWidget {
    const MyApp({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Lokalise SDK',
            theme: ThemeData(
                primarySwatch: Colors.blue,
            ),
            home: const MyHomePage(),
            // You can use  Lt.localizationsDelegates for shorter declaration of localizationsDelegates
            localizationsDelegates: const [ 
              Lt.delegate, // This adds Lt to the delegate call stack
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: Lt.supportedLocales, // This lists supported locales based on available languages in the generated `.dart` files
        );
    }
}
```

### 4. Add the `Lokalise.instance.update()` call to your initial page
```dart
class MyHomePage extends StatefulWidget {
    const MyHomePage({Key? key}) : super(key: key);

    @override
    State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = true;

    @override
    void initState() {
        super.initState();
        Lokalise.instance.update().then( // This is an async call, handle it appropriately
            (_) => setState(() => _isLoading = false),
            onError: (error) => setState(() => _isLoading = false),
        );
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(Lt.of(context).title),
            ),
            body: Center(
              child: _isLoading 
                ? const CircularProgressIndicator() 
                : Center(
                    child: Text(Lt.of(context).helloWorld),
            )),
        );
    }
}
```

### 5. (Optional) Updating translations on app resume.
We recommend updating translations every time the app resumes from the background,
to achieve that, you can use the `WidgetsBindingObserver` class implementing 
`didChangeAppLifecycleState` method. This will complement the previous step of updating 
translations on the app start.

```dart
class MyHomePage extends StatefulWidget {
    const MyHomePage({Key? key}) : super(key: key);

    @override
    State<MyHomePage> createState() => _MyHomePageState();
}

// Add mixin WidgetsBindingObserver
class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
    bool _isLoading = true;

    @override
    void initState() {
        super.initState();
        // Add this as observer
        WidgetsBinding.instance.addObserver(this);
        _updateTranslations();
    }

    void _updateTranslations() {
        setState(() => _isLoading = true);
        // Ensures the application has the latest translations
        Lokalise.instance.update().then(
            (_) => setState(() => _isLoading = false),
            onError: (error) => setState(() => _isLoading = false),
            );
    }

    @override
    void didChangeAppLifecycleState(AppLifecycleState state) { //
        super.didChangeAppLifecycleState(state);
        // Update translations on resume event
        if (state == AppLifecycleState.resumed) { 
            _updateTranslations();
        }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(Lt.of(context).title), // Gets the translation
            ),
            body: Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Center(
                        child: Text(Lt.of(context).helloWorld), // Gets the translation
                    ),
            ),
        );
    }
}
```

### The resulting app

> 📘 Sample app
>
> You can also find a sample Flutter app with the integrated SDK 
> [on GitHub](https://github.com/lokalise/apps/tree/main/examples/flutter-ota).

Here's a full example that demonstrates usage of the Flutter SDK (important 
lines are marked with comments):
```dart
import 'package:flutter/material.dart';
import 'package:lokalise_flutter_sdk/lokalise_flutter_sdk.dart'; // Imports the SDK
import 'l10n/generated/l10n.dart'; // Imports the generated Lt class

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Configures the SDK
    await Lokalise.init(
        projectId: 'Project ID',
        sdkToken: 'Lokalise SDK Token',
        // Add this only if you want to use prereleases. Use the Bundle freeze functionality in production
        preRelease: true,
    );
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Lokalise SDK',
            theme: ThemeData(
                primarySwatch: Colors.blue,
            ),
            home: const MyHomePage(),
            localizationsDelegates: Lt.localizationsDelegates,
            supportedLocales: Lt.supportedLocales,
        );
    }
}

class MyHomePage extends StatefulWidget {
    const MyHomePage({Key? key}) : super(key: key);

    @override
    State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
    bool _isLoading = true;

    @override
    void initState() {
        super.initState();
        WidgetsBinding.instance.addObserver(this);
        _updateTranslations();
    }

    void _updateTranslations() {
        setState(() => _isLoading = true);
        // Ensures the application has the latest translations
        Lokalise.instance.update().then(
            (_) => setState(() => _isLoading = false),
            onError: (error) => setState(() => _isLoading = false),
        );
    }

    @override
    void didChangeAppLifecycleState(AppLifecycleState state) {
        super.didChangeAppLifecycleState(state);
        if (state == AppLifecycleState.resumed) {
            _updateTranslations();
        }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(Lt.of(context).title), // Gets the translation
            ),
            body: Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Center(
                        child: Text(Lt.of(context).helloWorld), // Gets the translation
                    ),
            ),
        );
    }
}
```

> 📘 Note on updating local translations
>
> After the translations have been changed (`lib/l10n/intl_LOCALE.arb`), use the 
> `dart run lokalise_flutter_sdk:gen-lok-l10n` command to regenerate the Dart classes.


## Testing
To write your test cases without the need to save data or perform API calls, simply 
initialize the SDK at the beginning of the test using the initMock method.
```dart
await Lokalise.initMock();
``` 

This initializer allows for mocking the SDK results through two optional parameters:
- `cachedBundleTranslations`: Simulates a previously downloaded bundle that 
overwrites specified translations.
- `remoteBundleTranslations`: Simulates a newly downloaded bundle during the translation
update process, overwriting the specified translations.

For example:
```dart
await Lokalise.initMock(
    cachedBundleTranslations: {
        const Locale('en'): {'hello': 'Hello world'},
        const Locale('es'): {'hello': 'Hola mundo'},
    },
    remoteBundleTranslations: {
        const Locale('en'): {'hello': 'Hello world 2'},
        const Locale('es'): {'hello': 'Hola mundo 2'},
    },
);
```


## Customization
You can configure the `gen-lok-l10n` tool by adding a `lok-l10n.yaml` file in 
the root folder of your project, it allows you to specify the following:

- `output-class`: The Dart class name to use for the output localization and 
localizations delegate classes. The default is `Lt`.
- `arb-dir`: The directory where the template and translated arb files are located. 
The default is `lib/l10n`.
- `output-dir`: The directory where the generated localization classes are written.
This option is only relevant if you want to generate the localizations code somewhere 
else in the Flutter project (ignored if `synthetic-package` is true). If it is not 
specified the defaults directory is `{arb-dir}/generated`.
- `output-localization-file`: The filename for the output localization and localizations
delegate classes. The default is `l10n.dart`.
- `synthetic-package`: Determines whether or not the generated output files will be 
generated as a synthetic package or at a specified directory in the Flutter project 
(to use  this option is required to enable the `generate` flag in your pubspec 
file). This flag is `false` by default.
  - if it is `false`, the files will be generated in the directory specified by 
  `output-dir` (check the behaviour of this property defined above). 
  - If it is `true`, the files will be created in a synthetic package located at
  `.dart_tool/flutter_gen/gen-l10n`. To use them, use
  `import 'package:flutter_gen/gen_l10n/l10n.dart';`.
- `template-arb-file`: The template arb file that is used as the basis for generating 
the Dart localization and messages files. The default is `intl_en.arb`.
- `preferred-supported-locales`: The list of preferred supported locales for the application.
It modifies the order of locales in the `supportedLocales` property (learn about its 
importance [here](https://api.flutter.dev/flutter/material/MaterialApp/supportedLocales.html)).
By default, the tool generates the supported locales list alphabetically, always keeping `en` 
as the primary language.

For example:
```yaml
output-class: MyCustomClassName
arb-dir: lokalise/l10n
output-dir: lokalise/l10n/custom
output-localization-file: localizations.dart
preferred-supported-locales: [ en_US ]
```


## Additional details

### Bundle freeze

To use the bundle freeze functionality, the SDK uses the `version` key from the 
`pubspec.yaml` located in the Flutter project root.

Given a `version: 1.2.3+4` value, `1.2.3` is extracted and passed to the OTA server.

### Limitations and known issues
You can check the limitations and workarounds for known issues 
[here](https://developers.lokalise.com/docs/flutter-sdk-limitations-and-workarounds).

## License

This plugin is licensed under the 
[BSD 3 Clause License](https://github.com/lokalise/lokalise-flutter-sdk/blob/master/LICENSE).

Copyright (c) [Lokalise team](https://lokalise.com).
