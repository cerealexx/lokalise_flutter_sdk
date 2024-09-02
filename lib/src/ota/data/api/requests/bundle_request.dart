class BundleRequest {
  final int translationVersion;
  final String appVersion;
  final bool preRelease;

  BundleRequest({
    required this.translationVersion,
    required this.appVersion,
    required this.preRelease,
  });

  Map<String, String> toQueryParams() {
    final Map<String, String> result = {
      'transVersion': translationVersion.toString(),
      'appVersion': appVersion,
    };

    if (preRelease) {
      result['prerelease'] = preRelease.toString();
    }

    return result;
  }
}
