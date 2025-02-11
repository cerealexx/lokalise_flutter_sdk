import 'dart:io';

import 'package:lokalise_flutter_sdk/src/extensions/directory.dart';

class SyntheticPackageGenerator {
  static const _packageFilename = 'pubspec.yaml';

  final Directory outputDir;

  SyntheticPackageGenerator({required this.outputDir});

  Future<void> generate() async {
    if (outputDir.existsFile(withName: _packageFilename)) {
      return;
    }

    final file = await outputDir.createFile(withName: _packageFilename);
    file.writeAsStringSync(_content);
  }

  String get _content => '''
# Generated by the flutter tool
name: synthetic_package
description: The Flutter application's synthetic package.
''';
}
