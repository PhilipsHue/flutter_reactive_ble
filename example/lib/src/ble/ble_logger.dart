import 'package:intl/intl.dart';

class BleLogger {
  final List<String> _logMessages = [];
  final DateFormat formatter = DateFormat('hh:mm:ss');

  List<String> get messages => _logMessages;

  void addToLog(String message) {
    final now = DateTime.now();
    _logMessages.add('${formatter.format(now)}.${now.millisecond} - $message');
  }

  void clearLogs() => _logMessages.clear();
}
