import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/debug_logger.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('$DebugLogger', () {
    DebugLogger sut;
    const tag = 'TestTag';
    _PrinterStub printer;

    setUp(() {
      printer = _PrinterStub();
      sut = DebugLogger(
        tag,
        printer.print,
      );
    });

    group('Given debuglevel is set to verbose', () {
      setUp(() {
        sut.logLevel = LogLevel.verbose;
      });

      test('It logs message', () {
        sut.log("Log message");
        expect(printer.lastLoggedMessage, 'TestTag: Log message');
      });
    });

    group('Given loglevel is set to none', () {
      test('It does not log message', () {
        const message = "Log message";
        sut.log(message);
        expect(printer.lastLoggedMessage, null);
      });
    });
  });
}

class _PrinterStub {
  String _lastLog;
  String get lastLoggedMessage => _lastLog;

  void print(Object object) {
    _lastLog = object.toString();
  }
}
