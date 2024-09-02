import 'dart:convert';
import 'package:archive/archive_io.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/data_source/remote_bundle_data_source.dart';
import 'package:path/path.dart' as path;
import 'package:lokalise_flutter_sdk/src/ota/data/api/ota_api.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/requests/bundle_request.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/dto/get_up_to_date_bundle_dto.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/exceptions/internal_exception.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/bundle.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/language_bundle.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/translation/translation.dart';
import 'package:lokalise_flutter_sdk/src/ota/helpers/message_parser_wrapper.dart';
import 'package:lokalise_flutter_sdk/src/extensions/string.dart';

class RemoteBundleRepository implements RemoteBundleDataSource {
  final OtaApi _otaApi;

  RemoteBundleRepository({required OtaApi otaApi}) : _otaApi = otaApi;

  @override
  Future<Bundle?> getBundle({
    required GetUpToDateBundleDto getUpToDateBundleDto,
  }) async {
    final request = BundleRequest(
      translationVersion: getUpToDateBundleDto.translationVersion,
      appVersion: getUpToDateBundleDto.appVersion,
      preRelease: getUpToDateBundleDto.preRelease,
    );
    final response = await _otaApi.getBundle(
      credentials: getUpToDateBundleDto.credentials,
      request: request,
    );

    // response can be null if we already have the latest bundle cached.
    if (response == null) {
      return null;
    }

    return Bundle(
      projectId: getUpToDateBundleDto.credentials.projectId,
      translationVersion: response.version,
      appVersion: getUpToDateBundleDto.appVersion,
      languageBundles: _extractArchive(response.bundle),
    );
  }

  List<LanguageBundle> _extractArchive(Archive archive) {
    if (archive.isEmpty) {
      throw InternalException.bundleEmpty();
    }

    List<LanguageBundle> result = [];
    try {
      // The first element is the folder (locale/) so we skip it.
      for (ArchiveFile file in archive.files.skip(1)) {
        // Getting and validating the locale from file name
        // 'locale/es_AR.json' = 'es_AR'
        final locale = _getLocaleFromFileName(file.name);

        final Map<String, dynamic> content = json.decode(
          utf8.decode(file.content),
        );

        // Transformin Map<String, String> into Map<String, Translation?>
        final translations = content.map(
          (key, value) => MapEntry(
            key,
            MessageParserWrapper(text: value.toString()).translation,
          ),
        );
        // Removing entries with a null value
        translations.removeWhere((_, value) => value == null);

        result.add(
          LanguageBundle(
            locale: locale,
            translations:
                Map.castFrom<String, Translation?, String, Translation>(
              translations,
            ),
          ),
        );
      }
    } catch (_) {
      throw InternalException.bundleFormat(param: archive);
    }

    return result;
  }

  String _getLocaleFromFileName(String fileName) {
    // Getting locale from file name and replacing - by _ as for Flutter
    // the locales have underscore
    final locale = path.basenameWithoutExtension(fileName).replaceAll('-', '_');

    if (locale.isLocale) {
      return locale;
    }

    // Will be transformed into InternalException.bundleFormat on
    // the above method.
    throw Exception();
  }
}
