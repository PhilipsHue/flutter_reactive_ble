import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/connected_device_operation.dart';
import 'package:flutter_reactive_ble/src/debug_logger.dart';
import 'package:flutter_reactive_ble/src/device_connector.dart';
import 'package:flutter_reactive_ble/src/model/clear_gatt_cache_error.dart';
import 'package:flutter_reactive_ble/src/model/discovered_service.dart';
import 'package:flutter_reactive_ble/src/model/log_level.dart';
import 'package:flutter_reactive_ble/src/model/unit.dart';
import 'package:flutter_reactive_ble/src/plugin_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import 'stubs/device_scanner_stub.dart';

void main() {
  group('$FlutterReactiveBle', () {
    _BleOperationControllerStub _bleOperationControllerStub;
    DeviceScannerStub _deviceScanner;
    _DeviceConnectorStub _deviceConnector;
    _DeviceOperationStub _deviceOperation;
    StreamController<BleStatus> _bleStatusController;
    _DebugLoggerStub _debugLoggerStub;

    FlutterReactiveBle _sut;

    setUp(() {
      _bleOperationControllerStub = _BleOperationControllerStub();
      _deviceScanner = DeviceScannerStub();
      _deviceConnector = _DeviceConnectorStub();
      _deviceOperation = _DeviceOperationStub();
      _bleStatusController = StreamController();
      _debugLoggerStub = _DebugLoggerStub();

      _bleOperationControllerStub.bleStatusStreamStub =
          _bleStatusController.stream.asBroadcastStream();

      _sut = FlutterReactiveBle.witDependencies(
        bleOperationController: _bleOperationControllerStub,
        deviceScanner: _deviceScanner,
        deviceConnector: _deviceConnector,
        connectedDeviceOperation: _deviceOperation,
        debugLogger: _debugLoggerStub,
      );
    });

    tearDown(() async {
      await _bleStatusController.close();
    });

    group('BleStatus stream', () {
      Stream<BleStatus> bleStatusStream;
      setUp(() {
        bleStatusStream = _sut.statusStream;
      });

      test('It returns values retrieved from plugincontroller', () {
        _bleStatusController.add(BleStatus.ready);

        expect(
            bleStatusStream,
            emitsInOrder(<BleStatus>[
              BleStatus.ready,
            ]));
      });

      group('Get current Ble status', () {
        test('It returns unknown in case no status is emitted', () {
          expect(_sut.status, BleStatus.unknown);
        });

        test('It returns last known status from stream', () async {
          const expectedStatus = BleStatus.unauthorized;
          _bleStatusController.add(expectedStatus);

          await _sut.statusStream.first;
          expect(_sut.status, expectedStatus);
        });
      });
    });

    group('CharacteristicValueStream', () {
      const characteristic = Result<List<int>,
          GenericFailure<CharacteristicValueUpdateError>>.success(
        [1],
      );
      final charValue = CharacteristicValue(
          characteristic: _createChar(), result: characteristic);
      Stream<CharacteristicValue> charValueStream;

      setUp(() {
        _deviceOperation.charValueStreamStub = Stream.fromIterable([charValue]);
        charValueStream = _sut.characteristicValueStream;
      });

      test('It emits values', () {
        expect(
          charValueStream,
          emitsInAnyOrder(
            <CharacteristicValue>[charValue],
          ),
        );
      });
    });

    group('Deinitialize', () {
      setUp(() async {
        await _sut.deinitialize();
      });

      test('It executes deinitialize succesfull', () {
        expect(true, true);
      });
    });

    group('Read characteristic', () {
      QualifiedCharacteristic characteristic;
      List<int> result;

      setUp(() async {
        characteristic = _createChar();
        _deviceOperation.readCharValueStub = [1];

        result = await _sut.readCharacteristic(characteristic);
      });

      test('It returns correct value', () {
        expect(result, [1]);
      });
    });

    group('Write characteristic with response', () {
      const value = [2];
      QualifiedCharacteristic characteristic;

      setUp(() async {
        characteristic = _createChar();

        await _sut.writeCharacteristicWithResponse(characteristic,
            value: value);
      });

      test('It completes operation without errors', () {
        expect(true, true);
      });
    });

    group('Write characteristic without response', () {
      const value = [2];
      QualifiedCharacteristic characteristic;

      setUp(() async {
        characteristic = _createChar();

        await _sut.writeCharacteristicWithoutResponse(
          characteristic,
          value: value,
        );
      });

      test('It completes operation without errors', () {
        expect(true, true);
      });
    });

    group('Request mtu', () {
      const deviceId = '123';
      const mtu = 120;
      int result;

      setUp(() async {
        _deviceOperation.requestMtuStub = mtu;

        result = await _sut.requestMtu(deviceId: deviceId, mtu: mtu);
      });

      test('It returns correct value', () {
        expect(result, mtu);
      });
    });

    group('Request connection prio', () {
      const deviceId = '123';
      const priority = ConnectionPriority.highPerformance;

      setUp(() async {
        await _sut.requestConnectionPriority(
            deviceId: deviceId, priority: priority);
      });

      test('It completes operation without errors', () {
        expect(true, true);
      });
    });

    group('Scan devices', () {
      final withServices = [Uuid.parse('FEFF')];
      const mode = ScanMode.lowPower;
      const requireLocation = false;

      const device = DiscoveredDevice(
        id: 'deviceId',
        manufacturerData: null,
        name: 'test',
        rssi: -39,
        serviceData: {},
      );
      Stream<DiscoveredDevice> deviceStream;

      setUp(() {
        _deviceScanner.discoveredDevicesStub = [device];
        deviceStream = _sut.scanForDevices(
          withServices: withServices,
          scanMode: mode,
          requireLocationServicesEnabled: requireLocation,
        );
      });

      test('It emits values', () {
        expect(
          deviceStream,
          emitsInAnyOrder(
            <DiscoveredDevice>[device],
          ),
        );
      });
    });

    group('Connect to device ', () {
      const deviceId = '123';

      const update = ConnectionStateUpdate(
        deviceId: deviceId,
        connectionState: DeviceConnectionState.connecting,
        failure: null,
      );
      const timeout = Duration(seconds: 40);
      final servicesToDiscover = {
        Uuid.parse('FEFF'): [Uuid.parse('FE1F')]
      };
      Stream<ConnectionStateUpdate> deviceUpdateStream;

      setUp(() {
        _deviceConnector.connectionStateUpdatesStreamStub =
            Stream.fromIterable([update]);

        deviceUpdateStream = _sut.connectToDevice(
          id: deviceId,
          servicesWithCharacteristicsToDiscover: servicesToDiscover,
          connectionTimeout: timeout,
        );
      });

      test('It emits values', () {
        expect(
          deviceUpdateStream,
          emitsInAnyOrder(
            <ConnectionStateUpdate>[update],
          ),
        );
      });
    });

    group('Connect to advertising device ', () {
      const deviceId = '123';

      const update = ConnectionStateUpdate(
        deviceId: deviceId,
        connectionState: DeviceConnectionState.connecting,
        failure: null,
      );
      const timeout = Duration(seconds: 40);
      const prescanDuration = Duration(minutes: 2);
      final withServices = [Uuid.parse('EEFF')];
      final servicesToDiscover = {
        Uuid.parse('FEFF'): [Uuid.parse('FE1F')]
      };
      Stream<ConnectionStateUpdate> deviceUpdateStream;

      setUp(() {
        _deviceConnector.connectionStateUpdatesStreamStub =
            Stream.fromIterable([update]);

        deviceUpdateStream = _sut.connectToAdvertisingDevice(
          id: deviceId,
          servicesWithCharacteristicsToDiscover: servicesToDiscover,
          connectionTimeout: timeout,
          prescanDuration: prescanDuration,
          withServices: withServices,
        );
      });

      test('It emits values', () {
        expect(
          deviceUpdateStream,
          emitsInAnyOrder(
            <ConnectionStateUpdate>[update],
          ),
        );
      });
    });

    group('Clear Gatt cache', () {
      const deviceId = '123';

      const result = Result<Unit, GenericFailure<ClearGattCacheError>>.success(
        Unit(),
      );

      setUp(() async {
        _bleOperationControllerStub.clearGattCacheResult = result;

        await _sut.clearGattCache(deviceId);
      });

      test('It executes clear gattcache correctly', () {
        expect(true, true);
      });
    });

    group('Ble status stream', () {
      const update = ConnectionStateUpdate(
        deviceId: '123',
        connectionState: DeviceConnectionState.connected,
        failure: null,
      );

      Stream<ConnectionStateUpdate> updateStream;

      setUp(() {
        _deviceConnector.connectionStateUpdatesStreamStub =
            Stream.fromIterable([update]);

        updateStream = _sut.connectedDeviceStream;
      });

      test('It emits correct value', () {
        expect(
          updateStream,
          emitsInOrder(
            <ConnectionStateUpdate>[update],
          ),
        );
      });
    });

    group('Subscribe to characteristic', () {
      const update = ConnectionStateUpdate(
        deviceId: '123',
        connectionState: DeviceConnectionState.disconnected,
        failure: null,
      );

      QualifiedCharacteristic char;

      Stream<List<int>> valueStream;
      Stream<List<int>> resultStream;

      setUp(() {
        char = _createChar();
        _deviceConnector.connectionStateUpdatesStreamStub =
            Stream.fromIterable([update]);

        valueStream = Stream.fromIterable([
          [1],
          [2]
        ]);

        _deviceOperation.subscribeCharStreamStub = valueStream;

        resultStream = _sut.subscribeToCharacteristic(char);
      });

      test('It emits correct value', () {
        expect(
          resultStream,
          emitsInOrder(
            <List<int>>[
              [1],
              [2]
            ],
          ),
        );
      });
    });

    group('Logging', () {
      group('When loglevel is set to verbose', () {
        setUp(() {
          _sut.logLevel = LogLevel.verbose;
        });

        test('It enables debug logging', () {
          expect(_debugLoggerStub.expectedLogLevel, LogLevel.verbose);
        });
      });

      group('When loglevel is set to none', () {
        setUp(() {
          _sut.logLevel = LogLevel.none;
        });

        test('It enables debug logging', () {
          expect(_debugLoggerStub.expectedLogLevel, LogLevel.none);
        });
      });
    });

    group('Discover Services', () {
      const deviceId = '123';

      group('When operation is successful', () {
        const result = <DiscoveredService>[];

        setUp(() {
          _deviceOperation.discoveredServicesStub = result;
        });

        test('It returns result', () async {
          expect(await _sut.discoverServices(deviceId), <DiscoveredService>[]);
        });
      });
    });
  });
}

