import 'characteristic_instance.dart';
import 'generic_failure.dart';
import 'result.dart';

/// Value update for specific [CharacteristicInstance].
class CharacteristicValue {
  final CharacteristicInstance characteristic;
  final Result<List<int>, GenericFailure<CharacteristicValueUpdateError>?>
      result;

  const CharacteristicValue(
      {required this.characteristic, required this.result});

  @override
  String toString() =>
      "$runtimeType(characteristic: $characteristic, value: $result)";
}

/// Error type for characteristic value update.
enum CharacteristicValueUpdateError { unknown }
