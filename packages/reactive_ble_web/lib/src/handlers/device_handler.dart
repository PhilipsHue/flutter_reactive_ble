import 'dart:async';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter_web_bluetooth/flutter_web_bluetooth.dart';
import 'package:reactive_ble_platform_interface/reactive_ble_platform_interface.dart';
import 'package:rxdart/rxdart.dart';

class DeviceHandler {
  List<BluetoothDevice> bluetoothDeviceList = [];

  // ignore: close_sinks
  late Stream<ScanResult> devices;

  DeviceHandler() {
    devices = BehaviorSubject<ScanResult>();
  }

  void reset() {
    bluetoothDeviceList.clear();
  }

  void addDevice(BluetoothDevice device) {
    if (!bluetoothDeviceList.any((element) => element.id == device.id)) {
      bluetoothDeviceList.add(device);
    }
    devices =
        Stream.fromIterable(bluetoothDeviceList).map((event) => ScanResult(
                result: Result.success(DiscoveredDevice(
              id: event.id,
              name: event.name ?? '',
              serviceData: const {},
              manufacturerData: Uint8List(0),
              rssi: 0,
              serviceUuids: const [],
            ))));
    print(bluetoothDeviceList);
  }

  void removeDevice(BluetoothDevice device) =>
      bluetoothDeviceList.remove(device);

  Future<BluetoothCharacteristic> getBleCharacteristics(
      QualifiedCharacteristic characteristic) async {
    final device = getDeviceById(characteristic.deviceId);
    final services = await device.discoverServices();
    final service = services.firstWhereOrNull((element) =>
        element.uuid.toString() == characteristic.serviceId.toString());
    final characteristicData = await service
        ?.getCharacteristic(characteristic.characteristicId.toString());
    if (characteristicData == null)
      throw Exception(
          'Characteristic ${characteristic.characteristicId.toString()} for service ${characteristic.serviceId.toString()} not found');
    return characteristicData;
  }

  Future<List<DiscoveredService>> getBleServices(String deviceId) async {
    final device = getDeviceById(deviceId);
    final services = await device.discoverServices();
    // ignore: prefer_final_locals
    var discoveredServices = <DiscoveredService>[];
    services.forEach((service) async {
      final characteristics = await service.getCharacteristics();
      final characteristicIds =
          characteristics.map((e) => Uuid.parse(e.uuid)).toList();
      final characteristicsList = characteristics
          .map((e) => DiscoveredCharacteristic(
              characteristicId: Uuid.parse(e.uuid),
              serviceId: Uuid.parse(service.uuid),
              isReadable: e.properties.read,
              isWritableWithResponse: e.properties.write,
              isWritableWithoutResponse: e.properties.writeWithoutResponse,
              isNotifiable: e.properties.notify,
              isIndicatable: e.properties.indicate))
          .toList();

      discoveredServices.add(DiscoveredService(
          serviceId: Uuid.parse(service.uuid),
          characteristicIds: characteristicIds,
          characteristics: characteristicsList));
    });
    return discoveredServices;
  }

  BluetoothDevice getDeviceById(String id) {
    final device = bluetoothDeviceList
        .firstWhereOrNull((BluetoothDevice element) => element.id == id);
    if (device == null) throw Exception('Device not found');
    return device;
  }
}
