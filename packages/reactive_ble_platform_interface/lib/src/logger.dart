import 'model/log_level.dart';

abstract class Logger {
  set logLevel(LogLevel logLevel);
  LogLevel get logLevel;

  void log(Object message);
}
