import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reactive_ble_mobile/src/converter/args_to_protubuf_converter.dart';
import 'package:reactive_ble_mobile/src/converter/protobuf_converter.dart';
import 'package:reactive_ble_mobile/src/generated/bledata.pb.dart' as pb;
import 'package:reactive_ble_mobile/src/reactive_ble_mobile_platform.dart';
import 'package:reactive_ble_platform_interface/reactive_ble_platform_interface.dart';

import 'reactive_ble_platform_test.mocks.dart';
// ignore_for_file: avoid_implementing_value_types

@GenerateMocks([
  ArgsToProtobufConverter,
  ProtobufConverter,
  MethodChannel,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('$ReactiveBleMobilePlatform', () {
    late ReactiveBleMobilePlatform _sut;
    late MockMethodChannel _methodChannel;
    late ArgsToProtobufConverter _argsConverter;
    late ProtobufConverter _protobufConverter;
    late StreamController<List<int>> _connectedDeviceStreamController;
    late StreamController<List<int>> _argsStreamController;
    late StreamController<List<int>> _scanStreamController;
    late StreamController<List<int>> _statusStreamController;

    setUp(() {
      _argsConverter = MockArgsToProtobufConverter();
      _methodChannel = MockMethodChannel();
      _protobufConverter = MockProtobufConverter();
      _connectedDeviceStreamController = StreamController();
      _argsStreamController = StreamController();
      _scanStreamController = StreamController();
      _statusStreamController = StreamController();

      when(_methodChannel.invokeMethod<void>(any, any)).thenAnswer(
        (_) async => 0,
      );

      _sut = ReactiveBleMobilePlatform(
        argsToProtobufConverter: _argsConverter,
        bleMethodChannel: _methodChannel,
        protobufConverter: _protobufConverter,
        connectedDeviceChannel: _connectedDeviceStreamController.stream,
        charUpdateChannel: _argsStreamController.stream,
        bleDeviceScanChannel: _scanStreamController.stream,
        bleStatusChannel: _statusStreamController.stream,
      );
    });

    tearDown(() {
      _connectedDeviceStreamController.close();
      _argsStreamController.close();
      _scanStreamController.close();
      _statusStreamController.close();
    });

    group('connect to device', () {
      late pb.ConnectToDeviceRequest request;
      StreamSubscription? subscription;
      setUp(() {
        request = pb.ConnectToDeviceRequest();
        when(_argsConverter.createConnectToDeviceArgs('id', any, any))
            .thenReturn(request);
      });

      test(
        'It invokes methodchannel with correct method and arguments',
        () async {
          await _sut.connectToDevice('id', {}, null).first;
          verify(_methodChannel.invokeMethod<void>(
            'connectToDevice',
            request.writeToBuffer(),
          )).called(1);
        },
      );

      test('It emits 1 item', () async {
        final length = await _sut.connectToDevice('id', {}, null).length;
        expect(length, 1);
      });

      tearDown(() async {
        await subscription?.cancel();
      });
    });

    group('connect to device', () {
      late pb.DisconnectFromDeviceRequest request;
      setUp(() async {
        request = pb.DisconnectFromDeviceRequest();
        when(_argsConverter.createDisconnectDeviceArgs('id'))
            .thenReturn(request);
        await _sut.disconnectDevice('id');
      });

      test('It invokes methodchannel with correct method and arguments', () {
        verify(_methodChannel.invokeMethod<void>(
          'disconnectFromDevice',
          request.writeToBuffer(),
        )).called(1);
      });

      test('It executes the request succesfully', () async {
        expect(true, true);
      });
    });

    group('Connect to device stream', () {
      const update = ConnectionStateUpdate(
        deviceId: '123',
        connectionState: DeviceConnectionState.connecting,
        failure: null,
      );

      Stream<ConnectionStateUpdate>? result;

      setUp(() {
        _connectedDeviceStreamController.addStream(
          Stream.fromIterable([
            [1, 2, 3],
          ]),
        );

        when(
          _protobufConverter.connectionStateUpdateFrom([1, 2, 3]),
        ).thenReturn(update);
        result = _sut.connectionUpdateStream;
      });

      test('It emits correct value', () {
        expect(result, emitsInOrder(<ConnectionStateUpdate>[update]));
      });
    });

    group('Char update stream', () {
      late CharacteristicValue valueUpdate;
      late Stream<CharacteristicValue> result;

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

        when(_protobufConverter.characteristicValueFrom([0, 1]))
            .thenReturn(valueUpdate);

        result = _sut.charValueUpdateStream;
      });

      test('It emits updates', () {
        expect(result, emitsInOrder(<CharacteristicValue?>[valueUpdate]));
      });
    });

    group('Read characteristic', () {
      late QualifiedCharacteristic characteristic;
      late pb.ReadCharacteristicRequest request;

      setUp(() {
        request = pb.ReadCharacteristicRequest();
        characteristic = QualifiedCharacteristic(
          characteristicId: Uuid.parse('FEFF'),
          serviceId: Uuid.parse('FEFF'),
          deviceId: '123',
        );
        when(_argsConverter.createReadCharacteristicRequest(characteristic))
            .thenReturn(request);
      });

      test('It invokes method channel with correct arguments', () async {
        await _sut.readCharacteristic(characteristic).first;
        verify(
          _methodChannel.invokeMethod<void>(
            'readCharacteristic',
            request.writeToBuffer(),
          ),
        ).called(1);
      });

      test('It emits 1 item', () async {
        final length = await _sut.readCharacteristic(characteristic).length;
        expect(length, 1);
      });
    });

    group('Write characteristic with response', () {
      QualifiedCharacteristic characteristic;
      const value = [0, 1];
      late pb.WriteCharacteristicRequest request;
      late WriteCharacteristicInfo expectedResult;
      late WriteCharacteristicInfo result;

      setUp(() async {
        request = pb.WriteCharacteristicRequest();

        characteristic = QualifiedCharacteristic(
          characteristicId: Uuid.parse('FEFF'),
          serviceId: Uuid.parse('FEFF'),
          deviceId: '123',
        );

        expectedResult = WriteCharacteristicInfo(
          characteristic: characteristic,
          result: const Result.success(null),
        );

        when(_methodChannel.invokeMethod<List<int>?>(any, any)).thenAnswer(
          (_) async => [1],
        );
        when(
          _argsConverter.createWriteCharacteristicRequest(
            characteristic,
            [0, 1],
          ),
        ).thenReturn(request);

        when(_protobufConverter.writeCharacteristicInfoFrom([1]))
            .thenReturn(expectedResult);

        result = await _sut.writeCharacteristicWithResponse(
          characteristic,
          value,
        );
      });

      test('It invokes method channel with correct arguments', () {
        verify(_methodChannel.invokeMethod<List<int>?>(
                'writeCharacteristicWithResponse', request.writeToBuffer()))
            .called(1);
      });

      test('It returns correct value', () async {
        expect(result, expectedResult);
      });
    });

    group('Write characteristic without response', () {
      QualifiedCharacteristic characteristic;
      const value = [0, 1];
      late pb.WriteCharacteristicRequest request;
      late WriteCharacteristicInfo expectedResult;
      late WriteCharacteristicInfo result;

      setUp(() async {
        request = pb.WriteCharacteristicRequest();
        characteristic = QualifiedCharacteristic(
          characteristicId: Uuid.parse('FEFF'),
          serviceId: Uuid.parse('FEFF'),
          deviceId: '123',
        );

        expectedResult = WriteCharacteristicInfo(
            // ignore: void_checks
            characteristic: characteristic,
            // ignore: void_checks
            result: const Result.success(Unit()));

        when(_methodChannel.invokeMethod<List<int>?>(any, any)).thenAnswer(
          (_) async => value,
        );
        when(
          _argsConverter.createWriteCharacteristicRequest(
            characteristic,
            value,
          ),
        ).thenReturn(request);
        when(_protobufConverter.writeCharacteristicInfoFrom(value))
            .thenReturn(expectedResult);
        result = await _sut.writeCharacteristicWithoutResponse(
          characteristic,
          value,
        );
      });

      test('It returns correct value', () async {
        expect(result, expectedResult);
      });

      test('It invokes method channel with correct arguments', () {
        verify(
          _methodChannel.invokeMethod<void>(
            'writeCharacteristicWithoutResponse',
            request.writeToBuffer(),
          ),
        ).called(1);
      });
    });

    group('Subscribe to notifications', () {
      late QualifiedCharacteristic characteristic;
      late pb.NotifyCharacteristicRequest request;

      setUp(() {
        request = pb.NotifyCharacteristicRequest();
        characteristic = QualifiedCharacteristic(
          characteristicId: Uuid.parse('FEFF'),
          serviceId: Uuid.parse('FEFF'),
          deviceId: '123',
        );

        when(
          _argsConverter.createNotifyCharacteristicRequest(characteristic),
        ).thenReturn(request);
      });

      test('It emits one item', () async {
        final length = await _sut
            .subscribeToNotifications(
              characteristic,
            )
            .length;
        expect(length, 1);
      });

      test('It invokes method channel with correct arguments', () async {
        await _sut.subscribeToNotifications(characteristic).first;
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
      late pb.NotifyNoMoreCharacteristicRequest request;

      setUp(() async {
        request = pb.NotifyNoMoreCharacteristicRequest();
        characteristic = QualifiedCharacteristic(
          characteristicId: Uuid.parse('FEFF'),
          serviceId: Uuid.parse('FEFF'),
          deviceId: '123',
        );

        when(
          _argsConverter.createNotifyNoMoreCharacteristicRequest(
            characteristic,
          ),
        ).thenReturn(request);
        await _sut.stopSubscribingToNotifications(characteristic);
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
      late pb.NegotiateMtuRequest request;
      int? result;

      setUp(() async {
        request = pb.NegotiateMtuRequest();
        when(_argsConverter.createNegotiateMtuRequest(deviceId, mtuSize))
            .thenReturn(request);
        when(_methodChannel.invokeMethod<List<int>>(any, any)).thenAnswer(
          (_) async => [1],
        );

        when(_protobufConverter.mtuSizeFrom([1])).thenReturn(mtuSize);
        result = await _sut.requestMtuSize(deviceId, mtuSize);
      });

      test('It returns requested mtu size', () async {
        expect(result, mtuSize);
      });

      test('It invokes method channel with correct arguments', () {
        verify(
          _methodChannel.invokeMethod<List<int>>(
            'negotiateMtuSize',
            request.writeToBuffer(),
          ),
        ).called(1);
      });
    });

    group('Request connection priority', () {
      const deviceId = '123';
      ConnectionPriority priority;
      late pb.ChangeConnectionPriorityRequest request;
      late ConnectionPriorityInfo info;
      late ConnectionPriorityInfo result;

      setUp(() async {
        request = pb.ChangeConnectionPriorityRequest();
        priority = ConnectionPriority.highPerformance;
        info = const ConnectionPriorityInfo(result: Result.success(null));
        when(_methodChannel.invokeMethod<List<int>>(any, any)).thenAnswer(
          (_) async => [1],
        );
        when(
          _argsConverter.createChangeConnectionPrioRequest(
            deviceId,
            priority,
          ),
        ).thenReturn(request);

        when(_protobufConverter.connectionPriorityInfoFrom([1]))
            .thenReturn(info);
        result = await _sut.requestConnectionPriority(deviceId, priority);
      });

      test('It returns correct value', () async {
        expect(result, info);
      });

      test('It invokes method channel with correct arguments', () {
        verify(
          _methodChannel.invokeMethod<List<int>>(
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

      late pb.ScanForDevicesRequest request;

      setUp(() {
        request = pb.ScanForDevicesRequest();
        when(_argsConverter.createScanForDevicesRequest(
          withServices: withServices,
          scanMode: scanMode,
          requireLocationServicesEnabled: locationEnabled,
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

      test('It invokes correct method', () async {
        await _sut
            .scanForDevices(
              withServices: withServices,
              scanMode: scanMode,
              requireLocationServicesEnabled: locationEnabled,
            )
            .first;
        verify(_methodChannel.invokeMethod<void>(
          'scanForDevices',
          request.writeToBuffer(),
        )).called(1);
      });
    });

    group('ScanFordevices stream', () {
      final device = DiscoveredDevice(
        id: '123',
        name: 'Testdevice',
        rssi: -40,
        serviceData: const {},
        serviceUuids: const [],
        manufacturerData: Uint8List.fromList([1]),
      );
      late ScanResult scanResult;

      Stream<ScanResult>? result;
      setUp(() {
        scanResult = ScanResult(result: Result.success(device));

        when(_protobufConverter.scanResultFrom([1])).thenReturn(scanResult);

        _scanStreamController.addStream(
          Stream<List<int>>.fromIterable([
            [1],
          ]),
        );
        result = _sut.scanStream;
      });

      test('It emits correct values', () {
        expect(result, emitsInOrder(<ScanResult?>[scanResult]));
      });
    });

    group('initialize', () {
      setUp(() async {
        await _sut.initialize();
      });
      test('It invokes correct method in method channel', () {
        verify(_methodChannel.invokeMethod<void>('initialize')).called(1);
        expect(true, true);
      });
    });

    group('deInitialize', () {
      setUp(() async {
        await _sut.deinitialize();
      });
      test('It invokes correct method in method channel', () {
        verify(_methodChannel.invokeMethod<void>('deinitialize')).called(1);
      });
    });

    group('Clear gatt cache', () {
      const deviceId = '123';

      late pb.ClearGattCacheRequest request;
      Result<Unit, GenericFailure<ClearGattCacheError>?>? result;

      late Result<Unit, GenericFailure<ClearGattCacheError>> convertedResult;

      setUp(() async {
        request = pb.ClearGattCacheRequest();
        convertedResult =
            const Result<Unit, GenericFailure<ClearGattCacheError>>.success(
          Unit(),
        );
        when(_methodChannel.invokeMethod<List<int>>(any, any)).thenAnswer(
          (_) async => [1],
        );

        when(_argsConverter.createClearGattCacheRequest(deviceId))
            .thenReturn(request);

        when(_protobufConverter.clearGattCacheResultFrom([1]))
            .thenReturn(convertedResult);
        result = await _sut.clearGattCache(deviceId);
      });

      test('It calls method channel with correct arguments', () {
        verify(_methodChannel.invokeMethod<List<int>>(
          'clearGattCache',
          request.writeToBuffer(),
        )).called(1);
      });

      test('It returns correct value', () async {
        expect(result, convertedResult);
      });
    });

    group('Ble status', () {
      const status1 = BleStatus.poweredOff;
      const status2 = BleStatus.ready;

      Stream<BleStatus>? _bleStatusStream;

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
      late pb.DiscoverServicesRequest request;
      final services = [
        DiscoveredService(
          serviceId: Uuid([0x01, 0x02]),
          characteristicIds: const [],
          characteristics: const [],
          includedServices: const [],
        ),
      ];
      List<DiscoveredService>? result;

      setUp(() async {
        request = pb.DiscoverServicesRequest();

        when(_methodChannel.invokeMethod<List<int>>(any, any)).thenAnswer(
          (_) async => [1],
        );
        when(_argsConverter.createDiscoverServicesRequest(deviceId))
            .thenReturn(request);
        when(_protobufConverter.discoveredServicesFrom([1]))
            .thenReturn(services);

        result = await _sut.discoverServices(deviceId);
      });

      test('It returns discovered services', () {
        expect(result, services);
      });

      test('It invokes methodchannel with correct arguments', () {
        verify(
          _methodChannel.invokeMethod<List<int>>(
            'discoverServices',
            request.writeToBuffer(),
          ),
        ).called(1);
      });
    });
  });
}
