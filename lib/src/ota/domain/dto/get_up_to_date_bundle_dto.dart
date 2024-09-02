import 'package:lokalise_flutter_sdk/src/ota/domain/models/credentials.dart';

class GetUpToDateBundleDto {
  final Credentials credentials;
  final String appVersion;
  final int translationVersion;
  final bool preRelease;

  GetUpToDateBundleDto({
    required this.credentials,
    required this.appVersion,
    required this.translationVersion,
    required this.preRelease,
  });
}
