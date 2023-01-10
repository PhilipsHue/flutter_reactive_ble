import 'package:intl/intl.dart';

class BleLogger {
  final List<String> _logMessages = [];
  final DateFormat formatter = DateFormat('HH:mm:ss.SSS');

  List<String> get messages => _logMessages;

  void addToLog(String message) {
    final now = DateTime.now();
    _logMessages.add('${formatter.format(now)} - $message');
  }

  void clearLogs() => _logMessages.clear();
}
