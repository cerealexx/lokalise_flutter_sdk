import 'package:lokalise_flutter_sdk/src/generator/generator_config.dart';

import '../../assets_routes.dart';
import '../l10n_test_case.dart';

final generatorTest6Config = L10nTestCase(
  generatorConfig: GeneratorConfig(
    arbDir: '$kl10nRoute/test_6/input',
    templateArbFile: 'template.arb',
  ),
  expectedOutput: '$kl10nRoute/test_6/output',
  title: 'Using a non default template-arb-file',
  description:
      'We should use the template defined by templateArbFile as gen-10n does -> reading the locales from the @@locale property and without worryng about the naming',
);
