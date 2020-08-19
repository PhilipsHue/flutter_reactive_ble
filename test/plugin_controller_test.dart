import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/converter/args_to_protubuf_converter.dart';
import 'package:flutter_reactive_ble/src/converter/protobuf_converter.dart';
import 'package:flutter_reactive_ble/src/debug_logger.dart';
import 'package:flutter_reactive_ble/src/generated/bledata.pbserver.dart' as pb;
import 'package:flutter_reactive_ble/src/model/clear_gatt_cache_error.dart';
import 'package:flutter_reactive_ble/src/model/discovered_services.dart';
import 'package:flutter_reactive_ble/src/model/unit.dart';
import 'package:flutter_reactive_ble/src/plugin_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('$PluginController', () {
    PluginController _sut;
    _MethodChannelMock _methodChannel;
    _ArgsToProtobufConverterMock _argsConverter;
    ProtobufConverter _protobufConverter;
    _EventChannelMock _connectedDeviceChannel;
    _EventChannelMock _argsChannel;
    _EventChannelMock _scanChannel;
    _EventChannelMock _statusChannel;

    setUp(() {
      _argsConverter = _ArgsToProtobufConverterMock();
      _methodChannel = _MethodChannelMock();
      _protobufConverter = _ProtobufConverterMock();
      _connectedDeviceChannel = _EventChannelMock();
      _argsChannel = _EventChannelMock();
      _scanChannel = _EventChannelMock();
      _statusChannel = _EventChannelMock();

      _sut = PluginController(
        argsToProtobufConverter: _argsConverter,
        bleMethodChannel: _methodChannel,
        protobufConverter: _protobufConverter,
        connectedDeviceChannel: _connectedDeviceChannel,
        charUpdateChannel: _argsChannel,
        bleDeviceScanChannel: _scanChannel,
        bleStatusChannel: _statusChannel,
        debugLogger: _DebugLoggerMock(),
      );
    });

    group('connect to device', () {
      pb.ConnectToDeviceRequest request;
      StreamSubscription subscription;
      setUp(() {
        request = pb.ConnectToDeviceRequest();
        when(_argsConverter.createConnectToDeviceArgs(any, any, any))
            .thenReturn(request);
        when(_methodChannel.invokeMethod<void>(any, any)).thenAnswer(
          (_) => Future<void>.value(),
        );

        subscription = _sut.connectToDevice('id', {}, null).listen((event) {});
      });

      test('It invokes methodchannel with correct method and arguments', () {
        verify(_methodChannel.invokeMethod<void>(
                'connectToDevice', request.writeToBuffer()))
            .called(1);
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
        when(_methodChannel.invokeMethod<void>(any, any)).thenAnswer(
          (_) => Future<void>.value(),
        );

        await _sut.disconnectDevice('id');
      });

      test('It invokes methodchannel with correct method and arguments', () {
        verify(_methodChannel.invokeMethod<void>(
          'disconnectFromDevice',
          request.writeToBuffer(),
        )).called(1);
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
        when(_connectedDeviceChannel.receiveBroadcastStream()).thenAnswer(
          (_) => Stream<dynamic>.fromIterable(<dynamic>[
            [1, 2, 3],
          ]),
        );

        when(_protobufConverter.connectionStateUpdateFrom(any))
            .thenReturn(update);
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

        when(_argsChannel.receiveBroadcastStream()).thenAnswer(
          (realInvocation) => Stream<List<int>>.fromIterable([
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

      setUp(() async {
        request = pb.ReadCharacteristicRequest();
        characteristic = QualifiedCharacteristic(
          characteristicId: Uuid.parse('FEFF'),
          serviceId: Uuid.parse('FEFF'),
          deviceId: '123',
        );

        when(_argsConverter.createReadCharacteristicRequest(any))
            .thenReturn(request);
        when(_methodChannel.invokeMethod<void>('readCharacteristic', any))
            .thenAnswer((_) => Future.value());

        _sut.readCharacteristic(characteristic);
      });

      test('It calls args to protobuf converter with correct arguments', () {
        verify(_argsConverter.createReadCharacteristicRequest(characteristic))
            .called(1);
      });

      test('It invokes method channel with correct arguments', () {
        verify(_methodChannel.invokeMethod<void>(
                'readCharacteristic', request.writeToBuffer()))
            .called(1);
      });
    });

    group('Write characteristic with response', () {
      QualifiedCharacteristic characteristic;
      const value = [0, 1];
      pb.WriteCharacteristicRequest request;

      setUp(() async {
        request = pb.WriteCharacteristicRequest();
        characteristic = QualifiedCharacteristic(
          characteristicId: Uuid.parse('FEFF'),
          serviceId: Uuid.parse('FEFF'),
          deviceId: '123',
        );

        when(_argsConverter.createWriteChacracteristicRequest(any, any))
            .thenReturn(request);
        when(_methodChannel.invokeMethod<List<int>>(
                'writeCharacteristicWithResponse', any))
            .thenAnswer((_) => Future.value(const [1, 0]));

        await _sut.writeCharacteristicWithResponse(characteristic, value);
      });

      test('It calls args to protobuf converter with correct arguments', () {
        verify(_argsConverter.createWriteChacracteristicRequest(
                characteristic, value))
            .called(1);
      });

      test('It invokes method channel with correct arguments', () {
        verify(_methodChannel.invokeMethod<void>(
                'writeCharacteristicWithResponse', request.writeToBuffer()))
            .called(1);
      });
    });

    group('Write characteristic without response', () {
      QualifiedCharacteristic characteristic;
      const value = [0, 1];
      pb.WriteCharacteristicRequest request;

      setUp(() async {
        request = pb.WriteCharacteristicRequest();
        characteristic = QualifiedCharacteristic(
          characteristicId: Uuid.parse('FEFF'),
          serviceId: Uuid.parse('FEFF'),
          deviceId: '123',
        );

        when(_argsConverter.createWriteChacracteristicRequest(any, any))
            .thenReturn(request);
        when(_methodChannel.invokeMethod<List<int>>(
                'writeCharacteristicWithoutResponse', any))
            .thenAnswer((_) => Future.value(const [1, 0]));

        await _sut.writeCharacteristicWithoutResponse(characteristic, value);
      });

      test('It calls args to protobuf converter with correct arguments', () {
        verify(_argsConverter.createWriteChacracteristicRequest(
                characteristic, value))
            .called(1);
      });

      test('It invokes method channel with correct arguments', () {
        verify(_methodChannel.invokeMethod<void>(
                'writeCharacteristicWithoutResponse', request.writeToBuffer()))
            .called(1);
      });
    });

    group('Subscribe to notifications', () {
      QualifiedCharacteristic characteristic;
      pb.NotifyCharacteristicRequest request;

      setUp(() async {
        request = pb.NotifyCharacteristicRequest();
        characteristic = QualifiedCharacteristic(
          characteristicId: Uuid.parse('FEFF'),
          serviceId: Uuid.parse('FEFF'),
          deviceId: '123',
        );

        when(_argsConverter.createNotifyCharacteristicRequest(any))
            .thenReturn(request);
        when(
          _methodChannel.invokeMethod<void>('readNotifications', any),
        ).thenAnswer((_) => Future.value());

        _sut.subscribeToNotifications(characteristic);
      });

      test('It calls args to protobuf converter with correct arguments', () {
        verify(_argsConverter.createNotifyCharacteristicRequest(characteristic))
            .called(1);
      });

      test('It invokes method channel with correct arguments', () {
        verify(
          _methodChannel.invokeMethod<void>(
            'readNotifications',
            request.writeToBuffer(),
          ),
        ).called(1);
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
        when(
          _methodChannel.invokeMethod<void>('stopNotifications', any),
        ).thenAnswer((_) => Future.value());

        await _sut.stopSubscribingToNotifications(characteristic);
      });

      test('It calls args to protobuf converter with correct arguments', () {
        verify(_argsConverter
                .createNotifyNoMoreCharacteristicRequest(characteristic))
            .called(1);
      });

      test('It invokes method channel with correct arguments', () {
        verify(
          _methodChannel.invokeMethod<void>(
            'stopNotifications',
            request.writeToBuffer(),
          ),
        ).called(1);
      });
    });
    group('Request mtu size', () {
      const deviceId = '123';
      const mtuSize = 40;
      pb.NegotiateMtuRequest request;

      setUp(() async {
        request = pb.NegotiateMtuRequest();

        when(_argsConverter.createNegotiateMtuRequest(any, any))
            .thenReturn(request);
        when(
          _methodChannel.invokeMethod<List<int>>('negotiateMtuSize', any),
        ).thenAnswer((_) => Future.value([1]));

        await _sut.requestMtuSize(deviceId, mtuSize);
      });

      test('It calls args to protobuf converter with correct arguments', () {
        verify(_argsConverter.createNegotiateMtuRequest(deviceId, mtuSize))
            .called(1);
      });

      test('It calls protobuf converter wit correct arguments', () {
        verify(_protobufConverter.mtuSizeFrom([1])).called(1);
      });

      test('It invokes method channel with correct arguments', () {
        verify(
          _methodChannel.invokeMethod<void>(
            'negotiateMtuSize',
            request.writeToBuffer(),
          ),
        ).called(1);
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
        when(
          _methodChannel.invokeMethod<List<int>>(
              'requestConnectionPriority', any),
        ).thenAnswer((_) => Future.value([1]));

        await _sut.requestConnectionPriority(deviceId, priority);
      });

      test('It calls args to protobuf converter with correct arguments', () {
        verify(_argsConverter.createChangeConnectionPrioRequest(
                deviceId, priority))
            .called(1);
      });

      test('It calls protobuf converter wit correct arguments', () {
        verify(_protobufConverter.connectionPriorityInfoFrom([1])).called(1);
      });

      test('It invokes method channel with correct arguments', () {
        verify(
          _methodChannel.invokeMethod<void>(
            'requestConnectionPriority',
            request.writeToBuffer(),
          ),
        ).called(1);
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

        when(
          _methodChannel.invokeMethod<void>('scanForDevices', any),
        ).thenAnswer(
          (_) => Future.value(),
        );

        _sut.scanForDevices(
          withServices: withServices,
          scanMode: scanMode,
          requireLocationServicesEnabled: locationEnabled,
        );
      });

      test('It invokes correct method', () {
        verify(_methodChannel.invokeMethod<void>(
          'scanForDevices',
          request.writeToBuffer(),
        )).called(1);
      });

      test('It invokes argconverter with correct arguments', () {
        verify(_argsConverter.createScanForDevicesRequest(
          withServices: withServices,
          scanMode: scanMode,
          requireLocationServicesEnabled: locationEnabled,
        )).called(1);
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
        when(_scanChannel.receiveBroadcastStream())
            .thenAnswer((_) => Stream<List<int>>.fromIterable([
                  [1]
                ]));
        result = _sut.scanStream;
      });

      test('It calls protobufconverter with correct arguments', () async {
        await result.first;
        verify(_protobufConverter.scanResultFrom([1])).called(1);
      });

      test('It emits correct values', () {
        expect(result, emitsInOrder(<ScanResult>[scanResult]));
      });
    });

    group('initialize', () {
      setUp(() async {
        when(_methodChannel.invokeMethod<void>('initialize')).thenAnswer(
          (realInvocation) => Future.value(),
        );

        await _sut.initialize();
      });

      test('It invokes correct method in method channel', () {
        verify(_methodChannel.invokeMethod<void>('initialize')).called(1);
      });
    });

    group('deInitialize', () {
      setUp(() async {
        when(_methodChannel.invokeMethod<void>('deinitialize')).thenAnswer(
          (realInvocation) => Future.value(),
        );

        await _sut.deInitialize();
      });

      test('It invokes correct method in method channel', () {
        verify(_methodChannel.invokeMethod<void>('deinitialize')).called(1);
      });
    });

    group('Clear gatt cache', () {
      const deviceId = '123';

      pb.ClearGattCacheRequest request;
      Result<Unit, GenericFailure<ClearGattCacheError>> result;
      Result<Unit, GenericFailure<ClearGattCacheError>> convertedResult;

      setUp(() async {
        request = pb.ClearGattCacheRequest();
        convertedResult =
            const Result<Unit, GenericFailure<ClearGattCacheError>>.success(
                Unit());
        when(_methodChannel.invokeMethod<List<int>>('clearGattCache', any))
            .thenAnswer(
          (realInvocation) => Future.value([1]),
        );
        when(_argsConverter.createClearGattCacheRequest(any))
            .thenReturn(request);
        when(_protobufConverter.clearGattCacheResultFrom(any))
            .thenReturn(convertedResult);
        result = await _sut.clearGattCache(deviceId);
      });

      test('It calls method channel with correct arguments', () {
        verify(_methodChannel.invokeMethod<List<int>>(
          'clearGattCache',
          request.writeToBuffer(),
        )).called(1);
      });

      test('It calls args to protobufconverter with correct arguments', () {
        verify(_argsConverter.createClearGattCacheRequest(deviceId)).called(1);
      });

      test('It calls protobuf converter with correct arguments', () {
        verify(_protobufConverter.clearGattCacheResultFrom([1])).called(1);
      });

      test('It returns correct value', () {
        expect(result, convertedResult);
      });
    });

    group('Ble status', () {
      const status1 = BleStatus.poweredOff;
      const status2 = BleStatus.ready;

      Stream<BleStatus> _bleStatusStream;

      setUp(() {
        when(_statusChannel.receiveBroadcastStream()).thenAnswer(
          (_) => Stream<List<int>>.fromIterable([
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

      DiscoverServicesInfo result;

      setUp(() async {
        request = pb.DiscoverServicesRequest();
        when(_methodChannel.invokeMethod<List<int>>('discoverServices', any))
            .thenAnswer((_) => Future.value([1]));
        when(_argsConverter.createDiscoverServicesRequest(deviceId))
            .thenReturn(request);
        when(_protobufConverter.discoveredServicesFrom(any)).thenReturn(
            const DiscoverServicesInfo(
                deviceId: deviceId, result: Result.success([])));
        result = await _sut.discoverServices(deviceId);
      });

      test('It calls args to protobuf converted with correct arguments', () {
        verify(_argsConverter.createDiscoverServicesRequest(deviceId))
            .called(1);
      });

      test('It invokes methodchannel with correct arguments', () {
        verify(_methodChannel.invokeMethod<List<int>>(
                'discoverServices', request.writeToBuffer()))
            .called(1);
      });

      test('It invokes protobuf converter with correct arguments', () {
        verify(_protobufConverter.discoveredServicesFrom([1])).called(1);
      });

      test('It returns discoverservices info as result', () {
        expect(result.deviceId, deviceId);
      });
    });
  });
}

class _MethodChannelMock extends Mock implements MethodChannel {}

class _EventChannelMock extends Mock implements EventChannel {}

class _ArgsToProtobufConverterMock extends Mock
    implements ArgsToProtobufConverter {}

class _ProtobufConverterMock extends Mock implements ProtobufConverter {}

class _DebugLoggerMock extends Mock implements DebugLogger {}
