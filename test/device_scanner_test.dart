import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/device_scanner.dart';
import 'package:flutter_reactive_ble/src/model/discovered_device.dart';
import 'package:flutter_reactive_ble/src/model/result.dart';
import 'package:flutter_reactive_ble/src/model/scan_session.dart';
import 'package:flutter_reactive_ble/src/plugin_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('$DeviceScanner', () {
    DiscoveredDevice _device1;
    DiscoveredDevice _device2;
    _ScanOperationControllerStub _controller;
    Completer<void> _delayAfterScanCompletion;

    DeviceScannerImpl _sut;

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
      _controller = _ScanOperationControllerStub();
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

          _controller.scanResultsStub = [result1, result2];
        });

        group('And platform is not Android', () {
          setUp(() {
            _sut = DeviceScannerImpl(
              controller: _controller,
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
                emitsInOrder(<DiscoveredDevice>[_device1, _device2]));
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
            _sut = DeviceScannerImpl(
              controller: _controller,
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
          _controller.scanResultsStub = [resultFailure];

          _sut = DeviceScannerImpl(
            controller: _controller,
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

class _ScanOperationControllerStub implements ScanOperationController {
  List<ScanResult> _scanResults;
  @override
  Stream<void> scanForDevices(
          {List<Uuid> withServices,
          ScanMode scanMode,
          bool requireLocationServicesEnabled}) =>
      Stream.fromIterable([0]);

  @override
  Stream<ScanResult> get scanStream => Stream.fromIterable(_scanResults);

  set scanResultsStub(List<ScanResult> results) => _scanResults = results;
}
