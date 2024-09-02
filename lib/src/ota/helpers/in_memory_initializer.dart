// ignore: implementation_imports
import 'package:intl/src/intl_helpers.dart';
import 'package:flutter/material.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/repositories/in_memory_local_bundle_repository.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/repositories/in_memory_remote_bundle_repository.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/data_source/local_bundle_data_source.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/data_source/remote_bundle_data_source.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/bundle.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/language_bundle.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/translation/translation.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/services/message_lookup_proxy.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/use_cases/get_local_bundle_use_case.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/use_cases/get_up_to_date_bundle_use_case.dart';
import 'package:lokalise_flutter_sdk/src/ota/helpers/message_parser_wrapper.dart';
import 'package:lokalise_flutter_sdk/src/ota/lokalise_v2.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/credentials.dart';

class InMemoryInitializer {
  final Map<Locale, Map<String, String>> _localTranslations;
  final Map<Locale, Map<String, String>> _remoteTranslations;

  InMemoryInitializer({
    required Map<Locale, Map<String, String>> localTranslations,
    required Map<Locale, Map<String, String>> remoteTranslations,
  })  : _localTranslations = localTranslations,
        _remoteTranslations = remoteTranslations;

  LokaliseV2 get lokalise {
    const appVersion = 'test';
    final localDS = _localBundleDataSource(appVersion);
    final remoteDS = _remoteBundleDataSource(appVersion);

    return LokaliseV2(
      credentials: Credentials(projectId: '', token: ''),
      appVersion: appVersion,
      preRelease: true,
      getLocalBundleUseCase: GetLocalBundleUseCase(
        localBundleDataSource: localDS,
        logger: null,
      ),
      getUpToDateBundleUseCase: GetUpToDateBundleUseCase(
        localBundleDataSource: localDS,
        remoteBundleDataSource: remoteDS,
        logger: null,
      ),
      messageLookupProxy: MessageLookupProxy(
        messageLookup: messageLookup,
        bundle: Bundle.empty(projectId: '', appVersion: appVersion),
      ),
    );
  }

  LocalBundleDataSource _localBundleDataSource(String appVersion) {
    Bundle? bundle;
    if (_localTranslations.isNotEmpty) {
      bundle = Bundle(
        projectId: '',
        translationVersion: 1,
        appVersion: appVersion,
        languageBundles: _transformToLanguageBundle(_localTranslations),
      );
    }
    return InMemoryLocalBundleRepository(bundle: bundle);
  }

  RemoteBundleDataSource _remoteBundleDataSource(String appVersion) {
    Bundle? bundle;
    if (_remoteTranslations.isNotEmpty) {
      bundle = Bundle(
        projectId: '',
        translationVersion: 2,
        appVersion: appVersion,
        languageBundles: _transformToLanguageBundle(_remoteTranslations),
      );
    }
    return InMemoryRemoteBundleRepository(bundle: bundle);
  }

  List<LanguageBundle> _transformToLanguageBundle(
    Map<Locale, Map<String, String>> translations,
  ) {
    return translations.entries.map((e) {
      final translationsParsed = e.value.map((key, value) =>
          MapEntry(key, MessageParserWrapper(text: value).translation));
      translationsParsed.removeWhere((_, value) => value == null);

      return LanguageBundle(
        locale: e.key.toLanguageTag(),
        translations: Map.castFrom<String, Translation?, String, Translation>(
          translationsParsed,
        ),
      );
    }).toList();
  }
}
