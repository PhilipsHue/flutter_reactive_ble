import 'package:flutter_reactive_ble/src/model/log_level.dart';

class DebugLogger {
  DebugLogger(
    String tag,
    void Function(Object object) print,
  )   : _tag = tag,
        _print = print;

  set logLevel(LogLevel logLevel) => _logLevel = logLevel;

  void log(Object message) {
    if (_logLevel == LogLevel.verbose) {
      _print('$_tag: $message');
    }
  }

  final void Function(Object object) _print;
  final String _tag;
  LogLevel _logLevel = LogLevel.none;
}
