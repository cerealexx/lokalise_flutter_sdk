import 'package:flutter_test/flutter_test.dart';
import 'package:intl/src/intl_helpers.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/bundle.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/credentials.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/services/message_lookup_proxy.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/use_cases/get_local_bundle_use_case.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/use_cases/get_up_to_date_bundle_use_case.dart';
import 'package:lokalise_flutter_sdk/src/ota/lokalise_v2.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'lokalise_v2_test.mocks.dart';

@GenerateMocks([
  GetLocalBundleUseCase,
  GetUpToDateBundleUseCase,
  MessageLookupProxy,
])
void main() {
  const appVersion = '1.2.3';
  const projectId = 'test-projectId';
  late MockGetLocalBundleUseCase mockGetLocalBundleUseCase;
  late MockGetUpToDateBundleUseCase mockGetUpToDateBundleUseCase;
  late MockMessageLookupProxy mockMessageLookupProxy;
  late LokaliseV2 lokalise;

  setUp(() {
    mockGetLocalBundleUseCase = MockGetLocalBundleUseCase();
    mockGetUpToDateBundleUseCase = MockGetUpToDateBundleUseCase();
    mockMessageLookupProxy = MockMessageLookupProxy();

    lokalise = LokaliseV2(
      credentials: Credentials(projectId: projectId, token: 'token'),
      appVersion: appVersion,
      preRelease: true,
      getLocalBundleUseCase: mockGetLocalBundleUseCase,
      getUpToDateBundleUseCase: mockGetUpToDateBundleUseCase,
      messageLookupProxy: mockMessageLookupProxy,
    );
  });

  group('LokaliseV2 - messageLookUp', () {
    test('properly setted', () {
      // the MessageLookup loaded in intl should be our mock
      // what means that LokaliseV2 is properly initialized.
      expect(messageLookup, equals(mockMessageLookupProxy));
    });
  });

  group('LokaliseV2 - load', () {
    test('no bundle cached -> empty bundle is loaded', () async {
      // Given
      final bundle = Bundle.empty(projectId: projectId, appVersion: appVersion);
      when(mockGetLocalBundleUseCase.getBundle(
        projectId: projectId,
        appVersion: appVersion,
      )).thenAnswer((_) => Future.value(bundle));

      // When
      await lokalise.load();

      // Then
      verifyNever(mockGetUpToDateBundleUseCase.getBundle(dto: anyNamed('dto')));
      verify(mockMessageLookupProxy.bundle = bundle).called(1);
    });

    test('Bundle cached', () async {
      // Given
      final bundle = Bundle(
        projectId: projectId,
        appVersion: appVersion,
        translationVersion: 12,
        languageBundles: [],
      );
      when(mockGetLocalBundleUseCase.getBundle(
        projectId: projectId,
        appVersion: appVersion,
      )).thenAnswer((_) => Future.value(bundle));

      // When
      await lokalise.load();

      // Then
      verifyNever(mockGetUpToDateBundleUseCase.getBundle(dto: anyNamed('dto')));
      verify(mockMessageLookupProxy.bundle = bundle).called(1);
    });
  });

  group('LokaliseV2 - update', () {
    test('No bundle loaded and no bundle downloaded', () async {
      final bundle = Bundle.empty(projectId: projectId, appVersion: appVersion);
      when(mockMessageLookupProxy.translationVersion).thenReturn(0);
      when(mockGetUpToDateBundleUseCase.getBundle(dto: anyNamed('dto')))
          .thenAnswer((_) => Future.value(bundle));

      // When
      final res = await lokalise.update();

      // Then
      verify(mockMessageLookupProxy.bundle = bundle).called(1);
      expect(res.oldbundleVersion, equals(0));
      expect(res.oldbundleVersion, equals(res.newBundleVersion));
    });

    test('Bundle loaded and no bundle downloaded', () async {
      final bundle = Bundle(
        projectId: projectId,
        appVersion: appVersion,
        translationVersion: 12,
        languageBundles: [],
      );
      when(mockMessageLookupProxy.translationVersion)
          .thenReturn(bundle.translationVersion);
      when(mockGetUpToDateBundleUseCase.getBundle(dto: anyNamed('dto')))
          .thenAnswer((_) => Future.value(bundle));

      // When
      final res = await lokalise.update();

      // Then
      verify(mockMessageLookupProxy.bundle = bundle).called(1);
      expect(res.oldbundleVersion, equals(bundle.translationVersion));
      expect(res.newBundleVersion, equals(bundle.translationVersion));
    });

    test('new bundle downloaded', () async {
      const cachedBundleVersion = 10;
      final newBundle = Bundle(
        projectId: projectId,
        appVersion: appVersion,
        translationVersion: 13,
        languageBundles: [],
      );
      when(mockMessageLookupProxy.translationVersion)
          .thenReturn(cachedBundleVersion);
      when(mockGetUpToDateBundleUseCase.getBundle(dto: anyNamed('dto')))
          .thenAnswer((_) => Future.value(newBundle));

      // When
      final res = await lokalise.update();

      // Then
      verify(mockMessageLookupProxy.bundle = newBundle).called(1);
      expect(res.oldbundleVersion, equals(cachedBundleVersion));
      expect(res.newBundleVersion, equals(newBundle.translationVersion));
    });
  });

  group('LokaliseV2 - metadata', () {
    test('metadata is not called by at the beginning', () {
      verifyNever(mockMessageLookupProxy.addArgNamesByKeyName(any));
    });

    test('metadata is called n times', () {
      lokalise.metadata = {
        'key1': ['arg_name1']
      };
      lokalise.metadata = {
        'key2': ['arg_name2']
      };

      verify(mockMessageLookupProxy.addArgNamesByKeyName(any)).called(2);
    });
  });
}
