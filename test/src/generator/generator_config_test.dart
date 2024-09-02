import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/src/extensions/directory.dart';
import 'package:lokalise_flutter_sdk/src/generator/exceptions/generator_exception.dart';
import 'package:lokalise_flutter_sdk/src/generator/generator_config.dart';
import 'package:path/path.dart' as path;

import '../../assets/assets_routes.dart';

void main() {
  group('Generator default constructor', () {
    test('default values', () {
      final config = GeneratorConfig.byDefault();
      _configChecker(config: config);
    });
  });

  group('Generator from config file', () {
    late Directory directory;
    late File configFile;

    setUp(() async {
      directory = await Directory('$kGeneratedRoute/generator_config')
          .create(recursive: true);
      configFile = await directory.createFile(
        withName: GeneratorConfig.configFile,
      );
    });

    tearDown(() {
      directory.deleteSync(recursive: true);
    });

    test('wrong config file', () async {
      final fileNames = [
        'wrong_name.yaml',
        '${path.basenameWithoutExtension(GeneratorConfig.configFile)}.json'
      ];

      for (final name in fileNames) {
        final file = File(name);
        Exception? error;
        try {
          GeneratorConfig.fromConfigFile(file: file);
        } on Exception catch (e) {
          error = e;
        }
        expect(error, isInstanceOf<GeneratorException>());
      }
    });

    test('empty Yaml', () {
      configFile.writeAsStringSync(_toYaml({}));
      final config = GeneratorConfig.fromConfigFile(file: configFile);
      _configChecker(config: config);
    });

    test('with valid output-class', () {
      configFile.writeAsStringSync(_toYaml({
        'output-class': 'NewClass',
      }));
      final config = GeneratorConfig.fromConfigFile(file: configFile);
      _configChecker(config: config, outputClass: 'NewClass');
    });

    test('with empty output-class', () {
      configFile.writeAsStringSync(_toYaml({
        'output-class': '1class',
      }));

      late Exception error;
      try {
        GeneratorConfig.fromConfigFile(file: configFile);
      } on Exception catch (e) {
        error = e;
      }

      expect(error, isInstanceOf<GeneratorException>());
    });

    test('with valid arb-dir', () {
      configFile.writeAsStringSync(_toYaml({
        'arb-dir': 'test/assets',
      }));
      final config = GeneratorConfig.fromConfigFile(file: configFile);
      _configChecker(
          config: config,
          arbDir: 'test/assets',
          outputDir: 'test/assets/generated');
    });

    test('with output-dir', () {
      configFile.writeAsStringSync(_toYaml({
        'output-dir': 'test/assets',
      }));
      final config = GeneratorConfig.fromConfigFile(file: configFile);
      _configChecker(config: config, outputDir: 'test/assets');
    });

    test('with synthetic-package false', () {
      configFile.writeAsStringSync(_toYaml({
        'synthetic-package': 'false',
      }));
      final config = GeneratorConfig.fromConfigFile(file: configFile);
      _configChecker(config: config);
    });

    test('with synthetic-package true', () {
      configFile.writeAsStringSync(_toYaml({
        'synthetic-package': true,
        'output-dir': 'it_should_be_ignored',
      }));
      final config = GeneratorConfig.fromConfigFile(file: configFile);
      _configChecker(
        config: config,
        syntheticPackage: true,
      );
    });

    test('with invalid template-arb-file', () {
      configFile.writeAsStringSync(_toYaml({
        'template-arb-file': 'template.json',
      }));

      late Exception error;
      try {
        GeneratorConfig.fromConfigFile(file: configFile);
      } on Exception catch (e) {
        error = e;
      }

      expect(error, isInstanceOf<GeneratorException>());
    });

    test('with template-arb-file', () {
      configFile.writeAsStringSync(_toYaml({
        'template-arb-file': 'test_en.arb',
      }));
      final config = GeneratorConfig.fromConfigFile(file: configFile);
      _configChecker(
        config: config,
        templateArbFile: 'test_en.arb',
      );
    });

    test('with preferred-supported-locales containing invalid locale', () {
      configFile.writeAsStringSync(_toYaml({
        'preferred-supported-locales': ['ar', 'invalid', 'lv'],
      }));

      late Exception error;
      try {
        GeneratorConfig.fromConfigFile(file: configFile);
      } on Exception catch (e) {
        error = e;
      }

      expect(error, isInstanceOf<GeneratorException>());
    });

    test('with preferred-supported-locales', () {
      configFile.writeAsStringSync(_toYaml({
        'preferred-supported-locales': ['ar', 'lv'],
      }));
      final config = GeneratorConfig.fromConfigFile(file: configFile);
      _configChecker(
        config: config,
        preferredSupportedLocales: ['ar', 'lv'],
      );
    });

    test('with invalid output-localization-file', () {
      configFile.writeAsStringSync(_toYaml({
        'output-localization-file': 'no_dart.json',
      }));

      late Exception error;
      try {
        GeneratorConfig.fromConfigFile(file: configFile);
      } on Exception catch (e) {
        error = e;
      }

      expect(error, isInstanceOf<GeneratorException>());
    });

    test('with valid output-localization-file', () {
      configFile.writeAsStringSync(_toYaml({
        'output-localization-file': 'file.dart',
      }));
      final config = GeneratorConfig.fromConfigFile(file: configFile);
      _configChecker(
        config: config,
        outputLocalizationFile: 'file.dart',
      );
    });
  });
}

String _toYaml(Map<String, dynamic> map) {
  final result = map.entries.map((entry) {
    switch (entry.value.runtimeType) {
      case String:
        return '${entry.key}: ${entry.value}';
      case bool:
        return '${entry.key}: ${entry.value ? 'true' : 'false'}';
      case List<String>:
        return '${entry.key}: [${entry.value.join(', ')}]';
    }
  });

  return result.join('\n');
}

void _configChecker({
  required GeneratorConfig config,
  String arbDir = 'lib/l10n',
  bool syntheticPackage = false,
  String outputClass = 'Lt',
  String outputLocalizationFile = 'l10n.dart',
  String templateArbFile = 'intl_en.arb',
  String outputDir = 'lib/l10n/generated',
  List<String> preferredSupportedLocales = const ['en'],
}) {
  expect(config.arbDir, equals(arbDir));
  expect(config.syntheticPackage, equals(syntheticPackage));
  expect(
    config.outputDir,
    equals(
      syntheticPackage
          ? path.join('.dart_tool', 'flutter_gen', 'gen_l10n')
          : outputDir,
    ),
  );
  expect(config.outputClass, equals(outputClass));
  expect(config.outputLocalizationFile, equals(outputLocalizationFile));
  expect(config.templateArbFile, equals(templateArbFile));
  expect(config.preferredSupportedLocales, equals(preferredSupportedLocales));
}
