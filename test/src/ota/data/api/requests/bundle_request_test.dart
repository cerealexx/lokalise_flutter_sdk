import 'package:flutter_test/flutter_test.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/requests/bundle_request.dart';

void main() {
  group('BundleRequest - toQueryParams', () {
    test('With preRelease', () {
      final request = BundleRequest(
        translationVersion: 10,
        appVersion: '20',
        preRelease: true,
      );
      final expected = {
        'transVersion': '10',
        'appVersion': '20',
        'prerelease': 'true',
      };
      expect(request.toQueryParams(), equals(expected));
    });

    test('Without preRelease', () {
      final request = BundleRequest(
        translationVersion: 10,
        appVersion: '20',
        preRelease: false,
      );
      final expected = {
        'transVersion': '10',
        'appVersion': '20',
      };
      expect(request.toQueryParams(), equals(expected));
    });
  });
}
