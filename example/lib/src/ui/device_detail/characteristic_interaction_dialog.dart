import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble_example/src/ble/ble_device_interactor.dart';
import 'package:provider/provider.dart';

class CharacteristicInteractionDialog extends StatelessWidget {
  const CharacteristicInteractionDialog({
    required this.characteristic,
    Key? key,
  }) : super(key: key);
  final QualifiedCharacteristic characteristic;

  @override
  Widget build(BuildContext context) {
    return Consumer<BleDeviceInteractor>(builder: (context, interactor, _) {
      return _CharacteristicInteractionDialog(
        characteristic: characteristic,
        readCharacteristic: interactor.readCharacteristic,
        writeWithResponse: interactor.writeCharacterisiticWithResponse,
        writeWithoutResponse: interactor.writeCharacterisiticWithoutResponse,
        subscribeToCharacteristic: interactor.subScribeToCharacteristic,
      );
    });
  }
}

class _CharacteristicInteractionDialog extends StatefulWidget {
  const _CharacteristicInteractionDialog({
    required this.characteristic,
    required this.readCharacteristic,
    required this.writeWithResponse,
    required this.writeWithoutResponse,
    required this.subscribeToCharacteristic,
    Key? key,
  }) : super(key: key);

  final QualifiedCharacteristic characteristic;
  final Future<List<int>> Function(QualifiedCharacteristic characteristic)
      readCharacteristic;
  final Future<void> Function(
          QualifiedCharacteristic characteristic, List<int> value)
      writeWithResponse;

  final Stream<List<int>?> Function(QualifiedCharacteristic characteristic)
      subscribeToCharacteristic;

  final Future<void> Function(
          QualifiedCharacteristic characteristic, List<int> value)
      writeWithoutResponse;

  @override
  _CharacteristicInteractionDialogState createState() =>
      _CharacteristicInteractionDialogState();
}

class _CharacteristicInteractionDialogState
    extends State<_CharacteristicInteractionDialog> {
  late String readOutput;
  late String writeOutput;
  late String subscribeOutput;
  late TextEditingController textEditingController;
  Stream<List<int>?>? subScribeStream;

  @override
  void initState() {
    readOutput = '';
    writeOutput = '';
    subscribeOutput = '';
    textEditingController = TextEditingController();
    super.initState();
  }

  Future<void> subscribeCharacteristic() async {
    subScribeStream = widget.subscribeToCharacteristic(widget.characteristic);
    setState(() {
      subscribeOutput = 'Done';
    });
  }

  Future<void> readCharacteristic() async {
    final result = await widget.readCharacteristic(widget.characteristic);
    setState(() {
      readOutput = result.toString();
    });
  }

  List<int> _parseInput() {
    return textEditingController.text
        .split(',')
        .map(
          (value) => int.parse(value),
        )
        .toList();
  }

  Future<void> writeCharacteristicWithResponse() async {
    await widget.writeWithResponse(widget.characteristic, _parseInput());
    setState(() {
      writeOutput = 'Ok';
    });
  }

  Future<void> writeCharacteristicWithoutResponse() async {
    await widget.writeWithoutResponse(widget.characteristic, _parseInput());
    setState(() {
      writeOutput = 'Done';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              child: Text(
                'Characteristic: ${widget.characteristic.characteristicId}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: readCharacteristic,
                  child: Text('Read'),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 14.0),
                  child: Text('Output: $readOutput'),
                ),
              ],
            ),
            Divider(
              thickness: 2.0,
            ),
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Value',
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: writeCharacteristicWithResponse,
                  child: Text('Write with response'),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 14.0),
                  child: Text('Output: $writeOutput'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: writeCharacteristicWithoutResponse,
              child: Text('Write without response'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              child: Text(
                'Characteristic: ${widget.characteristic.characteristicId}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: subscribeCharacteristic,
              child: Text('Subscribe/notify'),
            ),
            StreamBuilder<List<int>?>(
                stream: subScribeStream,
                builder: (context, value) {
                  return Padding(
                    padding: const EdgeInsetsDirectional.only(start: 14.0),
                    child: Text('Output: $value'),
                  );
                }),
            Divider(
              thickness: 2.0,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('close')),
              ),
            )
          ],
        ),
      ),
    );
  }
}
