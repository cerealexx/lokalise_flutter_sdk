import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/enums/translation_type.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/translation/plural_translation.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/translation/simple_translation.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/translation/translation_element.dart';
import 'package:intl/intl.dart';

void main() {
  group('PluralTranslation - toJson', () {
    test('with all properties', () {
      final translation = PluralTranslation(
        argument: 'count',
        zero: SimpleTranslation(elements: []),
        one: SimpleTranslation(elements: []),
        two: SimpleTranslation(elements: []),
        few: SimpleTranslation(elements: []),
        many: SimpleTranslation(elements: []),
        other: SimpleTranslation(elements: []),
      );
      final expected = {
        'type': TranslationType.plural.name,
        'argument': 'count',
        'zero': {
          'type': TranslationType.simple.name,
          'elements': [],
        },
        'one': {
          'type': TranslationType.simple.name,
          'elements': [],
        },
        'two': {
          'type': TranslationType.simple.name,
          'elements': [],
        },
        'few': {
          'type': TranslationType.simple.name,
          'elements': [],
        },
        'many': {
          'type': TranslationType.simple.name,
          'elements': [],
        },
        'other': {
          'type': TranslationType.simple.name,
          'elements': [],
        },
      };

      expect(translation.toJson(), equals(expected));
    });

    test('without optional properties', () {
      final translation = PluralTranslation(
        argument: 'count',
        zero: null,
        one: null,
        two: null,
        few: null,
        many: null,
        other: SimpleTranslation(elements: []),
      );
      final expected = {
        'type': TranslationType.plural.name,
        'argument': 'count',
        'zero': null,
        'one': null,
        'two': null,
        'few': null,
        'many': null,
        'other': {
          'type': TranslationType.simple.name,
          'elements': [],
        },
      };

      expect(translation.toJson(), equals(expected));
    });
  });

  group('PluralTranslation - fromJson', () {
    test('with all properties', () {
      final json = {
        'type': TranslationType.plural.name,
        'argument': 'count',
        'zero': {
          'type': TranslationType.simple.name,
          'elements': [],
        },
        'one': {
          'type': TranslationType.simple.name,
          'elements': [],
        },
        'two': {
          'type': TranslationType.simple.name,
          'elements': [],
        },
        'few': {
          'type': TranslationType.simple.name,
          'elements': [],
        },
        'many': {
          'type': TranslationType.simple.name,
          'elements': [],
        },
        'other': {
          'type': TranslationType.simple.name,
          'elements': [],
        },
      };
      final translation = PluralTranslation.fromJson(json: json);

      expect(translation.type, equals(TranslationType.plural));

      expect(translation.zero?.type, equals(TranslationType.simple));
      expect(translation.zero?.getTranslation(args: {}), isNull);

      expect(translation.one?.type, equals(TranslationType.simple));
      expect(translation.one?.getTranslation(args: {}), isNull);

      expect(translation.two?.type, equals(TranslationType.simple));
      expect(translation.two?.getTranslation(args: {}), isNull);

      expect(translation.few?.type, equals(TranslationType.simple));
      expect(translation.few?.getTranslation(args: {}), isNull);

      expect(translation.many?.type, equals(TranslationType.simple));
      expect(translation.many?.getTranslation(args: {}), isNull);

      expect(translation.other.type, equals(TranslationType.simple));
      expect(translation.other.getTranslation(args: {}), isNull);
    });

    test('without optional properties', () {
      final json = {
        'type': TranslationType.plural.name,
        'argument': 'count',
        'zero': null,
        'one': null,
        'two': null,
        'few': null,
        'many': null,
        'other': {
          'type': TranslationType.simple.name,
          'elements': [],
        },
      };
      final translation = PluralTranslation.fromJson(json: json);

      expect(translation.type, equals(TranslationType.plural));
      expect(translation.other.type, equals(TranslationType.simple));
      expect(translation.other.getTranslation(args: {}), isNull);
      expect(translation.zero, isNull);
      expect(translation.one, isNull);
      expect(translation.two, isNull);
      expect(translation.few, isNull);
      expect(translation.many, isNull);
    });
  });

  group('PluralTranslation - getTranslation', () {
    setUpAll(() {
      /// We need to change the language to one with all the plural forms
      /// to be able to test it properly.
      /// Reference:
      /// https://www.unicode.org/cldr/cldr-aux/charts/29/supplemental/language_plural_rules.html#ar
      Intl.defaultLocale = 'ar';
    });

    tearDownAll(() {
      Intl.defaultLocale = 'en';
    });

    test('with all properties', () {
      final translation = PluralTranslation(
        argument: 'count',
        zero: SimpleTranslation(
          elements: [TranslationElement.literal(value: 'zero-test')],
        ),
        one: SimpleTranslation(
          elements: [TranslationElement.literal(value: 'one-test')],
        ),
        two: SimpleTranslation(
          elements: [TranslationElement.literal(value: 'two-test')],
        ),
        few: SimpleTranslation(
          elements: [TranslationElement.literal(value: 'few-test')],
        ),
        many: SimpleTranslation(
          elements: [TranslationElement.literal(value: 'many-test')],
        ),
        other: SimpleTranslation(
          elements: [TranslationElement.literal(value: 'other-test')],
        ),
      );

      expect(translation.getTranslation(args: {}), isNull);
      expect(translation.getTranslation(args: {'count': 'test'}), isNull);

      expect(
          translation.getTranslation(args: {'count': 0}), equals('zero-test'));
      expect(
          translation.getTranslation(args: {'count': 1}), equals('one-test'));
      expect(
          translation.getTranslation(args: {'count': 2}), equals('two-test'));
      expect(
          translation.getTranslation(args: {'count': 3}), equals('few-test'));
      expect(
          translation.getTranslation(args: {'count': 12}), equals('many-test'));
      expect(translation.getTranslation(args: {'count': 100}),
          equals('other-test'));
    });

    test('without option properties', () {
      final translation = PluralTranslation(
        argument: 'count',
        zero: null,
        one: null,
        two: null,
        few: null,
        many: null,
        other: SimpleTranslation(
          elements: [TranslationElement.literal(value: 'other-test')],
        ),
      );

      expect(translation.getTranslation(args: {}), isNull);
      expect(translation.getTranslation(args: {'count': 'test'}), isNull);

      expect(
          translation.getTranslation(args: {'count': 0}), equals('other-test'));
      expect(
          translation.getTranslation(args: {'count': 1}), equals('other-test'));
      expect(
          translation.getTranslation(args: {'count': 2}), equals('other-test'));
      expect(
          translation.getTranslation(args: {'count': 3}), equals('other-test'));
      expect(translation.getTranslation(args: {'count': 12}),
          equals('other-test'));
      expect(translation.getTranslation(args: {'count': 100}),
          equals('other-test'));
    });

    test('other translation has not elements', () {
      final translation = PluralTranslation(
        argument: 'count',
        zero: null,
        one: null,
        two: null,
        few: null,
        many: null,
        other: SimpleTranslation(
          elements: [],
        ),
      );

      expect(translation.getTranslation(args: {'count': 100}), equals(''));
    });
  });
}
