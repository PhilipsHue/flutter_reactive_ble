import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_ble_mobile/src/converter/args_to_protubuf_converter.dart';
import 'package:reactive_ble_mobile/src/generated/bledata.pb.dart' as pb;
import 'package:reactive_ble_platform_interface/reactive_ble_platform_interface.dart';

void main() {
  group('$ArgsToProtobufConverter', () {
    const _sut = ArgsToProtobufConverterImpl();

    group('Connect to device args', () {
      const deviceId = '123';
      Map<Uuid, List<Uuid>>? servicesToDiscover;
      Duration? timeout;
      late pb.ConnectToDeviceRequest result;

      group('And servicesToDiscover is not null', () {
        setUp(() {
          servicesToDiscover = {
            Uuid.parse('FEFE'): [Uuid.parse('FEFE')]
          };
        });

        group('And timeout is not null', () {
          setUp(() {
            timeout = const Duration(seconds: 2);
            result = _sut.createConnectToDeviceArgs(
                deviceId, servicesToDiscover, timeout);
          });

          test('It converts deviceId', () {
            expect(result.deviceId, deviceId);
          });

          test('It converts timeout', () {
            expect(result.timeoutInMs, 2000);
          });

          test('It converts servicesToDiscover', () {
            final uuid = pb.Uuid()..data = [254, 254];
            final expectedServiceWithChar = pb.ServiceWithCharacteristics()
              ..serviceId = uuid
              ..characteristics.add(uuid);
            expect(result.servicesWithCharacteristicsToDiscover.items,
                [expectedServiceWithChar]);
          });
        });

        group('And timeout is null', () {
          setUp(() {
            timeout = null;
            result = _sut.createConnectToDeviceArgs(
                deviceId, servicesToDiscover, timeout);
          });
          test('It sets timeout to default value', () {
            expect(result.timeoutInMs, 0);
          });
        });
      });

      group('And servicesToDiscover is null', () {
        setUp(() {
          servicesToDiscover = null;
          result = _sut.createConnectToDeviceArgs(
              deviceId, servicesToDiscover, timeout);
        });

        test('It converts servicesToDiscover to default', () {
          expect(result.servicesWithCharacteristicsToDiscover,
              pb.ServicesWithCharacteristics());
        });
      });
    });

    group('Disconnect device', () {
      const deviceId = '123';
      late pb.DisconnectFromDeviceRequest result;

      setUp(() {
        result = _sut.createDisconnectDeviceArgs(deviceId);
      });

      test('It sets correct device id', () {
        expect(result.deviceId, deviceId);
      });
    });

    group('Create ReadCharacteristicRequest', () {
      late pb.ReadCharacteristicRequest result;
      const deviceId = '123';
      final serviceUuid = Uuid.parse('FEFF');
      final charUuid = Uuid.parse('FEEF');
      CharacteristicInstance characteristic;

      setUp(() {
        characteristic = CharacteristicInstance(
          characteristicId: charUuid,
          characteristicInstanceId: "101",
          serviceId: serviceUuid,
          serviceInstanceId: "11",
          deviceId: deviceId,
        );

        result = _sut.createReadCharacteristicRequest(characteristic);
      });

      test('It converts the ids', () {
        expect(result.characteristic.deviceId, deviceId);
        expect(result.characteristic.serviceUuid.data, [254, 255]);
        expect(result.characteristic.serviceInstanceId, "11");
        expect(result.characteristic.characteristicUuid.data, [254, 239]);
        expect(result.characteristic.characteristicInstanceId, "101");
      });
    });

    group('Create WriteRequest', () {
      late pb.WriteCharacteristicRequest result;
      const deviceId = '123';
      final serviceUuid = Uuid.parse('FEFF');
      final charUuid = Uuid.parse('FEEF');
      CharacteristicInstance characteristic;

      const value = [0, 1];

      setUp(() {
        characteristic = CharacteristicInstance(
          characteristicId: charUuid,
          characteristicInstanceId: "101",
          serviceId: serviceUuid,
          serviceInstanceId: "11",
          deviceId: deviceId,
        );

        result = _sut.createWriteCharacteristicRequest(characteristic, value);
      });

      test('It converts the ids', () {
        expect(result.characteristic.deviceId, deviceId);
        expect(result.characteristic.serviceUuid.data, [254, 255]);
        expect(result.characteristic.serviceInstanceId, "11");
        expect(result.characteristic.characteristicUuid.data, [254, 239]);
        expect(result.characteristic.characteristicInstanceId, "101");
      });

      test('It converts value', () {
        expect(result.value, value);
      });
    });

    group('Create NotifyCharacteristic request', () {
      late pb.NotifyCharacteristicRequest result;
      const deviceId = '123';
      final serviceUuid = Uuid.parse('FEFF');
      final charUuid = Uuid.parse('FEEF');
      CharacteristicInstance characteristic;

      setUp(() {
        characteristic = CharacteristicInstance(
          characteristicId: charUuid,
          characteristicInstanceId: "101",
          serviceId: serviceUuid,
          serviceInstanceId: "11",
          deviceId: deviceId,
        );

        result = _sut.createNotifyCharacteristicRequest(characteristic);
      });

      test('It converts device ids', () {
        expect(result.characteristic.deviceId, deviceId);
        expect(result.characteristic.serviceUuid.data, [254, 255]);
        expect(result.characteristic.serviceInstanceId, "11");
        expect(result.characteristic.characteristicUuid.data, [254, 239]);
        expect(result.characteristic.characteristicInstanceId, "101");
      });
    });

    group('Create negotiate mtu request', () {
      const deviceId = '123';
      const mtuSize = 30;
      late pb.NegotiateMtuRequest result;

      setUp(() {
        result = _sut.createNegotiateMtuRequest(deviceId, mtuSize);
      });

      test('It converts device id', () {
        expect(result.deviceId, deviceId);
      });

      test('It converts mtusize', () {
        expect(result.mtuSize, mtuSize);
      });
    });

    group('Change connection prio request', () {
      const deviceId = '123';
      ConnectionPriority priority;
      late pb.ChangeConnectionPriorityRequest result;

      setUp(() {
        priority = ConnectionPriority.highPerformance;
        result = _sut.createChangeConnectionPrioRequest(deviceId, priority);
      });

      test('It converts device id', () {
        expect(result.deviceId, deviceId);
      });

      test('It converts priority', () {
        expect(result.priority, 1);
      });
    });

    group('Scan for devices request', () {
      late pb.ScanForDevicesRequest result;
      const scanMode = ScanMode.lowLatency;
      List<Uuid> withServices;

      group('When creating request without services to discover', () {
        setUp(() {
          result = _sut.createScanForDevicesRequest(
            withServices: null,
            scanMode: scanMode,
            requireLocationServicesEnabled: false,
          );
        });

        test('It converts services', () {
          expect(result.serviceUuids.isEmpty, true);
        });

        test('It converts scanmode', () {
          expect(result.scanMode, 2);
        });

        test('It converts requireLocationServicesEnabled', () {
          expect(result.requireLocationServicesEnabled, false);
        });
      });
      group('When creating request without services to discover', () {
        setUp(() {
          withServices = [Uuid.parse('FEFF')];
          result = _sut.createScanForDevicesRequest(
            withServices: withServices,
            scanMode: scanMode,
            requireLocationServicesEnabled: false,
          );
        });

        test('It converts services', () {
          expect(result.serviceUuids.first.data, [254, 255]);
        });

        test('It converts scanmode', () {
          expect(result.scanMode, 2);
        });

        test('It converts requireLocationServicesEnabled', () {
          expect(result.requireLocationServicesEnabled, false);
        });
      });

      group('When creating request without services to discover', () {
        Uuid uuid1;
        Uuid uuid2;

        setUp(() {
          uuid1 = Uuid.parse('FE1F');
          uuid2 = Uuid.parse('FEAA');

          result = _sut.createScanForDevicesRequest(
            withServices: [uuid1, uuid2],
            scanMode: scanMode,
            requireLocationServicesEnabled: false,
          );
        });

        test('It converts services', () {
          expect(result.serviceUuids.map((e) => e.data), [
            [254, 31],
            [254, 170]
          ]);
        });

        test('It converts scanmode', () {
          expect(result.scanMode, 2);
        });

        test('It converts services', () {
          expect(result.requireLocationServicesEnabled, false);
        });
      });
    });

    group('Create clear gatt request', () {
      const deviceId = '123';
      late pb.ClearGattCacheRequest result;
      setUp(() {
        result = _sut.createClearGattCacheRequest(deviceId);
      });

      test('It converts deviceId', () {
        expect(result.deviceId, deviceId);
      });
    });

    group('Notify no more characteristic request', () {
      const deviceId = '123';
      final serviceUuid = Uuid.parse('FEFF');
      final charUuid = Uuid.parse('FEEF');
      CharacteristicInstance characteristic;
      late pb.NotifyNoMoreCharacteristicRequest result;

      setUp(() {
        characteristic = CharacteristicInstance(
          characteristicId: charUuid,
          characteristicInstanceId: "101",
          serviceId: serviceUuid,
          serviceInstanceId: "11",
          deviceId: deviceId,
        );
        result = _sut.createNotifyNoMoreCharacteristicRequest(characteristic);
      });

      test('It converts the ids', () {
        expect(result.characteristic.deviceId, deviceId);
        expect(result.characteristic.serviceUuid.data, [254, 255]);
        expect(result.characteristic.serviceInstanceId, "11");
        expect(result.characteristic.characteristicUuid.data, [254, 239]);
        expect(result.characteristic.characteristicInstanceId, "101");
      });
    });

    group('DiscoverDevices request', () {
      const deviceId = "testdevice";
      late pb.DiscoverServicesRequest result;

      setUp(() {
        result = _sut.createDiscoverServicesRequest(deviceId);
      });

      test('It converts deviceId', () {
        expect(result.deviceId, deviceId);
      });
    });
  });
}
