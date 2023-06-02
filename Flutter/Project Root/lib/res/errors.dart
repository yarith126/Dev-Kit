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

/// ----------------- Error Screens -----------------

/// Error dialog for platform errors
showPlatformErrorDialog() {
  // if (navigatorKey.currentContext == null) {
  //   return;
  // }
  //
  // showDialog(
  //   context: navigatorKey.currentContext!,
  //   builder: (context) {
  //     return Container();
  //   },
  // );
}

/// Flutter fatal screen
class FlutterFatalScreen extends StatelessWidget {
  const FlutterFatalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implementation
    return Container();
  }
}

/// Play Services Unavailable screen
class PlayServicesUnavailableScreen extends StatelessWidget {
  const PlayServicesUnavailableScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implementation
    return Container();
  }
}
