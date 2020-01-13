import 'package:meta/meta.dart';

@immutable
class Result<Value, Failure> {
  const Result.success(this._value)
      : _failure = null; // ignore: avoid_field_initializers_in_const_classes
  const Result.failure(this._failure)
      : assert(_failure != null),
        _value = null; // ignore: avoid_field_initializers_in_const_classes

  Value dematerialize() => iif(
        success: (value) => value,
        failure: (failure) {
          if (failure is Exception) {
            // ignore: only_throw_errors
            throw failure;
          } else {
            throw Exception(failure);
          }
        },
      );

  T iif<T>(
      {@required T Function(Value value) success,
      @required T Function(Failure failure) failure}) {
    assert(_value == null || _failure == null);

    if (_failure != null) {
      return failure(_failure);
    } else {
      return success(_value);
    }
  }

  @override
  String toString() {
    if (_value != null && _failure == null) {
      return "$runtimeType.success($_value)";
    } else if (_failure != null && _value == null) {
      return "$runtimeType.failure($_failure)";
    } else {
      return "$runtimeType._unsafe(value: $_value, failure: $_failure)";
    }
  }

  @override
  int get hashCode =>
      ((17 * 37) + (_value?.hashCode ?? 0)) * 37 + (_failure?.hashCode ?? 0);

  @override
  bool operator ==(dynamic other) =>
      runtimeType == other.runtimeType &&
      _value == other._value &&
      _failure == other._failure;

  final Value _value;
  final Failure _failure;
}
