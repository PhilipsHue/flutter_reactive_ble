import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/device_connector.dart';
import 'package:flutter_reactive_ble/src/plugin_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('$DeviceConnector', () {
    DeviceConnector _sut;
    _PluginControllerMock _pluginController;
    Stream<ConnectionStateUpdate> _connectionStateUpdateStream;
    Stream<ConnectionStateUpdate> _result;

    Map<Uuid, List<Uuid>> _servicesToDiscover;

    const _deviceId = '123';
    const _connectionTimeout = Duration(seconds: 1);

    setUp(() {
      _pluginController = _PluginControllerMock();
      _servicesToDiscover = {
        Uuid.parse('FEFE'): [Uuid.parse('FEFE')]
      };
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
          when(_pluginController.connectToDevice(any, any, any)).thenAnswer(
            (_) => Stream.fromIterable([1]),
          );
          _sut = DeviceConnector(
            pluginController: _pluginController,
            connectionStateUpdateStream: _connectionStateUpdateStream,
          );
          _result = _sut.connect(
            _deviceId,
            _servicesToDiscover,
            _connectionTimeout,
          );
        });

        test('It emits connection updates for that device', () {
          expect(
              _result, emitsInOrder(<ConnectionStateUpdate>[updateForDevice]));
        });

        test('It invokes method connect device', () async {
          await _result.first;
          verify(_pluginController.connectToDevice(
            _deviceId,
            _servicesToDiscover,
            _connectionTimeout,
          )).called(1);
        });

        test('It invokes method disconnect when stream is cancelled', () async {
          final subscription = _result.listen((event) {});

          await subscription.cancel();

          verify(_pluginController.disconnectDevice(_deviceId)).called(1);
        });
      });
    });
  });
}

class _PluginControllerMock extends Mock implements PluginController {}
