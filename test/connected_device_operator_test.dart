import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/connected_device_operator.dart';
import 'package:flutter_reactive_ble/src/model/characteristic_value.dart';
import 'package:flutter_reactive_ble/src/model/qualified_characteristic.dart';
import 'package:flutter_reactive_ble/src/model/result.dart';
import 'package:flutter_reactive_ble/src/model/uuid.dart';
import 'package:flutter_reactive_ble/src/model/write_characteristic_info.dart';
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

    group('Write characteristic', () {
      QualifiedCharacteristic characteristic;
      WriteCharacteristicInfo info;
      const value = [1, 0];

      setUp(() {
        characteristic = QualifiedCharacteristic(
          characteristicId: Uuid.parse('FEFF'),
          serviceId: Uuid.parse('FEFF'),
          deviceId: '123',
        );
      });

      group('Write characteristic with response', () {
        group('Given write characteristic succeeds', () {
          setUp(() async {
            info = WriteCharacteristicInfo(
              characteristic: characteristic,
              result: const Result<void,
                  GenericFailure<WriteCharacteristicFailure>>.success(null),
            );

            when(_pluginController.writeCharacteristicWithResponse(any, any))
                .thenAnswer(
              (realInvocation) => Future.value(info),
            );

            _sut = ConnectedDeviceOperator(pluginController: _pluginController);
            await _sut.writeCharacteristicWithResponse(characteristic,
                value: value);
          });

          test('It invokes $PluginController with correct arguments', () {
            verify(_pluginController.writeCharacteristicWithResponse(
                    characteristic, value))
                .called(1);
          });
        });

        group('Given write characteristic fails', () {
          setUp(() {
            info = WriteCharacteristicInfo(
              characteristic: characteristic,
              result: const Result<void,
                  GenericFailure<WriteCharacteristicFailure>>.failure(
                GenericFailure<WriteCharacteristicFailure>(
                  code: WriteCharacteristicFailure.unknown,
                  message: 'something went wrong',
                ),
              ),
            );

            when(_pluginController.writeCharacteristicWithResponse(any, any))
                .thenAnswer(
              (realInvocation) => Future.value(info),
            );

            _sut = ConnectedDeviceOperator(pluginController: _pluginController);
          });

          test('It throws exception ', () async {
            expect(
              () => _sut.writeCharacteristicWithResponse(characteristic,
                  value: value),
              throwsException,
            );
          });
        });
      });
    });
  });
}

class _PluginControllerMock extends Mock implements PluginController {}
