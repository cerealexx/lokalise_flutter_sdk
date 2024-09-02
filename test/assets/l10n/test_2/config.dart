import 'package:lokalise_flutter_sdk/src/generator/generator_config.dart';

import '../../assets_routes.dart';
import '../l10n_test_case.dart';

final generatorTest2Config = L10nTestCase(
  generatorConfig: GeneratorConfig(arbDir: '$kl10nRoute/test_2/input'),
  expectedOutput: '$kl10nRoute/test_2/output',
  title: 'Placeholder with metadata',
  description:
      'Default configuration with arb files for 2 langs containing text with placeholder with metadata',
);
