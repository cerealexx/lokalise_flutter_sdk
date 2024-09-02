import 'package:lokalise_flutter_sdk/src/generator/generator_config.dart';

import '../../assets_routes.dart';
import '../l10n_test_case.dart';

final generatorTest9Config = L10nTestCase(
  generatorConfig: GeneratorConfig(
      arbDir: '$kl10nRoute/test_9/input',
      outputLocalizationFile: 'customized.dart'),
  expectedOutput: '$kl10nRoute/test_9/output',
  title: 'Customization output localization file name',
  description:
      'Using the outputLocalizationFile to customize the output file name',
);
