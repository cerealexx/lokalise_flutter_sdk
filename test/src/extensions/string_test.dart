import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/src/extensions/string.dart';

void main() {
  group('String extension - LocaleValidation', () {
    test('invalid locales', () async {
      const invalidLocales = [
        '',
        'custom',
        'custom_1',
        'this_is_my_locale',
        'en-US',
        'en-004',
        'zh-Hant_HK',
        'zh_Hant-HK',
      ];

      for (var locale in invalidLocales) {
        expect(
          locale.isLangLocale,
          false,
          reason: 'isLangLocale failing with: $locale',
        );
        expect(
          locale.isLangCountryLocale,
          false,
          reason: 'isLangCountryLocale failing with: $locale',
        );
        expect(
          locale.isLangScriptCountryLocale,
          false,
          reason: 'isLangScriptCountryLocale failing with: $locale',
        );
        expect(
          locale.isLocale,
          false,
          reason: 'isLocale failing with: $locale',
        );
      }
    });

    test('valid locales', () async {
      // {lang}
      const langLocales = [
        'es',
        'pt',
        'en',
        'lv',
        'zh', // Chinese
        'shi', // Tachelhit
      ];
      for (final locale in langLocales) {
        expect(
          locale.isLangLocale,
          true,
          reason: 'isLangLocale failing with: $locale',
        );
      }

      //{lang}_{script}
      const langScriptLocales = [
        'zh_Hans',
        'zh_Hant',
        'shi_Tfng',
        'sHi_TfNg',
      ];
      for (final locale in langScriptLocales) {
        expect(
          locale.isLangScriptLocale,
          true,
          reason: 'isLangScriptLocale failing with: $locale',
        );
      }

      //{lang}_{country}
      const langCountryLocales = [
        'es_FR',
        'en_US',
        'pt_BR',
        'lv_LV',
        'shi_MA',
        'zh_SG',
        'es_419',
        'en_004',
      ];
      for (final locale in langCountryLocales) {
        expect(
          locale.isLangCountryLocale,
          true,
          reason: 'isLangCountryLocale failing with: $locale',
        );
      }

      //{lang}_{script}_{country}
      const langScriptContryLocales = [
        'zh_Hant_HK',
        'zh_Hant_CN',
        'zh_Hant_MO',
        'shi_Tfng_MA',
      ];
      for (final locale in langScriptContryLocales) {
        expect(
          locale.isLangScriptCountryLocale,
          true,
          reason: 'isLangScriptCountryLocale failing with: $locale',
        );
      }

      const allLocales = [
        ...langLocales,
        ...langScriptContryLocales,
        ...langCountryLocales,
        ...langScriptContryLocales,
      ];
      for (final locale in allLocales) {
        expect(
          locale.isLocale,
          true,
          reason: 'isLocale failing with: $locale',
        );
      }
    });
  });

  group('String extension - classValidation', () {
    test('invalid names', () async {
      const invalidNames = [
        '',
        '1',
        '1class',
        '?class',
        '*class',
        'class?',
        'class*',
        'class-',
        'class_',
        'class.class',
        'class,class',
        'class+class',
        'class-class',
      ];
      for (final name in invalidNames) {
        expect(
          name.isValidClassName,
          isFalse,
          reason: 'isValidClassName failing with $name',
        );
      }
    });

    test('valid names', () async {
      const invalidNames = [
        'class',
        'class1',
        'classClass',
        'ClassClass',
        'class_class',
      ];
      for (final name in invalidNames) {
        expect(
          name.isValidClassName,
          isTrue,
          reason: 'isValidClassName failing with $name',
        );
      }
    });
  });
}
