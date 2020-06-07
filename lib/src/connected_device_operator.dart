import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/plugin_controller.dart';
import 'package:meta/meta.dart';

class ConnectedDeviceOperator {
  ConnectedDeviceOperator({
    @required PluginController pluginController,
  })  : assert(pluginController != null),
        _pluginController = pluginController;

  final PluginController _pluginController;

  Stream<CharacteristicValue> get characteristicValueStream =>
      _pluginController.charValueUpdateStream;

  Future<List<int>> readCharacteristic(QualifiedCharacteristic characteristic) {
    final specificCharacteristicValueStream = characteristicValueStream
        .where((update) => update.characteristic == characteristic)
        .map((update) => update.result.dematerialize());

    return _pluginController
        .readCharacteristic(characteristic)
        .asyncExpand((Object _) => specificCharacteristicValueStream)
        .firstWhere((_) => true,
            orElse: () => throw NoBleCharacteristicDataReceived());
  }

  Future<void> writeCharacteristicWithResponse(
    QualifiedCharacteristic characteristic, {
    @required List<int> value,
  }) async =>
      _pluginController
          .writeCharacteristicWithResponse(characteristic, value)
          .then((info) => info.result.dematerialize());

  Future<void> writeCharacteristicWithoutResponse(
    QualifiedCharacteristic characteristic, {
    @required List<int> value,
  }) async =>
      _pluginController
          .writeCharacteristicWithoutResponse(characteristic, value)
          .then((info) => info.result.dematerialize());

  Stream<List<int>> subscribeToCharacteristic(
    QualifiedCharacteristic characteristic,
    Future<ConnectionStateUpdate> shouldTerminate,
  ) {
    final specificCharacteristicValueStream = characteristicValueStream
        .where((update) => update.characteristic == characteristic)
        .map((update) => update.result.dematerialize());

    final autosubscribingRepeater = Repeater<List<int>>.broadcast(
      onListenEmitFrom: () => _pluginController
          .subscribeToNotifications(characteristic)
          .asyncExpand((Object _) => specificCharacteristicValueStream),
      onCancel: () => _pluginController
          .stopSubscribingToNotifications(characteristic)
          .catchError((Object e) =>
              print("Error unsubscribing from notifications: $e")),
    );

    shouldTerminate.then<void>((_) => autosubscribingRepeater.dispose());

    return autosubscribingRepeater.stream;
  }

  Future<int> requestMtu(String deviceId, int mtu) async =>
      _pluginController.requestMtuSize(deviceId, mtu);
}

@visibleForTesting
class NoBleCharacteristicDataReceived implements Exception {
  @override
  bool operator ==(Object other) => runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

@visibleForTesting
class NoBleDeviceConnectionStateReceived implements Exception {
  @override
  bool operator ==(Object other) => runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}
