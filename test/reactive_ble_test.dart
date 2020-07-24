import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/connected_device_operation.dart';
import 'package:flutter_reactive_ble/src/debug_logger.dart';
import 'package:flutter_reactive_ble/src/device_connector.dart';
import 'package:flutter_reactive_ble/src/device_scanner.dart';
import 'package:flutter_reactive_ble/src/model/clear_gatt_cache_error.dart';
import 'package:flutter_reactive_ble/src/model/log_level.dart';
import 'package:flutter_reactive_ble/src/model/unit.dart';
import 'package:flutter_reactive_ble/src/plugin_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('$FlutterReactiveBle', () {
    _PluginControllerMock _pluginController;
    _DeviceScannerMock _deviceScanner;
    _DeviceConnectorMock _deviceConnector;
    _DeviceOperationMock _deviceOperation;
    StreamController<BleStatus> _bleStatusController;
    _DebugLoggerMock _debugLoggerMock;

    FlutterReactiveBle _sut;

    setUp(() {
      _pluginController = _PluginControllerMock();
      _deviceScanner = _DeviceScannerMock();
      _deviceConnector = _DeviceConnectorMock();
      _deviceOperation = _DeviceOperationMock();
      _bleStatusController = StreamController();
      _debugLoggerMock = _DebugLoggerMock();

      when(_pluginController.initialize()).thenAnswer(
        (_) => Future.value(),
      );

      when(_pluginController.bleStatusStream).thenAnswer(
        (_) => _bleStatusController.stream.asBroadcastStream(),
      );

      _sut = FlutterReactiveBle.witDependencies(
        pluginController: _pluginController,
        deviceScanner: _deviceScanner,
        deviceConnector: _deviceConnector,
        connectedDeviceOperation: _deviceOperation,
        debugLogger: _debugLoggerMock,
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

      test('It calls initialize', () async {
        await bleStatusStream.first;
        verify(_pluginController.initialize()).called(1);
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
        when(_deviceOperation.characteristicValueStream).thenAnswer(
          (_) => Stream.fromIterable([charValue]),
        );
        charValueStream = _sut.characteristicValueStream;
      });

      test('It calls initalize', () async {
        await charValueStream.first;
        verify(_pluginController.initialize()).called(1);
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
        when(_pluginController.deInitialize()).thenAnswer(
          (_) => Future.value(),
        );

        await _sut.deinitialize();
      });

      test('It calls plugincontroller deinitailize method', () {
        verify(_pluginController.deInitialize()).called(1);
      });
    });

    group('Read characteristic', () {
      QualifiedCharacteristic characteristic;
      List<int> result;

      setUp(() async {
        characteristic = _createChar();

        when(_deviceOperation.readCharacteristic(any)).thenAnswer(
          (_) => Future.value([1]),
        );

        result = await _sut.readCharacteristic(characteristic);
      });

      test('It calls initalize', () async {
        verify(_pluginController.initialize()).called(1);
      });

      test('It calls deviceoperation with correct arguments', () {
        verify(_deviceOperation.readCharacteristic(characteristic)).called(1);
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

        when(_deviceOperation.writeCharacteristicWithResponse(
          any,
          value: anyNamed('value'),
        )).thenAnswer((_) => Future.value());

        await _sut.writeCharacteristicWithResponse(characteristic,
            value: value);
      });

      test('It calls initalize', () async {
        verify(_pluginController.initialize()).called(1);
      });

      test('It calls deviceoperation with correct arguments', () {
        verify(
          _deviceOperation.writeCharacteristicWithResponse(characteristic,
              value: value),
        ).called(1);
      });
    });

    group('Write characteristic without response', () {
      const value = [2];
      QualifiedCharacteristic characteristic;

      setUp(() async {
        characteristic = _createChar();

        when(_deviceOperation.writeCharacteristicWithoutResponse(
          any,
          value: anyNamed('value'),
        )).thenAnswer((_) => Future.value());

        await _sut.writeCharacteristicWithoutResponse(
          characteristic,
          value: value,
        );
      });

      test('It calls initalize', () async {
        verify(_pluginController.initialize()).called(1);
      });

      test('It calls deviceoperation with correct arguments', () {
        verify(
          _deviceOperation.writeCharacteristicWithoutResponse(
            characteristic,
            value: value,
          ),
        ).called(1);
      });
    });

    group('Request mtu', () {
      const deviceId = '123';
      const mtu = 120;
      int result;

      setUp(() async {
        when(_deviceOperation.requestMtu(any, any)).thenAnswer(
          (_) => Future.value(100),
        );

        result = await _sut.requestMtu(deviceId: deviceId, mtu: mtu);
      });

      test('It calls initalize', () async {
        verify(_pluginController.initialize()).called(1);
      });

      test('It calls deviceoperation with correct arguments', () {
        verify(_deviceOperation.requestMtu(deviceId, mtu)).called(1);
      });

      test('It returns correct value', () {
        expect(result, 100);
      });
    });
    group('Request connection prio', () {
      const deviceId = '123';
      const priority = ConnectionPriority.highPerformance;

      setUp(() async {
        when(_deviceOperation.requestConnectionPriority(any, any)).thenAnswer(
          (_) => Future.value(),
        );

        await _sut.requestConnectionPriority(
            deviceId: deviceId, priority: priority);
      });

      test('It calls initalize', () async {
        verify(_pluginController.initialize()).called(1);
      });

      test('It calls deviceoperation with correct arguments', () {
        verify(_deviceOperation.requestConnectionPriority(
          deviceId,
          priority,
        )).called(1);
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
        when(_deviceScanner.scanForDevices(
          withServices: anyNamed('withServices'),
          scanMode: anyNamed('scanMode'),
          requireLocationServicesEnabled:
              anyNamed('requireLocationServicesEnabled'),
        )).thenAnswer(
          (_) => Stream.fromIterable([device]),
        );

        deviceStream = _sut.scanForDevices(
          withServices: withServices,
          scanMode: mode,
          requireLocationServicesEnabled: requireLocation,
        );
      });

      test('It calls initalize', () async {
        await deviceStream.first;
        verify(_pluginController.initialize()).called(1);
      });

      test('It calls devicescanner with correct arguments', () async {
        await deviceStream.first;
        verify(_deviceScanner.scanForDevices(
          withServices: withServices,
          scanMode: mode,
          requireLocationServicesEnabled: requireLocation,
        )).called(1);
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
        when(_deviceConnector.connect(
          id: anyNamed('id'),
          servicesWithCharacteristicsToDiscover:
              anyNamed('servicesWithCharacteristicsToDiscover'),
          connectionTimeout: anyNamed('connectionTimeout'),
        )).thenAnswer(
          (_) => Stream.fromIterable([update]),
        );

        deviceUpdateStream = _sut.connectToDevice(
          id: deviceId,
          servicesWithCharacteristicsToDiscover: servicesToDiscover,
          connectionTimeout: timeout,
        );
      });

      test('It calls initalize', () async {
        await deviceUpdateStream.first;
        verify(_pluginController.initialize()).called(1);
      });

      test('It calls deviceconnector with correct arguments', () async {
        await deviceUpdateStream.first;
        verify(_deviceConnector.connect(
          id: deviceId,
          servicesWithCharacteristicsToDiscover: servicesToDiscover,
          connectionTimeout: timeout,
        )).called(1);
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
        when(_deviceConnector.connectToAdvertisingDevice(
          id: anyNamed('id'),
          servicesWithCharacteristicsToDiscover:
              anyNamed('servicesWithCharacteristicsToDiscover'),
          connectionTimeout: anyNamed('connectionTimeout'),
          prescanDuration: prescanDuration,
          withServices: withServices,
        )).thenAnswer(
          (_) => Stream.fromIterable([update]),
        );

        deviceUpdateStream = _sut.connectToAdvertisingDevice(
          id: deviceId,
          servicesWithCharacteristicsToDiscover: servicesToDiscover,
          connectionTimeout: timeout,
          prescanDuration: prescanDuration,
          withServices: withServices,
        );
      });

      test('It calls initalize', () async {
        await deviceUpdateStream.first;
        verify(_pluginController.initialize()).called(1);
      });

      test('It calls deviceconnector with correct arguments', () async {
        await deviceUpdateStream.first;
        verify(_deviceConnector.connectToAdvertisingDevice(
          id: anyNamed('id'),
          servicesWithCharacteristicsToDiscover:
              anyNamed('servicesWithCharacteristicsToDiscover'),
          connectionTimeout: anyNamed('connectionTimeout'),
          prescanDuration: prescanDuration,
          withServices: withServices,
        )).called(1);
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
        when(_pluginController.clearGattCache(any)).thenAnswer(
          (_) => Future.value(result),
        );

        await _sut.clearGattCache(deviceId);
      });

      test('It calls initalize', () async {
        verify(_pluginController.initialize()).called(1);
      });

      test('It calls plugincontroller with correct arguments', () {
        verify(_pluginController.clearGattCache(deviceId)).called(1);
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
        when(_deviceConnector.deviceConnectionStateUpdateStream).thenAnswer(
          (_) => Stream.fromIterable([update]),
        );

        updateStream = _sut.connectedDeviceStream;
      });

      test('It calls initialize', () {
        verify(_pluginController.initialize()).called(1);
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
        when(_deviceConnector.deviceConnectionStateUpdateStream).thenAnswer(
          (_) => Stream.fromIterable([update]),
        );

        valueStream = Stream.fromIterable([
          [1],
          [2]
        ]);

        when(_deviceOperation.subscribeToCharacteristic(any, any))
            .thenAnswer((_) => valueStream);

        resultStream = _sut.subscribeToCharacteristic(char);
      });

      test('It calls initialize', () {
        verify(_pluginController.initialize()).called(1);
      });

      test('It calls device operation with the correct arguments', () async {
        await resultStream.first;
        verify(_deviceOperation.subscribeToCharacteristic(char, any));
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
          _sut.setLogLevel(LogLevel.verbose);
        });

        test('It enables debug logging', () {
          verify(_debugLoggerMock.enable()).called(1);
        });
      });

      group('When loglevel is set to none', () {
        setUp(() {
          _sut.setLogLevel(LogLevel.none);
        });

        test('It enables debug logging', () {
          verify(_debugLoggerMock.disable()).called(1);
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

class _PluginControllerMock extends Mock implements PluginController {}

class _DeviceScannerMock extends Mock implements DeviceScanner {}

class _DeviceConnectorMock extends Mock implements DeviceConnector {}

class _DeviceOperationMock extends Mock implements ConnectedDeviceOperation {}

class _DebugLoggerMock extends Mock implements DebugLogger {}
