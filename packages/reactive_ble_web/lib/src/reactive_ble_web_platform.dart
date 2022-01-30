// ignore_for_file: unused_field

import 'package:flutter_web_bluetooth/flutter_web_bluetooth.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:reactive_ble_platform_interface/reactive_ble_platform_interface.dart';
import 'package:rxdart/rxdart.dart';
import 'helper.dart';

class ReactiveBleWebPlatform extends ReactiveBlePlatform {
  static void registerWith(Registrar registrar) {}

  ReactiveBleWebPlatform();

  ///Initialise `FlutterWebBluetooth`
  late FlutterWebBluetoothInterface flutterWeb;

  ///LocalData of list of `BluetoothPairedDevices`
  List<BluetoothDevice> bluetoothDeviceList = [];

  ///[Implemented Methods]
  @override
  Future<void> initialize() {
    flutterWeb = FlutterWebBluetooth.instance;
    bluetoothDeviceList.clear();
    return Future.delayed(const Duration(microseconds: 100));
  }

  @override
  Future<void> deinitialize() {
    bluetoothDeviceList.clear();
    return Future.delayed(const Duration(microseconds: 100));
  }

  @override
  Stream<BleStatus> get bleStatusStream => flutterWeb.isAvailable
      .map((event) => event ? BleStatus.ready : BleStatus.unsupported);

  @override
  Stream<ScanResult> get scanStream =>
      flutterWeb.devices.where((event) => event.isNotEmpty).map((event) {
        ///here Save This set to a local list for later usage
        event.forEach((element) {
          if (!bluetoothDeviceList.any((device) => device.id == element.id)) {
            bluetoothDeviceList.add(element);
          }
        });
        return event.map(setBluetoothToDiscoverdDevice);
      }).transform(SwitchMapStreamTransformer((i) => Stream.fromIterable(i)
          .map((d) => ScanResult(result: Result.success(d)))));

  @override
  Stream<void> scanForDevices({
    required List<Uuid> withServices,
    required ScanMode scanMode,
    required bool requireLocationServicesEnabled,
  }) =>
      flutterWeb
          .requestDevice(RequestOptionsBuilder.acceptAllDevices(
              optionalServices: getServicesList(serviceList: withServices)))
          .asStream();

  @override
  Stream<ConnectionStateUpdate> get connectionUpdateStream =>
      mockConnectionUpdateStream();

  @override
  Future<void> disconnectDevice(String deviceId) {
    print('DisconnectDevice Called');
    return Future.delayed(const Duration(seconds: 1));
    // BluetoothDevice device =
    //     bluetoothDeviceList.firstWhere((element) => element.id == deviceId);
    // device.disconnect();
  }

  @override
  Stream<void> connectToDevice(
    String id,
    Map<Uuid, List<Uuid>>? servicesWithCharacteristicsToDiscover,
    Duration? connectionTimeout,
  ) async* {
    // if (!bluetoothDeviceList.any((element) => element.id == id))
    //   throw 'Please Scan For Device First';
    final device =
        bluetoothDeviceList.firstWhere((element) => element.id == id);
    await device.connect(timeout: connectionTimeout);
  }

  ///[UnImplemented Yet]
  ///Will try to implement other Methods later

}

class ReactiveBleWebPlatformFactory {
  const ReactiveBleWebPlatformFactory();
  ReactiveBleWebPlatform create() => ReactiveBleWebPlatform();
}
