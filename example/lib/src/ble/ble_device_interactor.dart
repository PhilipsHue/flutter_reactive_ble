import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BleServiceDiscoverer {
  BleServiceDiscoverer(
      Future<List<DiscoveredService>> Function(String deviceId)
          bleDiscoverServices)
      : _bleDiscoverServices = bleDiscoverServices;

  final Future<List<DiscoveredService>> Function(String deviceId)
      _bleDiscoverServices;

  Future<List<DiscoveredService>> discoverServices(String deviceId) async {
    return await _bleDiscoverServices(deviceId);
  }
}
