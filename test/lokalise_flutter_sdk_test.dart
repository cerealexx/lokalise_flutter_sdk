import 'package:intl/src/intl_helpers.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/lokalise_flutter_sdk.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/persistence/entities/bundle_entity.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/services/message_lookup_proxy.dart';
import 'package:lokalise_flutter_sdk/src/ota/lokalise_v2.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();
    PackageInfo.setMockInitialValues(
      appName: 'test',
      packageName: 'test',
      version: 'test.version',
      buildNumber: 'test',
      buildSignature: 'test',
      installerStore: 'test',
    );
  });

  group('Lokalise - init', () {
    test('invalid project id', () async {
      expect(
        Lokalise.init(projectId: '', sdkToken: 'token'),
        throwsA(const TypeMatcher<AssertionError>()),
      );
      expect(
        Lokalise.init(projectId: '    ', sdkToken: 'token'),
        throwsA(const TypeMatcher<AssertionError>()),
      );
    });

    test('invalid sdk token', () async {
      expect(
        Lokalise.init(projectId: 'project', sdkToken: ''),
        throwsA(const TypeMatcher<AssertionError>()),
      );
      expect(
        Lokalise.init(projectId: 'project', sdkToken: '     '),
        throwsA(const TypeMatcher<AssertionError>()),
      );
    });

    test('only required parameters', () async {
      SharedPreferences.setMockInitialValues({});
      await Lokalise.init(projectId: 'project', sdkToken: 'token');

      expect(Lokalise.instance, isA<LokaliseV2>());
      expect(messageLookup, isA<MessageLookupProxy>());
      final lookUp = messageLookup as MessageLookupProxy;
      expect(lookUp.translationVersion, 0);
    });

    test('using all parameters', () async {
      SharedPreferences.setMockInitialValues({});
      await Lokalise.init(
        projectId: 'project',
        sdkToken: 'token',
        appVersion: '1.0.0',
        preRelease: true,
        logging: true,
      );

      expect(Lokalise.instance, isA<LokaliseV2>());
      expect(messageLookup, isA<MessageLookupProxy>());
      final lookUp = messageLookup as MessageLookupProxy;
      expect(lookUp.translationVersion, 0);
    });

    test('bundle cached is loaded', () async {
      const projectId = 'projectId';
      const appVersion = '1.0.0';
      const translationVersion = 123;
      final bundleEntity = BundleEntity(
        projectId: projectId,
        appVersion: appVersion,
        translationVersion: translationVersion,
        translations: {},
      );
      SharedPreferences.setMockInitialValues({
        'lokalise_stored_bundle': jsonEncode(bundleEntity.toJson()),
      });
      await Lokalise.init(
        projectId: projectId,
        sdkToken: 'token',
        appVersion: appVersion,
        preRelease: true,
      );

      expect(Lokalise.instance, isA<LokaliseV2>());
      expect(messageLookup, isA<MessageLookupProxy>());
      final lookUp = messageLookup as MessageLookupProxy;
      expect(lookUp.translationVersion, translationVersion);
    });
  });

  group('Lokalise - initMock', () {
    test('without params', () async {
      await Lokalise.initMock();
      expect(Lokalise.instance, isA<LokaliseV2>());
      expect(messageLookup, isA<MessageLookupProxy>());
      final lookUp = messageLookup as MessageLookupProxy;
      expect(lookUp.translationVersion, 0);
    });

    test('Mocking cached bundle', () async {
      await Lokalise.initMock(
        cachedBundleTranslations: {
          const Locale('en'): {'hello': 'hello world'}
        },
      );
      expect(Lokalise.instance, isA<LokaliseV2>());
      expect(messageLookup, isA<MessageLookupProxy>());
      final lookUp = messageLookup as MessageLookupProxy;
      expect(lookUp.translationVersion, 1);
    });

    test('Mocking bundles', () async {
      await Lokalise.initMock(
        cachedBundleTranslations: {
          const Locale('en'): {'hello': 'hello world'}
        },
        remoteBundleTranslations: {
          const Locale('en'): {'hello': 'hello world 2'}
        },
      );
      expect(Lokalise.instance, isA<LokaliseV2>());
      expect(messageLookup, isA<MessageLookupProxy>());
      final lookUp = messageLookup as MessageLookupProxy;
      expect(lookUp.translationVersion, 1);

      await Lokalise.instance.update();
      expect(lookUp.translationVersion, 2);
    });
  });
}
