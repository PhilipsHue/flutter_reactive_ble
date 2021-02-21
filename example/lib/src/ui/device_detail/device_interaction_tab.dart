import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble_example/src/ble/ble_device_connector.dart';
import 'package:functional_data/functional_data.dart';
import 'package:provider/provider.dart';

part 'device_interaction_tab.g.dart';

class DeviceInteractionTab extends StatelessWidget {
  final DiscoveredDevice device;

  const DeviceInteractionTab({
    required this.device,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Consumer2<BleDeviceConnector, ConnectionStateUpdate?>(
        builder: (_, deviceConnector, connectionStateUpdate, __) =>
            _DeviceInteractionTab(
          viewModel: DeviceInteractionViewModel(
            deviceId: device.id,
            connectionStatus: connectionStateUpdate!.connectionState,
            deviceConnector: deviceConnector,
          ),
        ),
      );
}

@immutable
@FunctionalData()
class DeviceInteractionViewModel extends $DeviceInteractionViewModel {
  DeviceInteractionViewModel({
    required this.deviceId,
    required this.connectionStatus,
    required this.deviceConnector,
  });

  final String deviceId;
  final DeviceConnectionState connectionStatus;
  final BleDeviceConnector deviceConnector;

  bool get deviceConnected =>
      connectionStatus == DeviceConnectionState.connected;

  void connect() {
    deviceConnector.connect(deviceId);
  }

  void disconnect() {
    deviceConnector.disconnect(deviceId);
  }

  void discoverServices() {
    deviceConnector.discoverServices(deviceId);
  }
}

class _DeviceInteractionTab extends StatelessWidget {
  const _DeviceInteractionTab({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  final DeviceInteractionViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
          child: Text(
            "ID: ${viewModel.deviceId}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          "Status: ${viewModel.connectionStatus}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed:
                    !viewModel.deviceConnected ? viewModel.connect : null,
                child: const Text("Connect"),
              ),
              ElevatedButton(
                onPressed:
                    viewModel.deviceConnected ? viewModel.disconnect : null,
                child: const Text("Disconnect"),
              ),
              ElevatedButton(
                onPressed: viewModel.deviceConnected
                    ? viewModel.discoverServices
                    : null,
                child: const Text("Discover Services"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
