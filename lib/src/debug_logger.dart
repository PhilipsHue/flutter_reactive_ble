import 'package:flutter_reactive_ble/src/model/log_level.dart';

class DebugLogger {
  DebugLogger(void Function(Object object) printToConsole)
      : _printToConsole = printToConsole;

  void enable() {
    _logLevel = LogLevel.verbose;
  }

  void disable() {
    _logLevel = LogLevel.none;
  }

  void log(Object message) {
    if (_logLevel == LogLevel.verbose) {
      _printToConsole('REACTIVE_BLE: $message');
    }
  }

  final void Function(Object object) _printToConsole;
  LogLevel _logLevel = LogLevel.none;
}
