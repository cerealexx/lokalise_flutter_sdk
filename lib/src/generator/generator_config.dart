import 'dart:io';
import 'package:lokalise_flutter_sdk/src/extensions/file.dart';
import 'package:lokalise_flutter_sdk/src/generator/exceptions/generator_exception.dart';
import 'package:lokalise_flutter_sdk/src/extensions/string.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

class GeneratorConfig {
  static const configFile = 'lok-l10n.yaml';

  static final _defaultArbDir = join('lib', 'l10n');
  static final _defaultSyntheticPackageDir = join(
    '.dart_tool',
    'flutter_gen',
    'gen_l10n',
  );
  static const _defaultOutputDirName = 'generated';
  static const _defaultOutputClass = 'Lt';
  static const _defaultOutputLocalizationFile = 'l10n.dart';
  static const _defaultTemplateArbFile = 'intl_en.arb';
  static const _defaultPreferredSupportedLocales = ['en'];

  final String arbDir;
  final bool syntheticPackage;
  final String outputDir;
  final String outputClass;
  final String outputLocalizationFile;
  final String templateArbFile;
  final List<String> preferredSupportedLocales;

  GeneratorConfig({
    String? arbDir,
    bool? syntheticPackage,
    String? outputDir,
    String? outputClass,
    String? outputLocalizationFile,
    String? templateArbFile,
    List<String>? preferredSupportedLocales,
  })  : arbDir = arbDir ?? _defaultArbDir,
        syntheticPackage = syntheticPackage ?? false,
        outputDir = _getOutputDir(
          syntheticPackage: syntheticPackage,
          outputDir: outputDir,
          arbDir: arbDir,
        ),
        outputClass = outputClass ?? _defaultOutputClass,
        outputLocalizationFile =
            outputLocalizationFile ?? _defaultOutputLocalizationFile,
        templateArbFile = templateArbFile ?? _defaultTemplateArbFile,
        preferredSupportedLocales =
            preferredSupportedLocales ?? _defaultPreferredSupportedLocales;

  static String _getOutputDir({
    required bool? syntheticPackage,
    required String? outputDir,
    required String? arbDir,
  }) {
    if (syntheticPackage == true) {
      return _defaultSyntheticPackageDir;
    } else if (outputDir != null) {
      return outputDir;
    } else {
      return join(arbDir ?? _defaultArbDir, _defaultOutputDirName);
    }
  }

  GeneratorConfig.byDefault() : this();

  static GeneratorConfig fromConfigFile({
    required File file,
  }) {
    if (file.basename != configFile) {
      throw GeneratorException('The config file should be $configFile');
    }

    return _ConfigParser(
      loadYaml(file.readAsStringSync()) ?? YamlMap.wrap({}),
    ).transform();
  }
}

class _ConfigParser {
  static const _arbDirKey = 'arb-dir';
  static const _syntheticPackageKey = 'synthetic-package';
  static const _outputDirKey = 'output-dir';
  static const _outputClassKey = 'output-class';
  static const _outputLocalizationFileKey = 'output-localization-file';
  static const _templateArbFileKey = 'template-arb-file';
  static const _preferredSupportedLocalesKey = 'preferred-supported-locales';

  final YamlMap _config;

  _ConfigParser(YamlMap config) : _config = config;

  GeneratorConfig transform() => GeneratorConfig(
        arbDir: _arbDir,
        syntheticPackage: _syntheticPackage,
        outputDir: _outputDir,
        outputClass: _outputClass,
        outputLocalizationFile: _outputLocalizationFile,
        templateArbFile: _templateArbFile,
        preferredSupportedLocales: _preferredSupportedLocales,
      );

  String? get _arbDir => _readProp<String>(_arbDirKey);

  bool? get _syntheticPackage => _readProp<bool>(_syntheticPackageKey);

  String? get _outputDir => _readProp<String>(_outputDirKey);

  String? get _outputClass {
    final outputClass = _readProp<String>(_outputClassKey);
    if (outputClass != null && !outputClass.isValidClassName) {
      throw GeneratorException('$_outputClassKey($outputClass) not valid');
    }

    return outputClass;
  }

  String? get _outputLocalizationFile {
    final outputLocalizationFile = _readProp<String>(
      _outputLocalizationFileKey,
    );
    if (outputLocalizationFile != null &&
        !outputLocalizationFile.endsWith('.dart')) {
      throw GeneratorException(
        '$_outputLocalizationFileKey($outputLocalizationFile) should be .dart file',
      );
    }

    return outputLocalizationFile;
  }

  String? get _templateArbFile {
    final templateArbFile = _readProp<String>(_templateArbFileKey);
    if (templateArbFile != null && !templateArbFile.endsWith('.arb')) {
      throw GeneratorException(
        '$_templateArbFileKey($templateArbFile) should be a .arb file',
      );
    }

    return templateArbFile;
  }

  List<String>? get _preferredSupportedLocales {
    final list = _readProp<YamlList>(_preferredSupportedLocalesKey)
        ?.value
        .map((e) => e.toString())
        .map((e) => e.replaceAll('-', '_'))
        .toList();
    if (list != null && !list.every((e) => e.isLocale)) {
      throw GeneratorException(
        '$_preferredSupportedLocalesKey($list) contains invalid locales',
      );
    }

    return list;
  }

  T? _readProp<T>(String key) {
    final prop = _config[key];
    return prop is T ? prop : null;
  }
}
