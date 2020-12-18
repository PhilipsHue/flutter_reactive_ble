import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/plugin_controller.dart';
import 'package:meta/meta.dart';

class ConnectedDeviceOperation {
  ConnectedDeviceOperation({
    @required DeviceOperationController controller,
  })  : assert(controller != null),
        _controller = controller;

  final DeviceOperationController _controller;

  Stream<CharacteristicValue> get characteristicValueStream =>
      _controller.charValueUpdateStream;

  Future<List<int>> readCharacteristic(QualifiedCharacteristic characteristic) {
    final specificCharacteristicValueStream = characteristicValueStream
        .where((update) => update.characteristic == characteristic)
        .map((update) => update.result.dematerialize());

    return _controller
        .readCharacteristic(characteristic)
        .asyncExpand((Object _) => specificCharacteristicValueStream)
        .firstWhere((_) => true,
            orElse: () => throw NoBleCharacteristicDataReceived());
  }

  Future<void> writeCharacteristicWithResponse(
    QualifiedCharacteristic characteristic, {
    @required List<int> value,
  }) async =>
      _controller
          .writeCharacteristicWithResponse(characteristic, value)
          .then((info) => info.result.dematerialize());

  Future<void> writeCharacteristicWithoutResponse(
    QualifiedCharacteristic characteristic, {
    @required List<int> value,
  }) async =>
      _controller
          .writeCharacteristicWithoutResponse(characteristic, value)
          .then((info) => info.result.dematerialize());

  Stream<List<int>> subscribeToCharacteristic(
    QualifiedCharacteristic characteristic,
    Future<void> isDisconnected,
  ) {
    final specificCharacteristicValueStream = characteristicValueStream
        .where((update) => update.characteristic == characteristic)
        .map((update) => update.result.dematerialize());

    final autosubscribingRepeater = Repeater<List<int>>.broadcast(
      onListenEmitFrom: () => _controller
          .subscribeToNotifications(characteristic)
          .asyncExpand((Object _) => specificCharacteristicValueStream),
      onCancel: () => _controller
          .stopSubscribingToNotifications(characteristic)
          .catchError((Object e) =>
              print("Error unsubscribing from notifications: $e")),
    );

    isDisconnected.then<void>((_) => autosubscribingRepeater.dispose());

    return autosubscribingRepeater.stream;
  }

  Future<int> requestMtu(String deviceId, int mtu) async =>
      _controller.requestMtuSize(deviceId, mtu);

  Future<void> requestConnectionPriority(
          String deviceId, ConnectionPriority priority) async =>
      _controller
          .requestConnectionPriority(deviceId, priority)
          .then((message) => message.result.dematerialize());
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
