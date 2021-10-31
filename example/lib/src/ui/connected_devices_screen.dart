import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble_example/src/ble/ble_device_interactor.dart';
import 'package:provider/provider.dart';

class ConnectedDevicesScreen extends StatelessWidget {
  const ConnectedDevicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<BleDeviceInteractor>(
        builder: (context, interactor, _) => _ConnectedDevicesScreen(
          deviceInteractor: interactor,
        ),
      );
}

class _ConnectedDevicesScreen extends StatefulWidget {
  const _ConnectedDevicesScreen({required this.deviceInteractor, Key? key})
      : super(key: key);

  final BleDeviceInteractor deviceInteractor;

  @override
  _ConnectedDevicesScreenState createState() => _ConnectedDevicesScreenState();
}

class _ConnectedDevicesScreenState extends State<_ConnectedDevicesScreen> {
  late bool _isFetchingDevices;
  late List<ConnectedDevice> _connectedDevices;

  @override
  void initState() {
    _isFetchingDevices = true;
    _connectedDevices = [];
    fetchDevices();
    super.initState();
  }

  Future<void> fetchDevices() async {
    final tmp = await widget.deviceInteractor.getConnectedDevices();

    setState(() {
      _connectedDevices = tmp;
      _isFetchingDevices = false;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Connected devices'),
        ),
        body: _isFetchingDevices
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _connectedDevices.isNotEmpty
                          ? ListView.builder(
                              itemBuilder: (context, index) {
                                final connectedDevice =
                                    _connectedDevices[index];
                                return Text(
                                  '${connectedDevice.deviceId} - ${connectedDevice.deviceName}',
                                );
                              },
                              itemCount: _connectedDevices.length,
                            )
                          : const Text('No connected devices found'),
                    ),
                    ElevatedButton(
                      onPressed: fetchDevices,
                      child: const Text('Fetch again'),
                    )
                  ],
                ),
              ),
      );
}
