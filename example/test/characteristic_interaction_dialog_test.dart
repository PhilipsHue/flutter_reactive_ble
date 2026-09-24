import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble_example/src/ble/ble_device_interactor.dart';
import 'package:flutter_reactive_ble_example/src/ui/device_detail/characteristic_interaction_dialog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  for (final subscribeTaps in [1, 2]) {
    testWidgets('closing the dialog cancels notifications after $subscribeTaps subscribe taps', (tester) async {
      final characteristic = _TestCharacteristic();
      addTearDown(() async {
        for (final updates in characteristic.updates) {
          await updates.close();
        }
      });

      await tester.pumpWidget(
        Provider<BleDeviceInteractor>(
          create: (_) => BleDeviceInteractor(
            bleDiscoverServices: (_) async => [],
            logMessage: (_) {},
            readRssi: (_) async => 0,
          ),
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (_) => CharacteristicInteractionDialog(characteristic: characteristic),
                  ),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      final subscribeButton = find.widgetWithText(ElevatedButton, 'Subscribe');
      await tester.ensureVisible(subscribeButton);
      for (var tap = 0; tap < subscribeTaps; tap++) {
        await tester.tap(subscribeButton);
      }
      await tester.pump();

      for (final updates in characteristic.updates) {
        updates.add([1, 2, 3]);
      }
      await tester.pump();
      expect(find.text('Output: [1, 2, 3]'), findsOneWidget);

      final closeButton = find.widgetWithText(ElevatedButton, 'close');
      await tester.ensureVisible(closeButton);
      await tester.tap(closeButton);
      await tester.pumpAndSettle();

      expect(find.byType(CharacteristicInteractionDialog), findsNothing);
      expect(characteristic.updates.where((updates) => updates.hasListener), isEmpty);
    });
  }
}

class _TestCharacteristic extends Fake implements Characteristic {
  final updates = <StreamController<List<int>>>[];

  @override
  Uuid get id => Uuid.parse('2a37');

  @override
  Stream<List<int>> subscribe() {
    final controller = StreamController<List<int>>();
    updates.add(controller);
    return controller.stream;
  }
}