QualifiedCharacteristic _createChar() => QualifiedCharacteristic(
      deviceId: '123',
      serviceId: Uuid.parse('FEFF'),
      characteristicId: Uuid.parse('FFEE'),
    );

class _BleOperationControllerStub implements BleOperationController {
  Stream<BleStatus> _statusStream;
  Result<Unit, GenericFailure<ClearGattCacheError>> _gattCacheResult;

  @override
  Stream<BleStatus> get bleStatusStream => _statusStream;

  @override
  Future<Result<Unit, GenericFailure<ClearGattCacheError>>> clearGattCache(
          String deviceId) async =>
      _gattCacheResult;

  @override
  Future<void> deinitialize() => Future.value();

  @override
  Future<void> initialize() => Future.value();

  set bleStatusStreamStub(Stream<BleStatus> stream) => _statusStream = stream;

  set clearGattCacheResult(
          Result<Unit, GenericFailure<ClearGattCacheError>> result) =>
      _gattCacheResult = result;
}

class _DeviceConnectorStub implements DeviceConnector {
  Stream<ConnectionStateUpdate> _connectionStateUpdatesStream;

  @override
  Stream<ConnectionStateUpdate> connect(
          {String id,
          Map<Uuid, List<Uuid>> servicesWithCharacteristicsToDiscover,
          Duration connectionTimeout}) =>
      _connectionStateUpdatesStream;

