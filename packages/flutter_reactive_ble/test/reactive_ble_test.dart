import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/connected_device_operation.dart';
import 'package:flutter_reactive_ble/src/device_connector.dart';
import 'package:flutter_reactive_ble/src/device_scanner.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reactive_ble_platform_interface/reactive_ble_platform_interface.dart';

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

      when(_blePlatform.bleStatusStream)
          .thenAnswer((realInvocation) => _bleStatusController.stream.asBroadcastStream());

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
      const characteristic = Result<List<int>, GenericFailure<CharacteristicValueUpdateError>>.success(
        [1],
      );
      final characteristicInstance = CharacteristicInstance(
        deviceId: "1",
        characteristicId: Uuid.parse('FEFF'),
        characteristicInstanceId: "11",
        serviceId: Uuid.parse('F0FF'),
        serviceInstanceId: "101",
      );
      final charValue = CharacteristicValue(characteristic: characteristicInstance, result: characteristic);
      Stream<CharacteristicValue>? charValueStream;

      setUp(() {
        when(_deviceOperation.characteristicValueStream).thenAnswer((_) => Stream.fromIterable([charValue]));
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
      });

      test('It executes deinitialize successful', () async {
        await _sut.deinitialize();
      });
    });

    group('Read characteristic', () {
      late QualifiedCharacteristic characteristic;
      List<int>? result;

      setUp(() async {
        characteristic = _createChar();
        when(_deviceOperation.getDiscoverServices(characteristic.deviceId)).thenAnswer((_) async => [
              DiscoveredService(
                serviceId: characteristic.serviceId,
                serviceInstanceId: "11",
                characteristicIds: [characteristic.characteristicId],
                includedServices: [],
                characteristics: [
                  DiscoveredCharacteristic(
                    characteristicId: Uuid.parse("1234"),
                    characteristicInstanceId: "101",
                    serviceId: characteristic.serviceId,
                    isReadable: true,
                    isWritableWithResponse: true,
                    isWritableWithoutResponse: true,
                    isNotifiable: true,
                    isIndicatable: true,
                  ),
                  DiscoveredCharacteristic(
                    characteristicId: characteristic.characteristicId,
                    characteristicInstanceId: "101",
                    serviceId: characteristic.serviceId,
                    isReadable: true,
                    isWritableWithResponse: true,
                    isWritableWithoutResponse: true,
                    isNotifiable: true,
                    isIndicatable: true,
                  ),
                ],
              )
            ]);
        when(_deviceOperation.readCharacteristic(any)).thenAnswer((_) async => [1]);

        result = await _sut.readCharacteristic(characteristic);
      });

      test("It reads the correct characteristic", () {
        verify(_deviceOperation.readCharacteristic(CharacteristicInstance(
          characteristicId: characteristic.characteristicId,
          characteristicInstanceId: "101",
          serviceId: characteristic.serviceId,
          serviceInstanceId: "11",
          deviceId: characteristic.deviceId,
        ))).called(1);
      });

      test('It returns correct value', () {
        expect(result, [1]);
      });
    });

    group('Write characteristic with response', () {
      const value = [2];
      late QualifiedCharacteristic characteristic;

      setUp(() async {
        characteristic = _createChar();

        when(_deviceOperation.writeCharacteristicWithResponse(
          any,
          value: anyNamed('value'),
        )).thenAnswer((_) async => [0]);
        when(_deviceOperation.getDiscoverServices(characteristic.deviceId)).thenAnswer((_) async => [
              DiscoveredService(
                serviceId: characteristic.serviceId,
                serviceInstanceId: "11",
                characteristicIds: [characteristic.characteristicId],
                includedServices: [],
                characteristics: [
                  DiscoveredCharacteristic(
                    characteristicId: Uuid.parse("1234"),
                    characteristicInstanceId: "101",
                    serviceId: characteristic.serviceId,
                    isReadable: true,
                    isWritableWithResponse: true,
                    isWritableWithoutResponse: true,
                    isNotifiable: true,
                    isIndicatable: true,
                  ),
                  DiscoveredCharacteristic(
                    characteristicId: characteristic.characteristicId,
                    characteristicInstanceId: "101",
                    serviceId: characteristic.serviceId,
                    isReadable: true,
                    isWritableWithResponse: true,
                    isWritableWithoutResponse: true,
                    isNotifiable: true,
                    isIndicatable: true,
                  ),
                ],
              )
            ]);

        await _sut.writeCharacteristicWithResponse(characteristic, value: value);
      });

      test("It write to the correct characteristic", () {
        verify(_deviceOperation.writeCharacteristicWithResponse(
          CharacteristicInstance(
            characteristicId: characteristic.characteristicId,
            characteristicInstanceId: "101",
            serviceId: characteristic.serviceId,
            serviceInstanceId: "11",
            deviceId: characteristic.deviceId,
          ),
          value: [2],
        )).called(1);
      });
    });

    group('Write characteristic without response', () {
      const value = [2];
      late QualifiedCharacteristic characteristic;

      setUp(() async {
        characteristic = _createChar();

        when(_deviceOperation.writeCharacteristicWithoutResponse(
          any,
          value: anyNamed('value'),
        )).thenAnswer((_) async => [0]);
        when(_deviceOperation.getDiscoverServices(characteristic.deviceId)).thenAnswer((_) async => [
              DiscoveredService(
                serviceId: characteristic.serviceId,
                serviceInstanceId: "11",
                characteristicIds: [characteristic.characteristicId],
                includedServices: [],
                characteristics: [
                  DiscoveredCharacteristic(
                    characteristicId: Uuid.parse("1234"),
                    characteristicInstanceId: "101",
                    serviceId: characteristic.serviceId,
                    isReadable: true,
                    isWritableWithResponse: true,
                    isWritableWithoutResponse: true,
                    isNotifiable: true,
                    isIndicatable: true,
                  ),
                  DiscoveredCharacteristic(
                    characteristicId: characteristic.characteristicId,
                    characteristicInstanceId: "101",
                    serviceId: characteristic.serviceId,
                    isReadable: true,
                    isWritableWithResponse: true,
                    isWritableWithoutResponse: true,
                    isNotifiable: true,
                    isIndicatable: true,
                  ),
                ],
              )
            ]);

        await _sut.writeCharacteristicWithoutResponse(
          characteristic,
          value: value,
        );
      });

      test("It write to the correct characteristic", () {
        verify(_deviceOperation.writeCharacteristicWithoutResponse(
          CharacteristicInstance(
            characteristicId: characteristic.characteristicId,
            characteristicInstanceId: "101",
            serviceId: characteristic.serviceId,
            serviceInstanceId: "11",
            deviceId: characteristic.deviceId,
          ),
          value: [2],
        )).called(1);
      });
    });

    group('Request mtu', () {
      const deviceId = '123';
      const mtu = 120;
      int? result;

      setUp(() async {
        when(_deviceOperation.requestMtu(any, any)).thenAnswer((_) async => mtu);

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
        when(_deviceOperation.requestConnectionPriority(any, any)).thenAnswer((_) async => 0);
        await _sut.requestConnectionPriority(deviceId: deviceId, priority: priority);
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
        connectable: Connectable.unknown,
        serviceData: const {},
        serviceUuids: const [],
      );
      Stream<DiscoveredDevice>? deviceStream;

      setUp(() {
        when(_deviceScanner.scanForDevices(
          withServices: anyNamed('withServices'),
          scanMode: anyNamed('scanMode'),
          requireLocationServicesEnabled: anyNamed('requireLocationServicesEnabled'),
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
                servicesWithCharacteristicsToDiscover: anyNamed('servicesWithCharacteristicsToDiscover'),
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
          servicesWithCharacteristicsToDiscover: anyNamed('servicesWithCharacteristicsToDiscover'),
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
        when(_blePlatform.clearGattCache('123')).thenAnswer((_) async => result);

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
        when(_deviceConnector.deviceConnectionStateUpdateStream).thenAnswer((_) => Stream.fromIterable([update]));
        when(_deviceOperation.getDiscoverServices(char.deviceId)).thenAnswer((_) async => [
              DiscoveredService(
                serviceId: char.serviceId,
                serviceInstanceId: "11",
                characteristicIds: [char.characteristicId],
                includedServices: [],
                characteristics: [
                  DiscoveredCharacteristic(
                    characteristicId: Uuid.parse("1234"),
                    characteristicInstanceId: "101",
                    serviceId: char.serviceId,
                    isReadable: true,
                    isWritableWithResponse: true,
                    isWritableWithoutResponse: true,
                    isNotifiable: true,
                    isIndicatable: true,
                  ),
                  DiscoveredCharacteristic(
                    characteristicId: char.characteristicId,
                    characteristicInstanceId: "101",
                    serviceId: char.serviceId,
                    isReadable: true,
                    isWritableWithResponse: true,
                    isWritableWithoutResponse: true,
                    isNotifiable: true,
                    isIndicatable: true,
                  ),
                ],
              )
            ]);

        valueStream = Stream.fromIterable([
          [1],
          [2]
        ]);

        when(_deviceOperation.subscribeToCharacteristic(any, any)).thenAnswer((_) => valueStream);

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
          when(_deviceOperation.discoverServices(any)).thenAnswer((_) async => result);
        });

        test('It returns result', () async {
          // ignore: deprecated_member_use_from_same_package
          expect(await _sut.discoverServices(deviceId), <DiscoveredService>[]);
        });
      });
    });

    group('Discover all services', () {
      const deviceId = '123';

      group('When operation is successful', () {
        const result = <DiscoveredService>[];

        setUp(() {
          when(_deviceOperation.discoverServices(any)).thenAnswer((_) async => result);
        });

        test('It succeeds', () async {
          await _sut.discoverAllServices(deviceId);
          verify(_deviceOperation.discoverServices(deviceId)).called(1);
        });
      });
    });

    group("getDiscoveredServices", () {
      const deviceId = "123";

      group("multiple characteristics with same id in single service", () {
        setUp(() {
          when(_deviceOperation.getDiscoverServices(deviceId)).thenAnswer((_) async => [
                DiscoveredService(
                  serviceId: Uuid.parse("ff01"),
                  serviceInstanceId: "11",
                  characteristicIds: [Uuid.parse("aa01")],
                  includedServices: [],
                  characteristics: [
                    DiscoveredCharacteristic(
                      characteristicId: Uuid.parse("aa01"),
                      characteristicInstanceId: "101",
                      serviceId: Uuid.parse("ff01"),
                      isReadable: true,
                      isWritableWithResponse: true,
                      isWritableWithoutResponse: true,
                      isNotifiable: true,
                      isIndicatable: true,
                    ),
                    DiscoveredCharacteristic(
                      characteristicId: Uuid.parse("aa01"),
                      characteristicInstanceId: "102",
                      serviceId: Uuid.parse("ff01"),
                      isReadable: true,
                      isWritableWithResponse: true,
                      isWritableWithoutResponse: true,
                      isNotifiable: true,
                      isIndicatable: true,
                    ),
                  ],
                )
              ]);
          when(_deviceOperation.readCharacteristic(any)).thenAnswer((_) async => [42]);
        });

        test("reading first instance of characteristic", () async {
          final services = await _sut.getDiscoveredServices("123");

          expect(await services.single.characteristics.first.read(), [42]);

          verify(_deviceOperation.readCharacteristic(CharacteristicInstance(
            characteristicId: Uuid.parse("aa01"),
            characteristicInstanceId: "101",
            serviceId: Uuid.parse("ff01"),
            serviceInstanceId: "11",
            deviceId: "123",
          )));
        });

        test("reading second instance of characteristic", () async {
          final services = await _sut.getDiscoveredServices("123");

          expect(await services.single.characteristics[1].read(), [42]);

          verify(_deviceOperation.readCharacteristic(CharacteristicInstance(
            characteristicId: Uuid.parse("aa01"),
            characteristicInstanceId: "102",
            serviceId: Uuid.parse("ff01"),
            serviceInstanceId: "11",
            deviceId: "123",
          )));
        });
      });

      group("multiple characteristics with same id in different service", () {
        setUp(() {
          when(_deviceOperation.getDiscoverServices(deviceId)).thenAnswer((_) async => [
            DiscoveredService(
              serviceId: Uuid.parse("ff01"),
              serviceInstanceId: "11",
              characteristicIds: [Uuid.parse("aa01")],
              includedServices: [],
              characteristics: [
                DiscoveredCharacteristic(
                  characteristicId: Uuid.parse("aa01"),
                  characteristicInstanceId: "101",
                  serviceId: Uuid.parse("ff01"),
                  isReadable: true,
                  isWritableWithResponse: true,
                  isWritableWithoutResponse: true,
                  isNotifiable: true,
                  isIndicatable: true,
                ),
              ],
            ),
            DiscoveredService(
              serviceId: Uuid.parse("ff01"),
              serviceInstanceId: "12",
              characteristicIds: [Uuid.parse("aa01")],
              includedServices: [],
              characteristics: [
                DiscoveredCharacteristic(
                  characteristicId: Uuid.parse("aa01"),
                  characteristicInstanceId: "101",
                  serviceId: Uuid.parse("ff01"),
                  isReadable: true,
                  isWritableWithResponse: true,
                  isWritableWithoutResponse: true,
                  isNotifiable: true,
                  isIndicatable: true,
                ),
              ],
            ),
          ]);
          when(_deviceOperation.readCharacteristic(any)).thenAnswer((_) async => [42]);
        });

        test("reading first instance of characteristic", () async {
          final services = await _sut.getDiscoveredServices("123");

          expect(await services.first.characteristics.single.read(), [42]);

          verify(_deviceOperation.readCharacteristic(CharacteristicInstance(
            characteristicId: Uuid.parse("aa01"),
            characteristicInstanceId: "101",
            serviceId: Uuid.parse("ff01"),
            serviceInstanceId: "11",
            deviceId: "123",
          )));
        });

        test("reading second instance of characteristic", () async {
          final services = await _sut.getDiscoveredServices("123");

          expect(await services[1].characteristics.single.read(), [42]);

          verify(_deviceOperation.readCharacteristic(CharacteristicInstance(
            characteristicId: Uuid.parse("aa01"),
            characteristicInstanceId: "101",
            serviceId: Uuid.parse("ff01"),
            serviceInstanceId: "12",
            deviceId: "123",
          )));
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
