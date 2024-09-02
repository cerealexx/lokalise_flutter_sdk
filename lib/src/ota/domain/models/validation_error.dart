class ValidationError<T> {
  final Type type;
  final String path;
  final T received;
  final Type? expectedType;

  ValidationError({
    required this.type,
    required this.path,
    required this.received,
    this.expectedType,
  });

  get message {
    late String message;
    if (expectedType != null) {
      message =
          '[$path] invalid type (expected: ${expectedType.toString()}, received: $received)';
    } else {
      message = '[$path] not valid (received: $received)';
    }

    return '${type.toString()} -> $message';
  }
}
