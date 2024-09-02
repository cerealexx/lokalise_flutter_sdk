import 'package:lokalise_flutter_sdk/src/ota/domain/models/language_bundle.dart';

class Bundle {
  /// The project id is needed to be able to check the
  /// cached data is related to the project which is
  /// configured in the SDK.
  final String projectId;

  /// We need to know the translation version to know which version
  /// we have cached before requesting a new version of them.
  final int translationVersion;

  /// We need to know the app version of the cached translation
  /// to be able to clean them after a new release of the app.
  final String appVersion;

  final List<LanguageBundle> languageBundles;

  Bundle({
    required this.projectId,
    required this.translationVersion,
    required this.appVersion,
    required this.languageBundles,
  });

  Bundle.empty({
    required this.projectId,
    required this.appVersion,
  })  : translationVersion = 0,
        languageBundles = [];
}
