import 'package:flutter/material.dart';

import 'src/ui/device_list.dart';
import 'src/utils.dart';

const _themeColor = Colors.lightGreen;

void main() {
  FlutterError.onError = (error) {
    log("An error occurred: ${error.exception}");
    log(error.stack.toString());
  };

  runApp(const FlutterReactiveBleExampleApp());
}

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
