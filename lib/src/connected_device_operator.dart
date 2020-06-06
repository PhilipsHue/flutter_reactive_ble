import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/plugin_controller.dart';
import 'package:meta/meta.dart';

class ConnectedDeviceOperator {
  ConnectedDeviceOperator({
    @required this.pluginController,
  });

  final PluginController pluginController;

  Stream<CharacteristicValue> get characteristicValueStream =>
      pluginController.charValueUpdateStream;
}
