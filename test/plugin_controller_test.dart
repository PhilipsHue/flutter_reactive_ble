import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/converter/args_to_protubuf_converter.dart';
import 'package:flutter_reactive_ble/src/converter/protobuf_converter.dart';
import 'package:flutter_reactive_ble/src/debug_logger.dart';
import 'package:flutter_reactive_ble/src/generated/bledata.pbserver.dart' as pb;
import 'package:flutter_reactive_ble/src/model/clear_gatt_cache_error.dart';
import 'package:flutter_reactive_ble/src/model/discovered_service.dart';
import 'package:flutter_reactive_ble/src/model/unit.dart';
import 'package:flutter_reactive_ble/src/model/write_characteristic_info.dart';
import 'package:flutter_reactive_ble/src/plugin_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('$PluginController', () {
    PluginController _sut;
    MethodChannel _methodChannel;
    _ArgsToProtobufConverterStub _argsConverter;
    _ProtobufConverterStub _protobufConverter;
    StreamController<List<int>> _connectedDeviceStreamController;
    StreamController<List<int>> _argsStreamController;
    StreamController<List<int>> _scanStreamController;
    StreamController<List<int>> _statusStreamController;

    setUp(() {
      _argsConverter = _ArgsToProtobufConverterStub();
      _methodChannel = const MethodChannel('test');
      _protobufConverter = _ProtobufConverterStub();
      _connectedDeviceStreamController = StreamController();
      _argsStreamController = StreamController();
      _scanStreamController = StreamController();
      _statusStreamController = StreamController();

      _methodChannel.setMockMethodCallHandler((call) async {});

      _sut = PluginController(
        argsToProtobufConverter: _argsConverter,
        bleMethodChannel: _methodChannel,
        protobufConverter: _protobufConverter,
        connectedDeviceChannel: _connectedDeviceStreamController.stream,
        charUpdateChannel: _argsStreamController.stream,
        bleDeviceScanChannel: _scanStreamController.stream,
        bleStatusChannel: _statusStreamController.stream,
        debugLogger: _LoggerStub(),
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
        _argsConverter.connectToDeviceRequestStub = request;
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
        _argsConverter.disconnectDeviceRequestStub = request;
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

        _protobufConverter.connectionstateUpdateStub = update;
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

        _protobufConverter.charValueStub = valueUpdate;

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

        _argsConverter.readCharRequestStub = request;
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

        _argsConverter.writeCharRequestStub = request;
        _protobufConverter.writeCharacteristicInfo = expectedResult;
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

        _argsConverter.writeCharRequestStub = request;
        _protobufConverter.writeCharacteristicInfo = expectedResult;
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

        _argsConverter.notifyCharRequestStub = request;
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

        _argsConverter.notifyNoMoreCharRequestStub = request;
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
        _argsConverter.mtuRequestStub = request;
        _protobufConverter.mtuSizeStub = mtuSize;
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

        _argsConverter.connectionPrioRequestStub = request;
        _protobufConverter.connectionPriorityInfoStub = info;
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
        _argsConverter.scanForDevicesRequestStub = request;
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

        _protobufConverter.scanResultStub = scanResult;

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

        _argsConverter.clearGattCacheRequestStub = request;

        _protobufConverter.clearGattCacheStub = convertedResult;
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

        _argsConverter.discoverServicesRequestStub = request;
        _protobufConverter.discoveredServiceStub = services;
        result = await _sut.discoverServices(deviceId);
      });

      test('It returns discovered services', () {
        expect(result, services);
      });
    });
  });
}

class _ArgsToProtobufConverterStub implements ArgsToProtobufConverter {
  @override
  pb.ChangeConnectionPriorityRequest createChangeConnectionPrioRequest(
          String deviceId, ConnectionPriority priority) =>
      _connectionPrioRequest;

  @override
  pb.ClearGattCacheRequest createClearGattCacheRequest(String deviceId) =>
      _clearGattCacheRequest;

  @override
  pb.ConnectToDeviceRequest createConnectToDeviceArgs(
          String id,
          Map<Uuid, List<Uuid>> servicesWithCharacteristicsToDiscover,
          Duration connectionTimeout) =>
      _connectToDeviceRequest;

  @override
  pb.DisconnectFromDeviceRequest createDisconnectDeviceArgs(String deviceId) =>
      _disconnectDeviceRequest;

  @override
  pb.DiscoverServicesRequest createDiscoverServicesRequest(String deviceId) =>
      _discoverServicesRequest;

  @override
  pb.NegotiateMtuRequest createNegotiateMtuRequest(String deviceId, int mtu) =>
      _negotiateMtuRequest;

  @override
  pb.NotifyCharacteristicRequest createNotifyCharacteristicRequest(
          QualifiedCharacteristic characteristic) =>
      _notifyCharRequest;

  @override
  pb.NotifyNoMoreCharacteristicRequest createNotifyNoMoreCharacteristicRequest(
          QualifiedCharacteristic characteristic) =>
      _notifyNoMoreCharRequest;

  @override
  pb.ReadCharacteristicRequest createReadCharacteristicRequest(
          QualifiedCharacteristic characteristic) =>
      _readCharRequest;

  @override
  pb.ScanForDevicesRequest createScanForDevicesRequest(
          {List<Uuid> withServices,
          ScanMode scanMode,
          bool requireLocationServicesEnabled}) =>
      _scanForDevicesRequest;

