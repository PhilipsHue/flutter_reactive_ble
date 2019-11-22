import 'package:flutter_reactive_ble/src/model/uuid.dart';
import 'package:meta/meta.dart';

class ScanSession {
  final Uuid withService;
  final Future<void> future;

  const ScanSession({@required this.withService, @required this.future});
}
