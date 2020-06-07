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

    group('Read characteristic', () {
      QualifiedCharacteristic charDevice;
      QualifiedCharacteristic charOtherSameDevice;
      QualifiedCharacteristic charOtherDevice;
      CharacteristicValue valueUpdate;
      CharacteristicValue valueUpdateOtherDevice;
      CharacteristicValue valueUpdateSameDeviceOtherChar;
      List<int> result;

      setUp(() {
        charDevice = QualifiedCharacteristic(
          characteristicId: Uuid.parse('FEFF'),
          serviceId: Uuid.parse('FEFF'),
          deviceId: '123',
        );

        charOtherSameDevice = QualifiedCharacteristic(
          characteristicId: Uuid.parse('FEFF'),
          serviceId: Uuid.parse('FAFF'),
          deviceId: '123',
        );

        charOtherDevice = QualifiedCharacteristic(
          characteristicId: Uuid.parse('FEFF'),
          serviceId: Uuid.parse('FEFF'),
          deviceId: '456',
        );

        valueUpdate = CharacteristicValue(
          characteristic: charDevice,
          result: const Result.success([1]),
        );

        valueUpdateSameDeviceOtherChar = CharacteristicValue(
          characteristic: charOtherSameDevice,
          result: const Result.success([3]),
        );

        valueUpdateOtherDevice = CharacteristicValue(
          characteristic: charOtherDevice,
          result: const Result.success([4]),
        );
      });

      group('Given multiple updates are received for specific device', () {
        setUp(() async {
          when(_pluginController.charValueUpdateStream)
              .thenAnswer((_) => Stream.fromIterable([
                    valueUpdate,
                    valueUpdateOtherDevice,
                    valueUpdateSameDeviceOtherChar,
                  ]));

          when(_pluginController.readCharacteristic(any))
              .thenAnswer((_) => Stream.fromIterable([0]));
          _sut = ConnectedDeviceOperator(
            pluginController: _pluginController,
          );
          result = await _sut.readCharacteristic(charDevice);
        });

        test('It calls plugin controller with correct arguments', () {
          verify(_pluginController.readCharacteristic(charDevice)).called(1);
        });

        test('It emits first value that matches', () {
          expect(result, [1]);
        });
      });

      group(
          'Given no updates are provide for characteristic of specific device',
          () {
        setUp(() async {
          when(_pluginController.charValueUpdateStream)
              .thenAnswer((_) => Stream.fromIterable([
                    valueUpdateOtherDevice,
                    valueUpdateSameDeviceOtherChar,
                  ]));

          when(_pluginController.readCharacteristic(any))
              .thenAnswer((_) => Stream.fromIterable([0]));
          _sut = ConnectedDeviceOperator(
            pluginController: _pluginController,
          );
        });

        test('It emits first value that matches', () async {
          expect(
            () => _sut.readCharacteristic(charDevice),
            throwsA(isInstanceOf<NoBleCharacteristicDataReceived>()),
          );
        });
      });
    });
  });
}

class _PluginControllerMock extends Mock implements PluginController {}
