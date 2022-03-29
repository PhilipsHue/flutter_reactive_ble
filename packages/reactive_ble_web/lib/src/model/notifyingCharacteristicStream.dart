import 'dart:async';

import 'package:flutter_web_bluetooth/flutter_web_bluetooth.dart';

class NotifyingCharacteristicStream {
  final BluetoothCharacteristic characteristic;
  final StreamSubscription stream;

  const NotifyingCharacteristicStream({
    required this.characteristic,
    required this.stream,
  });
}
