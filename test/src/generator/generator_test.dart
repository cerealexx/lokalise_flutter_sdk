import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/src/extensions/directory.dart';
import 'package:lokalise_flutter_sdk/src/extensions/file.dart';
import 'package:lokalise_flutter_sdk/src/generator/generator.dart';

import '../../assets/l10n/l10n_test_case.dart';
import '../../assets/l10n/test_0/config.dart';
import '../../assets/l10n/test_1/config.dart';
import '../../assets/l10n/test_2/config.dart';
import '../../assets/l10n/test_3/config.dart';
import '../../assets/l10n/test_4/config.dart';
import '../../assets/l10n/test_5/config.dart';
import '../../assets/l10n/test_6/config.dart';
import '../../assets/l10n/test_7/config.dart';
import '../../assets/l10n/test_8/config.dart';
import '../../assets/l10n/test_9/config.dart';

/// Please read test/assets/l10n/readme.md to learn about this test file.
void main() {
  String? directoryToClean;

  Future<void> executeTestCase(L10nTestCase testCase) async {
    final expectedDirectory = Directory(testCase.expectedOutput);
    if (!expectedDirectory.existsSync()) {
      fail('Expected output directory not found');
    }

    final generator = Generator(config: testCase.generatorConfig);
    await generator.generate();

    Directory generatedDir = Directory(testCase.generatorConfig.outputDir);
    if (!generatedDir.existsSync()) {
      fail('Generated directory not found');
    }
    if (testCase.generatorConfig.syntheticPackage) {
      generatedDir = generatedDir.parent;
    }
    directoryToClean = generatedDir.path;

    final expectedFiles = expectedDirectory.getFiles();
    final generatedFiles = generatedDir.getFiles();

    for (final generatedFile in generatedFiles) {
      final expectedFile = expectedFiles.firstWhere(
        (e) => e.basename == generatedFile.basename,
        orElse: () => File(''),
      );
      expect(
        expectedFile.existsSync(),
        isTrue,
        reason: testCase.buildFailureMessage('Expected file not found'),
      );
      expect(
        generatedFile.path.endsWith(
          expectedFile.path.replaceAll(expectedDirectory.path, ''),
        ),
        isTrue,
        reason: 'Generated file tree for ${generatedFile.path} not expected',
      );
      expect(
        generatedFile.readAsStringSync(),
        equals(expectedFile.readAsStringSync()),
        reason: testCase.buildFailureMessage('Files content are not equals'),
      );
    }
  }

  group('Generator tests', () {
    tearDown(() {
      if (directoryToClean == null) {
        return;
      }

      final generated = Directory(directoryToClean!);
      if (generated.existsSync()) {
        generated.deleteSync(recursive: true);
      }

      // Cleaning lib/l10n in case it exists
      final directory = Directory('lib/l10n');
      if (directory.existsSync()) {
        directory.deleteSync(recursive: true);
      }
    });

    test(
      'Test 0',
      () async => await executeTestCase(generatorTest0Config),
    );
    test(
      'Test 1',
      () async => await executeTestCase(generatorTest1Config),
    );
    test(
      'Test 2',
      () async => await executeTestCase(generatorTest2Config),
    );
    test(
      'Test 3',
      () async => await executeTestCase(generatorTest3Config),
    );
    test(
      'Test 4',
      () async => await executeTestCase(generatorTest4Config),
    );
    test(
      'Test 5',
      () async => await executeTestCase(generatorTest5Config),
    );
    test(
      'Test 6',
      () async => await executeTestCase(generatorTest6Config),
    );
    test(
      'Test 7',
      () async => await executeTestCase(generatorTest7Config),
    );
    test(
      'Test 8',
      () async => await executeTestCase(generatorTest8Config),
    );
    test(
      'Test 9',
      () async => await executeTestCase(generatorTest9Config),
    );
  });
}
