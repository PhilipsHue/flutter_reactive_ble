import 'package:flutter/material.dart';

import 'ui/device_list.dart';

const _themeColor = Colors.lightGreen;

void main() => runApp(const FlutterReactiveBleExampleApp());

class FlutterReactiveBleExampleApp extends StatelessWidget {
  const FlutterReactiveBleExampleApp();

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Reactive BLE example',
        color: _themeColor,
        theme: ThemeData(primarySwatch: _themeColor),
        home: const DeviceList(),
      );
}
