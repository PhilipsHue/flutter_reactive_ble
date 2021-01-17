import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/plugin_controller.dart';
import 'package:meta/meta.dart';

abstract class ConnectedDeviceOperation {
  Stream<CharacteristicValue> get characteristicValueStream;

  Future<List<int>> readCharacteristic(QualifiedCharacteristic characteristic);

  Future<void> writeCharacteristicWithResponse(
    QualifiedCharacteristic characteristic, {
    required List<int> value,
  });

  Future<void> writeCharacteristicWithoutResponse(
    QualifiedCharacteristic characteristic, {
    required List<int> value,
  });

  Stream<List<int>?> subscribeToCharacteristic(
    QualifiedCharacteristic characteristic,
    Future<void> isDisconnected,
  );

  Future<int> requestMtu(String deviceId, int? mtu);

  Future<List<DiscoveredService>> discoverServices(String deviceId);

  Future<void> requestConnectionPriority(
      String deviceId, ConnectionPriority priority);
}

class ConnectedDeviceOperationImpl implements ConnectedDeviceOperation {
  ConnectedDeviceOperationImpl({
    required DeviceOperationController controller,
  }) : _controller = controller;

  final DeviceOperationController _controller;

  @override
  Stream<CharacteristicValue> get characteristicValueStream =>
      _controller.charValueUpdateStream;

  @override
  Future<List<int>> readCharacteristic(QualifiedCharacteristic characteristic) {
    final specificCharacteristicValueStream = characteristicValueStream
        .where((update) => update.characteristic == characteristic)
        .map((update) => update.result.dematerialize());

    return _controller
        .readCharacteristic(characteristic)
        .asyncExpand((Object? _) => specificCharacteristicValueStream)
        .firstWhere((_) => true,
            orElse: () => throw NoBleCharacteristicDataReceived());
  }

  @override
  Future<void> writeCharacteristicWithResponse(
    QualifiedCharacteristic characteristic, {
    required List<int> value,
  }) async =>
      _controller
          .writeCharacteristicWithResponse(characteristic, value)
          .then((info) => info.result.dematerialize());

  @override
  Future<void> writeCharacteristicWithoutResponse(
    QualifiedCharacteristic characteristic, {
    required List<int> value,
  }) async =>
      _controller
          .writeCharacteristicWithoutResponse(characteristic, value)
          .then((info) => info.result.dematerialize());

  @override
  Stream<List<int>?> subscribeToCharacteristic(
    QualifiedCharacteristic characteristic,
    Future<void> isDisconnected,
  ) {
    final specificCharacteristicValueStream = characteristicValueStream
        .where((update) => update.characteristic == characteristic)
        .map((update) => update.result.dematerialize());

    final autosubscribingRepeater = Repeater<List<int>?>.broadcast(
      onListenEmitFrom: () => _controller
          .subscribeToNotifications(characteristic)
          .asyncExpand((Object? _) => specificCharacteristicValueStream),
      onCancel: () => _controller
          .stopSubscribingToNotifications(characteristic)
          .catchError((Object e) =>
              print("Error unsubscribing from notifications: $e")),
    );

    isDisconnected.then<void>((_) => autosubscribingRepeater.dispose());

    return autosubscribingRepeater.stream;
  }

  @override
  Future<int> requestMtu(String deviceId, int? mtu) async =>
      _controller.requestMtuSize(deviceId, mtu);

  @override
  Future<List<DiscoveredService>> discoverServices(String deviceId) =>
      _controller.discoverServices(deviceId);

  @override
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
