import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/connected_device_operation.dart';
import 'package:flutter_reactive_ble/src/model/characteristic_value.dart';
import 'package:flutter_reactive_ble/src/model/qualified_characteristic.dart';
import 'package:flutter_reactive_ble/src/model/result.dart';
import 'package:flutter_reactive_ble/src/model/uuid.dart';
import 'package:flutter_reactive_ble/src/model/write_characteristic_info.dart';
import 'package:flutter_reactive_ble/src/plugin_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'connected_device_operation_test.mocks.dart';

@GenerateMocks([DeviceOperationController])
void main() {
  late MockDeviceOperationController _controller;
  late ConnectedDeviceOperation _sut;

  group('$ConnectedDeviceOperation', () {
    setUp(() {
      _controller = MockDeviceOperationController();
      _sut = ConnectedDeviceOperationImpl(
        controller: _controller,
      );
    });
    group('Listen to char value updates', () {
      CharacteristicValue? valueUpdate;

      setUp(() {
        valueUpdate = CharacteristicValue(
          characteristic: QualifiedCharacteristic(
            characteristicId: Uuid.parse('FEFF'),
            serviceId: Uuid.parse('FEFF'),
            deviceId: '123',
          ),
          result: const Result.success([1]),
        );

        when(_controller.charValueUpdateStream)
            .thenAnswer((_) => Stream.fromIterable([valueUpdate!]));
      });

      test('It emits value updates received from plugincontroller', () {
        expect(
          _sut.characteristicValueStream,
          emitsInOrder(<CharacteristicValue?>[valueUpdate]),
        );
      });
    });

    group('Read characteristic', () {
      late QualifiedCharacteristic charDevice;
      QualifiedCharacteristic charOtherSameDevice;
      QualifiedCharacteristic charOtherDevice;
      CharacteristicValue? valueUpdate;
      CharacteristicValue? valueUpdateOtherDevice;
      CharacteristicValue? valueUpdateSameDeviceOtherChar;
      List<int>? result;

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

        when(_controller.readCharacteristic(any)).thenAnswer(
          (_) => Stream.fromIterable([0]),
        );
      });

      group('Given multiple updates are received for specific device', () {
        setUp(() async {
          when(_controller.charValueUpdateStream)
              .thenAnswer((_) => Stream.fromIterable([
                    valueUpdate!,
                    valueUpdateOtherDevice!,
                    valueUpdateSameDeviceOtherChar!,
                  ]));

          result = await _sut.readCharacteristic(charDevice);
        });

        test('It emits first value that matches', () {
          expect(result, [1]);
        });
      });

      group(
          'Given no updates are provide for characteristic of specific device',
          () {
        setUp(() async {
          when(_controller.charValueUpdateStream)
              .thenAnswer((_) => Stream.fromIterable([
                    valueUpdateOtherDevice!,
                    valueUpdateSameDeviceOtherChar!,
                  ]));
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
      late QualifiedCharacteristic characteristic;
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
          setUp(() {
            info = WriteCharacteristicInfo(
              characteristic: characteristic,
              result: const Result<void,
                  GenericFailure<WriteCharacteristicFailure>>.success(1),
            );

            when(_controller.writeCharacteristicWithResponse(any, any))
                .thenAnswer((_) async => info);
          });

          test('It completes without error', () async {
            await _sut.writeCharacteristicWithResponse(characteristic,
                value: value);
            expect(true, true);
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

              when(_controller.writeCharacteristicWithResponse(any, any))
                  .thenAnswer((_) async => info);
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

        group('Write characteristic without response', () {
          group('Given write characteristic succeeds', () {
            setUp(() {
              info = WriteCharacteristicInfo(
                characteristic: characteristic,
                result: const Result<void,
                    GenericFailure<WriteCharacteristicFailure>>.success(1),
              );

              when(_controller.writeCharacteristicWithoutResponse(any, any))
                  .thenAnswer((_) async => info);
            });

            test('It executes successfully', () async {
              await _sut.writeCharacteristicWithoutResponse(characteristic,
                  value: value);

              expect(true, true);
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

              when(_controller.writeCharacteristicWithoutResponse(any, any))
                  .thenAnswer((_) async => info);
            });

            test('It throws exception ', () async {
              expect(
                () => _sut.writeCharacteristicWithoutResponse(characteristic,
                    value: value),
                throwsException,
              );
            });
          });
        });
      });

      group('Subscribe to characteristic', () {
        late QualifiedCharacteristic charDevice;
        QualifiedCharacteristic charOtherSameDevice;
        QualifiedCharacteristic charOtherDevice;
        late CharacteristicValue valueUpdate1;
        late CharacteristicValue valueUpdate2;
        late CharacteristicValue valueUpdateOtherDevice;
        late CharacteristicValue valueUpdateSameDeviceOtherChar;
        late Stream<List<int>?> result;
        late Completer<ConnectionStateUpdate> terminateCompleter;

        setUp(() {
          terminateCompleter = Completer();

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

          valueUpdate1 = CharacteristicValue(
            characteristic: charDevice,
            result: const Result.success([1]),
          );

          valueUpdate2 = CharacteristicValue(
            characteristic: charDevice,
            result: const Result.success([2]),
          );

          valueUpdateSameDeviceOtherChar = CharacteristicValue(
            characteristic: charOtherSameDevice,
            result: const Result.success([3]),
          );

          valueUpdateOtherDevice = CharacteristicValue(
            characteristic: charOtherDevice,
            result: const Result.success([4]),
          );

          when(_controller.subscribeToNotifications(any))
              .thenAnswer((_) => Stream.fromIterable([0]));

          when(_controller.stopSubscribingToNotifications(any))
              .thenAnswer((_) async => 0);
        });

        group('Given multiple updates are received for specific device', () {
          setUp(() async {
            when(_controller.charValueUpdateStream)
                .thenAnswer((_) => Stream.fromIterable([
                      valueUpdate1,
                      valueUpdateOtherDevice,
                      valueUpdate2,
                      valueUpdateSameDeviceOtherChar,
                    ]));

            result = _sut.subscribeToCharacteristic(
                charDevice, terminateCompleter.future);
          });
          test('It emits all values that matches', () {
            expect(
                result,
                emitsInOrder(<List<int>>[
                  [1],
                  [2],
                ]));
          });
        });
      });

      group('Negotiate mtusize', () {
        const deviceId = '123';
        const mtuSize = 50;
        int? result;

        setUp(() async {
          when(_controller.requestMtuSize(any, any))
              .thenAnswer((_) async => mtuSize);

          result = await _sut.requestMtu(deviceId, mtuSize);
        });

        test('It provides result retrieved from plugin', () {
          expect(result, mtuSize);
        });
      });

      group('Change connection priority', () {
        const deviceId = '123';
        late ConnectionPriority priority;

        setUp(() {
          priority = ConnectionPriority.highPerformance;
        });

        group('Given request priority succeeds', () {
          setUp(() {
            when(_controller.requestConnectionPriority(any, any))
                .thenAnswer((_) async => const ConnectionPriorityInfo(
                      result: Result.success(1),
                    ));
          });

          test('It succeeds without an error', () async {
            await _sut.requestConnectionPriority(deviceId, priority);

            expect(true, true);
          });
        });

        group('Given request priority fails', () {
          setUp(() async {
            when(_controller.requestConnectionPriority(any, any))
                .thenAnswer((_) async => const ConnectionPriorityInfo(
                      result: Result.failure(
                        GenericFailure<ConnectionPriorityFailure>(
                            code: ConnectionPriorityFailure.unknown,
                            message: 'whoops'),
                      ),
                    ));
          });

          test('It throws failure', () async {
            expect(
                () async => _sut.requestConnectionPriority(deviceId, priority),
                throwsException);
          });
        });
      });
    });
  });
}
