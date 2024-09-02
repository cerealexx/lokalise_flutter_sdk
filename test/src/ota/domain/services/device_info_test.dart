import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/src/constants.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/services/device_info.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  group('DeviceInfo - appVersion', () {
    Future<void> versionChecker(String expected, String initAppVersion) async {
      final info = DeviceInfo(
        packageInfo: await PackageInfo.fromPlatform(),
        appVersion: initAppVersion,
      );
      expect(info.appVersion, equals(expected));
    }

    test('init version is not empty', () {
      const expected = 'version-test';

      PackageInfo.setMockInitialValues(
        appName: '',
        packageName: '',
        version: '1.2.3',
        buildNumber: '',
        buildSignature: '',
        installerStore: '',
      );

      versionChecker(expected, expected);
    });

    test('init version trim() is empty', () {
      const version = '1.2.3';
      const init = '        ';

      PackageInfo.setMockInitialValues(
        appName: '',
        packageName: '',
        version: version,
        buildNumber: '',
        buildSignature: '',
        installerStore: '',
      );

      versionChecker(version, init);
    });

    test('init version empty -> 1.2.3', () {
      const version = '1.2.3';
      const expected = version;

      PackageInfo.setMockInitialValues(
        appName: '',
        packageName: '',
        version: version,
        buildNumber: '',
        buildSignature: '',
        installerStore: '',
      );

      versionChecker(expected, '');
    });

    test('init version empty -> 2.3.0-beta.3', () {
      const version = '2.3.0-beta.3';
      const expected = '2.3.0';

      PackageInfo.setMockInitialValues(
        appName: '',
        packageName: '',
        version: version,
        buildNumber: '',
        buildSignature: '',
        installerStore: '',
      );

      versionChecker(expected, '');
    });

    test('init version empty -> 4.0.12-dev.2', () {
      const version = '4.0.12-dev.2';
      const expected = '4.0.12';

      PackageInfo.setMockInitialValues(
        appName: '',
        packageName: '',
        version: version,
        buildNumber: '',
        buildSignature: '',
        installerStore: '',
      );

      versionChecker(expected, '');
    });

    test('init version empty -> 3.1.0+4', () {
      const version = '3.1.0+4';
      const expected = '3.1.0';

      PackageInfo.setMockInitialValues(
        appName: '',
        packageName: '',
        version: version,
        buildNumber: '',
        buildSignature: '',
        installerStore: '',
      );

      versionChecker(expected, '');
    });

    test('init version empty -> 5.0.1+hotfix.1', () {
      const version = '5.0.1+hotfix.1';
      const expected = '5.0.1';

      PackageInfo.setMockInitialValues(
        appName: '',
        packageName: '',
        version: version,
        buildNumber: '',
        buildSignature: '',
        installerStore: '',
      );

      versionChecker(expected, '');
    });

    test('init version empty -> 8.1.2+5-beta', () {
      const version = '8.1.2+5-beta';
      const expected = '8.1.2';

      PackageInfo.setMockInitialValues(
        appName: '',
        packageName: '',
        version: version,
        buildNumber: '',
        buildSignature: '',
        installerStore: '',
      );

      versionChecker(expected, '');
    });

    test('init version empty -> 10.4.2-dev+5', () {
      const version = '10.4.2-dev+5';
      const expected = '10.4.2';

      PackageInfo.setMockInitialValues(
        appName: '',
        packageName: '',
        version: version,
        buildNumber: '',
        buildSignature: '',
        installerStore: '',
      );

      versionChecker(expected, '');
    });
  });

  group('DeviceInfo - PackageName', () {
    test('return packageInfo param', () async {
      const packageName = 'test-package-name';

      PackageInfo.setMockInitialValues(
        appName: '',
        packageName: packageName,
        version: '',
        buildNumber: '',
        buildSignature: '',
        installerStore: '',
      );

      final info = DeviceInfo(
        packageInfo: await PackageInfo.fromPlatform(),
        appVersion: '',
      );
      expect(info.packageName, equals(packageName));
    });
  });

  group('DeviceInfo - lokaliseSdkVersion', () {
    test('returns constant', () async {
      final info = DeviceInfo(
        packageInfo: await PackageInfo.fromPlatform(),
        appVersion: '',
      );

      expect(info.lokaliseSdkVersion, equals(kLokaliseSdkVersion));
    });
  });

  group('DeviceInfo - toJson', () {
    test('works', () async {
      PackageInfo.setMockInitialValues(
        appName: 'MyApp',
        packageName: 'test.package.com',
        version: '2.1.0',
        buildNumber: '18',
        buildSignature: 'qwerty',
        installerStore: 'Test store',
      );

      final info = DeviceInfo(
        packageInfo: await PackageInfo.fromPlatform(),
        appVersion: '',
      );

      expect(info.toJson(), {
        'sdk_version': kLokaliseSdkVersion,
        'app_version': '2.1.0',
        'package_name': 'test.package.com',
        'platform': info.platform,
      });
    });
  });
}
