import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_ble_mobile/src/converter/protobuf_converter.dart';
import 'package:reactive_ble_mobile/src/generated/bledata.pb.dart' as pb;
import 'package:reactive_ble_platform_interface/reactive_ble_platform_interface.dart';

void main() {
  group('$ProtobufConverter', () {
    const sut = ProtobufConverterImpl();

    group("decoding ${pb.DeviceScanInfo}", () {
      const id = 'id';
      const name = 'name';

      late pb.ServiceDataEntry serviceDataEntry1;
      late pb.ServiceDataEntry serviceDataEntry2;
      pb.DeviceScanInfo message;
      late pb.Uuid serviceUuid1;
      late pb.Uuid serviceUuid2;
      late Uint8List manufacturerData;
      late ScanResult scanresult;

      setUp(() {
        serviceDataEntry1 = pb.ServiceDataEntry()
          ..serviceUuid = (pb.Uuid()..data = [0])
          ..data = [1, 2, 3];
        serviceDataEntry2 = pb.ServiceDataEntry()
          ..serviceUuid = (pb.Uuid()..data = [1])
          ..data = [4, 5, 6];
        serviceUuid1 = pb.Uuid()..data = [2];
        serviceUuid2 = pb.Uuid()..data = [3];
        manufacturerData = Uint8List.fromList([1, 2, 3]);

        message = pb.DeviceScanInfo()
          ..id = id
          ..name = name
          ..serviceData.add(serviceDataEntry1)
          ..serviceData.add(serviceDataEntry2)
          ..serviceUuids.add(serviceUuid1)
          ..serviceUuids.add(serviceUuid2)
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

      test('converts service uuids', () {
        expect(
            scanresult.result.iif(
                success: (d) => d.serviceUuids[0].data,
                failure: (_) => throw Exception()),
            serviceUuid1.data);
        expect(
            scanresult.result.iif(
                success: (d) => d.serviceUuids[1].data,
                failure: (_) => throw Exception()),
            serviceUuid2.data);
      });

      test('converts manufacturer data', () {
        expect(
            scanresult.result.iif(
                success: (d) => d.manufacturerData,
                failure: (_) => throw Exception()),
            manufacturerData);
      });

      group('given Scan fails', () {
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
              failure: (_) => "Failed",
            ),
            "Failed",
          );
        });
      });
    });

    group("decoding ${pb.GenericFailure}", () {
      test("returns null if error is absent", () {
        final error = sut.genericFailureFrom(
          hasFailure: false,
          getFailure: () => throw Exception(),
          codes: <String>[],
          fallback: (int? rawOrNull) => throw Exception(),
        );
        expect(error, null);
      });

      test("converts an absent raw code using the fallback closure", () {
        const fallbackCode = "fallback code";

        final error = sut.genericFailureFrom(
          hasFailure: true,
          getFailure: () => pb.GenericFailure(),
          codes: <String>[fallbackCode],
          fallback: (_) => fallbackCode,
        )!;

        expect(error.code, fallbackCode);
      });

      test("converts an unknown raw code using the fallback closure", () {
        const fallbackCode = "fallback code";

        const unknownRawCode = 10;
        final error = sut.genericFailureFrom(
          hasFailure: true,
          getFailure: () => pb.GenericFailure()..code = unknownRawCode,
          codes: <String>[fallbackCode],
          fallback: (_) => fallbackCode,
        )!;

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
        ) as GenericFailure<String>;

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
        ) as GenericFailure<String>;

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
        ) as GenericFailure<String>;

        expect(error.message, message);
      });
    });

    group("constructing $Result", () {
      test("converts a failure", () {
        const failure = "failure";

        final result = sut.resultFrom(getValue: () => 1, failure: failure);

        expect(result.iif(success: (_) => throw Exception(), failure: id),
            failure);
      });

      test("converts a value", () {
        const value = "value";
        const String? failure = null;
        final result = sut.resultFrom(getValue: () => value, failure: failure);

        expect(
            result.iif(success: id, failure: (_) => throw Exception()), value);
      });
    });

    group("constructing $ConnectionStateUpdate", () {
      const id = 'id';
      const connectionState = 1;

      late List<int> message;

      group('given a message without a failure', () {
        setUp(() {
          final info = pb.DeviceInfo()
            ..id = id
            ..connectionState = connectionState;

          message = info.writeToBuffer();
        });

        test('device ID is decoded', () {
          final result = sut.connectionStateUpdateFrom(message);
          expect(result.deviceId, id);
        });

        test('connection state is decoded', () {
          final result = sut.connectionStateUpdateFrom(message);
          expect(result.connectionState, DeviceConnectionState.connected);
        });
      });

      group('given message with a failure', () {
        setUp(() {
          final failure = pb.GenericFailure()
            ..code = 0
            ..message = "failure";
          final deviceInfo = pb.DeviceInfo()..failure = failure;
          message = deviceInfo.writeToBuffer();
        });

        test('failure is decoded', () {
          final updateResult = sut.connectionStateUpdateFrom(message).failure!;
          expect(updateResult.message, "failure");
          expect(updateResult.code, ConnectionError.unknown);
        });
      });

      group('given an unknown status code', () {
        setUp(() {
          final info = pb.DeviceInfo()
            ..id = id
            ..connectionState = 100;

          message = info.writeToBuffer();
        });

        test('decoding fails', () {
          expect(
            () => sut.connectionStateUpdateFrom(message),
            throwsA(anything),
          );
        });
      });
    });

    group('decoding clear GATT cache result', () {
      test('succeeds', () {
        final result = sut
            .clearGattCacheResultFrom(pb.ClearGattCacheInfo().writeToBuffer());

        expect(
          result,
          const Result<Unit, GenericFailure<ClearGattCacheError>?>.success(
              Unit()),
        );
      });

      test('fails', () {
        final message = (pb.ClearGattCacheInfo()..failure = pb.GenericFailure())
            .writeToBuffer();
        final result = sut.clearGattCacheResultFrom(message).iif(
            success: (_) => throw AssertionError("Not expected to succeed"),
            failure: (f) => f);

        expect(result?.code, ClearGattCacheError.unknown);
      });
    });

    group("decoding ${pb.CharacteristicValueInfo}", () {
      const id = 'id';
      const value = [2, 3];
      late pb.CharacteristicValueInfo message;
      late pb.CharacteristicAddress characteristic;

      setUp(() {
        characteristic = pb.CharacteristicAddress()
          ..deviceId = id
          ..serviceUuid = (pb.Uuid()..data = [0])
          ..characteristicUuid = (pb.Uuid()..data = [1]);
      });

      group('given no error occurred', () {
        late CharacteristicValue result;

        setUp(() {
          message = pb.CharacteristicValueInfo()
            ..characteristic = characteristic
            ..value = value;

          result = sut.characteristicValueFrom(message.writeToBuffer());
        });

        test('device ID is converted', () {
          expect(result.characteristic.deviceId, id);
        });
        test('service ID is converted', () {
          expect(result.characteristic.serviceId, Uuid([00]));
        });

        test('characteristic ID is converted', () {
          expect(result.characteristic.characteristicId, Uuid([01]));
        });

        test('value is converted', () {
          final charValue = result.result.iif(
            success: (v) => v,
            failure: (_) => throw AssertionError("Not expected to fail"),
          );
          expect(charValue, value);
        });
      });

      group('given an error occurred', () {
        List<int> failureMessage;
        String? result;

        setUp(() {
          failureMessage =
              (message..failure = pb.GenericFailure()).writeToBuffer();
          result = sut.characteristicValueFrom(failureMessage).result.iif(
              success: (_) => throw AssertionError("Not expected to succeed"),
              failure: (_) => "failure");
        });

        test('failure is converted', () {
          expect(result, "failure");
        });
      });
    });

    group("Decoding ${pb.WriteCharacteristicInfo}", () {
      const id = 'id';

      late List<int> data;
      late pb.CharacteristicAddress characteristic;

      setUp(() {
        characteristic = pb.CharacteristicAddress()
          ..deviceId = id
          ..serviceUuid = (pb.Uuid()..data = [0])
          ..characteristicUuid = (pb.Uuid()..data = [1]);

        final message = pb.WriteCharacteristicInfo()
          ..characteristic = characteristic;

        data = message.writeToBuffer();
      });

      test('device ID is converted', () {
        final result = sut.writeCharacteristicInfoFrom(data);
        expect(result.characteristic.deviceId, id);
      });

      test('service ID is converted', () {
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
                failure: (f) => f!);
        expect(result.code, WriteCharacteristicFailure.unknown);
      });
    });

    group('decoding ${pb.ChangeConnectionPriorityInfo}', () {
      const id = 'id';

      late pb.ChangeConnectionPriorityInfo message;

      setUp(() {
        message = pb.ChangeConnectionPriorityInfo()..deviceId = id;
      });

      test('succeeds', () {
        final result =
            sut.connectionPriorityInfoFrom(message.writeToBuffer()).result;
        expect(
          result.iif(
            success: (_) => "success",
            failure: (_) => throw AssertionError("Not expected to fail"),
          ),
          "success",
        );
      });

      test('fails', () {
        final failureMessage = message..failure = pb.GenericFailure();
        final result = sut
            .connectionPriorityInfoFrom(failureMessage.writeToBuffer())
            .result
            .iif(
                success: (_) => throw AssertionError("Not expected to succeed"),
                failure: (f) => f!);
        expect(result.code, ConnectionPriorityFailure.unknown);
      });
    });

    group('decoding ${pb.BleStatusInfo}', () {
      test('converts valid status', () {
        final message = pb.BleStatusInfo()..status = 5;
        expect(sut.bleStatusFrom(message.writeToBuffer()), BleStatus.ready);
      });

      test('falls back in case of invalid status', () {
        final message = pb.BleStatusInfo()..status = 6;
        expect(sut.bleStatusFrom(message.writeToBuffer()), BleStatus.unknown);
      });
    });

    group('Coverts MTU size', () {
      const size = 20;
      int? result;

      setUp(() {
        final message = pb.NegotiateMtuInfo()..mtuSize = size;

        result = sut.mtuSizeFrom(message.writeToBuffer());
      });

      test('MTU size is decoded', () {
        expect(result, 20);
      });
    });

    group('decoding ${pb.DiscoveredService} ', () {
      const deviceId = "testDevice";
      pb.DiscoverServicesInfo message;
      List<DiscoveredService>? convertedResult;

      group('given a message without a failure', () {
        setUp(() {
          final serviceUuid = pb.Uuid()..data = [0];
          final internalServiceUuid = pb.Uuid()..data = [1];
          final charUuid = pb.Uuid()..data = [0, 1, 1];
          final internalCharUuid = pb.Uuid()..data = [1, 1];

          final discoveredInternalServices = pb.DiscoveredService()
            ..serviceUuid = internalServiceUuid
            ..characteristics.add(pb.DiscoveredCharacteristic(
                characteristicId: internalCharUuid,
                serviceId: internalServiceUuid,
                isReadable: true))
            ..characteristicUuids.add(internalCharUuid);

          final discoveredService = pb.DiscoveredService()
            ..serviceUuid = serviceUuid
            ..characteristicUuids.add(charUuid)
            ..characteristics.add(pb.DiscoveredCharacteristic(
                characteristicId: charUuid,
                serviceId: serviceUuid,
                isWritableWithResponse: true))
            ..includedServices.add(discoveredInternalServices);

          message = pb.DiscoverServicesInfo()
            ..deviceId = deviceId
            ..services.add(discoveredService);

          convertedResult = sut.discoveredServicesFrom(message.writeToBuffer());
        });

        test('services are decoded', () {
          expect(
            convertedResult,
            [
              DiscoveredService(
                serviceId: Uuid([0]),
                characteristicIds: [
                  Uuid([0, 1, 1])
                ],
                characteristics: [
                  DiscoveredCharacteristic(
                    characteristicId: Uuid([0, 1, 1]),
                    serviceId: Uuid([0]),
                    isReadable: false,
                    isWritableWithResponse: true,
                    isWritableWithoutResponse: false,
                    isNotifiable: false,
                    isIndicatable: false,
                  ),
                ],
                includedServices: [
                  DiscoveredService(
                    serviceId: Uuid([1]),
                    characteristicIds: [
                      Uuid([1, 1])
                    ],
                    characteristics: [
                      DiscoveredCharacteristic(
                        characteristicId: Uuid([1, 1]),
                        serviceId: Uuid([1]),
                        isReadable: true,
                        isWritableWithResponse: false,
                        isWritableWithoutResponse: false,
                        isNotifiable: false,
                        isIndicatable: false,
                      ),
                    ],
                    includedServices: [],
                  ),
                ],
              )
            ],
          );
        });
      });
    });
  });
}

T id<T>(T some) => some;
