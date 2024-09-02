import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/enums/translation_element_type.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/translation/translation_element.dart';

void main() {
  group('TranslationElement - named constuctors', () {
    test('literal works', () {
      final element = TranslationElement.literal(value: 'test-value');
      expect(element.type, equals(TranslationElementType.literal));
      expect(element.value, equals('test-value'));
    });

    test('placeholder works', () {
      final element = TranslationElement.placeholder(value: 'test-value');
      expect(element.type, equals(TranslationElementType.placeholder));
      expect(element.value, equals('test-value'));
    });
  });

  group('TranslationElement - toJson', () {
    test('literal type', () {
      final element = TranslationElement.literal(value: 'test-value');
      final expected = <String, dynamic>{
        'type': TranslationElementType.literal.name,
        'value': 'test-value',
      };
      expect(element.toJson(), equals(expected));
    });

    test('placeholder type', () {
      final element = TranslationElement.placeholder(value: 'test-value');
      final expected = <String, dynamic>{
        'type': TranslationElementType.placeholder.name,
        'value': 'test-value',
      };
      expect(element.toJson(), equals(expected));
    });
  });

  group('TranslationElement - fromJson', () {
    test('literal type', () {
      final json = <String, dynamic>{
        'type': TranslationElementType.literal.name,
        'value': 'test-value',
      };
      final element = TranslationElement.fromJson(json: json);
      expect(element.type, equals(TranslationElementType.literal));
      expect(element.value, equals('test-value'));
    });

    test('placeholder type', () {
      final json = <String, dynamic>{
        'type': TranslationElementType.placeholder.name,
        'value': 'test-value',
      };
      final element = TranslationElement.fromJson(json: json);
      expect(element.type, equals(TranslationElementType.placeholder));
      expect(element.value, equals('test-value'));
    });
  });
}
