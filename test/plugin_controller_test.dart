import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/converter/args_to_protubuf_converter.dart';
import 'package:flutter_reactive_ble/src/converter/protobuf_converter.dart';
import 'package:flutter_reactive_ble/src/debug_logger.dart';
import 'package:flutter_reactive_ble/src/generated/bledata.pbserver.dart' as pb;
import 'package:flutter_reactive_ble/src/model/clear_gatt_cache_error.dart';
import 'package:flutter_reactive_ble/src/model/unit.dart';
import 'package:flutter_reactive_ble/src/model/write_characteristic_info.dart';
import 'package:flutter_reactive_ble/src/plugin_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'plugin_controller_test.mocks.dart';

@GenerateMocks([Logger, ArgsToProtobufConverter, ProtobufConverter])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('$PluginController', () {
    PluginController _sut;
    MethodChannel _methodChannel;
    MockArgsToProtobufConverter _argsConverter;
    MockProtobufConverter _protobufConverter;
    StreamController<List<int>> _connectedDeviceStreamController;
    StreamController<List<int>> _argsStreamController;
    StreamController<List<int>> _scanStreamController;
    StreamController<List<int>> _statusStreamController;

    setUp(() {
      _argsConverter = MockArgsToProtobufConverter();
      _methodChannel = const MethodChannel('test');
      _protobufConverter = MockProtobufConverter();
      _connectedDeviceStreamController = StreamController();
      _argsStreamController = StreamController();
      _scanStreamController = StreamController();
      _statusStreamController = StreamController();

      _methodChannel.setMockMethodCallHandler((call) async {});
      final logger = MockLogger();
      when(logger.log(any)).thenReturn(null);

      _sut = PluginController(
        argsToProtobufConverter: _argsConverter,
        bleMethodChannel: _methodChannel,
        protobufConverter: _protobufConverter,
        connectedDeviceChannel: _connectedDeviceStreamController.stream,
        charUpdateChannel: _argsStreamController.stream,
        bleDeviceScanChannel: _scanStreamController.stream,
        bleStatusChannel: _statusStreamController.stream,
        debugLogger: logger,
      );
    });

    tearDown(() {
      _connectedDeviceStreamController.close();
      _argsStreamController.close();
      _scanStreamController.close();
      _statusStreamController.close();
    });

    group('connect to device', () {
      pb.ConnectToDeviceRequest request;
      StreamSubscription subscription;
      setUp(() {
        request = pb.ConnectToDeviceRequest();
        when(_argsConverter.createConnectToDeviceArgs(any, any, any))
            .thenReturn(request);
      });

      test('It emits 1 item', () async {
        final length = await _sut.connectToDevice('id', {}, null).length;
        expect(length, 1);
      });

      tearDown(() async {
        await subscription?.cancel();
      });
    });

    group('connect to device', () {
      pb.DisconnectFromDeviceRequest request;
      setUp(() async {
        request = pb.DisconnectFromDeviceRequest();
        when(_argsConverter.createDisconnectDeviceArgs(any))
            .thenReturn(request);
      });

      test('It executes the request succesfully', () async {
        await _sut.disconnectDevice('id');
        expect(true, true);
      });
    });

    group('Connect to device stream', () {
      const update = ConnectionStateUpdate(
        deviceId: '123',
        connectionState: DeviceConnectionState.connecting,
        failure: null,
      );

      Stream<ConnectionStateUpdate> result;

      setUp(() {
        _connectedDeviceStreamController.addStream(
          Stream.fromIterable([
            [1, 2, 3],
          ]),
        );

        when(
          _protobufConverter.connectionStateUpdateFrom(any),
        ).thenReturn(update);
        result = _sut.connectionUpdateStream;
      });

      test('It emits correct value', () {
        expect(result, emitsInOrder(<ConnectionStateUpdate>[update]));
      });
    });

    group('Char update stream', () {
      CharacteristicValue valueUpdate;
      Stream<CharacteristicValue> result;

      setUp(() {
        valueUpdate = CharacteristicValue(
          characteristic: QualifiedCharacteristic(
            characteristicId: Uuid.parse('FEFF'),
            serviceId: Uuid.parse('FEFF'),
            deviceId: '123',
          ),
          result: const Result.success([1]),
        );

        _argsStreamController.addStream(
          Stream<List<int>>.fromIterable([
            [0, 1]
          ]),
        );

        when(_protobufConverter.characteristicValueFrom(any))
            .thenReturn(valueUpdate);

        result = _sut.charValueUpdateStream;
      });

      test('It emits updates', () {
        expect(result, emitsInOrder(<CharacteristicValue>[valueUpdate]));
      });
    });

    group('Read characteristic', () {
      QualifiedCharacteristic characteristic;
      pb.ReadCharacteristicRequest request;

      setUp(() {
        request = pb.ReadCharacteristicRequest();
        characteristic = QualifiedCharacteristic(
          characteristicId: Uuid.parse('FEFF'),
          serviceId: Uuid.parse('FEFF'),
          deviceId: '123',
        );
        when(_argsConverter.createReadCharacteristicRequest(any))
            .thenReturn(request);
      });

      test('It emits 1 item', () async {
        final length = await _sut.readCharacteristic(characteristic).length;
        expect(length, 1);
      });
    });

    group('Write characteristic with response', () {
      QualifiedCharacteristic characteristic;
      const value = [0, 1];
      pb.WriteCharacteristicRequest request;
      WriteCharacteristicInfo expectedResult;

      setUp(() async {
        request = pb.WriteCharacteristicRequest();

        characteristic = QualifiedCharacteristic(
          characteristicId: Uuid.parse('FEFF'),
          serviceId: Uuid.parse('FEFF'),
          deviceId: '123',
        );

        expectedResult = WriteCharacteristicInfo(
            characteristic: characteristic, result: const Result.success(null));

        when(_argsConverter.createWriteChacracteristicRequest(any, any))
            .thenReturn(request);
        when(_protobufConverter.writeCharacteristicInfoFrom(any))
            .thenReturn(expectedResult);
      });

      test('It returns correct value', () async {
        final result =
            await _sut.writeCharacteristicWithResponse(characteristic, value);

        expect(result, expectedResult);
      });
    });

    group('Write characteristic without response', () {
      QualifiedCharacteristic characteristic;
      const value = [0, 1];
      pb.WriteCharacteristicRequest request;
      WriteCharacteristicInfo expectedResult;

      setUp(() async {
        request = pb.WriteCharacteristicRequest();
        characteristic = QualifiedCharacteristic(
          characteristicId: Uuid.parse('FEFF'),
          serviceId: Uuid.parse('FEFF'),
          deviceId: '123',
        );

        expectedResult = WriteCharacteristicInfo(
            characteristic: characteristic, result: const Result.success(null));

        when(_argsConverter.createWriteChacracteristicRequest(any, any))
            .thenReturn(request);
        when(_protobufConverter.writeCharacteristicInfoFrom(any))
            .thenReturn(expectedResult);
      });

      test('It returns correct value', () async {
        final result = await _sut.writeCharacteristicWithoutResponse(
            characteristic, value);

        expect(result, expectedResult);
      });
    });

    group('Subscribe to notifications', () {
      QualifiedCharacteristic characteristic;
      pb.NotifyCharacteristicRequest request;

      setUp(() {
        request = pb.NotifyCharacteristicRequest();
        characteristic = QualifiedCharacteristic(
          characteristicId: Uuid.parse('FEFF'),
          serviceId: Uuid.parse('FEFF'),
          deviceId: '123',
        );

        when(_argsConverter.createNotifyCharacteristicRequest(any))
            .thenReturn(request);
      });

      test('It emits one item', () async {
        final length =
            await _sut.subscribeToNotifications(characteristic).length;
        expect(length, 1);
      });
    });

    group('Stop subscribe to notifications', () {
      QualifiedCharacteristic characteristic;
      pb.NotifyNoMoreCharacteristicRequest request;

      setUp(() async {
        request = pb.NotifyNoMoreCharacteristicRequest();
        characteristic = QualifiedCharacteristic(
          characteristicId: Uuid.parse('FEFF'),
          serviceId: Uuid.parse('FEFF'),
          deviceId: '123',
        );

        when(_argsConverter.createNotifyNoMoreCharacteristicRequest(any))
            .thenReturn(request);
      });

      test('It completes without error', () async {
        await _sut.stopSubscribingToNotifications(characteristic);
        expect(true, true);
      });
    });

    group('Request mtu size', () {
      const deviceId = '123';
      const mtuSize = 40;
      pb.NegotiateMtuRequest request;

      setUp(() {
        request = pb.NegotiateMtuRequest();
        when(_argsConverter.createNegotiateMtuRequest(any, any))
            .thenReturn(request);

        when(_protobufConverter.mtuSizeFrom(any)).thenReturn(mtuSize);
      });

      test('It returns requested mtu size', () async {
        expect(await _sut.requestMtuSize(deviceId, mtuSize), mtuSize);
      });
    });

    group('Request connection priority', () {
      const deviceId = '123';
      ConnectionPriority priority;
      pb.ChangeConnectionPriorityRequest request;
      ConnectionPriorityInfo info;

      setUp(() async {
        request = pb.ChangeConnectionPriorityRequest();
        priority = ConnectionPriority.highPerformance;
        info = const ConnectionPriorityInfo(result: Result.success(null));

        when(_argsConverter.createChangeConnectionPrioRequest(any, any))
            .thenReturn(request);

        when(_protobufConverter.connectionPriorityInfoFrom(any))
            .thenReturn(info);
      });

      test('It returns correct value', () async {
        expect(await _sut.requestConnectionPriority(deviceId, priority), info);
      });
    });

    group('Scan for devices', () {
      const scanMode = ScanMode.balanced;
      const locationEnabled = true;
      final withServices = [Uuid.parse('FEFF')];

      pb.ScanForDevicesRequest request;

      setUp(() {
        request = pb.ScanForDevicesRequest();
        when(_argsConverter.createScanForDevicesRequest(
          withServices: anyNamed('withServices'),
          scanMode: anyNamed('scanMode'),
          requireLocationServicesEnabled:
              anyNamed('requireLocationServicesEnabled'),
        )).thenReturn(request);
      });

      test('It emits 1 item', () async {
        final length = await _sut
            .scanForDevices(
              withServices: withServices,
              scanMode: scanMode,
              requireLocationServicesEnabled: locationEnabled,
            )
            .length;

        expect(length, 1);
      });
    });

    group('ScanFordevices stream', () {
      final device = DiscoveredDevice(
        id: '123',
        name: 'Testdevice',
        rssi: -40,
        serviceData: const {},
        manufacturerData: Uint8List.fromList([1]),
      );
      ScanResult scanResult;

      Stream<ScanResult> result;
      setUp(() {
        scanResult = ScanResult(result: Result.success(device));

        when(_protobufConverter.scanResultFrom(any)).thenReturn(scanResult);

        _scanStreamController.addStream(
          Stream<List<int>>.fromIterable([
            [1],
          ]),
        );
        result = _sut.scanStream;
      });

      test('It emits correct values', () {
        expect(result, emitsInOrder(<ScanResult>[scanResult]));
      });
    });

    group('initialize', () {
      test('It completes without error', () async {
        await _sut.initialize();
        expect(true, true);
      });
    });

    group('deInitialize', () {
      test('It completes without error', () async {
        await _sut.deinitialize();
        expect(true, true);
      });
    });

    group('Clear gatt cache', () {
      const deviceId = '123';

      pb.ClearGattCacheRequest request;
      Result<Unit, GenericFailure<ClearGattCacheError>> convertedResult;

      setUp(() {
        request = pb.ClearGattCacheRequest();
        convertedResult =
            const Result<Unit, GenericFailure<ClearGattCacheError>>.success(
                Unit());

        when(_argsConverter.createClearGattCacheRequest(any))
            .thenReturn(request);

        when(_protobufConverter.clearGattCacheResultFrom(any))
            .thenReturn(convertedResult);
      });

      test('It returns correct value', () async {
        final result = await _sut.clearGattCache(deviceId);
        expect(result, convertedResult);
      });
    });

    group('Ble status', () {
      const status1 = BleStatus.poweredOff;
      const status2 = BleStatus.ready;

      Stream<BleStatus> _bleStatusStream;

      setUp(() {
        _statusStreamController.addStream(
          Stream<List<int>>.fromIterable([
            [1],
            [0]
          ]),
        );

        when(_protobufConverter.bleStatusFrom([1])).thenReturn(status1);
        when(_protobufConverter.bleStatusFrom([0])).thenReturn(status2);

        _bleStatusStream = _sut.bleStatusStream;
      });

      test('It emits correct values', () {
        expect(_bleStatusStream, emitsInOrder(<BleStatus>[status1, status2]));
      });
    });

    group('Discover services', () {
      const deviceId = "testdevice";
      pb.DiscoverServicesRequest request;
      final services = [
        DiscoveredService(
          serviceId: Uuid([0x01, 0x02]),
          characteristicIds: const [],
          includedServices: const [],
        ),
      ];
      List<DiscoveredService> result;

      setUp(() async {
        request = pb.DiscoverServicesRequest();

        when(_argsConverter.createDiscoverServicesRequest(any))
            .thenReturn(request);
        when(_protobufConverter.discoveredServicesFrom(any))
            .thenReturn(services);

        result = await _sut.discoverServices(deviceId);
      });

      test('It returns discovered services', () {
        expect(result, services);
      });
    });
  });
}
