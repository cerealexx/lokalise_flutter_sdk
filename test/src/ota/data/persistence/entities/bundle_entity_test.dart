import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/persistence/entities/bundle_entity.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/bundle.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/enums/translation_element_type.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/enums/translation_type.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/language_bundle.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/translation/plural_translation.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/translation/simple_translation.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/translation/translation_element.dart';

void main() {
  final Map<String, dynamic> bundleJson = {
    'project_id': '1abc23',
    'translation_version': 30,
    'app_version': '22',
    'translations': {
      'en': {
        'simple': {
          'type': TranslationType.simple.name,
          'elements': [
            {'type': TranslationElementType.literal.name, 'value': 'test(en)'}
          ],
        },
        'placeholder': {
          'type': TranslationType.simple.name,
          'elements': [
            {'type': TranslationElementType.placeholder.name, 'value': 'test'},
            {'type': TranslationElementType.literal.name, 'value': '(en)'}
          ],
        },
        'plural': {
          'type': TranslationType.plural.name,
          'argument': 'count',
          'zero': {
            'type': TranslationType.simple.name,
            'elements': [
              {
                'type': TranslationElementType.literal.name,
                'value': 'test 0(en)'
              }
            ],
          },
          'one': {
            'type': TranslationType.simple.name,
            'elements': [
              {
                'type': TranslationElementType.literal.name,
                'value': 'test 1(en)'
              }
            ],
          },
          'other': {
            'type': TranslationType.simple.name,
            'elements': [
              {
                'type': TranslationElementType.literal.name,
                'value': 'test +1(en)'
              }
            ],
          },
          'two': null,
          'few': null,
          'many': null,
        },
      },
      'es': {
        'simple': {
          'type': TranslationType.simple.name,
          'elements': [
            {'type': TranslationElementType.literal.name, 'value': 'test(es)'}
          ],
        },
        'placeholder': {
          'type': TranslationType.simple.name,
          'elements': [
            {'type': TranslationElementType.placeholder.name, 'value': 'test'},
            {'type': TranslationElementType.literal.name, 'value': '(es)'}
          ],
        },
        'plural': {
          'type': TranslationType.plural.name,
          'argument': 'count',
          'zero': {
            'type': TranslationType.simple.name,
            'elements': [
              {
                'type': TranslationElementType.literal.name,
                'value': 'test 0(es)'
              }
            ],
          },
          'one': {
            'type': TranslationType.simple.name,
            'elements': [
              {
                'type': TranslationElementType.literal.name,
                'value': 'test 1(es)'
              }
            ],
          },
          'other': {
            'type': TranslationType.simple.name,
            'elements': [
              {
                'type': TranslationElementType.literal.name,
                'value': 'test +1(es)'
              }
            ],
          },
          'two': null,
          'few': null,
          'many': null,
        },
      },
    }
  };

  final bundleTranslations = {
    'en': {
      'simple': SimpleTranslation(
        elements: [TranslationElement.literal(value: 'test(en)')],
      ),
      'placeholder': SimpleTranslation(
        elements: [
          TranslationElement.placeholder(value: 'test'),
          TranslationElement.literal(value: '(en)')
        ],
      ),
      'plural': PluralTranslation(
        argument: 'count',
        zero: SimpleTranslation(
          elements: [TranslationElement.literal(value: 'test 0(en)')],
        ),
        one: SimpleTranslation(
          elements: [TranslationElement.literal(value: 'test 1(en)')],
        ),
        other: SimpleTranslation(
          elements: [TranslationElement.literal(value: 'test +1(en)')],
        ),
        few: null,
        many: null,
        two: null,
      ),
    },
    'es': {
      'simple': SimpleTranslation(
        elements: [TranslationElement.literal(value: 'test(es)')],
      ),
      'placeholder': SimpleTranslation(
        elements: [
          TranslationElement.placeholder(value: 'test'),
          TranslationElement.literal(value: '(es)')
        ],
      ),
      'plural': PluralTranslation(
        argument: 'count',
        zero: SimpleTranslation(
          elements: [TranslationElement.literal(value: 'test 0(es)')],
        ),
        one: SimpleTranslation(
          elements: [TranslationElement.literal(value: 'test 1(es)')],
        ),
        other: SimpleTranslation(
          elements: [TranslationElement.literal(value: 'test +1(es)')],
        ),
        few: null,
        many: null,
        two: null,
      ),
    }
  };

  final bundleEntity = BundleEntity(
    projectId: '1abc23',
    translationVersion: 30,
    appVersion: '22',
    translations: bundleTranslations,
  );

  final bundle = Bundle(
    projectId: '1abc23',
    appVersion: '22',
    translationVersion: 30,
    languageBundles: [
      LanguageBundle(
        locale: 'en',
        translations: bundleTranslations['en']!,
      ),
      LanguageBundle(
        locale: 'es',
        translations: bundleTranslations['es']!,
      ),
    ],
  );

  void compareBundleEntity(BundleEntity bundle1, BundleEntity bundle2) {
    expect(bundle1.projectId, equals(bundle2.projectId));
    expect(bundle1.appVersion, equals(bundle2.appVersion));
    expect(bundle1.translationVersion, equals(bundle2.translationVersion));
    expect(bundle1.translations.length, equals(bundle2.translations.length));

    bundle1.translations.forEach((locale1, translations1) {
      expect(bundle2.translations.containsKey(locale1), true);

      final translations2 = bundle2.translations[locale1]!;
      expect(translations1.length, equals(translations2.length));

      translations1.forEach((key, value1) {
        expect(translations2.containsKey(key), true);

        final value2 = translations2[key]!;
        expect(value1.toJson(), value2.toJson());
      });
    });
  }

  void compareBundle(Bundle bundle1, Bundle bundle2) {
    expect(bundle1.projectId, equals(bundle2.projectId));
    expect(bundle1.appVersion, equals(bundle2.appVersion));
    expect(bundle1.translationVersion, equals(bundle2.translationVersion));
    expect(
        bundle1.languageBundles.length, equals(bundle2.languageBundles.length));

    for (var i = 0; i < bundle1.languageBundles.length; i++) {
      final lang1 = bundle1.languageBundles[i];
      final lang2 = bundle2.languageBundles[i];
      expect(lang1.locale, equals(lang2.locale));
      expect(lang1.translations.length, equals(lang2.translations.length));

      lang1.translations.forEach((key, value1) {
        expect(lang2.translations.containsKey(key), true);

        final value2 = lang2.translations[key]!;
        expect(value1.toJson(), value2.toJson());
      });
    }
  }

  group('BundleEntity - fromJson', () {
    test('Success', () {
      final expectedBundle = bundleEntity;
      final resultBundle = BundleEntity.fromJson(json: bundleJson);

      compareBundleEntity(resultBundle, expectedBundle);
    });

    test('Success - parsing toJson result', () {
      final parsedBundle = bundleEntity.toJson();
      final result = BundleEntity.fromJson(json: parsedBundle);

      compareBundleEntity(result, bundleEntity);
    });

    test('Success - empty translations', () {
      final Map<String, dynamic> emptyTranslationsBundle = {
        'project_id': '1abc23',
        'app_version': '22',
        'translation_version': 30,
        'translations': {}
      };
      final resultBundle = BundleEntity.fromJson(json: emptyTranslationsBundle);

      expect(resultBundle.translations, isEmpty);
      expect(resultBundle.projectId, equals('1abc23'));
      expect(resultBundle.appVersion, equals('22'));
      expect(resultBundle.translationVersion, equals(30));
    });

    test('Fail - type error', () {
      final Map<String, dynamic> json = {
        'project_id': '1abc23',
        'version': '22', // it is expected to be a number
        'translations': <String, List>{}
      };

      Object? error;
      try {
        BundleEntity.fromJson(json: json);
      } catch (e) {
        error = e;
      }
      expect(error, isNotNull);
    });
  });

  group('BundleEntity - toJson', () {
    test('Success', () {
      final json = bundleEntity.toJson();
      expect(json, equals(bundleJson));
    });

    test('Success - parsing fromJson result', () {
      final aux = BundleEntity.fromJson(json: bundleJson);
      expect(aux.toJson(), equals(bundleJson));
    });
  });

  group('BundleEntity - fromBundle', () {
    test('Success', () {
      final expected = bundleEntity;
      final result = BundleEntity.fromBundle(bundle: bundle);
      compareBundleEntity(result, expected);
    });

    test('Success - empty translations', () {
      final bundle = Bundle(
        projectId: '1abc23',
        translationVersion: 30,
        appVersion: '22',
        languageBundles: [],
      );
      final result = BundleEntity.fromBundle(bundle: bundle);

      expect(result.translations, isEmpty);
      expect(result.projectId, equals('1abc23'));
      expect(result.appVersion, equals('22'));
      expect(result.translationVersion, equals(30));
    });

    test('Success - parsing toBundle result', () {
      final parsedBundle = bundleEntity.toBundle();
      final result = BundleEntity.fromBundle(bundle: parsedBundle);

      compareBundleEntity(result, bundleEntity);
    });
  });

  group('BundleEntity - toBundle', () {
    test('Success', () {
      final result = bundleEntity.toBundle();
      compareBundle(result, bundle);
    });

    test('Success - parsing fromBundle result', () {
      final parsedBundle = BundleEntity.fromBundle(bundle: bundle);
      final result = parsedBundle.toBundle();

      compareBundle(result, bundle);
    });
  });
}
