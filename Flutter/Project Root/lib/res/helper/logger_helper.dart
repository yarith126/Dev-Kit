import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;

bool _noColorMode = false;

/// A logger that prints colorful log and report errors
class Logger {
  static error(msg) => _logger(msg, _Log.error);

  static success(msg) => _logger(msg, _Log.success);

  static warning(msg) => _logger(msg, _Log.warning);

  static info(msg) => _logger(msg, _Log.info);

  static pink(msg) => _logger(msg, _Log.pink);

  static cyan(msg) => _logger(msg, _Log.cyan);

  static white(msg) => _logger(msg, _Log.white);

  static black(msg) => _logger(msg, _Log.black);

  static _logger(msg, _Log type) {
    if (!kDebugMode) return;
    if (_noColorMode) return debugPrint(msg);
    switch (type) {
      case _Log.error:
        debugPrint('\x1B[91m$msg\x1B[0m');
        break;
      case _Log.success:
        debugPrint('\x1B[92m$msg\x1B[0m');
        break;
      case _Log.warning:
        debugPrint('\x1B[93m$msg\x1B[0m');
        break;
      case _Log.info:
        debugPrint('\x1B[94m$msg\x1B[0m');
        break;
      case _Log.pink:
        debugPrint('\x1B[95m$msg\x1B[0m');
        break;
      case _Log.cyan:
        debugPrint('\x1B[96m$msg\x1B[0m');
        break;
      case _Log.white:
        debugPrint('\x1B[97m$msg\x1B[0m');
        break;
      case _Log.black:
        debugPrint('\x1B[90m$msg\x1B[0m');
        break;
      case _Log.detailError:
        debugPrint('\x1B[93mError report: \x1B[0m$msg');
        break;
    }
  }

  static detailError(Object? error,
      [StackTrace? stackTrace, Object? location]) {
    // remove unnecessary last character
    if (!(stackTrace.toString() == '' || stackTrace == null)) {
      stackTrace = StackTrace.fromString(
          stackTrace.toString().substring(0, stackTrace.toString().length - 1));
    }
    String date = DateTime.now().toString();
    date = date.substring(0, date.length - 7);

    Logger.pink('==============================================');
    debugPrint('');
    debugPrint('\x1B[94mDate: \x1B[0m$date');
    debugPrint('');
    if (error.toString().endsWith('\n')) {
      error = error.toString().substring(0, error.toString().length - 1);
    }
    debugPrint('\x1B[91mException: \x1B[0m$error');
    debugPrint('');
    if (stackTrace == null || stackTrace.toString() == '') {
      debugPrint('\x1B[91mStackTrace:\x1B[0m null');
    } else {
      debugPrint('\x1B[91mStackTrace:\x1B[0m\n$stackTrace');
    }
    debugPrint('');
    Logger.pink('==============================================');
  }
}

enum _Log {
  error,
  success,
  warning,
  info,
  pink,
  cyan,
  white,
  black,
  detailError,
}
