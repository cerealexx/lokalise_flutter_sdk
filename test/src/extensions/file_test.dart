import 'dart:io';

import 'package:dart_style/dart_style.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/src/extensions/file.dart';
import '../../assets/assets_routes.dart';

void main() {
  group('File ArbFile extension', () {
    test('extractLocale - no_locale.arb', () async {
      final file = File('$kArbRoute/no_locale.arb');
      expect(file.extractLocale(), isNull);
    });
    test('extractLocale - basic1.arb', () async {
      final file = File('$kArbRoute/basic1.arb');
      expect(file.extractLocale(), equals('en'));
    });
    test('extractLocale - basic2.arb', () async {
      final file = File('$kArbRoute/basic2.arb');
      expect(file.extractLocale(), equals('es'));
    });

    test('readAsArb - basic1.arb', () async {
      final file = File('$kArbRoute/basic1.arb');
      final expected = {
        '@@locale': 'en',
        'hello': 'Hello world',
        'title': 'Title',
      };
      expect(file.readAsArb(), equals(expected));
    });
    test('readAsArb - basic2.arb', () async {
      final file = File('$kArbRoute/basic2.arb');
      final expected = {
        '@@locale': 'es',
        'hello': 'Hola {name}',
        '@hello': {
          'description': 'Esto es la descrición',
          'placeholders': {'name': {}}
        },
        'title': 'Titulo',
      };
      expect(file.readAsArb(), equals(expected));
    });
  });

  group('File DartFile extension', () {
    late Directory directory;
    late File file;

    setUp(() async {
      directory = await Directory('$kGeneratedRoute/file_dart_file')
          .create(recursive: true);
      file = await File('${directory.path}/file.dart').create();
    });

    tearDown(() {
      directory.deleteSync(recursive: true);
    });

    test('writeDart - empty content', () async {
      file.writeDart(content: '');
      expect(await file.readAsString(), equals('\n'));
    });

    test('writeDart - non dart content', () async {
      late Exception error;
      try {
        file.writeDart(content: 'This is just text');
      } on Exception catch (e) {
        error = e;
      } catch (e) {
        fail('Unexpected error');
      }
      expect(error, isInstanceOf<FormatterException>());
    });

    test('writeDart - basic const', () async {
      const content = "   const a='' ;   ";
      const expected = "const a = '';\n";
      file.writeDart(content: content);
      expect(await file.readAsString(), equals(expected));
    });

    test('writeDart - write class', () async {
      final content = File('$kDartRoute/class.dart').readAsStringSync();
      file.writeDart(content: content.replaceAll('  ', ''));
      expect(await file.readAsString(), equals(content));
    });
  });

  group('File FilePath extension', () {
    test('basename - basic1.arb', () async {
      final file = File('$kArbRoute/basic1.arb');
      expect(file.basename, equals('basic1.arb'));
    });
    test('basename - basic1.arb', () async {
      final file = File('$kDartRoute/class.dart');
      expect(file.basename, equals('class.dart'));
    });

    test('basenameWithoutExtension - basic1.arb', () async {
      final file = File('$kArbRoute/basic1.arb');
      expect(file.basenameWithoutExtension, equals('basic1'));
    });
    test('basenameWithoutExtension - basic1.arb', () async {
      final file = File('$kDartRoute/class.dart');
      expect(file.basenameWithoutExtension, equals('class'));
    });
  });
}
