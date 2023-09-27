import 'dart:async';
import 'package:collection/collection.dart';
import 'package:reactive_ble_platform_interface/reactive_ble_platform_interface.dart';
import 'package:reactive_ble_web/src/handlers/device_handler.dart';

class ConnectionHandler {
  late DeviceHandler deviceHandler;

  ConnectionHandler(this.deviceHandler);

  /// A list Containing all the `active connection` streams
  List<Map<String, StreamSubscription>> connectedDeviceStreamList = [];

  Future<void> addConnectionStream(String id,
      {Function(ConnectionStateUpdate)? onData}) async {
    await cancelStreambyId(id);
    // ignore: cancel_subscriptions
    final connectionSubscription = deviceHandler
        .getDeviceById(id)
        .connected
        .map((bool event) => ConnectionStateUpdate(
            deviceId: id,
            connectionState: event
                ? DeviceConnectionState.connected
                : DeviceConnectionState.disconnected,
            failure: null))
        .listen((event) => onData?.call(event));
    connectedDeviceStreamList.add({id: connectionSubscription});
  }

  Future<void> removeConnectionStream(String deviceId) async {
    await cancelStreambyId(deviceId);
  }

  Future<void> cancelStreambyId(String id) async {
    final data = connectedDeviceStreamList
        .firstWhereOrNull((element) => element.containsKey(id));
    if (data != null) {
      await data.values.first.cancel();
      connectedDeviceStreamList.remove(data);
    }
  }

  void reset() {
    connectedDeviceStreamList.forEach((element) {
      element.values.first.cancel();
      connectedDeviceStreamList.remove(element);
    });
  }
}
