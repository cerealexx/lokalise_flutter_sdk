library lokalise_flutter_sdk;

import 'dart:ui';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/update_result.dart';
import 'package:lokalise_flutter_sdk/src/ota/helpers/in_memory_initializer.dart';
import 'package:lokalise_flutter_sdk/src/ota/helpers/initializer.dart';

abstract class Lokalise {
  static Lokalise? _instance;

  /// Get the Lokalise singleton instance
  static Lokalise get instance => Lokalise._instance!;

  /// Initializes Lokalise.
  ///
  /// Parameters:
  ///   - [projectId] -> Lokalise project identifier
  ///   - [sdkToken] -> token to connect with your Lokalise project
  ///   - [appVersion] -> app version used for the bundle freeze
  ///       feature
  ///   - [preRelease] -> flag to select pre-release or production
  ///       bundles
  ///   - [logging] -> flag to show error logs in the SDK to facilitate
  ///       debugging
  ///
  /// Note: [appVersion] is automatically populated with your app version into
  /// your `pubspec.yaml` file, you can use [appVersion] for testing purposes
  /// but you shouldn't use it in production.
  ///
  /// Note: [logging] only works on debug mode, for profile and release the
  /// logging is disabled.
  static Future<void> init({
    required String projectId,
    required String sdkToken,
    String appVersion = '',
    bool preRelease = false,
    bool logging = false,
  }) async {
    assert(projectId.trim().isNotEmpty, 'Lokalise projectId cannot be empty');
    assert(sdkToken.trim().isNotEmpty, 'Lokalise sdkToken cannot be empty');
    final instance = await Initializer(
      projectId: projectId,
      sdkToken: sdkToken,
      appVersion: appVersion,
      preRelease: preRelease,
      logging: logging,
    ).lokalise;
    await instance.load();
    _instance = instance;
  }

  /// Initializes Lokalise for testing, without saving data or performing API
  /// calls.
  ///
  /// If the singleton instance has been initialized already, it is nullified.
  ///
  /// You can mock the SDK results through two optional parameters:
  ///   - [cachedBundleTranslations] -> simulates a previously downloaded bundle
  ///       that overwrites specified translations.
  ///   - [remoteBundleTranslations] -> simulates a newly downloaded bundle
  ///       during the translation update process, overwriting the specified
  ///       translations.
  ///
  /// Example:
  /// ```dart
  /// await Lokalise.initMock();
  /// // or
  /// await Lokalise.initMock(
  ///   cachedBundleTranslations: {
  ///     const Locale('en'): {'hello': 'Hello world'},
  ///     const Locale('es'): {'hello': 'Hola mundo'},
  ///    },
  ///    remoteBundleTranslations: {
  ///      const Locale('en'): {'hello': 'Hello world 2'},
  ///      const Locale('es'): {'hello': 'Hola mundo 2'},
  ///    },
  /// );
  /// ```
  static Future<void> initMock({
    Map<Locale, Map<String, String>>? cachedBundleTranslations,
    Map<Locale, Map<String, String>>? remoteBundleTranslations,
  }) async {
    final instance = InMemoryInitializer(
      localTranslations: cachedBundleTranslations ?? {},
      remoteTranslations: remoteBundleTranslations ?? {},
    ).lokalise;
    await instance.load();
    _instance = instance;
  }

  /// Checks the latest remote bundle or the one assigned to
  /// the app version following the bundle freeze settings
  /// and update the local translations with it if needed.
  Future<UpdateResult> update();

  /// Internal method used in l10n.dart to set the translations metadata
  set metadata(Map<String, List<String>> metadata);
}
