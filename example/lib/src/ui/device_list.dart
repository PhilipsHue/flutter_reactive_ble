import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../utils.dart';
import '../widgets.dart';
import 'device_detail_screen.dart';

class DeviceList extends StatefulWidget {
  const DeviceList();

  @override
  _DeviceListState createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> {
  final _ble = FlutterReactiveBle();

  final _devices = <DiscoveredDevice>[];
  StreamSubscription _statusSubscription;
  StreamSubscription _scanSubscription;
  BleStatus _status;

  TextEditingController _uuidController;

  @override
  void initState() {
    super.initState();
    _initBleState();
    _uuidController = TextEditingController()
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _statusSubscription?.cancel();
    _scanSubscription?.cancel();
    _uuidController?.dispose();
    super.dispose();
  }

  void _initBleState() {
    log("Starting to listen to status updates...");

    _statusSubscription = _ble.statusStream.listen((status) {
      log("Status updated: $status");

      if (mounted) {
        setState(() => _status = status);
      }
    });
  }

  bool _isValidUuidInput() {
    final uuidText = _uuidController.text;
    try {
      Uuid.parse(uuidText);
      return true;
    } on Exception {
      return false;
    }
  }

  void _startScanning() {
    if (_scanSubscription == null) {
      final uuid = Uuid.parse(_uuidController.text);
      log("Starting to listen for devices...");

      _clearDeviceList();
      setState(() {
        _scanSubscription =
            _ble.scanForDevices(withService: uuid).listen((device) {
          if (mounted) {
            setState(() {
              final knownDeviceIndex =
                  _devices.indexWhere((d) => d.id == device.id);

              if (knownDeviceIndex >= 0) {
                _devices[knownDeviceIndex] = device;
              } else {
                log("New device found: $device");
                _devices.add(device);
              }
            });
          }
        });
      });
    } else {
      log("Scanning is already in progress");
    }
  }

  void _stopScanning() {
    if (_scanSubscription != null) {
      _scanSubscription.cancel();
      log("Stopped listening for devices");
      setState(() => _scanSubscription = null);
    } else {
      log("Scanning is not in progress");
    }
  }

  void _clearDeviceList() => setState(_devices.clear);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('BLE $_status'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text('Service UUID (2, 4, 16 bytes):'),
                  TextField(
                    controller: _uuidController,
                    enabled: _scanSubscription == null,
                    decoration: InputDecoration(
                        errorText:
                            _uuidController.text.isEmpty || _isValidUuidInput()
                                ? null
                                : 'Invalid UUID format'),
                    autocorrect: false,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RaisedButton(
                        child: const Text('Scan'),
                        onPressed: _scanSubscription == null &&
                                _status == BleStatus.ready &&
                                _isValidUuidInput()
                            ? _startScanning
                            : null,
                      ),
                      RaisedButton(
                        child: const Text('Stop'),
                        onPressed:
                            _scanSubscription != null ? _stopScanning : null,
                      ),
                      RaisedButton(
                        child: const Text('Clear'),
                        onPressed:
                            _devices.isNotEmpty ? _clearDeviceList : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_status == BleStatus.ready) ...[
                        Text(_scanSubscription == null
                            ? 'Enter a UUID above and tap start to begin scanning'
                            : 'Tap a device to connect to it'),
                        if (_scanSubscription != null || _devices.isNotEmpty)
                          Text('count: ${_devices.length}'),
                      ] else
                        const Text("BLE Status isn't valid for scanning"),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: ListView(
                children: _devices
                    .map(
                      (device) => ListTile(
                        title: Text(device.name),
                        subtitle: Text("${device.id}\nRSSI: ${device.rssi}"),
                        leading: const BluetoothIcon(),
                        onTap: () async {
                          _stopScanning();
                          _clearDeviceList();
                          await Navigator.push<void>(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      DeviceDetailScreen(device: device)));
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      );
}
