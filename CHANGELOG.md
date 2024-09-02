## 1.3.2
### Fixes
- Fixed an issue that produce an error log on web platform

### Reminder
- On next major release the SDK will require Dart 3 and Flutter 3


## 1.3.1
### Fixes
- Fixed an issue where date formats specified in ARB files were not
being respected by the generator

### Reminder
- On next major release the SDK will require Dart 3 and Flutter 3


## 1.3.0
### New
- The SDK is now compatible with multiple Lokalise delegates, which 
allows to split apps in packages

### Reminder
- On next major release the SDK will require Dart 3 and Flutter 3


## 1.2.5
### New
- The SDK is now compatible with `package_info_plus 8`
- The SDK is now compatible with `intl_translation 0.20.0`

### Reminder
- On next major release the SDK will require Dart 3 and Flutter 3


## 1.2.4

### New
- The SDK is now compatible with `package_info_plus 7`

### Reminder
- On next major release the SDK will require Dart 3 and Flutter 3


## 1.2.3

### New
- The SDK is now compatible with `package_info_plus 6`

### Coming soon
- On next major release the SDK will require Dart 3 and Flutter 3


## 1.2.2

### Fixes
- Fixed an issue on the web platform that was preventing the use of the `logging` parameter.


## 1.2.1

### New
- The SDK is now compatible with `intl 0.19`, and ready to use with the upcoming version of Flutter.
- The SDK is now compatible with `petitparser 6`.
- The SDK is now compatible with `package_info_plus 5`.
- The SDK is now compatible with `logger 2`.


## 1.2.0

### New 
- New `gen-lok-l10n` customization options, please check the docs to read about them.
- New `logging` parameter added to the `Lokalise.init` method. You can use
this parameter in debug mode to get more details on the errors happening in the SDK.

### Fixes
- Fixed a generator issue that prevented the creation of corresponding entries in `.dart`
files when a format is included in a DateTime type key.

## Other
- Improved the `gen-lok-l10n` logging


## 1.1.1

### Others
- Improved `initMock` documentation explaining the usage of the optional parameters.


## 1.1.0

### New
- New `initMock` method to initialize the `Lokalise` instance, that you can use to write your test 
cases or experiment without using real storage or API calls.
- Support for locale codes that include the writing system (e.g., `zh_Hans` or `zh_Hant_HK`).


## 1.0.1

### New
- Added an example app to the SDK.
- The SDK is now compatible with `intl 0.18.0`, and ready to use with the upcoming version of Flutter.


## 1.0.0

### Breaking changes
- The generated files are now located on the l10n directory (l10n/generated). If you
already had generated files, you will need to remove them and run the generation
command again. You will also need to update your import statements for the
l10n.dart file.
- The route for the Lokalise class has changed to 
`import 'package:lokalise_flutter_sdk/lokalise_flutter_sdk.dart';`. Please update your import 
statements accordingly.

### Fixes
- Fixed an issue with bundle downloads on certain platforms. The app version was not 
populated properly when it didn't follow a simple pattern on `pubspec.yaml`. Now more complex 
app versions such as `x.y.z-aa-bb` are supported.

### Others
- Improved the quality of the codebase substantially.


## 0.5.1

### Fixes
- Fixed an error that caused newly downloaded bundles to not be used 
until the application was restarted.


## 0.5.0

 ### Breaking changes
 - The `appVersion` parameter has changed, and now it is automatically populated 
 with your app version. It continues being customizable for testing purposes but we 
 might remove it in the future so please don't use it.

 ### Others
 - Improved the quality of the codebase substantially


## 0.4.0

### New
- Customization of the `l10n.dart` class name

### Behaviour changes
- Improved error handling
- Debug logs removed
- `l10n.dart` class improved to be easier to use.
- Generate command name change from `lok_tr` to `gen-lok-l10n`


## 0.3.1

UPDATE README


## 0.3.0

IMPROVING LOKALISE CLASS API AND CLASSES GENERATOR


## 0.2.5

FIX OTA RESPONSE PARSING ISSUE


## 0.2.4

UPDATE LOKALISE OTA ENDPOINTS


## 0.2.3

RENAME EXECUTABLE, UPDATE LICENSE


## 0.2.2

ADD DOC COMMENTS FOR PUBLIC API


## 0.1.9

FIX DOCUMENTATION ON PUB.DEV / FORMAT FILES 


## 0.1.7

FIX GITHUB ACTIONS


## 0.1.3 

FIX TESTS


## 0.1.2 

FIX GENERATED CODE


## 0.1.1 

UPDATE README


## 0.1.0

RELEASE VERSION


## 0.0.9

IMPLEMENT TESTS


## 0.0.8

DOCUMENTATION UPDATE


## 0.0.7

IMPLEMENT OTA


## 0.0.6

EXECUTABLES TR (GENERATE DART CLASS FOR TRANSLATE)


## 0.0.5

FIX DEPRECATED ISSUES (EXTRACT MESSAGES)


## 0.0.4

IMPLEMENT TESTS


## 0.0.3

EXECUTABLES G (GENERATE)


## 0.0.2

EXECUTABLES GENERATE


## 0.0.1

INITIAL RELEASE
