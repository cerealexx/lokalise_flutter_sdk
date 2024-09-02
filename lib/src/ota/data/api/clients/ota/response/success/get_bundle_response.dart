import 'package:lokalise_flutter_sdk/src/ota/domain/exceptions/validation_exception.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/validation_error.dart';

class GetBundleResponse {
  final String url;
  final int version;

  GetBundleResponse({required this.url, required this.version});

  GetBundleResponse.empty() : this(url: '', version: 0);

  factory GetBundleResponse.fromJson({required Map<String, dynamic> json}) {
    _validateJson(json);

    final data = json['data'] as Map<String, dynamic>;
    return GetBundleResponse(
      url: data['url'] as String,
      version: data['version'] as int,
    );
  }

  bool get isEmpty => url.isEmpty && version == 0;

  static void _validateJson(Map<String, dynamic> json) {
    final List<ValidationError> errors = [];

    if (json['data'] is! Map<String, dynamic>) {
      errors.add(ValidationError(
        type: GetBundleResponse,
        path: 'data',
        received: json['data'],
        expectedType: Map<String, dynamic>,
      ));
      throw ValidationException(errors: errors);
    }

    final data = json['data'] as Map<String, dynamic>;
    if (data['url'] is String) {
      final url = data['url'] as String;
      if (url.isEmpty || (Uri.tryParse(url)?.host.isEmpty ?? true)) {
        errors.add(ValidationError(
          type: GetBundleResponse,
          path: 'data -> url',
          received: url,
        ));
      }
    } else {
      errors.add(ValidationError(
        type: GetBundleResponse,
        path: 'data -> url',
        received: data['url'],
        expectedType: String,
      ));
    }

    if (data['version'] is int) {
      final version = data['version'] as int;
      if (version < 0) {
        errors.add(ValidationError(
          type: GetBundleResponse,
          path: 'data -> version',
          received: version,
        ));
      }
    } else {
      errors.add(ValidationError(
        type: GetBundleResponse,
        path: 'data -> version',
        received: data['version'],
        expectedType: int,
      ));
    }

    if (errors.isNotEmpty) {
      throw ValidationException(errors: errors);
    }
  }
}
