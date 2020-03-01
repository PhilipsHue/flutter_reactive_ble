import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble_example/src/ble/ble_device_connector.dart';
import 'package:provider/provider.dart';

class DeviceDetailScreen extends StatelessWidget {
  final DiscoveredDevice device;

  const DeviceDetailScreen({@required this.device}) : assert(device != null);

  @override
  Widget build(BuildContext context) =>
      Consumer2<BleDeviceConnector, ConnectionStateUpdate>(
        builder: (_, deviceConnector, connectionStateUpdate, __) =>
            _DeviceDetail(
          device: device,
          connectionUpdate: connectionStateUpdate != null &&
                  connectionStateUpdate.deviceId == device.id
              ? connectionStateUpdate
              : ConnectionStateUpdate(
                  deviceId: device.id,
                  connectionState: DeviceConnectionState.disconnected,
                  failure: null,
                ),
          connect: deviceConnector.connect,
          disconnect: deviceConnector.disconnect,
        ),
      );
}

class _DeviceDetail extends StatelessWidget {
  const _DeviceDetail({
    @required this.device,
    @required this.connectionUpdate,
    @required this.connect,
    @required this.disconnect,
    Key key,
  })  : assert(device != null),
        assert(connectionUpdate != null),
        assert(connect != null),
        assert(disconnect != null),
        super(key: key);

  final DiscoveredDevice device;
  final ConnectionStateUpdate connectionUpdate;
  final void Function(String deviceId) connect;
  final void Function(String deviceId) disconnect;

  bool _deviceConnected() =>
      connectionUpdate.connectionState == DeviceConnectionState.connected;

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          disconnect(device.id);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(device.name ?? "unknown"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Id: ${connectionUpdate.deviceId}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Status: ${connectionUpdate.connectionState}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        onPressed: !_deviceConnected()
                            ? () => connect(device.id)
                            : null,
                        child: const Text("Connect"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        onPressed: _deviceConnected()
                            ? () => disconnect(device.id)
                            : null,
                        child: const Text("Disconnect"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
