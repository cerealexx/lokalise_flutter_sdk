import 'package:lokalise_flutter_sdk/src/generator/generator_config.dart';

import '../../assets_routes.dart';
import '../l10n_test_case.dart';

final generatorTest4Config = L10nTestCase(
  generatorConfig: GeneratorConfig(
    arbDir: '$kl10nRoute/test_4/input',
    outputDir: '$kGeneratedRoute/test_4',
  ),
  expectedOutput: '$kl10nRoute/test_4/output',
  title: 'Customization of the output directory',
  description:
      'The files are generated on the output-dir specified in the config',
);
