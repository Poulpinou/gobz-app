import 'dart:developer' as logger;

class Log {
  static void info(String message) {
    _sendLog(message: message, level: LogLevel.INFO);
  }

  static void warning(String message) {
    _sendLog(message: message, level: LogLevel.WARNING);
  }

  static void error(String message, Object error) {
    if (error is Error) {
      _sendLog(message: message, level: LogLevel.ERROR, error: error, stackTrace: error.stackTrace);
    } else {
      _sendLog(message: message, level: LogLevel.ERROR, error: error);
    }
  }

  static void _sendLog(
      {required String message, LogLevel level = LogLevel.INFO, Object? error, StackTrace? stackTrace}) {
    final DateTime time = DateTime.now();

    logger.log("[${time.toIso8601String()}][${level.stringValue}] $message",
        level: level.index, error: error, time: time, stackTrace: stackTrace);
  }
}

enum LogLevel { INFO, WARNING, ERROR }

extension LogLevelExt on LogLevel {
  String get stringValue => this.toString().split('.').last;
}
