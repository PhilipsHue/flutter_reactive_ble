import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/device_connector.dart';
import 'package:flutter_reactive_ble/src/device_scanner.dart';
import 'package:flutter_reactive_ble/src/model/scan_session.dart';
import 'package:flutter_reactive_ble/src/plugin_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('$DeviceConnector', () {
    DeviceConnector _sut;
    _DeviceConnectionControllerStub _controller;
    Stream<ConnectionStateUpdate> _connectionStateUpdateStream;
    Stream<ConnectionStateUpdate> _result;
    _DiscoverDevicesStub _discoverDevicesStub;
    _DeviceScannerStub _scanner;

    Map<Uuid, List<Uuid>> _servicesToDiscover;
    ConnectionStateUpdate updateForDevice;
    ConnectionStateUpdate updateOtherDevice;

    const _deviceId = '123';
    const _connectionTimeout = Duration(seconds: 1);
    const _delayAfterFailure = Duration(milliseconds: 10);

    setUp(() {
      _controller = _DeviceConnectionControllerStub();
      _discoverDevicesStub = _DiscoverDevicesStub();
      _scanner = _DeviceScannerStub();
      _servicesToDiscover = {
        Uuid.parse('FEFE'): [Uuid.parse('FEFE')]
      };

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
      _connectionStateUpdateStream =
          Stream.fromIterable([updateForDevice, updateOtherDevice]);

      _controller.connectionUpdateStub = _connectionStateUpdateStream;

      _sut = DeviceConnector(
        controller: _controller,
        deviceIsDiscoveredRecently:
            _discoverDevicesStub.deviceIsDiscoveredRecently,
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
            _result = _sut.connect(
              id: _deviceId,
              servicesWithCharacteristicsToDiscover: _servicesToDiscover,
              connectionTimeout: _connectionTimeout,
            );
          });

          test('It emits connection updates for that device', () {
            expect(_result,
                emitsInOrder(<ConnectionStateUpdate>[updateForDevice]));
          });
        });
      });
    });

    group('Connect to advertising device', () {
      const deviceId = '123';
      final uuidDeviceToScan = Uuid.parse('FEFF');
      final uuidCurrentScan = Uuid.parse('FEFE');
      const discoveredDevice = DiscoveredDevice(
        id: 'deviceId',
        manufacturerData: null,
        name: 'test',
        rssi: -39,
        serviceData: {},
      );

      setUp(() {
        _connectionStateUpdateStream = Stream.fromIterable([
          updateForDevice,
        ]);
      });
      group('Given a scan is running for another device', () {
        setUp(() {
          final session = ScanSession(
            future: Future.value(),
            withServices: [uuidCurrentScan],
          );
          _scanner.scanSessionsStub = [session, session];

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
          final session = ScanSession(
            future: Future.value(),
            withServices: [uuidDeviceToScan],
          );
          _scanner.scanSessionsStub = [session, session, session, session];
        });

        group('And device is discovered', () {
          setUp(() {
            _discoverDevicesStub.expectedResult = [true];

            _result = _sut.connectToAdvertisingDevice(
              id: deviceId,
              withServices: [uuidDeviceToScan],
              prescanDuration: const Duration(milliseconds: 10),
            );
          });

          test('It connects to device after scan has finished', () {
            expect(_result,
                emitsInOrder(<ConnectionStateUpdate>[updateForDevice]));
          });
        });

        group('And device is not found after scanning', () {
          setUp(() {
            _discoverDevicesStub.expectedResult = [false];

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

          _scanner.scanSessionsStub = [null, session, session];
        });

        group('And device is discovered in a previous scan', () {
          setUp(() {
            _discoverDevicesStub.expectedResult = [true];

            _result = _sut.connectToAdvertisingDevice(
              id: deviceId,
              withServices: [uuidDeviceToScan],
              prescanDuration: const Duration(milliseconds: 10),
            );
          });

          test('It emits device update', () {
            expect(_result,
                emitsInOrder(<ConnectionStateUpdate>[updateForDevice]));
          });
        });

        group('And device is not discovered in a previous scan', () {
          setUp(() {
            _scanner.discoveredDevicesStub = [discoveredDevice];
          });

          group('And device is not found after scanning', () {
            setUp(() {
              _discoverDevicesStub.expectedResult = [false, false];

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
              _discoverDevicesStub.expectedResult = responses;

              _result = _sut.connectToAdvertisingDevice(
                id: deviceId,
                withServices: [uuidDeviceToScan],
                prescanDuration: const Duration(milliseconds: 10),
              );
            });

            test('It emits device update', () {
              expect(_result,
                  emitsInOrder(<ConnectionStateUpdate>[updateForDevice]));
            });
          });
        });
      });
    });
  });
}

class _DeviceConnectionControllerStub implements DeviceConnectionController {
  Stream<ConnectionStateUpdate> _updates;
  @override
  Stream<void> connectToDevice(
          String id,
          Map<Uuid, List<Uuid>> servicesWithCharacteristicsToDiscover,
          Duration connectionTimeout) =>
      Stream.fromIterable([0]);

  @override
  Stream<ConnectionStateUpdate> get connectionUpdateStream => _updates;

  @override
  Future<void> disconnectDevice(String deviceId) => Future.value();

  set connectionUpdateStub(Stream<ConnectionStateUpdate> updates) =>
      _updates = updates;
}

class _DiscoverDevicesStub {
  List<bool> _results;

  bool deviceIsDiscoveredRecently({String deviceId, Duration cacheValidity}) =>
      _results.removeAt(0);

  set expectedResult(List<bool> results) => _results = results;
}

class _DeviceScannerStub implements DeviceScanner {
  List<ScanSession> _scanSessions;
  List<DiscoveredDevice> _discoveredDevices;

  @override
  ScanSession get currentScan => _scanSessions.removeAt(0);

  @override
  Stream<DiscoveredDevice> scanForDevices(
          {List<Uuid> withServices,
          ScanMode scanMode = ScanMode.balanced,
          bool requireLocationServicesEnabled = true}) =>
      Stream.fromIterable(_discoveredDevices);

  set scanSessionsStub(List<ScanSession> sessions) => _scanSessions = sessions;

  set discoveredDevicesStub(List<DiscoveredDevice> devices) =>
      _discoveredDevices = devices;
}
