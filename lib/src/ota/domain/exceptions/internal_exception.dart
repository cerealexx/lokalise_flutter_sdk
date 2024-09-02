import 'package:archive/archive_io.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/clients/ota/response/error/ota_error_response.dart';
import 'package:lokalise_flutter_sdk/src/ota/data/api/exceptions/api_exception.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/exceptions/validation_exception.dart';
import 'package:lokalise_flutter_sdk/src/ota/domain/models/json_serializable.dart';

class InternalException<T> implements Exception, JsonSerializable {
  static const otaApiError = 'ota_api_error';
  static const validationError = 'response_validation_error';
  static const bundleEmptyError = 'bundle_empty_error';
  static const bundleFormatError = 'bundle_format_error';
  static const unexpectedError = 'unexpected_error';

  final String code;
  final T param;

  InternalException._internal({required this.code, required this.param});

  static InternalException<ApiException> fromApiException({
    required ApiException param,
  }) =>
      InternalException._internal(
        code: otaApiError,
        param: param,
      );

  static InternalException<ValidationException> fromValidationException({
    required ValidationException param,
  }) =>
      InternalException._internal(
        code: validationError,
        param: param,
      );

  static InternalException<OtaErrorResponse> fromOtaErrorResponse({
    required OtaErrorResponse param,
  }) =>
      InternalException._internal(
        code: otaApiError,
        param: param,
      );

  static InternalException<String> bundleEmpty() => InternalException._internal(
        code: bundleEmptyError,
        param: 'The remote bundle is empty',
      );

  static InternalException<Archive> bundleFormat({
    required Archive param,
  }) =>
      InternalException._internal(
        code: bundleFormatError,
        param: param,
      );

  static InternalException<String> unexpected({
    required String param,
  }) =>
      InternalException._internal(
        code: unexpectedError,
        param: param,
      );

  @override
  Map<String, dynamic> toJson() => {
        'code': code,
        'error': param is JsonSerializable
            ? (param as JsonSerializable).toJson()
            : {'message': param.toString()},
      };
}
