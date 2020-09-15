import 'dart:typed_data';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/converter/protobuf_converter.dart';
import 'package:flutter_reactive_ble/src/generated/bledata.pb.dart' as pb;
import 'package:flutter_reactive_ble/src/model/clear_gatt_cache_error.dart';
import 'package:flutter_reactive_ble/src/model/discovered_services.dart';
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
      Uint8List manufacturerData;
      ScanResult scanresult;

      setUp(() {
        serviceDataEntry1 = pb.ServiceDataEntry()
          ..serviceUuid = (pb.Uuid()..data = [0])
          ..data = [1, 2, 3];
        serviceDataEntry2 = pb.ServiceDataEntry()
          ..serviceUuid = (pb.Uuid()..data = [1])
          ..data = [4, 5, 6];
        manufacturerData = Uint8List.fromList([1, 2, 3]);

        message = pb.DeviceScanInfo()
          ..id = id
          ..name = name
          ..serviceData.add(serviceDataEntry1)
          ..serviceData.add(serviceDataEntry2)
          ..manufacturerData = manufacturerData;

        scanresult = sut.scanResultFrom(message.writeToBuffer());
      });

      test('converts id', () {
        expect(
            scanresult.result
                .iif(success: (d) => d.id, failure: (_) => throw Exception()),
            id);
      });

      test('converts name', () {
        expect(
            scanresult.result
                .iif(success: (d) => d.name, failure: (_) => throw Exception()),
            name);
      });

      test('converts service data', () {
        expect(
            scanresult.result.iif(
                success: (d) =>
                    d.serviceData[Uuid(serviceDataEntry1.serviceUuid.data)],
                failure: (_) => throw Exception()),
            serviceDataEntry1.data);
        expect(
            scanresult.result.iif(
                success: (d) =>
                    d.serviceData[Uuid(serviceDataEntry2.serviceUuid.data)],
                failure: (_) => throw Exception()),
            serviceDataEntry2.data);
      });

      test('converts manufacturer data', () {
        expect(
            scanresult.result.iif(
                success: (d) => d.manufacturerData,
                failure: (_) => throw Exception()),
            manufacturerData);
      });

      group('Given Scan fails', () {
        setUp(() {
          final failure = pb.GenericFailure()
            ..code = 0
            ..message = "";
          final failedScan = pb.DeviceScanInfo()..failure = failure;
          scanresult = sut.scanResultFrom(failedScan.writeToBuffer());
        });
        test('converts failure', () {
          expect(
              scanresult.result.iif(
                  success: (d) =>
                      d.serviceData[Uuid(serviceDataEntry1.serviceUuid.data)],
                  failure: (_) => "Failed"),
              "Failed");
        });
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

      List<int> message;

      group('Message without failure', () {
        setUp(() {
          final info = pb.DeviceInfo()
            ..id = id
            ..connectionState = connectionState;

          message = info.writeToBuffer();
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
          final deviceInfo = pb.DeviceInfo()..failure = failure;
          message = deviceInfo.writeToBuffer();
        });

        test('converts failure', () {
          final updateResult = sut.connectionStateUpdateFrom(message).failure;
          expect(updateResult.message, "failure");
          expect(updateResult.code, ConnectionError.unknown);
        });
      });

      group('Irregular statuscode ', () {
        setUp(() {
          final info = pb.DeviceInfo()
            ..id = id
            ..connectionState = 100;

          message = info.writeToBuffer();
        });

        test('converts unknown code throws', () {
          expect(
              () => sut.connectionStateUpdateFrom(message), throwsA(anything));
        });
      });
    });

    group('Converts clear gatt cache result', () {
      test('Succeeds', () {
        final result = sut
            .clearGattCacheResultFrom(pb.ClearGattCacheInfo().writeToBuffer());

        expect(
            result,
            const Result<Unit, GenericFailure<ClearGattCacheError>>.success(
                Unit()));
      });

      test('Fails', () {
        final message = (pb.ClearGattCacheInfo()..failure = pb.GenericFailure())
            .writeToBuffer();
        final result = sut.clearGattCacheResultFrom(message).iif(
            success: (_) => throw AssertionError("Not expected to succeed"),
            failure: (f) => f);

        expect(result.code, ClearGattCacheError.unknown);
      });
    });
    group("Characteristic value", () {
      const id = 'id';
      const value = [2, 3];
      pb.CharacteristicValueInfo message;
      pb.CharacteristicAddress characteristic;

      setUp(() {
        characteristic = pb.CharacteristicAddress()
          ..deviceId = id
          ..serviceUuid = (pb.Uuid()..data = [0])
          ..characteristicUuid = (pb.Uuid()..data = [1]);
      });

      group('Given no error occured', () {
        CharacteristicValue result;

        setUp(() {
          message = pb.CharacteristicValueInfo()
            ..characteristic = characteristic
            ..value = value;

          result = sut.characteristicValueFrom(message.writeToBuffer());
        });

        test('It converts device id', () {
          expect(result.characteristic.deviceId, id);
        });
        test('It converts service uuid', () {
          expect(result.characteristic.serviceId, Uuid([00]));
        });

        test('It converts characteristic uuid', () {
          expect(result.characteristic.characteristicId, Uuid([01]));
        });

        test('it converts value', () {
          final charValue = result.result.iif(
            success: (v) => v,
            failure: (_) => throw AssertionError("Not expected to fail"),
          );
          expect(charValue, value);
        });
      });

      group('Given error occured', () {
        List<int> failureMessage;
        String result;
        setUp(() {
          failureMessage =
              (message..failure = pb.GenericFailure()).writeToBuffer();
          result = sut.characteristicValueFrom(failureMessage).result.iif(
              success: (_) => throw AssertionError("Not expected to succeed"),
              failure: (_) => "failure");
        });
        test('it converts failure', () {
          expect(result, "failure");
        });
      });
    });

    group("Converts writecharacteristic info", () {
      const id = 'id';

      List<int> data;
      pb.CharacteristicAddress characteristic;

      setUp(() {
        characteristic = pb.CharacteristicAddress()
          ..deviceId = id
          ..serviceUuid = (pb.Uuid()..data = [0])
          ..characteristicUuid = (pb.Uuid()..data = [1]);

        final message = pb.WriteCharacteristicInfo()
          ..characteristic = characteristic;

        data = message.writeToBuffer();
      });

      test('It converts device id', () {
        final result = sut.writeCharacteristicInfoFrom(data);
        expect(result.characteristic.deviceId, id);
      });
      test('It converts service uuid', () {
        final result = sut.writeCharacteristicInfoFrom(data);
        expect(result.characteristic.serviceId, Uuid([00]));
      });

      test('It converts characteristic uuid', () {
        final result = sut.writeCharacteristicInfoFrom(data);
        expect(result.characteristic.characteristicId, Uuid([01]));
      });

      test('it converts value', () {
        final result = sut.writeCharacteristicInfoFrom(data);

        expect(
            result.result.iif(
                success: (_) => "success",
                failure: (_) => throw AssertionError("Not expected to fail")),
            "success");
      });

      test('it converts failure', () {
        final message = pb.WriteCharacteristicInfo()
          ..characteristic = characteristic;
        final failureMessage = message..failure = pb.GenericFailure();
        final result = sut
            .writeCharacteristicInfoFrom(failureMessage.writeToBuffer())
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
        final result =
            sut.connectionPriorityInfoFrom(message.writeToBuffer()).result;
        expect(
            result.iif(
                success: (_) => "success",
                failure: (_) => throw AssertionError("Not expected to fail")),
            "success");
      });

      test('Fails', () {
        final failureMessage = message..failure = pb.GenericFailure();
        final result = sut
            .connectionPriorityInfoFrom(failureMessage.writeToBuffer())
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
        expect(sut.bleStatusFrom(message.writeToBuffer()), BleStatus.ready);
      });

      test('Fallsback in case of invalid status', () {
        final message = pb.BleStatusInfo()..status = 6;
        expect(sut.bleStatusFrom(message.writeToBuffer()), BleStatus.unknown);
      });
    });

    group('Coverts mtu size', () {
      const size = 20;
      int result;

      setUp(() {
        final message = pb.NegotiateMtuInfo()..mtuSize = size;

        result = sut.mtuSizeFrom(message.writeToBuffer());
      });

      test('It convert mtu size size', () {
        expect(result, 20);
      });
    });

    group('Converts Discover services ', () {
      const deviceId = "testDevice";
      pb.DiscoverServicesInfo message;
      DiscoverServicesInfo convertedResult;

      group('Given message has no failure', () {
        setUp(() {
          final serviceUuid = pb.Uuid()..data = [0];
          final internalServiceUuid = pb.Uuid()..data = [1];
          final charUuid = pb.Uuid()..data = [0, 1, 1];
          final internalCharUuid = pb.Uuid()..data = [1, 1];

          final discoveredInternalServices = pb.DiscoveredService()
            ..serviceUuid = internalServiceUuid
            ..characteristicUuids.add(internalCharUuid);

          final discoveredService = pb.DiscoveredService()
            ..serviceUuid = serviceUuid
            ..characteristicUuids.add(charUuid)
            ..includedServices.add(discoveredInternalServices);

          message = pb.DiscoverServicesInfo()
            ..deviceId = deviceId
            ..services.add(discoveredService);

          convertedResult = sut.discoveredServicesFrom(message.writeToBuffer());
        });

        test('It converts device id', () {
          expect(convertedResult.deviceId, deviceId);
        });

        test('It converts services', () {
          expect(
            convertedResult.result.dematerialize(),
            [
              DiscoveredService(
                serviceUuid: Uuid([0]),
                characteristics: [
                  Uuid([0, 1, 1])
                ],
                includedServices: [
                  DiscoveredService(
                    serviceUuid: Uuid([1]),
                    characteristics: [
                      Uuid([1, 1])
                    ],
                    includedServices: [],
                  ),
                ],
              )
            ],
          );
        });
      });

      group('Given message has a failure', () {
        const failureMessage = "Discovered services failure";
        setUp(() {
          final failure = pb.GenericFailure()..message = failureMessage;

          message = pb.DiscoverServicesInfo()
            ..deviceId = deviceId
            ..failure = failure;

          convertedResult = sut.discoveredServicesFrom(message.writeToBuffer());
        });

        test('It converts failure', () {
          expect(
            convertedResult.result.iif(
                success: (_) => throw AssertionError("should not happen"),
                failure: (f) => f),
            const GenericFailure<DiscoverServicesFailure>(
                code: DiscoverServicesFailure.unknown, message: failureMessage),
          );
        });
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
