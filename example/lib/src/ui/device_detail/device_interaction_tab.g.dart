// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_interaction_tab.dart';

// **************************************************************************
// FunctionalDataGenerator
// **************************************************************************

// ignore_for_file: join_return_with_assignment
// ignore_for_file: avoid_classes_with_only_static_members
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes
abstract class $DeviceInteractionViewModel {
  const $DeviceInteractionViewModel();
  String get deviceId;
  DeviceConnectionState get connectionStatus;
  BleDeviceConnector get deviceConnector;
  Future<List<DiscoveredService>> Function() get discoverServices;
  DeviceInteractionViewModel copyWith(
          {String? deviceId,
          DeviceConnectionState? connectionStatus,
          BleDeviceConnector? deviceConnector,
          Future<List<DiscoveredService>> Function()? discoverServices}) =>
      DeviceInteractionViewModel(
          deviceId: deviceId ?? this.deviceId,
          connectionStatus: connectionStatus ?? this.connectionStatus,
          deviceConnector: deviceConnector ?? this.deviceConnector,
          discoverServices: discoverServices ?? this.discoverServices);
  @override
  String toString() =>
      "DeviceInteractionViewModel(deviceId: $deviceId, connectionStatus: $connectionStatus, deviceConnector: $deviceConnector, discoverServices: $discoverServices)";
  @override
  bool operator ==(Object other) =>
      other is DeviceInteractionViewModel &&
      other.runtimeType == runtimeType &&
      deviceId == other.deviceId &&
      connectionStatus == other.connectionStatus &&
      deviceConnector == other.deviceConnector &&
      const Ignore().equals(discoverServices, other.discoverServices);
  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + deviceId.hashCode;
    result = 37 * result + connectionStatus.hashCode;
    result = 37 * result + deviceConnector.hashCode;
    result = 37 * result + const Ignore().hash(discoverServices);
    return result;
  }
}

class DeviceInteractionViewModel$ {
  static final deviceId = Lens<DeviceInteractionViewModel, String>(
      (s_) => s_.deviceId, (s_, deviceId) => s_.copyWith(deviceId: deviceId));
  static final connectionStatus =
      Lens<DeviceInteractionViewModel, DeviceConnectionState>(
          (s_) => s_.connectionStatus,
          (s_, connectionStatus) =>
              s_.copyWith(connectionStatus: connectionStatus));
  static final deviceConnector =
      Lens<DeviceInteractionViewModel, BleDeviceConnector>(
          (s_) => s_.deviceConnector,
          (s_, deviceConnector) =>
              s_.copyWith(deviceConnector: deviceConnector));
  static final discoverServices = Lens<DeviceInteractionViewModel,
          Future<List<DiscoveredService>> Function()>(
      (s_) => s_.discoverServices,
      (s_, discoverServices) =>
          s_.copyWith(discoverServices: discoverServices));
}
