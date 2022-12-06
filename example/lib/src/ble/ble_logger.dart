import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:intl/intl.dart';

class BleLogger {
  BleLogger({
    required FlutterReactiveBle ble,
  }) : _ble = ble;

  final FlutterReactiveBle _ble;
  final List<String> _logMessages = [];
  final DateFormat formatter = DateFormat('HH:mm:ss.SSS');

  List<String> get messages => _logMessages;

  void addToLog(String message) {
    final now = DateTime.now();
    _logMessages.add('${formatter.format(now)} - $message');
  }

  void clearLogs() => _logMessages.clear();

  bool get verboseLogging => _ble.logLevel == LogLevel.verbose;

  void toggleVerboseLogging() =>
      _ble.logLevel = verboseLogging ? LogLevel.none : LogLevel.verbose;
}
