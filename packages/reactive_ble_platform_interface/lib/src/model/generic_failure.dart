import 'package:meta/meta.dart';

/// Error result of a BLE operation.
@immutable
class GenericFailure<T> {
  /// Code that classifies the failure.
  final T code;

  /// String that provides additional context of the failure.
  final String message;

  const GenericFailure({required this.code, required this.message});

  @override
  String toString() => "$runtimeType(code: $code, message: \"$message\")";

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GenericFailure &&
          code == other.code &&
          message == other.message);

  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + code.hashCode;
    result = 37 * result + message.hashCode;
    return result;
  }
}
