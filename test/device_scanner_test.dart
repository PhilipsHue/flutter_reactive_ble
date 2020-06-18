import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/device_scanner.dart';
import 'package:flutter_reactive_ble/src/discovered_devices_registry.dart';
import 'package:flutter_reactive_ble/src/model/discovered_device.dart';
import 'package:flutter_reactive_ble/src/model/result.dart';
import 'package:flutter_reactive_ble/src/model/scan_session.dart';
import 'package:flutter_reactive_ble/src/plugin_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('$DeviceScanner', () {
    DiscoveredDevice _device1;
    DiscoveredDevice _device2;
    _ScanRegistryMock _scanRegistry;
    _PluginControllerMock _pluginController;
    Completer<void> _delayAfterScanCompletion;

    DeviceScanner _sut;

    setUp(() {
      _device1 = DiscoveredDevice(
        id: '123',
        name: 'Test1',
        serviceData: const {},
        manufacturerData: Uint8List.fromList([1]),
        rssi: -40,
      );
      _device2 = DiscoveredDevice(
        id: '456',
        name: 'Test2',
        serviceData: const {},
        manufacturerData: Uint8List.fromList([0]),
        rssi: -80,
      );

      _delayAfterScanCompletion = Completer();
      _scanRegistry = _ScanRegistryMock();
      _pluginController = _PluginControllerMock();
    });

    group('Scan for devices', () {
      Stream<DiscoveredDevice> scanStream;

      List<Uuid> withServices;
      bool locationEnabled;
      ScanMode scanmode;

      setUp(() {
        withServices = [Uuid.parse('FEFF')];
        locationEnabled = false;
        scanmode = ScanMode.lowLatency;

        when(_pluginController.scanForDevices(
          withServices: anyNamed('withServices'),
          scanMode: anyNamed('scanMode'),
          requireLocationServicesEnabled:
              anyNamed('requireLocationServicesEnabled'),
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

          when(_pluginController.scanStream).thenAnswer(
            (_) => Stream.fromIterable(
              [result1, result2],
            ),
          );
        });

        group('And platform is not Android', () {
          setUp(() {
            _sut = DeviceScanner(
              pluginController: _pluginController,
              platformIsAndroid: () => false,
              delayAfterScanCompletion: _delayAfterScanCompletion.future,
              scanRegistry: _scanRegistry,
            );
            scanStream = _sut.scanForDevices(
              withServices: withServices,
              scanMode: scanmode,
              requireLocationServicesEnabled: locationEnabled,
            );
          });
          test('It emits discovered devices ', () {
            expect(scanStream,
                emitsInOrder(<DiscoveredDevice>[_device1, _device2]));
          });

          test('It calls plugin controller with correct arguments', () {
            verify(_pluginController.scanForDevices(
              withServices: withServices,
              scanMode: scanmode,
              requireLocationServicesEnabled: locationEnabled,
            )).called(1);
          });

          test('It keeps instance of current scan session', () {
            expect(_sut.currentScan, isInstanceOf<ScanSession>());
          });

          group('When scanGetsCancelled', () {
            StreamSubscription<DiscoveredDevice> subscription;
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
            _sut = DeviceScanner(
              pluginController: _pluginController,
              platformIsAndroid: () => true,
              delayAfterScanCompletion: _delayAfterScanCompletion.future,
              scanRegistry: _scanRegistry,
            );
            scanStream = _sut.scanForDevices(
              withServices: withServices,
              scanMode: scanmode,
              requireLocationServicesEnabled: locationEnabled,
            );
          });

          group('When scanGetsCancelled and timeout is  completed', () {
            StreamSubscription<DiscoveredDevice> subscription;
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
            StreamSubscription<DiscoveredDevice> subscription;
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

        Stream<DiscoveredDevice> scanStream;

        setUp(() {
          when(_pluginController.scanStream).thenAnswer(
            (_) => Stream.fromIterable(
              [resultFailure],
            ),
          );

          _sut = DeviceScanner(
            pluginController: _pluginController,
            platformIsAndroid: () => false,
            delayAfterScanCompletion: _delayAfterScanCompletion.future,
            scanRegistry: _scanRegistry,
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

class _PluginControllerMock extends Mock implements PluginController {}

class _ScanRegistryMock extends Mock implements DiscoveredDevicesRegistry {}
