import 'package:flutter_reactive_ble/src/model/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group("Result", () {
    test("executes the failure branch for a non-null failure object", () {
      const failureObject = 1;
      const sut = Result<int, int>.failure(failureObject);
      final handler = _ResultHandlerMock<int, int, int>();

      sut.iif(success: handler.success, failure: handler.failure);

      verifyNever(handler.success(any));
      verify(handler.failure(failureObject)).called(1);
    });

    test("executes the success branch for a non-null success value", () {
      const value = 1;
      const sut = Result<int, int>.success(value);
      final handler = _ResultHandlerMock<int, int, int>();

      sut.iif(success: handler.success, failure: handler.failure);

      verify(handler.success(value)).called(1);
      verifyNever(handler.failure(any));
    });

    test("executes the success branch for null success value", () {
      const int value = null;
      const sut = Result<int, int>.success(value);
      final handler = _ResultHandlerMock<int, int, int>();

      sut.iif(success: handler.success, failure: handler.failure);

      verify(handler.success(value)).called(1);
      verifyNever(handler.failure(any));
    });

    test("throws failure as is", () {
      final failureObject = Exception();
      final sut = Result<int, Exception>.failure(failureObject);

      expect(sut.dematerialize, throwsA(failureObject));
    });

    test("throws failure wrapping in an exception", () {
      const failureObject = 1;
      const sut = Result<int, int>.failure(failureObject);

      expect(sut.dematerialize, throwsException);
    });
  });
}

class _ResultHandlerMock<Value, Failure, T> extends Mock
    implements _ResultHandler<Value, Failure, T> {}

abstract class _ResultHandler<Value, Failure, T> {
  T success(Value value);
  T failure(Failure failure);
}
