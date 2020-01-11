import 'package:flutter_reactive_ble/src/converter/protobuf_converter.dart';
import 'package:flutter_reactive_ble/src/generated/bledata.pb.dart' as pb;
import 'package:flutter_reactive_ble/src/model/uuid.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('ProtobufConverter', () {
    const sut = ProtobufConverter();

    group("DeviceScanInfo conversion", () {
      const id = 'id';
      const name = 'name';
      final serviceDataEntry1 = pb.ServiceDataEntry()
        ..serviceUuid = (pb.Uuid()..data = [0])
        ..data = [1, 2, 3];
      final serviceDataEntry2 = pb.ServiceDataEntry()
        ..serviceUuid = (pb.Uuid()..data = [1])
        ..data = [4, 5, 6];
      final message = pb.DeviceScanInfo()
        ..id = id
        ..name = name
        ..serviceData.add(serviceDataEntry1)
        ..serviceData.add(serviceDataEntry2);

      test('converts id', () {
        final scanresult = sut.scanResultFrom(message).result;
        expect(
            scanresult.iif(
                success: (d) => d.id, failure: (_) => throw Exception()),
            id);
      });

      test('converts name', () {
        final scanresult = sut.scanResultFrom(message).result;
        expect(
            scanresult.iif(
                success: (d) => d.name, failure: (_) => throw Exception()),
            name);
      });

      test('converts service data', () {
        final scanresult = sut.scanResultFrom(message).result;
        expect(
            scanresult.iif(
                success: (d) =>
                    d.serviceData[Uuid(serviceDataEntry1.serviceUuid.data)],
                failure: (_) => throw Exception()),
            serviceDataEntry1.data);
        expect(
            scanresult.iif(
                success: (d) =>
                    d.serviceData[Uuid(serviceDataEntry2.serviceUuid.data)],
                failure: (_) => throw Exception()),
            serviceDataEntry2.data);
      });

      test('converts failure', () {
        final failure = pb.GenericFailure()
          ..code = 0
          ..message = "";
        final failedScan = pb.DeviceScanInfo()..failure = failure;

        final scanresult = sut.scanResultFrom(failedScan).result;
        expect(
            scanresult.iif(
                success: (d) =>
                    d.serviceData[Uuid(serviceDataEntry1.serviceUuid.data)],
                failure: (_) => "Failed"),
            "Failed");
      });
    });

    group("GenericError conversion", () {
      test("returns null if error is absent", () {
        final error = sut.genericFailureFrom(
          hasFailure: false,
          getFailure: () => throw Exception(),
          codes: <String>[],
          fallback: (rawOrNull) => throw Exception(),
        );
        expect(error, null);
      });

      test("converts an absent raw code using the fallback closure", () {
        const fallbackCode = "fallback code";
        final fallback = _GenericFailureCodeFallbackMock();
        when(fallback.call(any)).thenReturn(fallbackCode);

        final error = sut.genericFailureFrom(
          hasFailure: true,
          getFailure: () => pb.GenericFailure(),
          codes: <String>[fallbackCode],
          fallback: fallback.call,
        );

        verify(fallback.call(null)).called(1);
        expect(error.code, fallbackCode);
      });

      test("converts an unknown raw code using the fallback closure", () {
        const fallbackCode = "fallback code";
        final fallback = _GenericFailureCodeFallbackMock();
        when(fallback.call(any)).thenReturn(fallbackCode);

        const unknownRawCode = 10;
        final error = sut.genericFailureFrom(
          hasFailure: true,
          getFailure: () => pb.GenericFailure()..code = unknownRawCode,
          codes: <String>[fallbackCode],
          fallback: fallback.call,
        );

        verify(fallback.call(unknownRawCode)).called(1);
        expect(error.code, fallbackCode);
      });

      test("converts a known raw code", () {
        const knownRawCode = 0;
        const knownCode = "known code";
        final error = sut.genericFailureFrom(
          hasFailure: true,
          getFailure: () => pb.GenericFailure()..code = knownRawCode,
          codes: <String>[knownCode],
          fallback: (rawOrNull) => throw Exception(),
        );

        expect(error.code, knownCode);
      });

      test("converts an absent message to an empty string", () {
        const knownRawCode = 0;
        const knownCode = "known code";
        final error = sut.genericFailureFrom(
          hasFailure: true,
          getFailure: () => pb.GenericFailure()..code = knownRawCode,
          codes: <String>[knownCode],
          fallback: (rawOrNull) => throw Exception(),
        );

        expect(error.message, "");
      });

      test("converts a message", () {
        const knownRawCode = 0;
        const knownCode = "known code";
        const message = "message";
        final error = sut.genericFailureFrom(
          hasFailure: true,
          getFailure: () => pb.GenericFailure()
            ..code = knownRawCode
            ..message = message,
          codes: <String>[knownCode],
          fallback: (rawOrNull) => throw Exception(),
        );

        expect(error.message, message);
      });
    });

    group("Result conversion", () {
      test("converts a failure", () {
        final getter = _ResultValueGetterMock<String>();
        const failure = "failure";

        final result = sut.resultFrom(getValue: getter.call, failure: failure);

        verifyNever(getter.call());
        expect(result.iif(success: (_) => throw Exception(), failure: id),
            failure);
      });

      test("converts a value", () {
        const value = "value";
        const String failure = null;
        final getter = _ResultValueGetterMock<String>();
        when(getter.call()).thenReturn(value);

        final result = sut.resultFrom(getValue: getter.call, failure: failure);

        verify(getter.call()).called(1);
        expect(
            result.iif(success: id, failure: (_) => throw Exception()), value);
      });
    });
  });
}

class _GenericFailureCodeFallbackMock extends Mock
    implements _GenericFailureCodeFallback {}

// ignore: one_member_abstracts
abstract class _GenericFailureCodeFallback {
  String call(int rawOrNull);
}

class _ResultValueGetterMock<Value> extends Mock
    implements _ResultValueGetter<Value> {}

// ignore: one_member_abstracts
abstract class _ResultValueGetter<Value> {
  Value call();
}

T id<T>(T some) => some;