  @override
  Stream<ConnectionStateUpdate> connectToAdvertisingDevice(
          {String id,
          List<Uuid> withServices,
          Duration prescanDuration,
          Map<Uuid, List<Uuid>> servicesWithCharacteristicsToDiscover,
          Duration connectionTimeout}) =>
      _connectionStateUpdatesStream;

  @override
  Stream<ConnectionStateUpdate> get deviceConnectionStateUpdateStream =>
      _connectionStateUpdatesStream;

  set connectionStateUpdatesStreamStub(Stream<ConnectionStateUpdate> updates) =>
      _connectionStateUpdatesStream = updates;
}

class _DeviceOperationStub implements ConnectedDeviceOperation {
  Stream<CharacteristicValue> _charValueStream;
  List<DiscoveredService> _discoveredServices;
  List<int> _readCharValue;
  Stream<List<int>> _subscribeCharStream;

  int _requestedMtu;

  @override
  Stream<CharacteristicValue> get characteristicValueStream => _charValueStream;

  @override
  Future<List<DiscoveredService>> discoverServices(String deviceId) async =>
      _discoveredServices;

  @override
  Future<List<int>> readCharacteristic(
          QualifiedCharacteristic characteristic) async =>
      _readCharValue;

  @override
  Future<void> requestConnectionPriority(
          String deviceId, ConnectionPriority priority) =>
      Future.value();

  @override
  Future<int> requestMtu(String deviceId, int mtu) async => _requestedMtu;

  @override
  Stream<List<int>> subscribeToCharacteristic(
          QualifiedCharacteristic characteristic,
          Future<void> isDisconnected) =>
      _subscribeCharStream;

  @override
  Future<void> writeCharacteristicWithResponse(
          QualifiedCharacteristic characteristic,
          {List<int> value}) =>
      Future.value();

  @override
  Future<void> writeCharacteristicWithoutResponse(
          QualifiedCharacteristic characteristic,
          {List<int> value}) =>
      Future.value();

  set charValueStreamStub(Stream<CharacteristicValue> stream) =>
      _charValueStream = stream;

  set subscribeCharStreamStub(Stream<List<int>> stream) =>
      _subscribeCharStream = stream;

  set discoveredServicesStub(List<DiscoveredService> services) =>
      _discoveredServices = services;

  set readCharValueStub(List<int> values) => _readCharValue = values;

  set requestMtuStub(int value) => _requestedMtu = value;
}

class _DebugLoggerStub implements Logger {
  LogLevel _logLevel;
  @override
  void log(Object message) {}

  @override
  set logLevel(LogLevel logLevel) => _logLevel = logLevel;

  LogLevel get expectedLogLevel => _logLevel;
}