  @override
  pb.WriteCharacteristicRequest createWriteChacracteristicRequest(
          QualifiedCharacteristic characteristic, List<int> value) =>
      _writeCharRequest;

  pb.ConnectToDeviceRequest _connectToDeviceRequest;
  pb.DisconnectFromDeviceRequest _disconnectDeviceRequest;
  pb.ReadCharacteristicRequest _readCharRequest;
  pb.WriteCharacteristicRequest _writeCharRequest;
  pb.NotifyCharacteristicRequest _notifyCharRequest;
  pb.NotifyNoMoreCharacteristicRequest _notifyNoMoreCharRequest;
  pb.DiscoverServicesRequest _discoverServicesRequest;
  pb.ScanForDevicesRequest _scanForDevicesRequest;
  pb.ChangeConnectionPriorityRequest _connectionPrioRequest;
  pb.ClearGattCacheRequest _clearGattCacheRequest;
  pb.NegotiateMtuRequest _negotiateMtuRequest;

  set connectToDeviceRequestStub(pb.ConnectToDeviceRequest request) =>
      _connectToDeviceRequest = request;

  set disconnectDeviceRequestStub(pb.DisconnectFromDeviceRequest request) =>
      _disconnectDeviceRequest = request;

  set readCharRequestStub(pb.ReadCharacteristicRequest request) =>
      _readCharRequest = request;

  set writeCharRequestStub(pb.WriteCharacteristicRequest request) =>
      _writeCharRequest = request;

  set notifyCharRequestStub(pb.NotifyCharacteristicRequest request) =>
      _notifyCharRequest = request;

  set notifyNoMoreCharRequestStub(
          pb.NotifyNoMoreCharacteristicRequest request) =>
      _notifyNoMoreCharRequest = request;

  set discoverServicesRequestStub(pb.DiscoverServicesRequest request) =>
      _discoverServicesRequest = request;

  set scanForDevicesRequestStub(pb.ScanForDevicesRequest request) =>
      _scanForDevicesRequest = request;

  set connectionPrioRequestStub(pb.ChangeConnectionPriorityRequest request) =>
      _connectionPrioRequest = request;

  set clearGattCacheRequestStub(pb.ClearGattCacheRequest request) =>
      _clearGattCacheRequest = request;

  set mtuRequestStub(pb.NegotiateMtuRequest request) =>
      _negotiateMtuRequest = request;
}

class _ProtobufConverterStub implements ProtobufConverter {
  @override
  BleStatus bleStatusFrom(List<int> data) {
    if (data.first == 0) {
      return BleStatus.ready;
    } else {
      return BleStatus.poweredOff;
    }
  }

  @override
  CharacteristicValue characteristicValueFrom(List<int> data) =>
      _characteristicValue;

  @override
  Result<Unit, GenericFailure<ClearGattCacheError>> clearGattCacheResultFrom(
          List<int> data) =>
      _clearGattCacheResult;

  @override
  ConnectionPriorityInfo connectionPriorityInfoFrom(List<int> data) =>
      _connectionPriorityInfo;

  @override
  ConnectionStateUpdate connectionStateUpdateFrom(List<int> data) =>
      _connectionStateUpdate;

  @override
  List<DiscoveredService> discoveredServicesFrom(List<int> data) =>
      _discoveredServices;

  @override
  int mtuSizeFrom(List<int> data) => _mtuSize;

  @override
  ScanResult scanResultFrom(List<int> data) => _scanResult;

  @override
  WriteCharacteristicInfo writeCharacteristicInfoFrom(List<int> data) =>
      _writeCharacteristicInfo;

  CharacteristicValue _characteristicValue;
  ConnectionPriorityInfo _connectionPriorityInfo;
  ScanResult _scanResult;
  Result<Unit, GenericFailure<ClearGattCacheError>> _clearGattCacheResult;
  List<DiscoveredService> _discoveredServices;
  int _mtuSize;
  WriteCharacteristicInfo _writeCharacteristicInfo;
  ConnectionStateUpdate _connectionStateUpdate;

  set charValueStub(CharacteristicValue charValue) =>
      _characteristicValue = charValue;

  set connectionPriorityInfoStub(
          ConnectionPriorityInfo connectionPriorityInfo) =>
      _connectionPriorityInfo = connectionPriorityInfo;

  set scanResultStub(ScanResult scanResult) => _scanResult = scanResult;

  set discoveredServiceStub(List<DiscoveredService> discoveredServices) =>
      _discoveredServices = discoveredServices;

  set clearGattCacheStub(
          Result<Unit, GenericFailure<ClearGattCacheError>>
              clearGattCacheResult) =>
      _clearGattCacheResult = clearGattCacheResult;

  set mtuSizeStub(int mtuSize) => _mtuSize = mtuSize;

  set writeCharacteristicInfo(WriteCharacteristicInfo charInfo) =>
      _writeCharacteristicInfo = charInfo;

  set connectionstateUpdateStub(ConnectionStateUpdate stateUpdate) =>
      _connectionStateUpdate = stateUpdate;
}

class _LoggerStub implements Logger {
  @override
  void log(Object message) {
    // do nothing
  }

  @override
  set logLevel(LogLevel logLevel) {
    // do nothing
  }
}
