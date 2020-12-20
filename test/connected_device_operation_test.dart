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

void main() {
  _DeviceOperationControllerStub _controller;
  ConnectedDeviceOperationImpl _sut;

  group('$ConnectedDeviceOperation', () {
    setUp(() {
      _controller = _DeviceOperationControllerStub();
      _sut = ConnectedDeviceOperationImpl(
        controller: _controller,
      );
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

        _controller.charValueUpdatesStub = [valueUpdate];
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
          _controller.charValueUpdatesStub = [
            valueUpdate,
            valueUpdateOtherDevice,
            valueUpdateSameDeviceOtherChar,
          ];

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
          _controller.charValueUpdatesStub = [
            valueUpdateOtherDevice,
            valueUpdateSameDeviceOtherChar,
          ];
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
          setUp(() {
            info = WriteCharacteristicInfo(
              characteristic: characteristic,
              result: const Result<void,
                  GenericFailure<WriteCharacteristicFailure>>.success(null),
            );

            _controller.writeCharInfoStub = info;
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

              _controller.writeCharInfoStub = info;
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
                    GenericFailure<WriteCharacteristicFailure>>.success(null),
              );

              _controller.writeCharInfoStub = info;
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

              _controller.writeCharInfoStub = info;
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
        QualifiedCharacteristic charDevice;
        QualifiedCharacteristic charOtherSameDevice;
        QualifiedCharacteristic charOtherDevice;
        CharacteristicValue valueUpdate1;
        CharacteristicValue valueUpdate2;
        CharacteristicValue valueUpdateOtherDevice;
        CharacteristicValue valueUpdateSameDeviceOtherChar;
        Stream<List<int>> result;
        Completer<ConnectionStateUpdate> terminateCompleter;

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
        });

        group('Given multiple updates are received for specific device', () {
          setUp(() async {
            _controller.charValueUpdatesStub = [
              valueUpdate1,
              valueUpdateOtherDevice,
              valueUpdate2,
              valueUpdateSameDeviceOtherChar,
            ];
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
        int result;

        setUp(() async {
          result = await _sut.requestMtu(deviceId, mtuSize);
        });

        test('It provides result retrieved from plugin', () {
          expect(result, mtuSize);
        });
      });

      group('Change connection priority', () {
        const deviceId = '123';
        ConnectionPriority priority;

        setUp(() {
          priority = ConnectionPriority.highPerformance;
        });

        group('Given request priority succeeds', () {
          setUp(() {
            _controller.connectionPrioInfoStub = const ConnectionPriorityInfo(
              result: Result.success(null),
            );
          });

          test('It succeeds without an error', () async {
            await _sut.requestConnectionPriority(deviceId, priority);

            expect(true, true);
          });
        });

        group('Given request priority fails', () {
          setUp(() async {
            _controller.connectionPrioInfoStub = const ConnectionPriorityInfo(
              result: Result.failure(
                GenericFailure<ConnectionPriorityFailure>(
                    code: ConnectionPriorityFailure.unknown, message: 'whoops'),
              ),
            );
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

class _DeviceOperationControllerStub implements DeviceOperationController {
  List<CharacteristicValue> _charValueUpdates;
  WriteCharacteristicInfo _writeCharInfo;
  ConnectionPriorityInfo _priorityInfo;

  @override
  Stream<CharacteristicValue> get charValueUpdateStream =>
      Stream.fromIterable(_charValueUpdates);

  @override
  Stream<void> readCharacteristic(QualifiedCharacteristic characteristic) =>
      Stream.fromIterable([0]);

  @override
  Future<ConnectionPriorityInfo> requestConnectionPriority(
          String deviceId, ConnectionPriority priority) async =>
      _priorityInfo;

  @override
  Future<int> requestMtuSize(String deviceId, int mtu) async => mtu;

  @override
  Future<void> stopSubscribingToNotifications(
      QualifiedCharacteristic characteristic) async {}

  @override
  Stream<void> subscribeToNotifications(
          QualifiedCharacteristic characteristic) =>
      Stream.fromIterable([0]);

  @override
  Future<WriteCharacteristicInfo> writeCharacteristicWithResponse(
          QualifiedCharacteristic characteristic, List<int> value) async =>
      _writeCharInfo;

  @override
  Future<WriteCharacteristicInfo> writeCharacteristicWithoutResponse(
          QualifiedCharacteristic characteristic, List<int> value) async =>
      _writeCharInfo;

  set charValueUpdatesStub(List<CharacteristicValue> updates) =>
      _charValueUpdates = updates;

  set writeCharInfoStub(WriteCharacteristicInfo info) => _writeCharInfo = info;

  set connectionPrioInfoStub(ConnectionPriorityInfo info) =>
      _priorityInfo = info;

  @override
  Future<List<DiscoveredService>> discoverServices(String deviceId) async => [];
}
