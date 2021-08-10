import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/device_scanner.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reactive_ble_platform_interface/reactive_ble_platform_interface.dart';

import 'device_scanner_test.mocks.dart';

@GenerateMocks([ReactiveBlePlatform])
void main() {
  group('$DeviceScanner', () {
    DiscoveredDevice? _device1;
    DiscoveredDevice? _device2;
    late ReactiveBlePlatform _blePlatform;
    late Completer<void> _delayAfterScanCompletion;

    late DeviceScannerImpl _sut;

    setUp(() {
      _device1 = DiscoveredDevice(
        id: '123',
        name: 'Test1',
        serviceUuids: const [],
        serviceData: const {},
        manufacturerData: Uint8List.fromList([1]),
        rssi: -40,
      );
      _device2 = DiscoveredDevice(
        id: '456',
        name: 'Test2',
        serviceUuids: const [],
        serviceData: const {},
        manufacturerData: Uint8List.fromList([0]),
        rssi: -80,
      );

      _delayAfterScanCompletion = Completer();
      _blePlatform = MockReactiveBlePlatform();
    });

    group('Scan for devices', () {
      late Stream<DiscoveredDevice> scanStream;

      late List<Uuid> withServices;
      late bool locationEnabled;
      late ScanMode scanmode;

      setUp(() {
        withServices = [Uuid.parse('FEFF')];
        locationEnabled = false;
        scanmode = ScanMode.lowLatency;

        when(_blePlatform.scanForDevices(
          withServices: withServices,
          scanMode: scanmode,
          requireLocationServicesEnabled: locationEnabled,
        )).thenAnswer((_) => Stream.fromIterable([0]));
      });

      group('When scan is sucesfull', () {
        setUp(() {
          final result1 = ScanResult(
            result:
                Result<DiscoveredDevice, GenericFailure<ScanFailure>>.success(
                    _device1),
          );
          final result2 = ScanResult(
            result:
                Result<DiscoveredDevice, GenericFailure<ScanFailure>>.success(
                    _device2),
          );

          when(_blePlatform.scanStream)
              .thenAnswer((_) => Stream.fromIterable([result1, result2]));
        });

        group('And platform is not Android', () {
          setUp(() {
            _sut = DeviceScannerImpl(
              blePlatform: _blePlatform,
              platformIsAndroid: () => false,
              delayAfterScanCompletion: _delayAfterScanCompletion.future,
              addToScanRegistry: (deviceId) {},
            );
            scanStream = _sut.scanForDevices(
              withServices: withServices,
              scanMode: scanmode,
              requireLocationServicesEnabled: locationEnabled,
            );
          });
          test('It emits discovered devices ', () {
            expect(scanStream,
                emitsInOrder(<DiscoveredDevice?>[_device1, _device2]));
          });

          test('It keeps instance of current scan session', () {
            expect(_sut.currentScan, isInstanceOf<ScanSession>());
          });

          group('When scanGetsCancelled', () {
            late StreamSubscription<DiscoveredDevice> subscription;
            setUp(() {
              subscription = scanStream.listen((event) {});
            });

            test('It sets currentScan session is set to null', () async {
              await subscription.cancel();
              expect(_sut.currentScan, null);
            });
          });
        });

        group('And platform is android', () {
          setUp(() {
            _sut = DeviceScannerImpl(
              blePlatform: _blePlatform,
              platformIsAndroid: () => true,
              delayAfterScanCompletion: _delayAfterScanCompletion.future,
              addToScanRegistry: (deviceId) {},
            );
            scanStream = _sut.scanForDevices(
              withServices: withServices,
              scanMode: scanmode,
              requireLocationServicesEnabled: locationEnabled,
            );
          });

          group('When scanGetsCancelled and timeout is  completed', () {
            late StreamSubscription<DiscoveredDevice> subscription;
            setUp(() {
              subscription = scanStream.listen((event) {});
              _delayAfterScanCompletion.complete();
            });

            test('It sets currentScan session is set to null', () async {
              await subscription.cancel();
              expect(_sut.currentScan, null);
            });
          });

          group('When scanGetsCancelled and timeout is  completed', () {
            late StreamSubscription<DiscoveredDevice> subscription;
            setUp(() {
              subscription = scanStream.listen((event) {});
            });

            test('It does not cancel current scan session', () {
              subscription.cancel();
              expect(_sut.currentScan, isInstanceOf<ScanSession>());
            });
          });
        });
      });

      group('When scan failed', () {
        const failure =
            GenericFailure(code: ScanFailure.unknown, message: 'Whoops');
        const resultFailure = ScanResult(result: Result.failure(failure));

        Stream<DiscoveredDevice>? scanStream;

        setUp(() {
          when(_blePlatform.scanStream)
              .thenAnswer((_) => Stream.fromIterable([resultFailure]));

          _sut = DeviceScannerImpl(
            blePlatform: _blePlatform,
            platformIsAndroid: () => false,
            delayAfterScanCompletion: _delayAfterScanCompletion.future,
            addToScanRegistry: (deviceId) {},
          );

          scanStream = _sut.scanForDevices(
            withServices: withServices,
            scanMode: scanmode,
            requireLocationServicesEnabled: locationEnabled,
          );
        });

        test('It throws exception', () {
          expect(
              scanStream,
              emitsInOrder(<Object>[
                emitsError(isInstanceOf<Exception>()),
                emitsDone,
              ]));
        });
      });
    });
  });
}
