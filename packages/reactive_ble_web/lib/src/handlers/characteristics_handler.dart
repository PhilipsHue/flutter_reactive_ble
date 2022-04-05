import 'dart:async';
import 'package:collection/collection.dart';
import 'package:reactive_ble_platform_interface/reactive_ble_platform_interface.dart';
import 'package:reactive_ble_web/src/handlers/device_handler.dart';

class CharacteristicsHandler {
  late DeviceHandler deviceHandler;

  CharacteristicsHandler(this.deviceHandler);

  /// A list Containing all the `active connection` streams
  List<Map<QualifiedCharacteristic, StreamSubscription>>
      characteristicStreamList = [];

  ///To `add Stream` of New Connection
  Future<void> addCharacteristicStream(QualifiedCharacteristic characteristic,
      {Function(CharacteristicValue)? onData}) async {
    await cancelStream(characteristic);
    final bleCharacteristic =
        await deviceHandler.getBleCharacteristics(characteristic);
    // ignore: cancel_subscriptions
    final charSubscription = bleCharacteristic.value
        .map((event) => CharacteristicValue(
            characteristic: characteristic,
            result: Result.success(event.buffer.asUint8List())))
        .listen((event) => onData?.call(event));

    characteristicStreamList.add({characteristic: charSubscription});
  }

  /// To `remove Stream` of Connection
  Future<void> removeCharacteristicStream(
      QualifiedCharacteristic characteristic) async {
    await cancelStream(characteristic);
  }

  ///To `cancel Stream` of Connection
  Future<void> cancelStream(QualifiedCharacteristic characteristic) async {
    final data = characteristicStreamList
        .firstWhereOrNull((element) => element.containsKey(characteristic));
    if (data != null) {
      await data.values.first.cancel();
      characteristicStreamList.remove(data);
    }
  }

  void reset() {
    characteristicStreamList.forEach((element) {
      element.values.first.cancel();
      characteristicStreamList.remove(element);
    });
  }
}
