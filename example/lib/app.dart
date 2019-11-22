import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble_example/device_detail_screen.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final _ble = FlutterReactiveBle();
  final devices = <DiscoveredDevice>[];
  StreamSubscription scanSubscription;
  String _status;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    _ble.statusStream.listen((status) {
      if (mounted) {
        setState(() {
          _status = "$status";
        });
      }
    });

    final uuid = Uuid.parse('0000FE0F-0000-1000-8000-00805F9B34FB');
    scanSubscription = _ble.scanForDevices(withService: uuid).listen((device) {
      if (devices.where((d) => d.id == device.id).isEmpty) {
        if (mounted) {
          setState(() {
            devices.add(device);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('BLE $_status'),
          ),
          body: Builder(
            builder: (context) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Tap on a device to connect it'),
                  Flexible(
                    child: ListView(
                      children: devices
                          .map(
                            (device) => ListTile(
                              title: Text("${device.name} ${device.id}"),
                              onTap: () {
                                scanSubscription.cancel();
                                Navigator.push<Widget>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DeviceDetailScreen(
                                      device: device,
                                      ble: _ble,
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
