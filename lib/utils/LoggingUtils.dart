import 'dart:developer' as logger;

class Log {
  static void info(String message) {
    _sendLog(message: message, level: LogLevel.INFO);
  }

  static void warning(String message) {
    _sendLog(message: message, level: LogLevel.WARNING);
  }

  static void error(String message, Exception exception) {
    _sendLog(message: message, level: LogLevel.ERROR, exception: exception);
  }

  static void _sendLog(
      {required String message, LogLevel level = LogLevel.INFO, Exception? exception}) {
    final DateTime time = DateTime.now();

    logger.log("[${time.toIso8601String()}][${level.stringValue}] $message",
        level: level.index, error: exception, time: time);
  }
}

enum LogLevel { INFO, WARNING, ERROR }

extension LogLevelExt on LogLevel {
  String get stringValue => this.toString().split('.').last;
}
