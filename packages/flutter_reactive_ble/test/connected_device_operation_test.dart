import 'dart:async';

import 'package:flutter_reactive_ble/src/connected_device_operation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reactive_ble_platform_interface/reactive_ble_platform_interface.dart';

import 'connected_device_operation_test.mocks.dart';

@GenerateMocks([ReactiveBlePlatform])
void main() {
  late ReactiveBlePlatform _blePlatform;
  late ConnectedDeviceOperation _sut;

  group('$ConnectedDeviceOperation', () {
    setUp(() {
      _blePlatform = MockReactiveBlePlatform();
      _sut = ConnectedDeviceOperationImpl(
        blePlatform: _blePlatform,
      );
    });
    group('Listen to char value updates', () {
      CharacteristicValue? valueUpdate;

      setUp(() {
        valueUpdate = CharacteristicValue(
          characteristic: CharacteristicInstance(
            characteristicId: Uuid.parse('FEFF'),
            characteristicInstanceId: "11",
            serviceId: Uuid.parse('FEFF'),
            serviceInstanceId: "101",
            deviceId: '123',
          ),
          result: const Result.success([1]),
        );

        when(_blePlatform.charValueUpdateStream)
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
      late CharacteristicInstance charDevice;
      CharacteristicInstance charOtherSameDevice;
      CharacteristicInstance charOtherDevice;
      CharacteristicValue? valueUpdate;
      CharacteristicValue? valueUpdateOtherDevice;
      CharacteristicValue? valueUpdateSameDeviceOtherChar;
      List<int>? result;

      setUp(() {
        charDevice = CharacteristicInstance(
          characteristicId: Uuid.parse('FEFF'),
          characteristicInstanceId: "11",
          serviceId: Uuid.parse('FEFF'),
          serviceInstanceId: "101",
          deviceId: '123',
        );

        charOtherSameDevice = CharacteristicInstance(
          characteristicId: Uuid.parse('FEFF'),
          characteristicInstanceId: "11",
          serviceId: Uuid.parse('FAFF'),
          serviceInstanceId: "101",
          deviceId: '123',
        );

        charOtherDevice = CharacteristicInstance(
          characteristicId: Uuid.parse('FEFF'),
          characteristicInstanceId: "11",
          serviceId: Uuid.parse('FEFF'),
          serviceInstanceId: "101",
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

        when(_blePlatform.readCharacteristic(charDevice)).thenAnswer(
          (_) => Stream.fromIterable([0]),
        );
      });

      group('Given multiple updates are received for specific device', () {
        setUp(() async {
          when(_blePlatform.charValueUpdateStream)
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
          when(_blePlatform.charValueUpdateStream)
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
      late CharacteristicInstance characteristic;
      WriteCharacteristicInfo info;
      const value = [1, 0];

      setUp(() {
        characteristic = CharacteristicInstance(
          characteristicId: Uuid.parse('FEFF'),
          characteristicInstanceId: "11",
          serviceId: Uuid.parse('FEFF'),
          serviceInstanceId: "101",
          deviceId: '123',
        );
      });

      group('Write characteristic with response', () {
        group('Given write characteristic succeeds', () {
          setUp(() {
            info = WriteCharacteristicInfo(
              characteristic: characteristic,
              result: const Result<Unit,
                  GenericFailure<WriteCharacteristicFailure>>.success(Unit()),
            );

            when(_blePlatform.writeCharacteristicWithResponse(
                    characteristic, value))
                .thenAnswer((_) async => info);
          });

          test('It completes without error', () async {
            await _sut.writeCharacteristicWithResponse(
              characteristic,
              value: value,
            );
            expect(true, true);
          });

          group('Given write characteristic fails', () {
            setUp(() {
              info = WriteCharacteristicInfo(
                characteristic: characteristic,
                result: const Result<Unit,
                    GenericFailure<WriteCharacteristicFailure>>.failure(
                  GenericFailure<WriteCharacteristicFailure>(
                    code: WriteCharacteristicFailure.unknown,
                    message: 'something went wrong',
                  ),
                ),
              );

              when(_blePlatform.writeCharacteristicWithResponse(
                      characteristic, value))
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
                result: const Result<Unit,
                    GenericFailure<WriteCharacteristicFailure>>.success(Unit()),
              );

              when(_blePlatform.writeCharacteristicWithoutResponse(
                      characteristic, value))
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
                result: const Result<Unit,
                    GenericFailure<WriteCharacteristicFailure>>.failure(
                  GenericFailure<WriteCharacteristicFailure>(
                    code: WriteCharacteristicFailure.unknown,
                    message: 'something went wrong',
                  ),
                ),
              );

              when(_blePlatform.writeCharacteristicWithoutResponse(
                      characteristic, value))
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
        late CharacteristicInstance charDevice;
        CharacteristicInstance charOtherSameDevice;
        CharacteristicInstance charOtherDevice;
        late CharacteristicValue valueUpdate1;
        late CharacteristicValue valueUpdate2;
        late CharacteristicValue valueUpdateOtherDevice;
        late CharacteristicValue valueUpdateSameDeviceOtherChar;
        late Stream<List<int>?> result;
        late Completer<ConnectionStateUpdate> terminateCompleter;

        setUp(() {
          terminateCompleter = Completer();

          charDevice = CharacteristicInstance(
            characteristicId: Uuid.parse('FEFF'),
            characteristicInstanceId: "11",
            serviceId: Uuid.parse('FEFF'),
            serviceInstanceId: "101",
            deviceId: '123',
          );

          charOtherSameDevice = CharacteristicInstance(
            characteristicId: Uuid.parse('FEFF'),
            characteristicInstanceId: "11",
            serviceId: Uuid.parse('FAFF'),
            serviceInstanceId: "101",
            deviceId: '123',
          );

          charOtherDevice = CharacteristicInstance(
            characteristicId: Uuid.parse('FEFF'),
            characteristicInstanceId: "11",
            serviceId: Uuid.parse('FEFF'),
            serviceInstanceId: "101",
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

          when(_blePlatform.subscribeToNotifications(charDevice))
              .thenAnswer((_) => Stream.fromIterable([0]));

          when(_blePlatform.stopSubscribingToNotifications(charDevice))
              .thenAnswer((_) async => 0);
        });

        group('Given multiple updates are received for specific device', () {
          setUp(() async {
            when(_blePlatform.charValueUpdateStream)
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

        group('Subscribe to characteristic async', () {
          test('It waits for subscription to complete before returning stream',
              () async {
            final subscriptionCompleter = Completer<void>();
            when(_blePlatform.subscribeToNotifications(charDevice))
                .thenAnswer((_) => subscriptionCompleter.future.asStream());
            when(_blePlatform.charValueUpdateStream)
                .thenAnswer((_) => Stream.fromIterable([
                      valueUpdate1,
                      valueUpdateOtherDevice,
                      valueUpdate2,
                      valueUpdateSameDeviceOtherChar,
                    ]));

            var completed = false;
            final streamFuture = _sut
                .subscribeToCharacteristicAsync(
                    charDevice, terminateCompleter.future)
                .then((stream) {
              completed = true;
              return stream;
            });

            await Future<void>.delayed(Duration.zero);
            expect(completed, isFalse);

            subscriptionCompleter.complete();
            final stream = await streamFuture;
            expect(completed, isTrue);

            expect(
              stream,
              emitsInOrder(<List<int>>[
                [1],
                [2],
              ]),
            );
          });

          test(
              'It buffers notifications emitted before the returned stream is listened to',
              () async {
            final charValueController =
                StreamController<CharacteristicValue>.broadcast();
            addTearDown(charValueController.close);

            when(_blePlatform.charValueUpdateStream)
                .thenAnswer((_) => charValueController.stream);

            final stream = await _sut.subscribeToCharacteristicAsync(
                charDevice, terminateCompleter.future);

            // Emit a notification before any listener is attached to `stream`
            charValueController.add(valueUpdate1);
            await Future<void>.delayed(Duration.zero);

            final received = <List<int>>[];
            final subscription = stream.listen(received.add);
            addTearDown(subscription.cancel);

            charValueController.add(valueUpdate2);
            await Future<void>.delayed(Duration.zero);

            expect(received, <List<int>>[
              [1],
              [2],
            ]);
          });

          test(
              'It stops subscribing to notifications when stream subscription is cancelled',
              () async {
            final charValueController =
                StreamController<CharacteristicValue>.broadcast();
            addTearDown(charValueController.close);

            when(_blePlatform.charValueUpdateStream)
                .thenAnswer((_) => charValueController.stream);

            final stream = await _sut.subscribeToCharacteristicAsync(
                charDevice, terminateCompleter.future);

            final subscription = stream.listen((_) {});
            await subscription.cancel();

            verify(_blePlatform.stopSubscribingToNotifications(charDevice))
                .called(1);
          });

          test('It closes stream when device disconnects', () async {
            final charValueController =
                StreamController<CharacteristicValue>.broadcast();
            addTearDown(charValueController.close);

            when(_blePlatform.charValueUpdateStream)
                .thenAnswer((_) => charValueController.stream);

            final stream = await _sut.subscribeToCharacteristicAsync(
                charDevice, terminateCompleter.future);

            terminateCompleter.complete(const ConnectionStateUpdate(
              deviceId: '123',
              connectionState: DeviceConnectionState.disconnected,
              failure: null,
            ));

            await expectLater(stream, emitsDone);
          });

          test('It propagates error if subscribeToNotifications fails',
              () async {
            when(_blePlatform.subscribeToNotifications(charDevice))
                .thenAnswer((_) => Stream<void>.error(Exception('BLE failure')));
            when(_blePlatform.charValueUpdateStream)
                .thenAnswer((_) => const Stream.empty());

            await expectLater(
              _sut.subscribeToCharacteristicAsync(
                  charDevice, terminateCompleter.future),
              throwsException,
            );
          });
        });
      });

      group('Negotiate mtusize', () {
        const deviceId = '123';
        const mtuSize = 50;
        int? result;

        setUp(() async {
          when(_blePlatform.requestMtuSize(deviceId, mtuSize))
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
            when(_blePlatform.requestConnectionPriority(deviceId, priority))
                .thenAnswer((_) async => const ConnectionPriorityInfo(
                      result: Result.success(Unit()),
                    ));
          });

          test('It succeeds without an error', () async {
            await _sut.requestConnectionPriority(deviceId, priority);

            expect(true, true);
          });
        });

        group('Given request priority fails', () {
          setUp(() async {
            when(_blePlatform.requestConnectionPriority(deviceId, priority))
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
