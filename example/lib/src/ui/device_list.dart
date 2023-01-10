import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble_example/src/ble/ble_scanner.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';

import '../widgets.dart';
import 'device_detail/device_detail_screen.dart';

DiscoveredDevice _sampleDevice = DiscoveredDevice(
  //id: "\x95\xea\xb4rh\x82\U00000003He\x87\U00000006N\xbc\U00000016,\xa0",
  //id: '95eab472-6882-0348-6587-064ebc162ca0',//'EB:B1:88:2B:5C:FE',9A6F21BD-3DF6-4C29-EDEC-9B9E111309F4
  id: '68:9E:19:37:0C:30', //'17C3069C-4D6B-BF21-6B47-ED9826BF95A0',
  name: 'iNetBox',
  serviceUuids: const [],
  serviceData: const {},
  manufacturerData: Uint8List.fromList([1]) ,
  rssi: -40,
);

class DeviceListScreen extends StatelessWidget {
  const DeviceListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer2<BleScanner, BleScannerState?>(
        builder: (_, bleScanner, bleScannerState, __) => _DeviceList(
          scannerState: bleScannerState ??
              const BleScannerState(
                discoveredDevices: [],
                scanIsInProgress: false,
                  advertiseIsInProgress: false),
          startScan: bleScanner.startScan,
          stopScan: bleScanner.stopScan,
          startAdvertising: bleScanner.startAdvertising,
          stopAdvertising: bleScanner.stopAdvertising,
          writeSample: bleScanner.writeSample,
        ),
      );
}

class _DeviceList extends StatefulWidget {
  const _DeviceList({
    required this.scannerState,
      required this.startScan,
      required this.stopScan,
      required this.startAdvertising,
    required this.stopAdvertising,
    required this.writeSample,
  });

  final BleScannerState scannerState;
  final void Function(List<Uuid>) startScan;
  final VoidCallback stopScan;
  final VoidCallback startAdvertising;
  final VoidCallback stopAdvertising;
  final VoidCallback writeSample;

  @override
  _DeviceListState createState() => _DeviceListState();
}

class _DeviceListState extends State<_DeviceList> {
  late TextEditingController _uuidController;

  @override
  void initState() {
    super.initState();
    _uuidController = TextEditingController()
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    widget.stopScan();
    _uuidController.dispose();
    super.dispose();
  }

  bool _isValidUuidInput() {
    final uuidText = _uuidController.text;
    if (uuidText.isEmpty) {
      return true;
    } else {
      try {
        Uuid.parse(uuidText);
        return true;
      } on Exception {
        return false;
      }
    }
  }

  void _startScanning() {
    final text = _uuidController.text;
    widget.startScan(text.isEmpty ? [] : [Uuid.parse(_uuidController.text)]);
  }

  void _startAdvertising() {
    widget.startAdvertising();
  }

  void _stopAdvertising() {
    widget.stopAdvertising();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Scan for devices'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          child: const Text('Advertise'),
                        onPressed: !widget.scannerState.scanIsInProgress &&
                                !widget.scannerState.advertiseIsInProgress
                              ? _startAdvertising
                              : null,
                        ),
                        ElevatedButton(
                          child: const Text('Stop'),
                          onPressed: widget.scannerState.advertiseIsInProgress
                              ? _stopAdvertising
                              : null,
                        ),
                        ElevatedButton(
                          child: const Text('Connect'),
                          onPressed: () async {
                            widget.stopScan();
                            await Navigator.push<void>(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DeviceDetailScreen(
                                      device: _sampleDevice)));
                          },
                        ),
                      ElevatedButton(
                        child: const Text('write'),
                        onPressed: () async {
                          widget.writeSample();
                        },
                      ),
                      ],
                    ),
                  ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text('Service UUID (2, 4, 16 bytes):'),
                  TextField(
                    controller: _uuidController,
                    enabled: !widget.scannerState.scanIsInProgress,
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
                      ElevatedButton(
                        child: const Text('Scan'),
                        onPressed: !widget.scannerState.scanIsInProgress &&
                                _isValidUuidInput()
                            ? _startScanning
                            : null,
                      ),
                      ElevatedButton(
                        child: const Text('Stop'),
                        onPressed: widget.scannerState.scanIsInProgress
                            ? widget.stopScan
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(!widget.scannerState.scanIsInProgress
                            ? 'Enter a UUID above and tap start to begin scanning'
                            : 'Tap a device to connect to it'),
                      ),
                      if (widget.scannerState.scanIsInProgress ||
                          widget.scannerState.discoveredDevices.isNotEmpty)
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.only(start: 18.0),
                          child: Text(
                              'count: ${widget.scannerState.discoveredDevices.length}'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: ListView(
                children: widget.scannerState.discoveredDevices
                    .map(
                      (device) => ListTile(
                        title: Text(device.name),
                        subtitle: Text("${device.id}\nRSSI: ${device.rssi}"),
                        leading: const BluetoothIcon(),
                        onTap: () async {
                          widget.stopScan();
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
