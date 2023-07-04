// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'association_info.dart';

// **************************************************************************
// FunctionalDataGenerator
// **************************************************************************

abstract class $AssociationInfo {
  const $AssociationInfo();

  String get deviceMacAddress;

  AssociationInfo copyWith({
    String? deviceMacAddress,
  }) =>
      AssociationInfo(
        deviceMacAddress: deviceMacAddress ?? this.deviceMacAddress,
      );

  AssociationInfo copyUsing(
      void Function(AssociationInfo$Change change) mutator) {
    final change = AssociationInfo$Change._(
      this.deviceMacAddress,
    );
    mutator(change);
    return AssociationInfo(
      deviceMacAddress: change.deviceMacAddress,
    );
  }

  @override
  String toString() => "AssociationInfo(deviceMacAddress: $deviceMacAddress)";

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      other is AssociationInfo &&
      other.runtimeType == runtimeType &&
      deviceMacAddress == other.deviceMacAddress;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    return deviceMacAddress.hashCode;
  }
}

class AssociationInfo$Change {
  AssociationInfo$Change._(
    this.deviceMacAddress,
  );

  String deviceMacAddress;
}

// ignore: avoid_classes_with_only_static_members
class AssociationInfo$ {
  static final deviceMacAddress = Lens<AssociationInfo, String>(
    (deviceMacAddressContainer) => deviceMacAddressContainer.deviceMacAddress,
    (deviceMacAddressContainer, deviceMacAddress) =>
        deviceMacAddressContainer.copyWith(deviceMacAddress: deviceMacAddress),
  );
}
