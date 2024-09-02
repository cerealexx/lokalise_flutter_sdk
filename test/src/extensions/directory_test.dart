import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/src/extensions/directory.dart';

import '../../assets/assets_routes.dart';

void main() {
  group('Directory extension', () {
    late Directory directory;

    setUp(() {
      directory = Directory('$kGeneratedRoute/directory_extension');
    });

    tearDown(() {
      directory.deleteSync(recursive: true);
    });

    test('createIfNotExists', () async {
      expect(directory.existsSync(), isFalse);
      // create when it does not exist
      directory = await directory.createIfNotExists();
      expect(directory.existsSync(), isTrue);
      // create when it exists
      directory = await directory.createIfNotExists();
      expect(directory.existsSync(), isTrue);
    });

    test('createSubdirectory', () async {
      directory = await directory.create(recursive: true);
      final subdir = await directory.createSubdirectory(withName: 'subdir');
      expect(subdir.existsSync(), isTrue);
    });

    test('clean - empty directory', () async {
      directory = await directory.create(recursive: true);
      await directory.clean();
      expect(directory.listSync(recursive: true), isEmpty);
    });

    test('clean - no empty directory', () async {
      directory = await directory.create(recursive: true);
      expect(directory.listSync(recursive: true), isEmpty);
      for (final e in ['name_1', 'name_2', 'dir/name_3', 'dir/dir2/name_4']) {
        File('${directory.path}/$e').createSync(recursive: true);
      }
      expect(directory.listSync(recursive: true), isNotEmpty);

      await directory.clean();
      expect(directory.listSync(recursive: true), isEmpty);
    });

    test('getFile - non exists', () async {
      directory = await directory.create(recursive: true);
      expect(directory.getFile(withName: 'name'), isNull);
    });

    test('getFile - exists', () async {
      directory = await directory.create(recursive: true);
      const fileName = 'name';
      File('${directory.path}/$fileName').createSync();

      final file = directory.getFile(withName: fileName);
      expect(file, isNotNull);
      expect(file!.existsSync(), isTrue);
    });

    test('existsFile - non exists', () async {
      directory = await directory.create(recursive: true);
      expect(directory.existsFile(withName: 'name'), isFalse);
    });

    test('existsFile - exists', () async {
      directory = await directory.create(recursive: true);
      const fileName = 'name';
      File('${directory.path}/$fileName').createSync();

      expect(directory.existsFile(withName: fileName), isTrue);
    });

    test('getFiles - empty directory', () async {
      directory = await directory.create(recursive: true);
      expect(directory.getFiles(), isEmpty);
    });

    test('getFiles - all files', () async {
      directory = await directory.create(recursive: true);
      const fileNames = ['name_1.dart', 'name_2.arb'];
      for (final e in fileNames) {
        File('${directory.path}/$e').createSync(recursive: true);
      }

      final files = directory.getFiles();
      for (final name in fileNames) {
        var exists = false;
        for (final file in files) {
          exists = file.path.contains(name);
          if (exists) break;
        }
        expect(exists, isTrue);
      }
    });

    test('getFiles - with extension', () async {
      directory = await directory.create(recursive: true);
      const extension = 'arb';
      const fileNames = ['name_1.dart', 'name_2.$extension'];
      for (final e in fileNames) {
        File('${directory.path}/$e').createSync(recursive: true);
      }

      final files = directory.getFiles(withExtension: extension);
      expect(files, hasLength(1));
      expect(files[0].path, endsWith(extension));
    });

    test('createFile - not exists', () async {
      directory = await directory.create(recursive: true);
      const name = 'name';
      final file = await directory.createFile(withName: name);
      expect(file.existsSync(), isTrue);
      expect(file.readAsStringSync(), isEmpty);
    });

    test('createFile - it already exists', () async {
      directory = await directory.create(recursive: true);
      const name = 'name';

      final file1 = await File('${directory.path}/$name').create();
      expect(file1.existsSync(), isTrue);

      final file2 = await directory.createFile(withName: name);
      expect(file2.existsSync(), isTrue);
    });

    test('format', () async {
      directory = await directory.create(recursive: true);
      final dartContent = File('$kDartRoute/class.dart').readAsStringSync();

      final newFilesContent = dartContent.replaceAll('  ', '');
      for (final e in ['name_1.dart', 'name_2.dart']) {
        (await File('${directory.path}/$e').create(recursive: true))
            .writeAsStringSync(newFilesContent);
      }

      directory.formatDartFiles();
      directory
          .listSync(recursive: true)
          .whereType<File>()
          .forEach((f) => expect(f.readAsStringSync(), dartContent));
    });
  });
}
