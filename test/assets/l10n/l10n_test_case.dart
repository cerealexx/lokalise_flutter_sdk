import 'dart:convert';

import 'package:lokalise_flutter_sdk/src/generator/generator_config.dart';

class L10nTestCase {
  final String title;
  final String description;
  final GeneratorConfig generatorConfig;
  final String expectedOutput;

  L10nTestCase({
    required this.title,
    required this.description,
    required this.generatorConfig,
    required this.expectedOutput,
  });

  String buildFailureMessage(String message) => json.encode({
        'message': message,
        'case': title,
        'description': description,
      });
}
