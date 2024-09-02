// ignore: implementation_imports
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:intl/src/intl_helpers.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/bundle.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/language_bundle.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/translation/simple_translation.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/translation/translation_element.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/services/message_lookup_proxy.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'message_lookup_proxy_test.mocks.dart';

@GenerateMocks([MessageLookup])
void main() {
  late MockMessageLookup mockMessageLookup;
  late MessageLookupProxy proxy;

  setUpAll(() {
    Intl.defaultLocale = 'en';
  });

  setUp(() {
    mockMessageLookup = MockMessageLookup();
    proxy = MessageLookupProxy(
      messageLookup: mockMessageLookup,
      bundle: Bundle(
        projectId: 'test-project',
        appVersion: 'test-appVersion',
        translationVersion: 0,
        languageBundles: [],
      ),
    );
  });

  group('MessageLookupProxy - translationVersion', () {
    test('works', () {
      // at the beginning it is 0 -> see setup
      expect(proxy.translationVersion, equals(0));

      proxy.bundle = Bundle(
        projectId: '',
        translationVersion: 18,
        appVersion: '',
        languageBundles: [],
      );
      expect(proxy.translationVersion, equals(18));
    });
  });

  group('MessageLookupProxy - addLocale', () {
    test('should redirect call', () {
      const locale = 'es';
      function() {}
      proxy.addLocale(locale, function);
      verify(mockMessageLookup.addLocale(locale, function));
    });
  });

  group('MessageLookupProxy - lookupMessage', () {
    test('No translations in the bundle', () {
      // Given
      const message = 'test';
      when(mockMessageLookup.lookupMessage(null, null, null, null, null))
          .thenReturn(message);

      // When
      final res = proxy.lookupMessage(null, null, null, null, null);

      // Then
      expect(res, equals(message));
      verify(mockMessageLookup.lookupMessage(null, null, null, null, null))
          .called(1);
    });

    test('locale is not in the bundle', () {
      // Given
      const locale = 'lv';
      proxy.bundle = Bundle(
        projectId: 'test',
        translationVersion: 0,
        appVersion: '0',
        languageBundles: [LanguageBundle(locale: 'es', translations: {})],
      );

      const message = 'test';
      when(mockMessageLookup.lookupMessage(null, locale, null, null, null))
          .thenReturn(message);

      // When
      final res = proxy.lookupMessage(null, locale, null, null, null);

      // Then
      expect(res, equals(message));
      verify(mockMessageLookup.lookupMessage(null, locale, null, null, null))
          .called(1);
    });

    test('key is not in the lang translations', () {
      // Given
      const locale = 'lv';
      proxy.bundle = Bundle(
        projectId: 'test',
        translationVersion: 0,
        appVersion: '0',
        languageBundles: [
          LanguageBundle(
            locale: locale,
            translations: {'another': SimpleTranslation(elements: [])},
          ),
        ],
      );

      const keyName = 'key_name';
      const message = 'test';
      when(mockMessageLookup.lookupMessage(null, locale, keyName, null, null))
          .thenReturn(message);

      // When
      final res = proxy.lookupMessage(null, locale, keyName, null, null);

      // Then
      expect(res, equals(message));
      verify(mockMessageLookup.lookupMessage(null, locale, keyName, null, null))
          .called(1);
    });

    test('argsNamesByKeyNameList is empty and argsValues is null', () {
      // Given
      const locale = 'lv';
      const keyName = 'key_name';
      const message = 'test';
      proxy.bundle = Bundle(
        projectId: 'test',
        translationVersion: 0,
        appVersion: '0',
        languageBundles: [
          LanguageBundle(
            locale: locale,
            translations: {
              keyName: SimpleTranslation(
                elements: [TranslationElement.literal(value: message)],
              )
            },
          ),
        ],
      );

      // When
      final res = proxy.lookupMessage(null, locale, keyName, null, null);

      // Then
      expect(res, equals(message));
      verifyNever(mockMessageLookup.lookupMessage(any, any, any, any, any));
    });

    test('argsNamesByKeyNameList is empty and argsValues is not null', () {
      // Given
      const locale = 'lv';
      const keyName = 'key_name';
      proxy.bundle = Bundle(
        projectId: 'test',
        translationVersion: 0,
        appVersion: '0',
        languageBundles: [
          LanguageBundle(
            locale: locale,
            translations: {keyName: SimpleTranslation(elements: [])},
          ),
        ],
      );

      const message = 'test';
      const argValues = ['arg_value1', 'arg_value2'];
      when(mockMessageLookup.lookupMessage(
              null, locale, keyName, argValues, null))
          .thenReturn(message);

      // When
      final res = proxy.lookupMessage(null, locale, keyName, argValues, null);

      // Then
      expect(res, equals(message));
      verify(mockMessageLookup.lookupMessage(
        null,
        locale,
        keyName,
        argValues,
        null,
      )).called(1);
    });

    test('argsNamesByKeyNameList is not empty and argsValues is null', () {
      // Given
      const locale = 'lv';
      const keyName = 'key_name';
      proxy.bundle = Bundle(
        projectId: 'test',
        translationVersion: 0,
        appVersion: '0',
        languageBundles: [
          LanguageBundle(
            locale: locale,
            translations: {keyName: SimpleTranslation(elements: [])},
          ),
        ],
      );
      proxy.addArgNamesByKeyName({
        keyName: ['arg_name1']
      });

      const message = 'test';
      when(mockMessageLookup.lookupMessage(null, locale, keyName, null, null))
          .thenReturn(message);

      // When
      final res = proxy.lookupMessage(null, locale, keyName, null, null);

      // Then
      expect(res, equals(message));
      verify(mockMessageLookup.lookupMessage(
        null,
        locale,
        keyName,
        null,
        null,
      )).called(1);
    });

    test('arguments are both null (key not in argsNamesByKeyNameList)', () {
      // Given
      const locale = 'lv';
      const keyName = 'key_name';
      proxy.bundle = Bundle(
        projectId: 'test',
        translationVersion: 0,
        appVersion: '0',
        languageBundles: [
          LanguageBundle(
            locale: locale,
            translations: {keyName: SimpleTranslation(elements: [])},
          ),
        ],
      );
      proxy.addArgNamesByKeyName({
        'whatever': ['arg_name1']
      });

      const message = 'test';
      when(mockMessageLookup.lookupMessage(null, locale, keyName, null, null))
          .thenReturn(message);

      // When
      final res = proxy.lookupMessage(null, locale, keyName, null, null);

      // Then
      expect(res, equals(message));
      verify(mockMessageLookup.lookupMessage(
        null,
        locale,
        keyName,
        null,
        null,
      )).called(1);
    });

    test('arguments has different sizes', () {
      // Given
      const locale = 'lv';
      const keyName = 'key_name';
      proxy.bundle = Bundle(
        projectId: 'test',
        translationVersion: 0,
        appVersion: '0',
        languageBundles: [
          LanguageBundle(
            locale: locale,
            translations: {keyName: SimpleTranslation(elements: [])},
          ),
        ],
      );
      proxy.addArgNamesByKeyName({
        keyName: ['arg_name1']
      });

      const message = 'test';
      const argValues = ['arg_value1', 'arg_value2'];
      when(mockMessageLookup.lookupMessage(
              null, locale, keyName, argValues, null))
          .thenReturn(message);

      // When
      final res = proxy.lookupMessage(null, locale, keyName, argValues, null);

      // Then
      expect(res, equals(message));
      verify(mockMessageLookup.lookupMessage(
        null,
        locale,
        keyName,
        argValues,
        null,
      )).called(1);
    });

    test('arguments has the same sizes', () {
      // Given
      const locale = 'lv';
      const keyName = 'key_name';
      const message = 'test';
      proxy.bundle = Bundle(
        projectId: 'test',
        translationVersion: 0,
        appVersion: '0',
        languageBundles: [
          LanguageBundle(
            locale: locale,
            translations: {
              keyName: SimpleTranslation(
                elements: [TranslationElement.literal(value: message)],
              )
            },
          ),
        ],
      );
      proxy.addArgNamesByKeyName({
        keyName: ['arg_name1']
      });

      // When
      const argValues = ['arg_value1'];
      final res = proxy.lookupMessage(null, locale, keyName, argValues, null);

      // Then
      expect(res, equals(message));
      verifyNever(mockMessageLookup.lookupMessage(any, any, any, any, any));
    });

    test('Multiple argsNamesByKeyNameList - no args match', () {
      // Given
      const locale = 'lv';
      const keyName = 'key_name';
      const message = 'test';
      proxy.bundle = Bundle(
        projectId: 'test',
        translationVersion: 0,
        appVersion: '0',
        languageBundles: [
          LanguageBundle(
            locale: locale,
            translations: {
              keyName: SimpleTranslation(
                elements: [TranslationElement.literal(value: message)],
              )
            },
          ),
        ],
      );
      const defaultMessage = 'test - default';
      const argValues = ['arg_value1', 'arg_value2', 'arg_value3'];

      when(mockMessageLookup.lookupMessage(
              any, locale, keyName, argValues, null))
          .thenReturn(defaultMessage);

      proxy.addArgNamesByKeyName({
        keyName: ['arg_name1']
      });
      proxy.addArgNamesByKeyName({
        keyName: ['arg_name2', 'arg_name3']
      });

      // When
      final res = proxy.lookupMessage(null, locale, keyName, argValues, null);

      // Then
      expect(res, equals(defaultMessage));
      verify(mockMessageLookup.lookupMessage(any, any, any, any, any))
          .called(1);
    });

    test('Multiple argsNamesByKeyNameList - match found on 1 inserted element',
        () {
      // Given
      const locale = 'lv';
      const keyName = 'key_name';
      const message = 'test';
      proxy.bundle = Bundle(
        projectId: 'test',
        translationVersion: 0,
        appVersion: '0',
        languageBundles: [
          LanguageBundle(
            locale: locale,
            translations: {
              keyName: SimpleTranslation(
                elements: [TranslationElement.literal(value: message)],
              )
            },
          ),
        ],
      );
      proxy.addArgNamesByKeyName({
        keyName: ['arg_name1']
      });
      proxy.addArgNamesByKeyName({
        keyName: ['arg_name2', 'arg_name3']
      });

      // When
      const argValues = ['arg_value1', 'arg_value2'];
      final res = proxy.lookupMessage(null, locale, keyName, argValues, null);

      // Then
      expect(res, equals(message));
      verifyNever(mockMessageLookup.lookupMessage(any, any, any, any, any));
    });

    test('Multiple argsNamesByKeyNameList - match found on n inserted element',
        () {
      // Given
      const locale = 'lv';
      const keyName = 'key_name';
      const message = 'test';
      proxy.bundle = Bundle(
        projectId: 'test',
        translationVersion: 0,
        appVersion: '0',
        languageBundles: [
          LanguageBundle(
            locale: locale,
            translations: {
              keyName: SimpleTranslation(
                elements: [TranslationElement.literal(value: message)],
              )
            },
          ),
        ],
      );
      proxy.addArgNamesByKeyName({
        keyName: ['arg_name1']
      });
      proxy.addArgNamesByKeyName({
        keyName: ['arg_name2', 'arg_name3']
      });
      proxy.addArgNamesByKeyName({
        keyName: ['arg_name4']
      });

      // When
      const argValues = ['arg_value1', 'arg_value2'];
      final res = proxy.lookupMessage(null, locale, keyName, argValues, null);

      // Then
      expect(res, equals(message));
      verifyNever(mockMessageLookup.lookupMessage(any, any, any, any, any));
    });
  });
}
