// ignore_for_file: file_names

library lokalise_flutter_sdk;

import 'dart:io';
import 'package:lokalise_flutter_sdk/src/generator/generator.dart';
import 'package:lokalise_flutter_sdk/src/generator/generator_config.dart';
import 'package:lokalise_flutter_sdk/src/generator/exceptions/generator_exception.dart';
import 'package:lokalise_flutter_sdk/src/generator/logger.dart';
import 'package:path/path.dart';

Future<void> main(List<String> args) async {
  try {
    final generator = Generator(config: _getConfig());
    await generator.generate();
  } on GeneratorException catch (e) {
    Logger.instance.error(e.message);
    exit(1);
  } catch (e) {
    Logger.instance.error(
      'Failed to generate localization files.\n$e',
    );
    exit(2);
  }
}

GeneratorConfig _getConfig() {
  final configFilePaths = [
    // file in root directory
    GeneratorConfig.configFile,
    // file in lib/l10n (to keep compatibility)
    join(
      Directory.current.path,
      'lib',
      'l10n',
      GeneratorConfig.configFile,
    ),
  ];

  for (final path in configFilePaths) {
    final file = File(path);
    if (file.existsSync()) {
      return GeneratorConfig.fromConfigFile(file: file);
    }
  }

  return GeneratorConfig.byDefault();
}
