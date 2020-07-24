import 'package:flutter_reactive_ble/src/debug_logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('$DebugLogger', () {
    DebugLogger sut;
    _PrinterMock printerMock;

    setUp(() {
      printerMock = _PrinterMock();
      sut = DebugLogger(printerMock.print);
    });

    group('Given debuglevel is enabled', () {
      setUp(() {
        sut.enable();
      });

      test('It logs message', () {
        const message = "Log message";
        sut.log(message);
        verify(printerMock.print('REACTIVE_BLE: $message')).called(1);
      });
    });

    group('Given debuglevel is disabled', () {
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
