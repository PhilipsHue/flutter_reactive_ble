import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../src/utils.dart';
import '../src/widgets.dart';
import 'device_detail_screen.dart';

final _uuid = Uuid.parse('0000FE0F-0000-1000-8000-00805F9B34FB');

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

  @override
  void initState() {
    super.initState();
    _initBleState();
  }

  @override
  void dispose() {
    super.dispose();
    _statusSubscription?.cancel();
    _scanSubscription?.cancel();
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

  void _startScanning() {
    if (_scanSubscription == null) {
      log("Starting to listen for devices...");

      _scanSubscription = _ble.scanForDevices(withService: _uuid).listen((device) {
        if (!_devices.any((d) => d.id == device.id)) {
          log("New device found: $device");

          if (mounted) {
            setState(() {
              _devices.add(device);
            });
          }
        }
      });
      setState(() {}); // Because _scanSubscription isn't null anymore
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
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RaisedButton(
                      child: const Text('Start scanning'),
                      onPressed: _scanSubscription == null && _status == BleStatus.ready ? _startScanning : null,
                    ),
                    RaisedButton(
                      child: const Text('Stop scanning'),
                      onPressed: _scanSubscription != null ? _stopScanning : null,
                    ),
                    RaisedButton(
                      child: const Text('Clear scanlist'),
                      onPressed: _clearDeviceList,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_status == BleStatus.ready) ...[
                      Text(_scanSubscription == null ? 'Tap start to begin scanning' : 'Tap a device to connect to it'),
                      Text('count: ${_devices.length}'),
                    ] else
                      const Text("BLE Status isn't valid for scanning"),
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
                          subtitle: Text(device.id),
                          leading: const BluetoothIcon(),
                          onTap: () async {
                            _stopScanning();
                            _clearDeviceList();
                            await Navigator.push<void>(context, MaterialPageRoute(builder: (_) => DeviceDetailScreen(device: device)));
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      );
}
