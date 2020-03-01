import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble_example/src/ble/ble_device_connector.dart';
import 'package:flutter_reactive_ble_example/src/ble/ble_scanner.dart';
import 'package:flutter_reactive_ble_example/src/ble/ble_status_monitor.dart';
import 'package:flutter_reactive_ble_example/src/ui/device_list.dart';
import 'package:provider/provider.dart';

const _themeColor = Colors.lightGreen;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final _ble = FlutterReactiveBle();
  final _scanner = BleScanner(_ble);
  final _monitor = BleStatusMonitor(_ble);
  final _connector = BleDeviceConnector(_ble);
  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: _scanner),
        Provider.value(value: _monitor),
        Provider.value(value: _connector),
        StreamProvider<BleScannerState>(
          create: (_) => _scanner.state,
          initialData: const BleScannerState(
              discoveredDevices: [], scanIsInProgress: false),
        ),
        StreamProvider<BleStatus>(
          create: (_) => _monitor.state,
          initialData: BleStatus.unknown,
        ),
        StreamProvider<ConnectionStateUpdate>(
          create: (_) => _connector.state,
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Reactive BLE example',
        color: _themeColor,
        theme: ThemeData(primarySwatch: _themeColor),
        home: HomeScreen(),
      ),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<BleStatus>(
        builder: (_, status, __) {
          if (status == BleStatus.ready) {
            return DeviceListScreen();
          } else {
            return BleStatusScreen(status: status);
          }
        },
      );
}

class BleStatusScreen extends StatelessWidget {
  const BleStatusScreen({@required this.status, Key key})
      : assert(status != null),
        super(key: key);

  final BleStatus status;

  String determineText(BleStatus status) {
    switch (status) {
      case BleStatus.unknown:
        return "Waiting for ble lib to fetch status";
      case BleStatus.unsupported:
        return "This phone does not support BLE";
      case BleStatus.unauthorized:
        return "Authorize the FlutterReactiveBle example app to use bluetooth and location";
      case BleStatus.poweredOff:
        return "Ble is powered off on your device turn it on";
      case BleStatus.discoveryDisabled:
        return "Ble discovery is disabled turn on location services";
      case BleStatus.ready:
        return "Ble is up and running";
      default:
        throw AssertionError("This should not happen");
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Text(
            determineText(status),
          ),
        ),
      );
}
