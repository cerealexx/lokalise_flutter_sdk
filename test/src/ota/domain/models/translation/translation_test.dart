import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/enums/translation_type.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/translation/plural_translation.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/translation/simple_translation.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/translation/translation.dart';

void main() {
  group('Translation - fromJson', () {
    test('there is no type', () {
      final json = <String, dynamic>{};
      final translation = Translation.fromJson(json: json);
      expect(translation, isNull);
    });

    test('simple translation', () {
      final json = {
        'type': TranslationType.simple.name,
        'original': 'test-original',
        'elements': [],
      };
      final translation = Translation.fromJson(json: json);
      expect(translation, isA<SimpleTranslation>());
    });

    test('plural translation', () {
      final json = {
        'type': TranslationType.plural.name,
        'original': 'original-test',
        'argument': 'count',
        'zero': null,
        'one': null,
        'two': null,
        'few': null,
        'many': null,
        'other': {
          'type': TranslationType.simple.name,
          'original': 'other-test',
          'elements': [],
        },
      };
      final translation = Translation.fromJson(json: json);
      expect(translation, isA<PluralTranslation>());
    });
  });
}
