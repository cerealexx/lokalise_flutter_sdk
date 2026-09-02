import 'package:lokalise_flutter_sdk/src/generator/generator_config.dart';

import '../../assets_routes.dart';
import '../l10n_test_case.dart';

final generatorTest10Config = L10nTestCase(
  generatorConfig: GeneratorConfig(arbDir: '$kl10nRoute/test_10/input'),
  expectedOutput: '$kl10nRoute/test_10/output',
  title: 'Argument-aware runtime lookup',
  description:
      'Generated runtime lookup for literal, placeholder, plural, select, and formatted messages',
);
