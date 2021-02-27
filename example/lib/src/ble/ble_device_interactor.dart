import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BleServiceDiscoverer {
  BleServiceDiscoverer(
    Future<List<DiscoveredService>> Function(String deviceId)
        bleDiscoverServices,
    this._logMessage,
  ) : _bleDiscoverServices = bleDiscoverServices;

  final Future<List<DiscoveredService>> Function(String deviceId)
      _bleDiscoverServices;

  final void Function(String message) _logMessage;

  Future<List<DiscoveredService>> discoverServices(String deviceId) async {
    try {
      _logMessage('Start discovering services for: $deviceId');
      final result = await _bleDiscoverServices(deviceId);
      _logMessage('Discovering services finished');
      return result;
    } on Error catch (e) {
      _logMessage('Error occured when discovering services: $e');
      throw e;
    }
  }
}
