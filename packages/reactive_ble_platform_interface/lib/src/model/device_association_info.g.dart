// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_association_info.dart';

// **************************************************************************
// FunctionalDataGenerator
// **************************************************************************

abstract class $DeviceAssociationInfo {
  const $DeviceAssociationInfo();

  String get macAddress;

  DeviceAssociationInfo copyWith({
    String? macAddress,
  }) =>
      DeviceAssociationInfo(
        macAddress: macAddress ?? this.macAddress,
      );

  DeviceAssociationInfo copyUsing(
      void Function(DeviceAssociationInfo$Change change) mutator) {
    final change = DeviceAssociationInfo$Change._(
      this.macAddress,
    );
    mutator(change);
    return DeviceAssociationInfo(
      macAddress: change.macAddress,
    );
  }

  @override
  String toString() => "DeviceAssociationInfo(macAddress: $macAddress)";

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      other is DeviceAssociationInfo &&
      other.runtimeType == runtimeType &&
      macAddress == other.macAddress;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    return macAddress.hashCode;
  }
}

class DeviceAssociationInfo$Change {
  DeviceAssociationInfo$Change._(
    this.macAddress,
  );

  String macAddress;
}

// ignore: avoid_classes_with_only_static_members
class DeviceAssociationInfo$ {
  static final macAddress = Lens<DeviceAssociationInfo, String>(
    (macAddressContainer) => macAddressContainer.macAddress,
    (macAddressContainer, macAddress) =>
        macAddressContainer.copyWith(macAddress: macAddress),
  );
}
