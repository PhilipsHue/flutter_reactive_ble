import 'package:meta/meta.dart';

@immutable
class GenericFailure<T> {
  final T code;
  final String message;

  const GenericFailure({@required this.code, @required this.message});

  @override
  String toString() => "$runtimeType(code: $code, message: \"$message\")";
}
