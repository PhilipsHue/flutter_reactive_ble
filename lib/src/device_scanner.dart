import 'dart:async';

import 'package:flutter_reactive_ble/src/plugin_controller.dart';
import 'package:flutter_reactive_ble/src/rx_ext/repeater.dart';
import 'package:flutter_reactive_ble/src/rx_ext/serial_disposable.dart';
import 'package:meta/meta.dart';

import 'discovered_devices_registry.dart';
import 'model/discovered_device.dart';
import 'model/scan_mode.dart';
import 'model/scan_session.dart';
import 'model/uuid.dart';

class DeviceScanner {
  DeviceScanner({
    @required PluginController pluginController,
    @required bool Function() platformIsAndroid,
    @required Future<void> delayAfterScanCompletion,
    @required this.scanRegistry,
  })  : assert(pluginController != null),
        assert(platformIsAndroid != null),
        assert(scanRegistry != null),
        assert(platformIsAndroid != null),
        assert(delayAfterScanCompletion != null),
        _pluginController = pluginController,
        _platformIsAndroid = platformIsAndroid,
        _delayAfterScanCompletion = delayAfterScanCompletion;

  ScanSession _currentScanSession;

  final PluginController _pluginController;
  final bool Function() _platformIsAndroid;
  final Future<void> _delayAfterScanCompletion;
  final DiscoveredDevicesRegistry scanRegistry;

  Stream<ScanResult> get _scanStream => _pluginController.scanStream;

  final SerialDisposable<Repeater<DiscoveredDevice>> _scanStreamDisposable =
      SerialDisposable((repeater) => repeater.dispose());

  ScanSession get currentScan => _currentScanSession;

  Stream<DiscoveredDevice> scanForDevices({
    @required List<Uuid> withServices,
    ScanMode scanMode = ScanMode.balanced,
    bool requireLocationServicesEnabled = true,
  }) {
    final completer = Completer<void>();
    _currentScanSession =
        ScanSession(withServices: withServices, future: completer.future);

    final scanRepeater = Repeater(
      onListenEmitFrom: () =>
          _scanStream.map((scan) => scan.result.dematerialize()).handleError(
        (Object e, StackTrace s) {
          if (!completer.isCompleted) {
            completer.completeError(e, s);
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

    return _pluginController
        .scanForDevices(
          withServices: withServices,
          scanMode: scanMode,
          requireLocationServicesEnabled: requireLocationServicesEnabled,
        )
        .asyncExpand(
          (_) => scanRepeater.stream.map((discoveredDevice) {
            scanRegistry.add(discoveredDevice.id);
            return discoveredDevice;
          }),
        );
  }
}
