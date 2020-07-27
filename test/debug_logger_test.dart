import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/debug_logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('$DebugLogger', () {
    DebugLogger sut;
    const tag = 'TestTag';
    _PrinterMock printerMock;

    setUp(() {
      printerMock = _PrinterMock();
      sut = DebugLogger(
        tag,
        printerMock.print,
      );
    });

    group('Given debuglevel is set to verbose', () {
      setUp(() {
        sut.logLevel = LogLevel.verbose;
      });

      test('It logs message', () {
        const message = "Log message";
        sut.log(message);
        verify(printerMock.print('$tag: $message')).called(1);
      });
    });

    group('Given loglevel is set to none', () {
      test('It does not log message', () {
        const message = "Log message";
        sut.log(message);
        verifyNever(printerMock.print(any));
      });
    });
  });
}

abstract class _Printer {
  void print(Object object);
}

class _PrinterMock extends Mock implements _Printer {}
