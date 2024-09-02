import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/src/ota/helpers/initializer.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    PackageInfo.setMockInitialValues(
      appName: 'test',
      packageName: 'test',
      version: '1.0.0',
      buildNumber: 'test',
      buildSignature: 'test',
      installerStore: 'test',
    );
  });

  group('Initializer', () {
    test('version provided', () async {
      final initializer = Initializer(
        projectId: 'test-projectId',
        sdkToken: 'test-token',
        appVersion: '1.0.0',
        preRelease: true,
        logging: false,
      );
      final instance = await initializer.lokalise;
      expect(instance, isNotNull);
    });

    test('version empty', () async {
      final initializer = Initializer(
        projectId: 'test-projectId',
        sdkToken: 'test-token',
        appVersion: '',
        preRelease: true,
        logging: false,
      );
      final instance = await initializer.lokalise;
      expect(instance, isNotNull);
    });

    test('logging enabled', () async {
      final initializer = Initializer(
        projectId: 'test-projectId',
        sdkToken: 'test-token',
        appVersion: '',
        preRelease: true,
        logging: true,
      );
      final instance = await initializer.lokalise;
      expect(instance, isNotNull);
    });
  });
}
