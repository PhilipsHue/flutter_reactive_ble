import 'package:flutter_reactive_ble/src/model/generic_failure.dart';
import 'package:flutter_reactive_ble/src/model/qualified_characteristic.dart';
import 'package:flutter_reactive_ble/src/model/result.dart';
import 'package:meta/meta.dart';

class CharacteristicValue {
  final QualifiedCharacteristic characteristic;
  final Result<List<int>, GenericFailure<CharacteristicValueUpdateError>> result;

  const CharacteristicValue({@required this.characteristic, @required this.result});

  @override
  String toString() => "$runtimeType(characteristic: $characteristic, value: $result)";
}

enum CharacteristicValueUpdateError { unknown }
