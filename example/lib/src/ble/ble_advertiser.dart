import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble_example/src/ble/reactive_state.dart';

class BleAdvertiser implements ReactiveState<ConnectionStateUpdate> {
  BleAdvertiser({
    required FlutterReactiveBle ble,
    required Function(String message) logMessage,
  })  : _ble = ble,
        _logMessage = logMessage;

  final FlutterReactiveBle _ble;
  final void Function(String message) _logMessage;

  @override
  Stream<ConnectionStateUpdate> get state =>
      _centralConnectionController.stream;

  final _centralConnectionController =
      StreamController<ConnectionStateUpdate>();

  late StreamSubscription<ConnectionStateUpdate> _connection;

  /*
  Future<void> startAdvertise() async {
    _logMessage('Start advertising');

    _connection = _ble.startAdvertising().listen(
      (update) {
        _logMessage('ConnectionState for central: ${update.connectionState}');
        _centralConnectionController.add(update);
      },
      onError: (Object e) => _logMessage(
          'Advertising / Connecting to central resulted in error $e'),
    );
  }
  */

  Future<void> dispose() async {
    await _centralConnectionController.close();
  }
}
/*
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
}*/
