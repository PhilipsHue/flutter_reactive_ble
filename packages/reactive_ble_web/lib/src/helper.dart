import 'dart:typed_data';

import 'package:flutter_web_bluetooth/flutter_web_bluetooth.dart';
import 'package:reactive_ble_platform_interface/reactive_ble_platform_interface.dart';

List<String> getServicesList({List<Uuid> serviceList = const []}) {
  ///`Common UUID Lists`
  final commonList =
      BluetoothDefaultServiceUUIDS.VALUES.map((e) => e.uuid).toList();

  ///we need to provide list of services ,so that we can work with them later
  final providedList = serviceList.map((e) => e.toString()).toList();

  final finalList = commonList + providedList;
  return finalList;
}

Stream<ConnectionStateUpdate> mockConnectionUpdateStream() async* {
  for (var i = 0; i < 10; i++) {
    await Future<dynamic>.delayed(const Duration(seconds: 1));
    yield const ConnectionStateUpdate(
        deviceId: 'testing',
        failure: null,
        connectionState: DeviceConnectionState.connecting);
  }
}

///Method to Convert `BluetoothDevice` to `DiscoverdDevice`
///Needs More Improvment
DiscoveredDevice setBluetoothToDiscoverdDevice(BluetoothDevice device) {
  final uint8list = Uint8List(0);
  final serviceData = <Uuid, Uint8List>{};
  final uuidList = <Uuid>[];
  return DiscoveredDevice(
    id: device.id,
    name: device.name ?? '',
    serviceData: serviceData,
    manufacturerData: uint8list,
    rssi: 0,
    serviceUuids: uuidList,
  );
}
