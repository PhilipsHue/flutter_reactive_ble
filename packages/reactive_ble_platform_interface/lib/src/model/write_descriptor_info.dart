import 'package:meta/meta.dart';

import 'generic_failure.dart';
import 'qualified_descriptor.dart';
import 'result.dart';
import 'unit.dart';

@immutable
class WriteDescriptorInfo {
  final QualifiedDescriptor descriptor;
  final Result<Unit, GenericFailure<WriteDescriptorFailure>?> result;

  const WriteDescriptorInfo({
    required this.descriptor,
    required this.result,
  });

  @override
  String toString() => "$runtimeType(descriptor: $descriptor, result: $result)";

  @override
  int get hashCode => ((17 * 37) + descriptor.hashCode) * 37 + result.hashCode;

  @override
  bool operator ==(Object other) =>
      runtimeType == other.runtimeType &&
      other is WriteDescriptorInfo &&
      descriptor == other.descriptor &&
      result == other.result;
}

enum WriteDescriptorFailure { unknown }
