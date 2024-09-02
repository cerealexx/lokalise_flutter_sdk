import 'package:lokalise_flutter_sdk/src/generator/generator_config.dart';

import '../../assets_routes.dart';
import '../l10n_test_case.dart';

final generatorTest0Config = L10nTestCase(
  generatorConfig: GeneratorConfig(arbDir: '$kl10nRoute/test_0/input'),
  expectedOutput: '$kl10nRoute/test_0/output',
  title: 'Basic arb',
  description:
      'Default configuration with arb files for 2 langs containing just simple text keys',
);
