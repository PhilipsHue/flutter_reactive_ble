import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/src/converter/args_to_protubuf_converter.dart';
import 'package:flutter_reactive_ble/src/generated/bledata.pbserver.dart' as pb;
import 'package:flutter_reactive_ble/src/plugin_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('$PluginController', () {
    PluginController _sut;
    _MethodChannelMock _methodChannel;
    _Converter _converter;

    setUp(() {
      _converter = _Converter();
      _methodChannel = _MethodChannelMock();
      _sut = PluginController(
          argsToProtobufConverter: _converter,
          bleMethodChannel: _methodChannel);
    });

    group('connect to device', () {
      pb.ConnectToDeviceRequest request;
      StreamSubscription subscription;
      setUp(() {
        request = pb.ConnectToDeviceRequest();
        when(_converter.createConnectToDeviceArgs(any, any, any))
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
        when(_converter.createDisconnectDeviceArgs(any)).thenReturn(request);
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
  });
}

class _MethodChannelMock extends Mock implements MethodChannel {}

class _Converter extends Mock implements ArgsToProtobufConverter {}
