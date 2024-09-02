import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/enums/translation_type.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/translation/plural_translation.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/translation/simple_translation.dart';
import 'package:lokalise_flutter_sdk/src/ota/helpers/message_parser_wrapper.dart';

void main() {
  group('MessageParserWrapper - simple translation -> ', () {
    test("''", () {
      const text = '';
      final translation = MessageParserWrapper(text: text).translation;
      expect(translation, isNotNull);
      expect(translation!.type, equals(TranslationType.simple));

      expect(translation.getTranslation(args: {}), equals(text));
    });

    test('Hello world', () {
      const text = 'Hello world';
      final translation = MessageParserWrapper(text: text).translation;
      expect(translation, isNotNull);
      expect(translation!.type, equals(TranslationType.simple));
      expect(translation.getTranslation(args: {}), equals(text));
    });

    test('Heyo {name}, you are my friend', () {
      const text = 'Heyo {name}, you are my friend';
      final translation = MessageParserWrapper(text: text).translation;
      expect(translation, isNotNull);
      expect(translation!.type, equals(TranslationType.simple));
      expect(
        translation.getTranslation(args: {'name': 'test'}),
        equals('Heyo test, you are my friend'),
      );
    });

    test('It is {pronoum} {thing}', () {
      const text = 'It is {pronoum} {thing}';
      final translation = MessageParserWrapper(text: text).translation;
      expect(translation, isNotNull);
      expect(translation!.type, equals(TranslationType.simple));
      expect(
        translation.getTranslation(args: {'pronoum': 'my', 'thing': 'laptop'}),
        equals('It is my laptop'),
      );
    });

    test('Hey {name}\nHow are you?', () {
      const text = 'Hey {name}\nHow are you?';
      final translation = MessageParserWrapper(text: text).translation;
      expect(translation, isNotNull);
      expect(translation!.type, equals(TranslationType.simple));
      expect(
        translation.getTranslation(args: {'name': 'test'}),
        equals('Hey test\nHow are you?'),
      );
    });
  });

  group('MessageParserWrapper - plural translation -> ', () {
    test(
        '{count, plural, zero{0} one{1} two{2} few{few}, many{many} other{other}}',
        () {
      const text =
          '{count, plural, zero{0} one{1} two{2} few{few} many{many} other{other}}';

      final translation = MessageParserWrapper(text: text).translation;
      expect(translation, isNotNull);
      expect(translation!.type, equals(TranslationType.plural));

      final plural = translation as PluralTranslation;
      expect(plural.argument, equals('count'));

      expect(plural.zero!.getTranslation(args: {}), equals('0'));
      expect(plural.one!.getTranslation(args: {}), equals('1'));
      expect(plural.two!.getTranslation(args: {}), equals('2'));
      expect(plural.few!.getTranslation(args: {}), equals('few'));
      expect(plural.many!.getTranslation(args: {}), equals('many'));
      expect(plural.other.getTranslation(args: {}), equals('other'));
    });

    test('{count, plural, =0{0} =1{1} =2{2} few{few}, many{many} other{other}}',
        () {
      const text =
          '{count, plural, =0{0} =1{1} =2{2} few{few} many{many} other{other}}';
      final translation = MessageParserWrapper(text: text).translation;
      expect(translation, isNotNull);
      expect(translation!.type, equals(TranslationType.plural));

      final plural = translation as PluralTranslation;
      expect(plural.argument, equals('count'));

      expect(plural.zero!.getTranslation(args: {}), equals('0'));
      expect(plural.one!.getTranslation(args: {}), equals('1'));
      expect(plural.two!.getTranslation(args: {}), equals('2'));
      expect(plural.few!.getTranslation(args: {}), equals('few'));
      expect(plural.many!.getTranslation(args: {}), equals('many'));
      expect(plural.other.getTranslation(args: {}), equals('other'));
    });

    test('{count, plural, zero{0}}', () {
      const text = '{count, plural, zero{0}}';
      final translation = MessageParserWrapper(text: text).translation;
      expect(translation, isNotNull);
      expect(translation!.type, equals(TranslationType.plural));

      final plural = translation as PluralTranslation;
      expect(plural.argument, equals('count'));

      expect(plural.zero, isA<SimpleTranslation>());
      expect(plural.zero!.getTranslation(args: {}), equals('0'));

      expect(plural.one, isNull);
      expect(plural.two, isNull);
      expect(plural.few, isNull);
      expect(plural.many, isNull);

      expect(plural.other, isA<SimpleTranslation>());
      expect(plural.other.getTranslation(args: {}), isNull);
    });

    test(
        '{another, plural, few{few {count}} many{many {count}} other{other {count}}}',
        () {
      const text =
          '{another, plural, few{few {count}} many{many {count}} other{other {count}}}';

      final translation = MessageParserWrapper(text: text).translation;
      expect(translation, isNotNull);
      expect(translation!.type, equals(TranslationType.plural));

      final plural = translation as PluralTranslation;
      expect(plural.argument, equals('another'));

      expect(plural.zero, isNull);
      expect(plural.one, isNull);
      expect(plural.two, isNull);
      final param = {'count': 3};
      expect(plural.few!.getTranslation(args: param), equals('few 3'));
      expect(plural.many!.getTranslation(args: param), equals('many 3'));
      expect(plural.other.getTranslation(args: param), equals('other 3'));
    });

    test(
        '{another, plural, few{few {few}} many{many {many}} other{other {other}}}',
        () {
      const text =
          '{another, plural, few{few {few}} many{many {many}} other{other {other}}}';

      final translation = MessageParserWrapper(text: text).translation;
      expect(translation, isNotNull);
      expect(translation!.type, equals(TranslationType.plural));

      final plural = translation as PluralTranslation;
      expect(plural.argument, equals('another'));

      expect(plural.zero, isNull);
      expect(plural.one, isNull);
      expect(plural.two, isNull);
      expect(plural.few!.getTranslation(args: {'few': 1}), equals('few 1'));
      expect(plural.many!.getTranslation(args: {'many': 2}), equals('many 2'));
      expect(
          plural.other.getTranslation(args: {'other': 3}), equals('other 3'));
    });
  });
}
