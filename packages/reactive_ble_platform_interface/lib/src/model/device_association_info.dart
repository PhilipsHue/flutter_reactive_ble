import 'package:functional_data/functional_data.dart';
import 'package:meta/meta.dart';

part 'device_association_info.g.dart';

//ignore_for_file: annotate_overrides

/// Result of a device association request performed by the Android companion
/// workflow. The resulting [macAddress] can be used to connect to the device
/// directly, without the need for a scan or location permission.
@immutable
@FunctionalData()
class DeviceAssociationInfo extends $DeviceAssociationInfo {
  /// The MAC address of the associated device.
  final String macAddress;

  /// Creates a [DeviceAssociationInfo] with the given [macAddress].
  const DeviceAssociationInfo({
    required this.macAddress,
  });
}
