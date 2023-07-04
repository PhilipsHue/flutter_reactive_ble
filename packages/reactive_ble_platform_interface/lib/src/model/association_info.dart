import 'package:functional_data/functional_data.dart';
import 'package:meta/meta.dart';

part 'association_info.g.dart';

//ignore_for_file: annotate_overrides

@immutable
@FunctionalData()
class AssociationInfo extends $AssociationInfo {
  final String deviceMacAddress;

  const AssociationInfo({
    required this.deviceMacAddress,
  });
}
