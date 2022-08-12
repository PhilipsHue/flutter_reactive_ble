import 'package:collection/collection.dart';
import 'package:flutter_reactive_ble/src/device_scanner.dart';
import 'package:flutter_reactive_ble/src/rx_ext/repeater.dart';
import 'package:reactive_ble_platform_interface/reactive_ble_platform_interface.dart';

abstract class CentralConnector {
  Stream<ConnectionStateUpdate> get centralConnectionStateUpdateStream;

  Stream<CharacteristicValue> get centralDataChangedStream;
}

class CentralConnectorImpl implements CentralConnector {
  const CentralConnectorImpl({
    required ReactiveBlePlatform blePlatform,
  }) : _blePlatform = blePlatform;

  final ReactiveBlePlatform _blePlatform;

  @override
  Stream<ConnectionStateUpdate> get centralConnectionStateUpdateStream =>
      _blePlatform.connectionCentralStream;

  @override
  Stream<CharacteristicValue> get centralDataChangedStream =>
      _blePlatform.charCentralValueUpdateStream;
}
