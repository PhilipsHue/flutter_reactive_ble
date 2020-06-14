import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/connected_device_operation.dart';
import 'package:flutter_reactive_ble/src/device_connector.dart';
import 'package:flutter_reactive_ble/src/device_scanner.dart';
import 'package:flutter_reactive_ble/src/plugin_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('$FlutterReactiveBle', () {
    _PluginControllerMock _pluginController;
    _DeviceScannerMock _deviceScanner;
    _DeviceConnectorMock _deviceConnector;
    _DeviceOperationMock _deviceOperation;

    FlutterReactiveBle _sut;

    setUp(() {
      _pluginController = _PluginControllerMock();
      _deviceScanner = _DeviceScannerMock();
      _deviceConnector = _DeviceConnectorMock();
      _deviceOperation = _DeviceOperationMock();

      when(_pluginController.initialize()).thenAnswer(
        (_) => Future.value(),
      );

      _sut = FlutterReactiveBle.testInstance(
        pluginController: _pluginController,
        deviceScanner: _deviceScanner,
        deviceConnector: _deviceConnector,
        connectedDeviceOperation: _deviceOperation,
      );
    });

    group('BleStatus', () {
      Stream<BleStatus> bleStatusStream;
      setUp(() {
        when(_pluginController.bleStatusStream).thenAnswer(
          (realInvocation) => Stream.fromIterable(
            [BleStatus.ready],
          ),
        );

        bleStatusStream = _sut.statusStream;
      });

      test('It calls initialize', () async {
        await bleStatusStream.first;
        verify(_pluginController.initialize()).called(1);
      });

      test('It returns values retrieved from plugincontroller', () {
        expect(
            bleStatusStream,
            emitsInOrder(<BleStatus>[
              BleStatus.unknown,
              BleStatus.ready,
            ]));
      });
    });
  });
}

class _PluginControllerMock extends Mock implements PluginController {}

class _DeviceScannerMock extends Mock implements DeviceScanner {}

class _DeviceConnectorMock extends Mock implements DeviceConnector {}

class _DeviceOperationMock extends Mock implements ConnectedDeviceOperation {}
