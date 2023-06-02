import 'dart:convert';

import 'package:http/http.dart';

/// Verifies http response and return reponse body
///
/// Throws [HttpStatusException] if the http status code isn't 20x
///
/// Throws [JsonException] if the input is not valid JSON text.
Map<String, dynamic> processHttpResponse(Response response) {
  response.headers;
  var json = decodeJson(response.body);

  String errorCode = response.statusCode.toString();
  if (!errorCode.startsWith('20')) {
    var message = json['message'];
    if (message != null && message is String) {
      throw HttpStatusException(
          ErrorCode.httpException, response.statusCode, message);
    }
    throw HttpStatusException(
        ErrorCode.httpException, response.statusCode, response.body);
  }
  return json;
}

/// Returns json['data']
///
/// Throws [JsonException] if json['data'] is null
getJsonData(Map<String, dynamic> json) {
  var data = json['data'];
  if (data == null) throw JsonException(ErrorCode.jsonDataIsNull, json);
  return data;
}

/// Decodes string to json
///
/// Throws [JsonException] if the input is not valid JSON text.
Map<String, dynamic> decodeJson(String encodedJson) {
  try {
    return jsonDecode(encodedJson);
  } on FormatException catch (e, s) {
    _chainedThrow(JsonException(ErrorCode.jsonBadFormat, e), s);
  } catch (e, s) {
    _chainedThrow(JsonException(ErrorCode.jsonException, e), s);
  }
}

Never _chainedThrow(error, stack) {
  throw Error.throwWithStackTrace(error, stack);
}

/// -------------------- Exceptions --------------------

/// Error code
class ErrorCode {
  static String unhandledException = 'UNHANDLED_EXCEPTION';
  static String jsonException = 'NOT_A_JSON';
  static String jsonBadFormat = 'JSON_BAD_FORMAT';
  static String jsonDataIsNull = 'JSON_DATA_IS_NULL';
  static String modelException = 'MODEL_EXCEPTION';
  static String socketException = 'SOCKET_EXCEPTION';
  static String httpException = 'HTTP_EXCEPTION';
  static String playServiceUnavailable = 'PLAY_SERVICE_UNAVAILABLE';
  static String flutterError = 'FLUTTER_ERROR';
}

/// Custom abtract exception
abstract class _ErrorCodeException implements Exception {
  String errorCode;
  Object message;

  _ErrorCodeException(this.errorCode, this.message);

  @override
  String toString() {
    return '$runtimeType: [$errorCode] $message';
  }
}

class JsonException extends _ErrorCodeException {
  JsonException(String errorCode, Object message) : super(errorCode, message);
}

class ModelException extends _ErrorCodeException {
  ModelException(String errorCode, Object message) : super(errorCode, message);
}

class HttpStatusException extends _ErrorCodeException {
  HttpStatusException(String errorCode, int statusCode, Object message)
      : super('${errorCode}_$statusCode', message);
}