import 'package:lokalise_flutter_sdk/src/generator/generator_config.dart';

import '../../assets_routes.dart';
import '../l10n_test_case.dart';

final generatorTest5Config = L10nTestCase(
  generatorConfig: GeneratorConfig(
    arbDir: '$kl10nRoute/test_5/input',
    syntheticPackage: true,
  ),
  expectedOutput: '$kl10nRoute/test_5/output',
  title: 'Using synthetic-package',
  description:
      'With synthetic-package as true, the files are generated in the correct path with the corresponding pubspec.yaml',
);
