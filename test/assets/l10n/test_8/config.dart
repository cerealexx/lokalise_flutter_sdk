import 'package:lokalise_flutter_sdk/src/generator/generator_config.dart';

import '../../assets_routes.dart';
import '../l10n_test_case.dart';

final generatorTest8Config = L10nTestCase(
  generatorConfig: GeneratorConfig(arbDir: '$kl10nRoute/test_8/input'),
  expectedOutput: '$kl10nRoute/test_8/output',
  title: 'Check bugfix -> DP-651',
  description:
      'Bug -> Missing entry in DART files if format included for DateTime type in Key',
);
