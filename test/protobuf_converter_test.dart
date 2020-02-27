import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/converter/protobuf_converter.dart';
import 'package:flutter_reactive_ble/src/generated/bledata.pb.dart' as pb;
import 'package:flutter_reactive_ble/src/model/clear_gatt_cache_error.dart';
import 'package:flutter_reactive_ble/src/model/unit.dart';
import 'package:flutter_reactive_ble/src/model/uuid.dart';
import 'package:flutter_reactive_ble/src/model/write_characteristic_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('ProtobufConverter', () {
    const sut = ProtobufConverter();

    group("DeviceScanInfo conversion", () {
      const id = 'id';
      const name = 'name';

      pb.ServiceDataEntry serviceDataEntry1;
      pb.ServiceDataEntry serviceDataEntry2;
      pb.DeviceScanInfo message;

      setUp(() {
        serviceDataEntry1 = pb.ServiceDataEntry()
          ..serviceUuid = (pb.Uuid()..data = [0])
          ..data = [1, 2, 3];
        serviceDataEntry2 = pb.ServiceDataEntry()
          ..serviceUuid = (pb.Uuid()..data = [1])
          ..data = [4, 5, 6];

        message = pb.DeviceScanInfo()
          ..id = id
          ..name = name
          ..serviceData.add(serviceDataEntry1)
          ..serviceData.add(serviceDataEntry2);
      });

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

    group("ConnectionStateUpdate conversion", () {
      const id = 'id';
      const connectionState = 1;

      pb.DeviceInfo message;

      group('Message without failure', () {
        setUp(() {
          message = pb.DeviceInfo()
            ..id = id
            ..connectionState = connectionState;
        });

        test('Converts id', () {
          final result = sut.connectionStateUpdateFrom(message);
          expect(result.deviceId, id);
        });

        test('Converts status update', () {
          final result = sut.connectionStateUpdateFrom(message);
          expect(result.connectionState, DeviceConnectionState.connected);
        });
      });

      group('Message with failure', () {
        setUp(() {
          final failure = pb.GenericFailure()
            ..code = 0
            ..message = "failure";
          message = pb.DeviceInfo()..failure = failure;
        });
        test('converts failure', () {
          final updateResult = sut.connectionStateUpdateFrom(message).failure;
          expect(updateResult.message, "failure");
          expect(updateResult.code, ConnectionError.unknown);
        });
      });

      group('Irregular statuscode ', () {
        setUp(() {
          message = pb.DeviceInfo()
            ..id = id
            ..connectionState = 100;
        });

        test('converts unknown code throws', () {
          expect(
              () => sut.connectionStateUpdateFrom(message), throwsA(anything));
        });
      });
    });

    group('Converts clear gatt cache result', () {
      test('Succeeds', () {
        final result = sut.clearGattCacheResultFrom(pb.ClearGattCacheInfo());

        expect(
            result,
            const Result<Unit, GenericFailure<ClearGattCacheError>>.success(
                Unit()));
      });

      test('Fails', () {
        final message = pb.ClearGattCacheInfo()..failure = pb.GenericFailure();
        final result = sut.clearGattCacheResultFrom(message).iif(
            success: (_) => throw AssertionError("Not expected to succeed"),
            failure: (f) => f);

        expect(result.code, ClearGattCacheError.unknown);
      });
    });
    group("Converts characteristic value", () {
      const id = 'id';
      const value = [2, 3];
      pb.CharacteristicValueInfo message;

      setUp(() {
        final characteristic = pb.CharacteristicAddress()
          ..deviceId = id
          ..serviceUuid = (pb.Uuid()..data = [0])
          ..characteristicUuid = (pb.Uuid()..data = [1]);

        message = pb.CharacteristicValueInfo()
          ..characteristic = characteristic
          ..value = value;
      });

      test('It converts device id', () {
        final result = sut.characteristicValueFrom(message);
        expect(result.characteristic.deviceId, id);
      });
      test('It converts service uuid', () {
        final result = sut.characteristicValueFrom(message);
        expect(result.characteristic.serviceId, Uuid([00]));
      });

      test('It converts characteristic uuid', () {
        final result = sut.characteristicValueFrom(message);
        expect(result.characteristic.characteristicId, Uuid([01]));
      });

      test('it converts value', () {
        final result = sut.characteristicValueFrom(message);
        final charValue = result.result.iif(
            success: (v) => v,
            failure: (_) => throw AssertionError("Not expected to fail"));
        expect(charValue, value);
      });

      test('it converts failure', () {
        final failureMessage = message..failure = pb.GenericFailure();
        final result = sut.characteristicValueFrom(failureMessage).result.iif(
            success: (_) => throw AssertionError("Not expected to succeed"),
            failure: (_) => "failure");
        expect(result, "failure");
      });
    });

    group("Converts writecharacteristic info", () {
      const id = 'id';

      pb.WriteCharacteristicInfo message;

      setUp(() {
        final characteristic = pb.CharacteristicAddress()
          ..deviceId = id
          ..serviceUuid = (pb.Uuid()..data = [0])
          ..characteristicUuid = (pb.Uuid()..data = [1]);

        message = pb.WriteCharacteristicInfo()..characteristic = characteristic;
      });

      test('It converts device id', () {
        final result = sut.writeCharacteristicInfoFrom(message);
        expect(result.characteristic.deviceId, id);
      });
      test('It converts service uuid', () {
        final result = sut.writeCharacteristicInfoFrom(message);
        expect(result.characteristic.serviceId, Uuid([00]));
      });

      test('It converts characteristic uuid', () {
        final result = sut.writeCharacteristicInfoFrom(message);
        expect(result.characteristic.characteristicId, Uuid([01]));
      });

      test('it converts value', () {
        final result = sut.writeCharacteristicInfoFrom(message);

        expect(
            result.result.iif(
                success: (_) => "success",
                failure: (_) => throw AssertionError("Not expected to fail")),
            "success");
      });

      test('it converts failure', () {
        final failureMessage = message..failure = pb.GenericFailure();
        final result = sut
            .writeCharacteristicInfoFrom(failureMessage)
            .result
            .iif(
                success: (_) => throw AssertionError("Not expected to succeed"),
                failure: (f) => f);
        expect(result.code, WriteCharacteristicFailure.unknown);
      });
    });

    group('Converts connection priority info', () {
      const id = 'id';

      pb.ChangeConnectionPriorityInfo message;

      setUp(() {
        message = pb.ChangeConnectionPriorityInfo()..deviceId = id;
      });

      test('Succeeds', () {
        final result = sut.connectionPriorityInfoFrom(message).result;
        expect(
            result.iif(
                success: (_) => "success",
                failure: (_) => throw AssertionError("Not expected to fail")),
            "success");
      });

      test('Fails', () {
        final failureMessage = message..failure = pb.GenericFailure();
        final result = sut
            .connectionPriorityInfoFrom(failureMessage)
            .result
            .iif(
                success: (_) => throw AssertionError("Not expected to succeed"),
                failure: (f) => f);
        expect(result.code, ConnectionPriorityFailure.unknown);
      });
    });

    group('Converts Blestatus', () {
      test('Converts valid status', () {
        final message = pb.BleStatusInfo()..status = 5;
        expect(sut.bleStatusFrom(message), BleStatus.ready);
      });

      test('Fallsback in case of invalid status', () {
        final message = pb.BleStatusInfo()..status = 6;
        expect(sut.bleStatusFrom(message), BleStatus.unknown);
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
