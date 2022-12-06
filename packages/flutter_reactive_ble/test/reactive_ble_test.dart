import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/connected_device_operation.dart';
import 'package:flutter_reactive_ble/src/device_connector.dart';
import 'package:flutter_reactive_ble/src/device_scanner.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'reactive_ble_test.mocks.dart';

@GenerateMocks(
  [
    ReactiveBlePlatform,
    Logger,
    ConnectedDeviceOperation,
    DeviceConnector,
    DeviceScanner,
  ],
)
void main() {
  group('$FlutterReactiveBle', () {
    late ReactiveBlePlatform _blePlatform;
    late MockDeviceScanner _deviceScanner;
    late MockDeviceConnector _deviceConnector;
    late MockConnectedDeviceOperation _deviceOperation;
    late StreamController<BleStatus> _bleStatusController;
    MockLogger _debugLogger;

    late FlutterReactiveBle _sut;

    setUp(() {
      _blePlatform = MockReactiveBlePlatform();
      _deviceScanner = MockDeviceScanner();
      _deviceConnector = MockDeviceConnector();
      _deviceOperation = MockConnectedDeviceOperation();
      _bleStatusController = StreamController();
      _debugLogger = MockLogger();

      when(_blePlatform.initialize()).thenAnswer(
        (_) => Future.value(),
      );

      when(_blePlatform.deinitialize()).thenAnswer(
        (_) => Future.value(),
      );

      when(_blePlatform.bleStatusStream).thenAnswer(
          (realInvocation) => _bleStatusController.stream.asBroadcastStream());

      _sut = FlutterReactiveBle.witDependencies(
        reactiveBlePlatform: _blePlatform,
        deviceScanner: _deviceScanner,
        deviceConnector: _deviceConnector,
        connectedDeviceOperation: _deviceOperation,
        debugLogger: _debugLogger,
        initialization: Future.value(),
      );
    });

    tearDown(() async {
      await _sut.deinitialize();
      await _bleStatusController.close();
    });

    group('BleStatus stream', () {
      Stream<BleStatus>? bleStatusStream;
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
      Stream<CharacteristicValue>? charValueStream;

      setUp(() {
        when(_deviceOperation.characteristicValueStream)
            .thenAnswer((_) => Stream.fromIterable([charValue]));
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
        when(_blePlatform.deinitialize()).thenAnswer((_) async => 1);
        await _sut.deinitialize();
      });

      test('It executes deinitialize succesfull', () {
        expect(true, true);
      });
    });

    group('Read characteristic', () {
      QualifiedCharacteristic characteristic;
      List<int>? result;

      setUp(() async {
        characteristic = _createChar();
        when(_deviceOperation.readCharacteristic(any))
            .thenAnswer((_) async => [1]);

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

        when(_deviceOperation.writeCharacteristicWithResponse(
          any,
          value: anyNamed('value'),
        )).thenAnswer((_) async => [0]);

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

        when(_deviceOperation.writeCharacteristicWithoutResponse(
          any,
          value: anyNamed('value'),
        )).thenAnswer((_) async => [0]);

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
      int? result;

      setUp(() async {
        when(_deviceOperation.requestMtu(any, any))
            .thenAnswer((_) async => mtu);

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
        when(_deviceOperation.requestConnectionPriority(any, any))
            .thenAnswer((_) async => 0);
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

      final device = DiscoveredDevice(
        id: 'deviceId',
        manufacturerData: Uint8List.fromList([0]),
        name: 'test',
        rssi: -39,
        serviceData: const {},
        serviceUuids: const [],
      );
      Stream<DiscoveredDevice>? deviceStream;

      setUp(() {
        when(_deviceScanner.scanForDevices(
          withServices: anyNamed('withServices'),
          scanMode: anyNamed('scanMode'),
          requireLocationServicesEnabled:
              anyNamed('requireLocationServicesEnabled'),
        )).thenAnswer((_) => Stream.fromIterable([device]));

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
      Stream<ConnectionStateUpdate?>? deviceUpdateStream;

      setUp(() {
        when(_deviceConnector.connect(
                id: anyNamed('id'),
                servicesWithCharacteristicsToDiscover:
                    anyNamed('servicesWithCharacteristicsToDiscover'),
                connectionTimeout: anyNamed('connectionTimeout')))
            .thenAnswer((realInvocation) => Stream.fromIterable([update]));

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
      Stream<ConnectionStateUpdate?>? deviceUpdateStream;

      setUp(() {
        when(_deviceConnector.connectToAdvertisingDevice(
          id: anyNamed('id'),
          servicesWithCharacteristicsToDiscover:
              anyNamed('servicesWithCharacteristicsToDiscover'),
          connectionTimeout: anyNamed('connectionTimeout'),
          prescanDuration: anyNamed('prescanDuration'),
          withServices: anyNamed('withServices'),
        )).thenAnswer((realInvocation) => Stream.fromIterable([update]));

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
        when(_blePlatform.clearGattCache('123'))
            .thenAnswer((_) async => result);

        await _sut.clearGattCache(deviceId);
      });

      test('It executes clear gattcache correctly', () {
        expect(true, true);
      });
    });

    group('ConnecteddeviceStream stream', () {
      const update = ConnectionStateUpdate(
        deviceId: '123',
        connectionState: DeviceConnectionState.connected,
        failure: null,
      );

      Stream<ConnectionStateUpdate>? updateStream;

      setUp(() {
        when(_deviceConnector.deviceConnectionStateUpdateStream)
            .thenAnswer((realInvocation) => Stream.fromIterable([update]));

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

      late Stream<List<int>> valueStream;
      late Stream<List<int>?> resultStream;

      setUp(() {
        char = _createChar();
        when(_deviceConnector.deviceConnectionStateUpdateStream)
            .thenAnswer((_) => Stream.fromIterable([update]));

        valueStream = Stream.fromIterable([
          [1],
          [2]
        ]);

        when(_deviceOperation.subscribeToCharacteristic(any, any))
            .thenAnswer((_) => valueStream);

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

    group('Discover Services', () {
      const deviceId = '123';

      group('When operation is successful', () {
        const result = <DiscoveredService>[];

        setUp(() {
          when(_deviceOperation.discoverServices(any))
              .thenAnswer((_) async => result);
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
