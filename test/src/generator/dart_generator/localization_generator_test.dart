import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/src/extensions/file.dart';
import 'package:lokalise_flutter_sdk/src/generator/dart_generator/localization_generator.dart';

import '../../../assets/assets_routes.dart';

void main() {
  group('LocalizationGenerator', () {
    late Directory directory;

    setUp(() async {
      directory = await Directory('$kGeneratedRoute/localization_generator')
          .create(recursive: true);
    });

    tearDown(() {
      directory.deleteSync(recursive: true);
    });

    test('basic1 Test [en, es, it]', () async {
      final locales = ['it', 'en', 'es'];
      final templateArb = File('$kArbRoute/basic1.arb');

      final generator = LocalizationGenerator(
        templateArb: templateArb,
        locales: locales,
        preferedSupportedLocales: [],
      );
      final resultFile = await generator.generate(
        onDirectory: directory,
        withFileName: 'file.dart',
        withClassName: 'Test',
      );

      expect(resultFile.basename, equals('file.dart'));
      final expected = File(
        '$kArbLocalizationResultRoute/basic1_test_en_es_it.dart',
      );
      expect(
        resultFile.readAsStringSync(),
        equals(expected.readAsStringSync()),
      );
    });

    test('basic1 myname [en, es, it]', () async {
      final locales = ['es', 'en', 'it'];
      final templateArb = File('$kArbRoute/basic1.arb');

      final generator = LocalizationGenerator(
        templateArb: templateArb,
        locales: locales,
        preferedSupportedLocales: [],
      );
      final resultFile = await generator.generate(
        onDirectory: directory,
        withFileName: 'l10n.dart',
        withClassName: 'myname',
      );

      expect(resultFile.basename, equals('l10n.dart'));
      final expected = File(
        '$kArbLocalizationResultRoute/basic1_myname_en_es_it.dart',
      );
      expect(
        resultFile.readAsStringSync(),
        equals(expected.readAsStringSync()),
      );
    });

    test('basic1 Lt [it, en, es] -> preffered [it]', () async {
      final locales = ['es', 'en', 'it'];
      final preferedSupportedLocales = ['it'];
      final templateArb = File('$kArbRoute/basic1.arb');

      final generator = LocalizationGenerator(
        templateArb: templateArb,
        locales: locales,
        preferedSupportedLocales: preferedSupportedLocales,
      );
      final resultFile = await generator.generate(
        onDirectory: directory,
        withFileName: 'lt.dart',
        withClassName: 'Lt',
      );

      expect(resultFile.basename, equals('lt.dart'));
      final expected = File(
        '$kArbLocalizationResultRoute/basic1_lt_it_en_es.dart',
      );
      expect(
        resultFile.readAsStringSync(),
        equals(expected.readAsStringSync()),
      );
    });

    test('basic1 Lt [it, es, ar, en] -> preffered [it, es]', () async {
      final locales = ['en', 'ar', 'es', 'it'];
      final preferedSupportedLocales = ['it', 'es'];
      final templateArb = File('$kArbRoute/basic1.arb');

      final generator = LocalizationGenerator(
        templateArb: templateArb,
        locales: locales,
        preferedSupportedLocales: preferedSupportedLocales,
      );
      final resultFile = await generator.generate(
        onDirectory: directory,
        withFileName: 'test.dart',
        withClassName: 'Lt',
      );

      expect(resultFile.basename, equals('test.dart'));
      final expected = File(
        '$kArbLocalizationResultRoute/basic1_lt_it_es_ar_en.dart',
      );
      expect(
        resultFile.readAsStringSync(),
        equals(expected.readAsStringSync()),
      );
    });

    test('basic2 Lt [es]', () async {
      final locales = ['es'];
      final arb = File('$kArbRoute/basic2.arb');

      final generator = LocalizationGenerator(
        templateArb: arb,
        locales: locales,
        preferedSupportedLocales: [],
      );
      final resultFile = await generator.generate(
        onDirectory: directory,
        withFileName: 'file.dart',
        withClassName: 'Lt',
      );

      expect(resultFile.basename, equals('file.dart'));
      final expected = File(
        '$kArbLocalizationResultRoute/basic2_lt_es.dart',
      );
      expect(
        resultFile.readAsStringSync(),
        equals(expected.readAsStringSync()),
      );
    });

    test('basic2 Lt [es, en]', () async {
      final locales = ['en', 'es'];
      final arb = File('$kArbRoute/basic2.arb');

      final generator = LocalizationGenerator(
        templateArb: arb,
        locales: locales,
        preferedSupportedLocales: [],
      );
      final resultFile = await generator.generate(
        onDirectory: directory,
        withFileName: 'generate.dart',
        withClassName: 'Lt',
      );

      expect(resultFile.basename, equals('generate.dart'));
      final expected = File(
        '$kArbLocalizationResultRoute/basic2_lt_en_es.dart',
      );
      expect(
        resultFile.readAsStringSync(),
        equals(expected.readAsStringSync()),
      );
    });
  });
}
