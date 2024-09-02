import 'package:lokalise_flutter_sdk/src/generator/generator_config.dart';

import '../../assets_routes.dart';
import '../l10n_test_case.dart';

final generatorTest1Config = L10nTestCase(
  generatorConfig: GeneratorConfig(arbDir: '$kl10nRoute/test_1/input'),
  expectedOutput: '$kl10nRoute/test_1/output',
  title: 'Placeholder without metadata',
  description:
      'Default configuration with arb files for 2 langs containing text with placeholder but without metadata',
);
