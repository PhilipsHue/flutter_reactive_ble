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
    Key? key,
  }) : super(key: key);

  final QualifiedCharacteristic characteristic;
  final Future<List<int>> Function(QualifiedCharacteristic characteristic)
      readCharacteristic;
  final Future<void> Function(
          QualifiedCharacteristic characteristic, List<int> value)
      writeWithResponse;

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
  late TextEditingController textEditingController;

  @override
  void initState() {
    readOutput = '';
    writeOutput = '';
    textEditingController = TextEditingController();
    super.initState();
  }

  Future<void> readCharacteristic() async {
    final result = await widget.readCharacteristic(widget.characteristic);
    setState(() {
      readOutput = result.toString();
    });
  }

  Future<void> writeCharacteristicWithResponse() async {
    final value = int.parse(textEditingController.text);
    await widget.writeWithResponse(widget.characteristic, [value]);
    setState(() {
      writeOutput = 'Acknowledged';
    });
  }

  Future<void> writeCharacteristicWithoutResponse() async {
    final value = int.parse(textEditingController.text);
    await widget.writeWithoutResponse(widget.characteristic, [value]);
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
              keyboardType: TextInputType.numberWithOptions(decimal: false),
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
