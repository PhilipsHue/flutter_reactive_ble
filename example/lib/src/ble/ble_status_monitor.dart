import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble_example/src/ble/reactive_state.dart';

class BleStatusMonitor implements ReactiveState<BleStatus?> {
  const BleStatusMonitor(this._ble);

  final FlutterReactiveBle _ble;

  @override
  Stream<BleStatus?> get state => _ble.statusStream;
}
