import 'package:reactive_ble_platform_interface/reactive_ble_platform_interface.dart';

abstract class Logger {
  set logLevel(LogLevel logLevel);

  void log(Object message);
}

class DebugLogger implements Logger {
  DebugLogger(
    String tag,
    void Function(Object object) print,
  )   : _tag = tag,
        _print = print;

  @override
  set logLevel(LogLevel logLevel) => _logLevel = logLevel;

  @override
  void log(Object message) {
    if (_logLevel == LogLevel.verbose) {
      _print('$_tag: $message');
    }
  }

  final void Function(Object object) _print;
  final String _tag;
  LogLevel _logLevel = LogLevel.none;
}
