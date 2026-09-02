import 'dart:io';

import 'package:lokalise_flutter_sdk/src/ota/data/persistence/bundle_document_store.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

BundleDocumentStore createBundleDocumentStore() => NativeBundleDocumentStore();

typedef ApplicationSupportDirectoryProvider = Future<Directory> Function();
typedef AtomicFileReplacement = Future<void> Function(
  File temporaryFile,
  String destinationPath,
);

class NativeBundleDocumentStore implements BundleDocumentStore {
  static const storageDirectoryName = 'lokalise_flutter_sdk';
  static const bundleFileName = 'ota_bundle.json';
  static const temporaryFileSuffix = '.tmp';

  final ApplicationSupportDirectoryProvider _applicationSupportDirectory;
  final AtomicFileReplacement _atomicFileReplacement;

  NativeBundleDocumentStore({
    ApplicationSupportDirectoryProvider? applicationSupportDirectory,
    AtomicFileReplacement? atomicFileReplacement,
  })  : _applicationSupportDirectory =
            applicationSupportDirectory ?? getApplicationSupportDirectory,
        _atomicFileReplacement = atomicFileReplacement ?? _renameTemporaryFile;

  @override
  Future<String?> read() async {
    final file = await _bundleFile();
    if (!await file.exists()) {
      return null;
    }
    return file.readAsString();
  }

  @override
  Future<void> replace(
    String value, {
    required BundleDocumentValidator validator,
  }) async {
    final destination = await _bundleFile(createDirectory: true);
    final temporary = File('${destination.path}$temporaryFileSuffix');

    try {
      await temporary.writeAsString(value, flush: true);
      final stagedValue = await temporary.readAsString();
      if (!validator(stagedValue)) {
        throw const FormatException('Invalid OTA bundle document');
      }

      await _atomicFileReplacement(temporary, destination.path);
    } finally {
      if (await temporary.exists()) {
        await temporary.delete();
      }
    }
  }

  @override
  Future<bool> remove() async {
    final file = await _bundleFile();
    final temporary = File('${file.path}$temporaryFileSuffix');
    var removed = false;
    if (await file.exists()) {
      await file.delete();
      removed = true;
    }
    if (await temporary.exists()) {
      await temporary.delete();
      removed = true;
    }
    return removed;
  }

  Future<File> _bundleFile({bool createDirectory = false}) async {
    final applicationSupport = await _applicationSupportDirectory();
    final directory = Directory(
      path.join(applicationSupport.path, storageDirectoryName),
    );
    if (createDirectory) {
      await directory.create(recursive: true);
    }
    return File(path.join(directory.path, bundleFileName));
  }

  static Future<void> _renameTemporaryFile(
    File temporaryFile,
    String destinationPath,
  ) async {
    await temporaryFile.rename(destinationPath);
  }
}
