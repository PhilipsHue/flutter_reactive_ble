import 'package:flutter_reactive_ble/src/connected_device_operator.dart';
import 'package:flutter_reactive_ble/src/model/characteristic_value.dart';
import 'package:flutter_reactive_ble/src/model/qualified_characteristic.dart';
import 'package:flutter_reactive_ble/src/model/result.dart';
import 'package:flutter_reactive_ble/src/model/uuid.dart';
import 'package:flutter_reactive_ble/src/plugin_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  _PluginControllerMock _pluginController;
  ConnectedDeviceOperator _sut;

  group('$ConnectedDeviceOperator', () {
    setUp(() {
      _pluginController = _PluginControllerMock();
    });
    group('Listen to char value updates', () {
      CharacteristicValue valueUpdate;

      setUp(() {
        valueUpdate = CharacteristicValue(
          characteristic: QualifiedCharacteristic(
            characteristicId: Uuid.parse('FEFF'),
            serviceId: Uuid.parse('FEFF'),
            deviceId: '123',
          ),
          result: const Result.success([1]),
        );

        when(_pluginController.charValueUpdateStream)
            .thenAnswer((_) => Stream.fromIterable([valueUpdate]));

        _sut = ConnectedDeviceOperator(pluginController: _pluginController);
      });

      test('It emits value updates received from plugincontroller', () {
        expect(
          _sut.characteristicValueStream,
          emitsInOrder(<CharacteristicValue>[valueUpdate]),
        );
      });
    });
  });
}

class _PluginControllerMock extends Mock implements PluginController {}
