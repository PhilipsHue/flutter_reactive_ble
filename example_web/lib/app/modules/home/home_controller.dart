import 'dart:async';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  late FlutterReactiveBle flutterReactiveBle;

  RxString bleStatusText = ''.obs;

  ///Bluetooth Streams
  StreamSubscription? statusStream;
  StreamSubscription<DiscoveredDevice>? scanStream;
  StreamSubscription? deviceStream;

  RxList<DiscoveredDevice> discoveredDevices = <DiscoveredDevice>[].obs;

  @override
  void onInit() {
    flutterReactiveBle = FlutterReactiveBle();
    bluetoothStatus();
    super.onInit();
  }

  bluetoothStatus() async {
    if (statusStream != null) statusStream!.cancel();
    statusStream = flutterReactiveBle.statusStream.listen((event) {
      print(event);
      bleStatusText(event.name);
    });
  }

  ///Scan for bluetooth Device will first open a dialog in web
  ///and we have to pair device there first , only then we can work futrher
  ///with that device and get that in scanForDeviceStream
  scanBluetoothDevice() async {
    if (scanStream != null) scanStream!.cancel();
    scanStream =
        flutterReactiveBle.scanForDevices(withServices: []).listen((event) {
      if (!discoveredDevices.any((element) => element.id == event.id)) {
        discoveredDevices.add(event);
      }
    });
  }

  ///connectToDevice will connet to that device
  ///but i havent implemented method to update connection status yet
  connectDevice(DiscoveredDevice device) {
    if (deviceStream != null) deviceStream!.cancel();
    deviceStream =
        flutterReactiveBle.connectToDevice(id: device.id).listen((event) {
      print(event);
    });
  }

  stopListening() {
    statusStream!.cancel();
  }
}
