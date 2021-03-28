import 'package:flutter/widgets.dart';
import 'package:flutter_reactive_ble_example/src/ble/ble_logger.dart';
import 'package:provider/provider.dart';

class DeviceLogTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<BleLogger>(
      builder: (context, logger, _) => _DeviceLogTab(
        messages: logger.messages,
      ),
    );
  }
}

class _DeviceLogTab extends StatelessWidget {
  const _DeviceLogTab({
    required this.messages,
    Key? key,
  }) : super(key: key);

  final List<String> messages;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: ListView.builder(
        itemBuilder: (context, index) => Text(messages[index]),
        itemCount: messages.length,
      ),
    );
  }
}
