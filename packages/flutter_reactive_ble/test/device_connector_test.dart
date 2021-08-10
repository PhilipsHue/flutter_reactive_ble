import 'dart:typed_data';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/device_connector.dart';
import 'package:flutter_reactive_ble/src/device_scanner.dart';
import 'package:flutter_reactive_ble/src/discovered_devices_registry.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reactive_ble_platform_interface/reactive_ble_platform_interface.dart';

import 'device_connector_test.mocks.dart';

@GenerateMocks([ReactiveBlePlatform, DeviceScanner, DiscoveredDevicesRegistry])
void main() {
  group('$DeviceConnector', () {
    late DeviceConnector _sut;
    late MockReactiveBlePlatform _blePlatform;
    late Stream<ConnectionStateUpdate> _connectionStateUpdateStream;
    late Stream<ConnectionStateUpdate?> _result;
    late MockDiscoveredDevicesRegistry _registry;
    late MockDeviceScanner _scanner;

    late Map<Uuid, List<Uuid>> _servicesToDiscover;
    late ConnectionStateUpdate updateForDevice;
    late ConnectionStateUpdate updateOtherDevice;

    const _deviceId = '123';
    const _connectionTimeout = Duration(seconds: 1);
    const _delayAfterFailure = Duration(milliseconds: 10);

    setUp(() {
      _blePlatform = MockReactiveBlePlatform();
      _registry = MockDiscoveredDevicesRegistry();
      _scanner = MockDeviceScanner();
      _servicesToDiscover = {
        Uuid.parse('FEFE'): [Uuid.parse('FEFE')]
      };
      when(_blePlatform.connectionUpdateStream)
          .thenAnswer((_) => _connectionStateUpdateStream);

      when(_blePlatform.disconnectDevice(any)).thenAnswer((_) async => 0);

      updateForDevice = const ConnectionStateUpdate(
        deviceId: _deviceId,
        connectionState: DeviceConnectionState.connecting,
        failure: null,
      );

      updateOtherDevice = const ConnectionStateUpdate(
        deviceId: '333',
        connectionState: DeviceConnectionState.connecting,
        failure: null,
      );
      _sut = DeviceConnectorImpl(
        blePlatform: _blePlatform,
        deviceIsDiscoveredRecently: _registry.deviceIsDiscoveredRecently,
        deviceScanner: _scanner,
        delayAfterScanFailure: _delayAfterFailure,
      );
    });

    group('Connect to device', () {
      group('Given connection update stream has updates for device', () {
        setUp(() {
          _connectionStateUpdateStream = Stream.fromIterable([
            updateOtherDevice,
            updateForDevice,
          ]);
        });

        group('And invoking connect method succeeds', () {
          setUp(() async {
            when(_blePlatform.connectToDevice(any, any, any)).thenAnswer(
              (_) => Stream.fromIterable([1]),
            );
            _result = _sut.connect(
              id: _deviceId,
              servicesWithCharacteristicsToDiscover: _servicesToDiscover,
              connectionTimeout: _connectionTimeout,
            );
          });

          test('It emits connection updates for that device', () {
            expect(_result,
                emitsInOrder(<ConnectionStateUpdate?>[updateForDevice]));
          });
        });
      });
    });

    group('Connect to advertising device', () {
      const deviceId = '123';
      final uuidDeviceToScan = Uuid.parse('FEFF');
      final uuidCurrentScan = Uuid.parse('FEFE');
      final discoveredDevice = DiscoveredDevice(
        id: 'deviceId',
        manufacturerData: Uint8List.fromList([0]),
        serviceUuids: const [],
        name: 'test',
        rssi: -39,
        serviceData: const {},
      );

      setUp(() {
        _connectionStateUpdateStream = Stream.fromIterable([
          updateForDevice,
        ]);
      });
      group('Given a scan is running for another device', () {
        setUp(() {
          when(_scanner.currentScan).thenReturn(
            ScanSession(
              future: Future.value(),
              withServices: [uuidCurrentScan],
            ),
          );

          _result = _sut.connectToAdvertisingDevice(
            id: deviceId,
            withServices: [uuidDeviceToScan],
            prescanDuration: const Duration(milliseconds: 10),
          );
        });

        test('It emits connection update with failure', () {
          const expectedUpdate = ConnectionStateUpdate(
            deviceId: deviceId,
            connectionState: DeviceConnectionState.disconnected,
            failure: GenericFailure(
              code: ConnectionError.failedToConnect,
              message: "A scan for a different service is running",
            ),
          );

          expect(
              _result, emitsInOrder(<ConnectionStateUpdate>[expectedUpdate]));
        });
      });

      group('Given a scan is running for the same device device', () {
        final uuidDeviceToScan = Uuid.parse('FEFF');

        setUp(() {
          when(_scanner.currentScan).thenReturn(
            ScanSession(
              future: Future.value(),
              withServices: [uuidDeviceToScan],
            ),
          );
        });

        group('And device is discovered', () {
          setUp(() {
            when(_registry.deviceIsDiscoveredRecently(
                    deviceId: deviceId,
                    cacheValidity: anyNamed('cacheValidity')))
                .thenReturn(true);
            when(_blePlatform.connectToDevice(any, any, any))
                .thenAnswer((_) => Stream.fromIterable([1]));

            _result = _sut.connectToAdvertisingDevice(
              id: deviceId,
              withServices: [uuidDeviceToScan],
              prescanDuration: const Duration(milliseconds: 10),
            );
          });

          test('It connects to device after scan has finished', () {
            expect(_result,
                emitsInOrder(<ConnectionStateUpdate?>[updateForDevice]));
          });
        });

        group('And device is not found after scanning', () {
          setUp(() {
            when(_registry.deviceIsDiscoveredRecently(
                    deviceId: deviceId,
                    cacheValidity: anyNamed('cacheValidity')))
                .thenReturn(false);

            _result = _sut.connectToAdvertisingDevice(
              id: deviceId,
              withServices: [uuidDeviceToScan],
              prescanDuration: const Duration(milliseconds: 10),
            );
          });
          test('It emits failure', () {
            const expectedUpdate = ConnectionStateUpdate(
              deviceId: deviceId,
              connectionState: DeviceConnectionState.disconnected,
              failure: GenericFailure(
                code: ConnectionError.failedToConnect,
                message: "Device is not advertising",
              ),
            );

            expect(
                _result, emitsInOrder(<ConnectionStateUpdate>[expectedUpdate]));
          });
        });
      });

      group('Given no scan is running', () {
        setUp(() {
          final session = ScanSession(
              future: Future.value(), withServices: [uuidDeviceToScan]);

          final responses = [null, session, session];

          when(_scanner.currentScan).thenAnswer((_) => responses.removeAt(0));
        });

        group('And device is discovered in a previous scan', () {
          setUp(() {
            when(_registry.deviceIsDiscoveredRecently(
                    deviceId: deviceId,
                    cacheValidity: anyNamed('cacheValidity')))
                .thenReturn(true);
            when(_blePlatform.connectToDevice(any, any, any))
                .thenAnswer((_) => Stream.fromIterable([1]));

            _result = _sut.connectToAdvertisingDevice(
              id: deviceId,
              withServices: [uuidDeviceToScan],
              prescanDuration: const Duration(milliseconds: 10),
            );
          });

          test('It emits device update', () {
            expect(_result,
                emitsInOrder(<ConnectionStateUpdate?>[updateForDevice]));
          });
        });

        group('And device is not discovered in a previous scan', () {
          setUp(() {
            when(_scanner.scanForDevices(
              withServices: anyNamed('withServices'),
              scanMode: anyNamed('scanMode'),
            )).thenAnswer((_) => Stream.fromIterable([discoveredDevice]));
          });

          group('And device is not found after scanning', () {
            setUp(() {
              when(_registry.deviceIsDiscoveredRecently(
                      deviceId: deviceId,
                      cacheValidity: anyNamed('cacheValidity')))
                  .thenReturn(false);

              _result = _sut.connectToAdvertisingDevice(
                id: deviceId,
                withServices: [uuidDeviceToScan],
                prescanDuration: const Duration(milliseconds: 10),
              );
            });

            test('It emits failure', () {
              const expectedUpdate = ConnectionStateUpdate(
                deviceId: deviceId,
                connectionState: DeviceConnectionState.disconnected,
                failure: GenericFailure(
                  code: ConnectionError.failedToConnect,
                  message: "Device is not advertising",
                ),
              );

              expect(_result,
                  emitsInOrder(<ConnectionStateUpdate>[expectedUpdate]));
            });
          });
          group('And device found after scanning', () {
            setUp(() {
              final responses = [false, true, true, true];
              when(_registry.deviceIsDiscoveredRecently(
                      deviceId: deviceId,
                      cacheValidity: anyNamed('cacheValidity')))
                  .thenAnswer((_) => responses.removeAt(0));

              when(_blePlatform.connectToDevice(any, any, any))
                  .thenAnswer((_) => Stream.fromIterable([1]));

              _result = _sut.connectToAdvertisingDevice(
                id: deviceId,
                withServices: [uuidDeviceToScan],
                prescanDuration: const Duration(milliseconds: 10),
              );
            });

            test('It emits device update', () {
              expect(_result,
                  emitsInOrder(<ConnectionStateUpdate?>[updateForDevice]));
            });
          });
        });
      });
    });
  });
}
