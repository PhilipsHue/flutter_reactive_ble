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

  Future<List<int>> readCharacteristic(QualifiedCharacteristic characteristic) {
    final specificCharacteristicValueStream = characteristicValueStream
        .where((update) => update.characteristic == characteristic)
        .map((update) => update.result.dematerialize());

    return pluginController
        .readCharacteristic(characteristic)
        .asyncExpand((Object _) => specificCharacteristicValueStream)
        .firstWhere((_) => true,
            orElse: () => throw NoBleCharacteristicDataReceived());
  }
}

@visibleForTesting
class NoBleCharacteristicDataReceived implements Exception {
  @override
  bool operator ==(Object other) => runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}
