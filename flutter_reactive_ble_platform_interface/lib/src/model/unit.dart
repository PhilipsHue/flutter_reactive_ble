import 'package:meta/meta.dart';

@immutable
class Unit {
  const Unit();

  @override
  bool operator ==(dynamic other) => other.runtimeType == runtimeType;

  @override
  int get hashCode => 1;
}
