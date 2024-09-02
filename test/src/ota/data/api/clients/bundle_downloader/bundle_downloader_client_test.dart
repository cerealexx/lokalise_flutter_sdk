import 'package:archive/archive_io.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/clients/bundle_downloader/bundle_downloader_client.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/exceptions/api_exception.dart';

void main() {
  MockClient getMockClient(String url, List<int> body, int code) {
    return MockClient((request) async {
      expect(request.method, equals('GET'));
      expect(request.url.toString(), equals(url));
      return Response(String.fromCharCodes(body), code);
    });
  }

  group('BundleDownloaderClient - download', () {
    test('200 returns archive', () async {
      // Given
      const resourceUrl = 'http://test-url.com/200';
      final zipEncoder = ZipEncoder();

      final bundleDownloader = BundleDownloaderClient(
        httpClient: getMockClient(
          resourceUrl,
          zipEncoder.encode(Archive())!,
          200,
        ),
        zipDecoder: ZipDecoder(),
      );

      // When
      final response =
          await bundleDownloader.download(resourceUrl: resourceUrl);

      // Then
      expect(response.isSuccess, equals(true));
      expect(response.httpCode, equals(200));
      expect(response.result!.files.isEmpty, equals(true));
    });

    test('Not 200 throws ApiException', () async {
      // Given
      const resourceUrl = 'http://test-url.com/400';
      final bundleDownloader = BundleDownloaderClient(
        httpClient: getMockClient(
          resourceUrl,
          [],
          400,
        ),
        zipDecoder: ZipDecoder(),
      );

      // When - Then
      ApiException? exception;
      try {
        await bundleDownloader.download(resourceUrl: resourceUrl);
      } on ApiException catch (e) {
        exception = e;
      }

      // Then
      expect(exception!.httpCode, equals(400));
      expect(exception.responseBody, equals(''));
    });
  });
}
