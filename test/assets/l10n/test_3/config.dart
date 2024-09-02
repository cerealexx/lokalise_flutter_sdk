import 'package:lokalise_flutter_sdk/src/generator/generator_config.dart';

import '../../assets_routes.dart';
import '../l10n_test_case.dart';

final generatorTest3Config = L10nTestCase(
  generatorConfig: GeneratorConfig(
    arbDir: '$kl10nRoute/test_3/input',
    outputClass: 'Custom',
  ),
  expectedOutput: '$kl10nRoute/test_3/output',
  title: 'Basic arb using custom class name (output-class)',
  description:
      'Using a non default class name (output-class) with simple arb files',
);
