import 'dart:convert';
import 'package:http/http.dart';

import '../errors.dart';

/// Checks http response and return json
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

/// Decodes json
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

/// Throws error with stack
Never _chainedThrow(error, stack) {
  throw Error.throwWithStackTrace(error, stack);
}
