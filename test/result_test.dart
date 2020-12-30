import 'package:flutter_reactive_ble/src/model/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Result", () {
    test("executes the failure branch for a non-null failure object", () {
      const failureObject = 1;
      const sut = Result<int, int>.failure(failureObject);
      final handler = _ResultHandler<int?, int?, int>();

      final result =
          sut.iif(success: handler.success, failure: handler.failure);

      expect(result, failureObject);
    });

    test("executes the success branch for a non-null success value", () {
      const value = 1;
      const sut = Result<int, int>.success(value);
      final handler = _ResultHandler<int?, int?, int>();

      final result =
          sut.iif(success: handler.success, failure: handler.failure);

      expect(result, value);
    });

    test("executes the success branch for null success value", () {
      const int? value = null;
      const sut = Result<int, int>.success(value);
      final handler = _ResultHandler<int?, int?, int>();

      final result =
          sut.iif(success: handler.success, failure: handler.failure);

      expect(result, null);
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

class _ResultHandler<Value, Failure, T> {
  T success(Value value) => value as T;
  T failure(Failure failure) => failure as T;
}
