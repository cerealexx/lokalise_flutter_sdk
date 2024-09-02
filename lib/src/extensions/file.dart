import 'dart:convert';
import 'dart:io';
import 'package:dart_style/dart_style.dart' show DartFormatter;
import 'package:path/path.dart' as path;

extension DartFile on File {
  static final _dartFormatter = DartFormatter();

  void writeDart({required String content}) =>
      writeAsStringSync(_dartFormatter.format(content));
}

extension ArbFile on File {
  Map<String, dynamic> readAsArb() =>
      json.decode(readAsStringSync()) as Map<String, dynamic>;

  String? extractLocale() {
    final locale = readAsArb()['@@locale'];

    return locale is String ? locale.replaceAll('-', '_') : null;
  }
}

extension FilePath on File {
  String get basename => path.basename(this.path);
  String get basenameWithoutExtension =>
      path.basenameWithoutExtension(this.path);
}
