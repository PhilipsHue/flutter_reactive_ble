import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../src/utils.dart';
import '../src/widgets.dart';

final _serviceUuid = Uuid.parse("932C32BD-0000-47A2-835A-A8D455B859DD");
final _charUuid = Uuid.parse("932C32BD-0002-47A2-835A-A8D455B859DD");

class DeviceDetailScreen extends StatefulWidget {
  final DiscoveredDevice device;

  const DeviceDetailScreen({@required this.device}) : assert(device != null);

  @override
  State<StatefulWidget> createState() => _DetailState(device.id, device.name);
}

class _DetailState extends State<DeviceDetailScreen> {
  final _ble = FlutterReactiveBle();

  _DetailState(this.deviceId, this.deviceName);

  final String deviceId;
  final String deviceName;

  Stream<ConnectionStateUpdate> _connectedDeviceStream;
  Stream<List<int>> _charValueStream;
  StreamSubscription _currentValueUpdateSubscription;

  DeviceConnectionState _connectionState;
  int _currentValue;

  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _connectToDevice();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _currentValueUpdateSubscription?.cancel();
    _textController.dispose();
  }

  void _connectToDevice() {
    log("Connecting to $deviceName ($deviceId)");
    _connectedDeviceStream = _ble
        .connectToDevice(
          id: deviceId,
          connectionTimeout: const Duration(seconds: 10),
        )
        .asBroadcastStream();

    _charValueStream = _connectedDeviceStream
        .where((device) =>
            device.connectionState == DeviceConnectionState.connected)
        .take(1)
        .asyncExpand((_) {
      log("Connected to $deviceName ($deviceId), getting characteristic");

      return _ble.subscribeToCharacteristic(QualifiedCharacteristic(
        characteristicId: _charUuid,
        serviceId: _serviceUuid,
        deviceId: deviceId,
      ));
    });

    _currentValueUpdateSubscription =
        _charValueStream.listen((data) => _currentValue = data.first);

    _connectedDeviceStream
        .where((device) =>
            device.connectionState == DeviceConnectionState.connected)
        .first
        .then((_) => Future<void>.delayed(const Duration(milliseconds: 100)))
        .then((_) => _readCharacteristic());
  }

  Future<void> _readCharacteristic() async {
    log("Reading characteristic...");

    final result = await _ble.readCharacteristic(QualifiedCharacteristic(
      characteristicId: _charUuid,
      serviceId: _serviceUuid,
      deviceId: deviceId,
    ));

    setState(() => _currentValue = result.first);
    log("Characteristic read: $_currentValue");
  }

  Future<void> _writeCharacteristic() async {
    final value = _textController.text;

    log("Writing $value to characteristic...");
    await _ble.writeCharacteristicWithResponse(
      QualifiedCharacteristic(
        characteristicId: _charUuid,
        serviceId: _serviceUuid,
        deviceId: deviceId,
      ),
      value: utf8.encode(value),
    );
    log("Characteristic written");
  }

  bool get _isConnected => _connectionState == DeviceConnectionState.connected;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
              "${_isConnected ? 'Connected' : 'Connecting'} to: $deviceName"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Device ID: $deviceId'),
                StreamBuilder(
                  stream: _connectedDeviceStream,
                  builder: (_, AsyncSnapshot<ConnectionStateUpdate> snapshot) {
                    if (snapshot.hasData) {
                      WidgetsBinding.instance.addPostFrameCallback((_) =>
                          setState(() => _connectionState =
                              snapshot.data.connectionState));

                      return StatusMessage(
                          'Connection state is: ${snapshot.data.connectionState}');
                    } else {
                      return const StatusMessage('No data yet...');
                    }
                  },
                ),
                StreamBuilder(
                  stream: _charValueStream,
                  builder: (_, AsyncSnapshot<List<int>> snapshot) {
                    if (snapshot.hasData) {
                      return StatusMessage(
                          'Value for notification is: ${snapshot.data}');
                    } else if (_currentValue == null) {
                      return const StatusMessage(
                          'No data for characteristic retrieved yet...');
                    } else {
                      return StatusMessage(
                          'Value for notification is: $_currentValue');
                    }
                  },
                ),
                RaisedButton(
                  child: const Text('Read characteristic'),
                  onPressed: _isConnected ? _readCharacteristic : null,
                ),
                const SizedBox(height: 32),
                const Text('Write characteristic value:'),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        enabled: _isConnected,
                      ),
                    ),
                    const SizedBox(width: 16),
                    RaisedButton(
                      child: const Text('Write characteristic'),
                      onPressed: _isConnected && _textController.text.isNotEmpty
                          ? _writeCharacteristic
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: 64),
                if (_connectionState == DeviceConnectionState.disconnected)
                  RaisedButton(
                    child: const Text('Connect to device'),
                    onPressed: _connectToDevice,
                  ),
              ],
            ),
          ),
        ),
      );
}
