import 'package:lokalise_flutter_sdk/src/ota/domain/models/bundle.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/json_serializable.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/language_bundle.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/translation/simple_translation.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/translation/translation.dart';

class BundleEntity implements JsonSerializable {
  final String projectId;
  final int translationVersion;
  final String appVersion;
  final Map<String, Map<String, Translation>> translations;

  BundleEntity(
      {required this.projectId,
      required this.translationVersion,
      required this.appVersion,
      required this.translations});

  factory BundleEntity.fromJson({required Map<String, dynamic> json}) {
    final jsonTranslations = (json['translations'] as Map).isEmpty
        ? <String, Map<String, dynamic>>{}
        : Map.castFrom<String, dynamic, String, Map<String, dynamic>>(
            json['translations']);

    return BundleEntity(
      projectId: json['project_id'] as String,
      translationVersion: json['translation_version'] as int,
      appVersion: json['app_version'] as String,
      translations: jsonTranslations.map(
        (locale, map) => MapEntry(
          locale,
          map.map(
            (key, value) => MapEntry(
              key,
              Translation.fromJson(json: value) ??
                  SimpleTranslation(elements: []),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'project_id': projectId,
        'translation_version': translationVersion,
        'app_version': appVersion,
        'translations': translations.map(
          (locale, translations) => MapEntry(
            locale,
            translations.map(
              (key, value) => MapEntry(key, value.toJson()),
            ),
          ),
        )
      };

  factory BundleEntity.fromBundle({required Bundle bundle}) {
    return BundleEntity(
      projectId: bundle.projectId,
      translationVersion: bundle.translationVersion,
      appVersion: bundle.appVersion,
      translations: {
        for (final e in bundle.languageBundles) e.locale: e.translations
      },
    );
  }

  Bundle toBundle() {
    return Bundle(
        projectId: projectId,
        translationVersion: translationVersion,
        appVersion: appVersion,
        languageBundles: translations.entries
            .map((e) => LanguageBundle(locale: e.key, translations: e.value))
            .toList());
  }
}
