import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BleDeviceInteractor {
  BleDeviceInteractor({
    required Future<List<Service>> Function(String deviceId) bleDiscoverServices,
    required void Function(String message) logMessage,
    required this.readRssi,
  })  : _bleDiscoverServices = bleDiscoverServices,
        _logMessage = logMessage;

  final Future<List<Service>> Function(String deviceId) _bleDiscoverServices;

  final Future<int> Function(String deviceId) readRssi;

  final void Function(String message) _logMessage;

  Future<List<Service>> discoverServices(String deviceId) async {
    try {
      _logMessage('Start discovering services for: $deviceId');
      final result = await _bleDiscoverServices(deviceId);
      _logMessage('Discovering services finished');
      return result;
    } on Exception catch (e) {
      _logMessage('Error occurred when discovering services: $e');
      rethrow;
    }
  }
}
