import 'package:meta/meta.dart';

import 'generic_failure.dart';
import 'qualified_characteristic.dart';
import 'result.dart';
import 'unit.dart';

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
      ((17 * 37) + characteristic.hashCode) * 37 + result.hashCode;

  @override
  bool operator ==(Object other) =>
      runtimeType == other.runtimeType &&
      other is WriteCharacteristicInfo &&
      characteristic == other.characteristic &&
      result == other.result;
}

enum WriteCharacteristicFailure { unknown }
