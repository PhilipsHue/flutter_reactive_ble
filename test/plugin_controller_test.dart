import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/converter/args_to_protubuf_converter.dart';
import 'package:flutter_reactive_ble/src/converter/protobuf_converter.dart';
import 'package:flutter_reactive_ble/src/generated/bledata.pbserver.dart' as pb;
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

    setUp(() {
      _argsConverter = _ArgsToProtobufConverterMock();
      _methodChannel = _MethodChannelMock();
      _protobufConverter = _ProtobufConverterMock();
      _connectedDeviceChannel = _EventChannelMock();
      _argsChannel = _EventChannelMock();
      _sut = PluginController(
        argsToProtobufConverter: _argsConverter,
        bleMethodChannel: _methodChannel,
        protobufConverter: _protobufConverter,
        connectedDeviceChannel: _connectedDeviceChannel,
        charUpdateChannel: _argsChannel,
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

        when(_sut.charUpdateChannel.receiveBroadcastStream()).thenAnswer(
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
  });
}

class _MethodChannelMock extends Mock implements MethodChannel {}

class _EventChannelMock extends Mock implements EventChannel {}

class _ArgsToProtobufConverterMock extends Mock
    implements ArgsToProtobufConverter {}

class _ProtobufConverterMock extends Mock implements ProtobufConverter {}
