import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:location_permissions/location_permissions.dart';


// This flutter app demonstrates an usage of the flutter_reactive_ble flutter plugin
// This app works only with BLE devices which advertise with a Nordic UART Service (NUS) UUID
Uuid _UART_UUID = Uuid.parse("6E400001-B5A3-F393-E0A9-E50E24DCCA9E");
Uuid _UART_RX   = Uuid.parse("6E400002-B5A3-F393-E0A9-E50E24DCCA9E");
Uuid _UART_TX   = Uuid.parse("6E400003-B5A3-F393-E0A9-E50E24DCCA9E");

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter_reactive_ble example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter_reactive_ble UART example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final flutterReactiveBle = FlutterReactiveBle();
  List<DiscoveredDevice> _foundBleUARTDevices = [];
  StreamSubscription<DiscoveredDevice> _scanStream;
  Stream<ConnectionStateUpdate> _currentConnectionStream;
  StreamSubscription<ConnectionStateUpdate> _connection;
  QualifiedCharacteristic _txCharacteristic;
  QualifiedCharacteristic _rxCharacteristic;
  Stream<List<int>> _receivedDataStream;
  TextEditingController _dataToSendText;
  bool _scanning = false;
  bool _connected = false;
  String _logTexts = "";
  List<String> _receivedData = [];
  int _numberOfMessagesReceived = 0;

  void initState() {
    super.initState();
    _dataToSendText = TextEditingController();
  }

  void refreshScreen() {
    setState(() {});
  }

  void _sendData() async {
      await flutterReactiveBle.writeCharacteristicWithResponse(_rxCharacteristic, value: _dataToSendText.text.codeUnits);
  }

  void onNewReceivedData(List<int> data) {
    _numberOfMessagesReceived += 1;
    _receivedData.add( _numberOfMessagesReceived.toString() + ": " + String.fromCharCodes(data));
    if (_receivedData.length > 5) {
      _receivedData.removeAt(0);
    }
    refreshScreen();
  }

  void _disconnect() async {
    await _connection.cancel();
    _connected = false;
    refreshScreen();
  }

  void _stopScan() async {
    await _scanStream.cancel();
    _scanning = false;
    refreshScreen();
  }

  Future<void> showNoPermissionDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No location permission '),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('No location permission granted.'),
                Text('Location permission is required for BLE to function.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Acknowledge'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _startScan() async {
    PermissionStatus permission;
    permission = await LocationPermissions().requestPermissions();
    if (permission == PermissionStatus.granted) {
      _foundBleUARTDevices = [];
      _scanning = true;
      refreshScreen();
      _scanStream =
          flutterReactiveBle.scanForDevices(withServices: [_UART_UUID]).listen((
              device) {
            if (_foundBleUARTDevices.every((element) =>
            element.id != device.id)) {
              _foundBleUARTDevices.add(device);
              refreshScreen();
            }
          }, onError: (Object error) {
            _logTexts =
                _logTexts + "ERROR while scanning:" + error.toString() + " \n";
            refreshScreen();
          }
          );
    }
    else {
      await showNoPermissionDialog();
    }
  }

  void onConnectDevice(index) {
    _currentConnectionStream = flutterReactiveBle.connectToAdvertisingDevice(
      id:_foundBleUARTDevices[index].id,
      prescanDuration: Duration(seconds: 1),
      withServices: [_UART_UUID, _UART_RX, _UART_TX],
    );
    _logTexts = "";
    refreshScreen();
    _connection = _currentConnectionStream.listen((event) {
      String id = event.deviceId.toString();
      switch(event.connectionState) {
        case DeviceConnectionState.connecting:
          {
            _logTexts = _logTexts + "Connecting to ${id}\n";
            break;
          }
        case DeviceConnectionState.connected:
          {
            _connected = true;
            _logTexts = _logTexts + "Connected to ${id}\n";
            _numberOfMessagesReceived = 0;
            _receivedData = [];
            _txCharacteristic = QualifiedCharacteristic(serviceId: _UART_UUID, characteristicId: _UART_TX, deviceId: event.deviceId);
            _receivedDataStream = flutterReactiveBle.subscribeToCharacteristic(_txCharacteristic);
            _receivedDataStream.listen((data) {
               onNewReceivedData(data);
            }, onError: (dynamic error) {
              _logTexts = _logTexts + "Error: ${error} ${id}\n";
            });
            _rxCharacteristic = QualifiedCharacteristic(serviceId: _UART_UUID, characteristicId: _UART_RX, deviceId: event.deviceId);
            break;
          }
        case DeviceConnectionState.disconnecting:
          {
            _connected = false;
            _logTexts = _logTexts + "Disconnecting from ${id}\n";
            break;
          }
        case DeviceConnectionState.disconnected:
          {
            _logTexts = _logTexts + "Disconnected from ${id}\n";
            break;
          }
      }
      refreshScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("BLE UART Devices found:"),
            Container(
                margin: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.blue,
                  width:2
                )
              ),
              height: 100,
              child: ListView.builder(
                  itemCount: _foundBleUARTDevices.length,
                  itemBuilder: (context, index) {
                    return Card(
                        child: ListTile(
                          dense: true,
                          enabled: !((!_connected && _scanning) || (!_scanning && _connected)),
                          trailing: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              (!_connected && _scanning) || (!_scanning && _connected)? (){}: onConnectDevice(index);
                            },
                            child: Container(
                              width: 48,
                              height: 48,
                              padding: EdgeInsets.symmetric(vertical: 4.0),
                              alignment: Alignment.center,
                              child: Icon(Icons.add_link),
                            ),
                          ),
                          subtitle: Text(_foundBleUARTDevices[index].id),
                          title: Text(index.toString() + ":" +" "+_foundBleUARTDevices[index].name),
                    ));
                    }
              )
            ),
            Text("Status messages:"),
            Container(
                margin: const EdgeInsets.all(3.0),
               width:1400,
               decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(10),
               border: Border.all(
                  color: Colors.blue,
                  width:2
                  )
               ),
               height: 90,
               child: Scrollbar(

                   child: SingleChildScrollView(
                      child: Text(_logTexts)
               )
               )
            ),
            Text("Received data:"),
            Container(
                margin: const EdgeInsets.all(3.0),
                width:1400,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Colors.blue,
                        width:2
                    )
                ),
                height: 90,
                child: Text(_receivedData.join("\n"))
            ),
            Text("Send message:"),
            Container(
                margin: const EdgeInsets.all(3.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Colors.blue,
                        width:2
                    )
                ),
                child: Row(
                    children: <Widget> [
                      Expanded(
                          child: TextField(
                            enabled: _connected,
                            controller: _dataToSendText,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter a string'
                          ),
                        )
                      ),
                      RaisedButton(
                          child: Icon(
                            Icons.send,
                            color:_connected ? Colors.blue : Colors.grey,
                          ),
                          onPressed: _connected ? _sendData: (){}
                      ),
                    ]
            ))
           ],
        ),
      ),
      persistentFooterButtons: [
        Container(
          height: 35,
          child: Column(
            children: [
              _scanning ? Text("Scanning: Scanning") : Text("Scanning: Idle"),
              _connected ? Text("Connected"): Text("disconnected."),
            ],
          ) ,
        ),
        RaisedButton(
          onPressed: !_scanning && !_connected ? _startScan : (){},
          child: Icon(
            Icons.play_arrow,
            color: !_scanning && !_connected ? Colors.blue: Colors.grey,
          ),
        ),
        RaisedButton(
          onPressed: _scanning ? _stopScan: (){},
          child: Icon(
            Icons.stop,
            color:_scanning ? Colors.blue: Colors.grey,
          )
        ),
        RaisedButton(
            onPressed: _connected ? _disconnect: (){},
            child: Icon(
              Icons.cancel,
              color:_connected ? Colors.blue:Colors.grey,
        )
        )
      ],
    );
  }
}
