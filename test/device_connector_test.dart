import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/device_connector.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('$DeviceConnector', () {
    DeviceConnector _sut;
    _MethodChannelMock _methodChannel;
    Stream<ConnectionStateUpdate> _connectionStateUpdateStream;
    Stream<ConnectionStateUpdate> _result;

    const _deviceId = '123';

    setUp(() {
      _methodChannel = _MethodChannelMock();
    });

    group('Given connection update stream has updates for device', () {
      ConnectionStateUpdate updateForDevice;
      ConnectionStateUpdate updateOtherDevice;
      setUp(() {
        updateForDevice = const ConnectionStateUpdate(
          deviceId: _deviceId,
          connectionState: DeviceConnectionState.connecting,
          failure: null,
        );

        updateOtherDevice = const ConnectionStateUpdate(
          deviceId: '333',
          connectionState: DeviceConnectionState.connecting,
          failure: null,
        );

        _connectionStateUpdateStream = Stream.fromIterable([
          updateOtherDevice,
          updateForDevice,
        ]);
      });

      group('And invoking connect method succeeds', () {
        setUp(() async {
          when(_methodChannel.invokeMethod<void>('connectToDevice', any))
              .thenAnswer((_) => Future.value());
          _sut = DeviceConnector(
            bleMethodChannel: _methodChannel,
            connectionStateUpdateStream: _connectionStateUpdateStream,
          );
          _result = _sut.connect(
            _deviceId,
            {
              Uuid.parse('FEFE'): [Uuid.parse('FEFE')]
            },
            const Duration(seconds: 1),
          );
        });

        test('It emits connection updates for that device', () {
          expect(
              _result, emitsInOrder(<ConnectionStateUpdate>[updateForDevice]));
        });

        test('It invokes method connect device', () async {
          await _result.first;
          verify(_methodChannel.invokeMethod<void>('connectToDevice', any))
              .called(1);
        });

        test('It invokes method disconnect when stream is cancelled', () async {
          final subscription = _result.listen((event) {});

          await subscription.cancel();

          verify(_methodChannel.invokeMethod<void>('disconnectFromDevice', any))
              .called(1);
        });
      });
    });
  });
}

class _MethodChannelMock extends Mock implements MethodChannel {}
