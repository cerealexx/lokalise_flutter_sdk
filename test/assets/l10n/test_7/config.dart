import 'package:lokalise_flutter_sdk/src/generator/generator_config.dart';

import '../../assets_routes.dart';
import '../l10n_test_case.dart';

final generatorTest7Config = L10nTestCase(
  generatorConfig: GeneratorConfig(
    arbDir: '$kl10nRoute/test_7/input',
    preferredSupportedLocales: ['es'],
  ),
  expectedOutput: '$kl10nRoute/test_7/output',
  title: 'Customization of locales order',
  description:
      'Using preferredSupportedLocales prop we should be able to modify the locales order',
);
