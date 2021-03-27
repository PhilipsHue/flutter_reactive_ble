import 'package:flutter_reactive_ble/src/model/uuid.dart';

class ScanSession {
  final List<Uuid> withServices;
  final Future<void> future;

  const ScanSession({required this.withServices, required this.future});
}
