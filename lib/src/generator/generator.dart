import 'dart:io';
import 'package:lokalise_flutter_sdk/src/extensions/string.dart';
import 'package:lokalise_flutter_sdk/src/extensions/directory.dart';
import 'package:lokalise_flutter_sdk/src/extensions/file.dart';
import 'package:lokalise_flutter_sdk/src/generator/dart_generator/localization_generator.dart';
import 'package:lokalise_flutter_sdk/src/generator/dart_generator/synthetic_package_generator.dart';
import 'package:lokalise_flutter_sdk/src/generator/generator_config.dart';
import 'package:lokalise_flutter_sdk/src/generator/dart_generator/intl_translation_proxy.dart';
import 'exceptions/generator_exception.dart';

class Generator {
  final GeneratorConfig _config;

  Generator({required GeneratorConfig config}) : _config = config;

  Future<void> generate() async {
    final arbDir = Directory(_config.arbDir);
    if (!arbDir.existsSync()) {
      throw GeneratorException('Arb dir ${_config.arbDir} not found');
    }

    final templateArb = arbDir.getFile(
      withName: _config.templateArbFile,
    );
    if (templateArb == null) {
      throw GeneratorException(
          'Template file ${_config.templateArbFile} not found');
    }

    final locales = arbDir
        .getFiles(withExtension: 'arb')
        .map((e) => e.extractLocale())
        .whereType<String>()
        .toList();
    for (final locale in locales) {
      if (!locale.isLocale) {
        throw GeneratorException('Invalid $locale locale in arb files');
      }
    }

    final outputDir = await Directory(_config.outputDir).createIfNotExists();
    await outputDir.clean();

    final localizationFile = await _generateLocalizationFile(
      templateArb: templateArb,
      locales: locales,
      outputDir: outputDir,
    );

    await _generateIntlFiles(
      arbDir: arbDir,
      outputDir: outputDir,
      localizationFile: localizationFile,
    );

    if (_config.syntheticPackage) {
      await SyntheticPackageGenerator(outputDir: outputDir.parent).generate();
    }
  }

  Future<File> _generateLocalizationFile({
    required File templateArb,
    required List<String> locales,
    required Directory outputDir,
  }) async {
    final localizationGenerator = LocalizationGenerator(
      templateArb: templateArb,
      locales: locales,
      preferedSupportedLocales: _config.preferredSupportedLocales,
    );

    return await localizationGenerator.generate(
      onDirectory: outputDir,
      withFileName: _config.outputLocalizationFile,
      withClassName: _config.outputClass,
    );
  }

  Future<void> _generateIntlFiles({
    required Directory outputDir,
    required Directory arbDir,
    required File localizationFile,
  }) async {
    final intlDir = await outputDir.createSubdirectory(withName: 'intl');
    final arbFiles = arbDir.getFiles(withExtension: 'arb');
    arbFiles.sort(
      (a, b) => a.basename.compareTo(b.basename),
    );

    final proxy = IntlTranslationProxy();
    await proxy.generateFromArb(
      outputDir: intlDir,
      localizationFile: localizationFile,
      arbFiles: arbFiles,
    );

    intlDir.formatDartFiles();
  }
}
