import 'package:flutter/material.dart';

class BluetoothIcon extends StatelessWidget {
  const BluetoothIcon();

  @override
  Widget build(BuildContext context) => const SizedBox(
        width: 64,
        height: 64,
        child: Align(alignment: Alignment.center, child: Icon(Icons.bluetooth)),
      );
}

class StatusMessage extends StatelessWidget {
  const StatusMessage(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      );
}
