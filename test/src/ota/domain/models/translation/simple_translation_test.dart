import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/enums/translation_element_type.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/enums/translation_type.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/translation/simple_translation.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/translation/translation_element.dart';

void main() {
  group('SimpleTranslation - toJson', () {
    test('empty elements', () {
      final translation = SimpleTranslation(elements: []);
      final expected = <String, dynamic>{
        'type': TranslationType.simple.name,
        'elements': [],
      };
      expect(translation.toJson(), equals(expected));
    });

    test('not empty elements', () {
      final translation = SimpleTranslation(
        elements: [
          TranslationElement.literal(value: 'test-literal'),
          TranslationElement.placeholder(value: 'test-placeholder'),
        ],
      );
      final expected = <String, dynamic>{
        'type': TranslationType.simple.name,
        'elements': [
          {
            'type': TranslationElementType.literal.name,
            'value': 'test-literal',
          },
          {
            'type': TranslationElementType.placeholder.name,
            'value': 'test-placeholder',
          },
        ],
      };
      expect(translation.toJson(), equals(expected));
    });
  });

  group('SimpleTranslation - fromJson', () {
    test('empty elements', () {
      final json = <String, dynamic>{
        'type': TranslationType.simple.name,
        'elements': [],
      };
      final translation = SimpleTranslation.fromJson(json: json);
      expect(translation.type, equals(TranslationType.simple));
      expect(translation.elements, isEmpty);
    });

    test('not empty elements', () {
      final json = <String, dynamic>{
        'type': TranslationType.simple.name,
        'elements': [
          {
            'type': TranslationElementType.literal.name,
            'value': 'test-literal',
          },
          {
            'type': TranslationElementType.placeholder.name,
            'value': 'test-placeholder',
          },
        ],
      };
      final translation = SimpleTranslation.fromJson(json: json);
      expect(translation.type, equals(TranslationType.simple));
      expect(translation.elements.length, equals(2));
      expect(
        translation.elements[0].type,
        equals(TranslationElementType.literal),
      );
      expect(
        translation.elements[0].value,
        equals('test-literal'),
      );
      expect(
        translation.elements[1].type,
        equals(TranslationElementType.placeholder),
      );
      expect(
        translation.elements[1].value,
        equals('test-placeholder'),
      );
    });
  });

  group('SimpleTranslation - getTranslation', () {
    test('empty elements', () {
      final translation = SimpleTranslation(elements: []);
      expect(translation.getTranslation(args: {}), isNull);
    });

    test('literal element', () {
      final translation = SimpleTranslation(
        elements: [TranslationElement.literal(value: 'Hello world')],
      );
      expect(translation.getTranslation(args: {}), equals('Hello world'));
    });

    test('placeholder element', () {
      final translation = SimpleTranslation(
        elements: [TranslationElement.placeholder(value: 'name')],
      );
      expect(translation.getTranslation(args: {}), isNull);
      expect(
          translation.getTranslation(args: {'name': 'test'}), equals('test'));
    });

    test('translation with placeholders', () {
      final translation = SimpleTranslation(
        elements: [
          TranslationElement.literal(value: 'Hello '),
          TranslationElement.placeholder(value: 'name'),
          TranslationElement.literal(value: ' how are '),
          TranslationElement.placeholder(value: 'you'),
          TranslationElement.literal(value: '?')
        ],
      );
      expect(
        translation.getTranslation(args: {'name': 'test'}),
        isNull,
      );
      expect(
        translation.getTranslation(args: {'you': 'test'}),
        isNull,
      );
      expect(
        translation.getTranslation(args: {'name': 'test', 'you': 'test'}),
        equals('Hello test how are test?'),
      );
    });
  });
}
