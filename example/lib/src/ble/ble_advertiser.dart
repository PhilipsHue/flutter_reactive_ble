import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble_example/src/ble/reactive_state.dart';
import 'package:meta/meta.dart';

class BleAdvertiser implements ReactiveState<BleAdvertiserState> {
  BleAdvertiser({
    required FlutterReactiveBle ble,
    required Function(String message) logMessage,
  })  : _ble = ble,
        _logMessage = logMessage;

  final FlutterReactiveBle _ble;
  final void Function(String message) _logMessage;
  final StreamController<BleAdvertiserState> _stateStreamController = StreamController();

  bool _advertiseIsInProgress = false;

  DiscoveredDevice _connectedDevice = DiscoveredDevice(
    id: '',
    name: '',
    serviceUuids: const [],
    serviceData: const {},
    manufacturerData: Uint8List.fromList([1]) ,
    rssi: 0,);

  @override
  Stream<BleAdvertiserState> get state => _stateStreamController.stream;

  void startAdvertising() {
    _logMessage('Start ble advertising');

    //_ble.startAdvertising();
    //.listen(device) {_connectedDevice = device; };
    //_advertiseIsInProgress = true;
    //_pushState();

    //Reset connected device
    _connectedDevice = DiscoveredDevice(
      id: '',
      name: '',
      serviceUuids: const [],
      serviceData: const {},
      manufacturerData: Uint8List.fromList([1]) ,
      rssi: 0,);

    //_subscription?.cancel();
    //_subscription = _ble.startAdvertisingWaitDeviceConnect()//.listen((device){
      //_pushState();
    //},);
  }

  Future<void> stopAdvertising() async{
    _logMessage('Stop ble advertising');
    _ble.stopAdvertising();
    _advertiseIsInProgress = false;

    await _subscription?.cancel();
    _subscription = null;
    _pushState();
  }

  void _pushState() {
    _stateStreamController.add(
      BleAdvertiserState(
        connectedDevice: _connectedDevice,
        advertiseIsInProgress: _subscription != null,
      ),
    );
  }

  Future<void> dispose() async {
    await _stateStreamController.close();
  }

  StreamSubscription? _subscription;
}

@immutable
class BleAdvertiserState {
  const BleAdvertiserState({
    required this.connectedDevice,
    required this.advertiseIsInProgress,
  });

  final DiscoveredDevice connectedDevice;
  final bool advertiseIsInProgress;
}
