import 'dart:io';
import 'package:path/path.dart';
import 'package:lokalise_flutter_sdk/src/extensions/file.dart';

extension DirectoryUtils on Directory {
  Future<Directory> createIfNotExists() async {
    if (existsSync()) {
      return this;
    }

    return create(recursive: true);
  }

  Future<Directory> createSubdirectory({required String withName}) async {
    final subDir = Directory(join(path, withName));
    if (subDir.existsSync()) {
      return subDir;
    }

    return subDir.create(recursive: true);
  }

  Future<void> clean() => Future.forEach(
        listSync(),
        (FileSystemEntity e) async => await e.delete(recursive: true),
      );

  File? getFile({required String withName}) {
    final file = File(join(path, withName));
    return file.existsSync() ? file : null;
  }

  bool existsFile({required String withName}) =>
      getFile(withName: withName) != null;

  List<File> getFiles({
    String withExtension = '',
  }) =>
      listSync()
          .whereType<File>()
          .where((e) => e.path.endsWith(withExtension))
          .toList();

  Future<File> createFile({required String withName}) =>
      File(join(path, withName)).create(recursive: true);

  void formatDartFiles() =>
      getFiles().forEach((e) => e.writeDart(content: e.readAsStringSync()));
}
