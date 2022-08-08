import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble_example/src/ble/reactive_state.dart';
import 'package:meta/meta.dart';

class BleScanner implements ReactiveState<BleScannerState> {
  BleScanner({
    required FlutterReactiveBle ble,
    required Function(String message) logMessage,
  })  : _ble = ble,
        _logMessage = logMessage;

  final FlutterReactiveBle _ble;
  final void Function(String message) _logMessage;
  final StreamController<BleScannerState> _stateStreamController =
      StreamController();

  final _devices = <DiscoveredDevice>[];

  bool _advertiseIsInProgress = false;

  @override
  Stream<BleScannerState> get state => _stateStreamController.stream;

  void startAdvertising() {
    _logMessage('Start ble advertising');
    _ble.startAdvertising(); //.listen(update) {};
    _advertiseIsInProgress = true;
    _pushState();
  }

  void stopAdvertising() {
    _logMessage('Stop ble advertising');
    _ble.stopAdvertising();
    _advertiseIsInProgress = false;
    _pushState();
  }

  void writeSample() {
    _logMessage('write sample');
    QualifiedCharacteristic characteristic = QualifiedCharacteristic(
        characteristicId: Uuid.parse("6E400002-B5A3-F393-E0A9-E50E24DCCA9E"),
        serviceId: Uuid.parse("6E400001-B5A3-F393-E0A9-E50E24DCCA9E"),
        deviceId: "12345");
    List<int> value = [1, 2, 3, 4, 5, 6, 6];
    _ble.writeLocalCharacteristic(characteristic, value);
  }

  void startScan(List<Uuid> serviceIds) {
    _logMessage('Start ble discovery');
    _devices.clear();
    _subscription?.cancel();
    _subscription =
        _ble.scanForDevices(withServices: serviceIds).listen((device) {
      final knownDeviceIndex = _devices.indexWhere((d) => d.id == device.id);
      if (knownDeviceIndex >= 0) {
        _devices[knownDeviceIndex] = device;
      } else {
        _devices.add(device);
      }
      _pushState();
    }, onError: (Object e) => _logMessage('Device scan fails with error: $e'));
    _pushState();
  }

  void _pushState() {
    _stateStreamController.add(
      BleScannerState(
        discoveredDevices: _devices,
        scanIsInProgress: _subscription != null,
        advertiseIsInProgress: _advertiseIsInProgress,
      ),
    );
  }

  Future<void> stopScan() async {
    _logMessage('Stop ble discovery');

    await _subscription?.cancel();
    _subscription = null;
    _pushState();
  }

  Future<void> dispose() async {
    await _stateStreamController.close();
  }

  StreamSubscription? _subscription;
}

@immutable
class BleScannerState {
  const BleScannerState({
    required this.discoveredDevices,
    required this.scanIsInProgress,
    required this.advertiseIsInProgress,
  });

  final List<DiscoveredDevice> discoveredDevices;
  final bool scanIsInProgress;
  final bool advertiseIsInProgress;
}
