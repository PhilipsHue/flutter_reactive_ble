import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble_example/src/ble/ble_device_interactor.dart';
import 'package:provider/provider.dart';

class CharacteristicInteractionDialog extends StatelessWidget {
  const CharacteristicInteractionDialog({
    required this.characteristic,
    Key? key,
  }) : super(key: key);
  final Characteristic characteristic;

  @override
  Widget build(BuildContext context) => Consumer<BleDeviceInteractor>(
        builder: (context, interactor, _) => _CharacteristicInteractionDialog(characteristic: characteristic),
      );
}

class _CharacteristicInteractionDialog extends StatefulWidget {
  const _CharacteristicInteractionDialog({
    required this.characteristic,
    Key? key,
  }) : super(key: key);

  final Characteristic characteristic;

  @override
  _CharacteristicInteractionDialogState createState() => _CharacteristicInteractionDialogState();
}

class _CharacteristicInteractionDialogState extends State<_CharacteristicInteractionDialog> {
  late String readOutput;
  late String writeOutput;
  late String subscribeOutput;
  late TextEditingController textEditingController;
  late StreamSubscription<List<int>>? subscribeStream;

  @override
  void initState() {
    readOutput = '';
    writeOutput = '';
    subscribeOutput = '';
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    subscribeStream?.cancel();
    super.dispose();
  }

  Future<void> subscribeCharacteristic() async {
    subscribeStream = widget.characteristic.subscribe().listen((event) {
      setState(() {
        subscribeOutput = event.toString();
      });
    });
    setState(() {
      subscribeOutput = 'Notification set';
    });
  }

  Future<void> readCharacteristic() async {
    final result = await widget.characteristic.read();
    setState(() {
      readOutput = result.toString();
    });
  }

  List<int> _parseInput() => textEditingController.text.split(',').map(int.parse).toList();

  Future<void> writeCharacteristicWithResponse() async {
    await widget.characteristic.write(_parseInput());
    setState(() {
      writeOutput = 'Ok';
    });
  }

  Future<void> writeCharacteristicWithoutResponse() async {
    await widget.characteristic.write(_parseInput(), withResponse: false);
    setState(() {
      writeOutput = 'Done';
    });
  }

  Widget sectionHeader(String text) => Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
      );

  List<Widget> get writeSection => [
        sectionHeader('Write characteristic'),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            controller: textEditingController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Value',
            ),
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: false,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: writeCharacteristicWithResponse,
              child: const Text('With response'),
            ),
            ElevatedButton(
              onPressed: writeCharacteristicWithoutResponse,
              child: const Text('Without response'),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 8.0),
          child: Text('Output: $writeOutput'),
        ),
      ];

  List<Widget> get readSection => [
        sectionHeader('Read characteristic'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: readCharacteristic,
              child: const Text('Read'),
            ),
            Text('Output: $readOutput'),
          ],
        ),
      ];

  List<Widget> get subscribeSection => [
        sectionHeader('Subscribe / notify'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: subscribeCharacteristic,
              child: const Text('Subscribe'),
            ),
            Text('Output: $subscribeOutput'),
          ],
        ),
      ];

  Widget get divider => const Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0),
        child: Divider(thickness: 2.0),
      );

  @override
  Widget build(BuildContext context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              const Text(
                'Select an operation',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  widget.characteristic.id.toString(),
                ),
              ),
              divider,
              ...readSection,
              divider,
              ...writeSection,
              divider,
              ...subscribeSection,
              divider,
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('close'),
                  ),
                ),
              )
            ],
          ),
        ),
      );
}
