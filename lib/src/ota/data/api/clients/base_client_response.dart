abstract class BaseClientResponse<T, Z> {
  final int httpCode;
  final T? result;
  final Z? error;

  BaseClientResponse._internal(this.httpCode, this.result, this.error);

  BaseClientResponse.success({
    required int httpCode,
    required T result,
  }) : this._internal(httpCode, result, null);

  BaseClientResponse.failure({
    required int httpCode,
    required Z error,
  }) : this._internal(httpCode, null, error);

  bool get isSuccess => result != null;
}
