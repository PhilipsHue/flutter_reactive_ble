import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class _DetailState extends State<DeviceDetailScreen> {
  final String deviceId;
  final String deviceName;
  final FlutterReactiveBle ble;
  Stream<ConnectionStateUpdate> connectedDeviceStream;
  Stream<List<int>> charValueStream;
  StreamSubscription currentValueUpdateSubscription;
  int currentValue;

  final serviceUuid = Uuid.parse("932C32BD-0000-47A2-835A-A8D455B859DD");
  final charUuid = Uuid.parse("932C32BD-0002-47A2-835A-A8D455B859DD");

  _DetailState(this.deviceId, this.deviceName, this.ble);

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    super.dispose();
    currentValueUpdateSubscription.cancel();
  }

  void initPlatformState() {
    connectedDeviceStream = ble.connectToDevice(id: deviceId);

    charValueStream = connectedDeviceStream
        .where((device) => device.connectionState == DeviceConnectionState.connected)
        .take(1)
        .asyncExpand((d) => ble.subscribeToCharacteristic(QualifiedCharacteristic(
              characteristicId: charUuid,
              serviceId: serviceUuid,
              deviceId: deviceId,
            )));

    currentValueUpdateSubscription = charValueStream.listen((data) => currentValue = data.first);

    connectedDeviceStream
        .where((device) => device.connectionState == DeviceConnectionState.connected)
        .first
        .then((_) => Future<void>.delayed(const Duration(milliseconds: 20)))
        .then((_) => ble.readCharacteristic(QualifiedCharacteristic(
              characteristicId: charUuid,
              serviceId: serviceUuid,
              deviceId: deviceId,
            )));
  }

  Future<void> readCharacteristic() async {
    await ble.readCharacteristic(QualifiedCharacteristic(
      characteristicId: charUuid,
      serviceId: serviceUuid,
      deviceId: deviceId,
    ));
  }

  Future<void> writeCharacteristic() async {
    final value = currentValue == 0 ? 0x01 : 0x00;

    await ble.writeCharacteristicWithResponse(
      QualifiedCharacteristic(
        characteristicId: charUuid,
        serviceId: serviceUuid,
        deviceId: deviceId,
      ),
      value: List.of([value]),
    );
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('Device ID: $deviceId'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Device name: $deviceName"),
                StreamBuilder(
                    stream: connectedDeviceStream,
                    builder: (BuildContext context, AsyncSnapshot<ConnectionStateUpdate> snapshot) {
                      if (snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            "Connection state is: ${snapshot.data.connectionState}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      } else {
                        return const Text("No data");
                      }
                    }),
                StreamBuilder(
                    stream: charValueStream,
                    builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
                      if (snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            "Value for notification is: ${snapshot.data}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      } else {
                        return const Text("No data for characteristic retrieved");
                      }
                    }),
                FlatButton(
                  onPressed: readCharacteristic,
                  child: const Text("Read characteristic"),
                ),
                FlatButton(
                  onPressed: writeCharacteristic,
                  child: const Text("Write characteristic"),
                ),
              ],
            ),
          ),
        ),
      );
}

class DeviceDetailScreen extends StatefulWidget {
  final DiscoveredDevice device;
  final FlutterReactiveBle ble;

  const DeviceDetailScreen({@required this.device, @required this.ble});

  @override
  State<StatefulWidget> createState() => _DetailState(device.id, device.name, ble);
}
