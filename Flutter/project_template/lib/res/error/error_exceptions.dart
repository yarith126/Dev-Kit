/// Exception for json parsing error
class JsonException extends _ErrorCodeException {
  JsonException(String errorCode, Object message) : super(errorCode, message);
}

/// Exception for model parsing error
class ModelException extends _ErrorCodeException {
  ModelException(String errorCode, Object message) : super(errorCode, message);
}

/// Exception for bad http status code
class HttpStatusException extends _ErrorCodeException {
  HttpStatusException(String errorCode, int statusCode, Object message)
      : super('${errorCode}_$statusCode', message);
}

/// Base class for custom errors
abstract class _ErrorCodeException implements Exception {
  String errorCode;
  Object message;

  _ErrorCodeException(this.errorCode, this.message);

  @override
  String toString() {
    return '$runtimeType: [$errorCode] $message';
  }
}
