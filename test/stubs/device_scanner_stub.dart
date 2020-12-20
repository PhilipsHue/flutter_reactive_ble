import 'package:flutter_reactive_ble/src/device_scanner.dart';
import 'package:flutter_reactive_ble/src/model/discovered_device.dart';
import 'package:flutter_reactive_ble/src/model/scan_mode.dart';
import 'package:flutter_reactive_ble/src/model/scan_session.dart';
import 'package:flutter_reactive_ble/src/model/uuid.dart';

class DeviceScannerStub implements DeviceScanner {
  List<ScanSession> _scanSessions;
  List<DiscoveredDevice> _discoveredDevices;

  @override
  ScanSession get currentScan => _scanSessions.removeAt(0);

  @override
  Stream<DiscoveredDevice> scanForDevices(
          {List<Uuid> withServices,
          ScanMode scanMode = ScanMode.balanced,
          bool requireLocationServicesEnabled = true}) =>
      Stream.fromIterable(_discoveredDevices);

  set scanSessionsStub(List<ScanSession> sessions) => _scanSessions = sessions;

  set discoveredDevicesStub(List<DiscoveredDevice> devices) =>
      _discoveredDevices = devices;
}
