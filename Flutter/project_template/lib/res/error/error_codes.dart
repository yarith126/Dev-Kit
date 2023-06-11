import 'package:flutter/material.dart';

/// A human readable error codes
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