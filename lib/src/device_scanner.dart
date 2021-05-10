import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/plugin_controller.dart';
import 'package:flutter_reactive_ble/src/rx_ext/repeater.dart';
import 'package:flutter_reactive_ble/src/rx_ext/serial_disposable.dart';
import 'package:pedantic/pedantic.dart';

import 'model/discovered_device.dart';
import 'model/scan_mode.dart';
import 'model/scan_session.dart';
import 'model/uuid.dart';

abstract class DeviceScanner {
  ScanSession? get currentScan;

  Stream<DiscoveredDevice> scanForDevices({
    required List<Uuid> withServices,
    ScanMode scanMode = ScanMode.balanced,
    bool requireLocationServicesEnabled = true,
  });
}

class DeviceScannerImpl implements DeviceScanner {
  DeviceScannerImpl({
    required ScanOperationController controller,
    required bool Function() platformIsAndroid,
    required Future<void> delayAfterScanCompletion,
    required this.addToScanRegistry,
  })   : _controller = controller,
        _platformIsAndroid = platformIsAndroid,
        _delayAfterScanCompletion = delayAfterScanCompletion;

  ScanSession? _currentScanSession;

  final ScanOperationController _controller;
  final bool Function() _platformIsAndroid;
  final Future<void> _delayAfterScanCompletion;
  final void Function(String deviceId) addToScanRegistry;

  Stream<ScanResult> get _scanStream => _controller.scanStream;

  final SerialDisposable<Repeater<DiscoveredDevice>> _scanStreamDisposable =
      SerialDisposable(
          (Repeater<DiscoveredDevice> repeater) => repeater.dispose());

  @override
  ScanSession? get currentScan => _currentScanSession;

  @override
  Stream<DiscoveredDevice> scanForDevices({
    required List<Uuid> withServices,
    ScanMode scanMode = ScanMode.balanced,
    bool requireLocationServicesEnabled = true,
  }) {
    final completer = Completer<void>();
    _currentScanSession =
        ScanSession(withServices: withServices, future: completer.future);
    // Make sure completing a future with an error does not lead to an unhandled exception.
    unawaited(completer.future.catchError((Object e, StackTrace s) {}));

    final scanRepeater = Repeater(
      onListenEmitFrom: () =>
          _scanStream.map((scan) => scan.result.dematerialize()).handleError(
        (Object e, StackTrace s) {
          if (!completer.isCompleted) {
            completer.completeError(e, s);
            if (e is Exception)
              throw e;
            else if (e is Error)
              throw e;
            else
              throw Exception(e);
          }
        },
      ),
      onCancel: () async {
        if (_platformIsAndroid()) {
          // Some devices have issues with establishing connection directly after scan is stopped so we should wait here.
          // See https://github.com/googlesamples/android-BluetoothLeGatt/issues/44
          await _delayAfterScanCompletion;
        }
        _currentScanSession = null;
        if (!completer.isCompleted) {
          completer.complete();
        }
      },
    );

    _scanStreamDisposable.set(scanRepeater);

    return _controller
        .scanForDevices(
          withServices: withServices,
          scanMode: scanMode,
          requireLocationServicesEnabled: requireLocationServicesEnabled,
        )
        .asyncExpand((_) => scanRepeater.stream.map((discoveredDevice) {
              addToScanRegistry(discoveredDevice.id);
              return discoveredDevice;
            }));
  }
}
