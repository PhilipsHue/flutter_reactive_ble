import 'package:flutter_reactive_ble/src/model/generic_failure.dart';
import 'package:flutter_reactive_ble/src/model/qualified_characteristic.dart';
import 'package:flutter_reactive_ble/src/model/result.dart';
import 'package:flutter_reactive_ble/src/model/unit.dart';
import 'package:meta/meta.dart';

@immutable
class WriteCharacteristicInfo {
  final QualifiedCharacteristic characteristic;
  final Result<Unit, GenericFailure<WriteCharacteristicFailure>?> result;

  const WriteCharacteristicInfo({
    required this.characteristic,
    required this.result,
  });

  @override
  String toString() =>
      "$runtimeType(characteristic: $characteristic, result: $result)";

  @override
  int get hashCode =>
      (((17 * 37) + characteristic.hashCode) * 37 + result.hashCode);

  @override
  bool operator ==(Object other) =>
      runtimeType == other.runtimeType &&
      other is WriteCharacteristicInfo &&
      characteristic == other.characteristic &&
      result == other.result;
}

enum WriteCharacteristicFailure { unknown }
