// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_interaction_tab.dart';

// **************************************************************************
// FunctionalDataGenerator
// **************************************************************************

abstract class $DeviceInteractionViewModel {
  const $DeviceInteractionViewModel();

  String get deviceId;
  DeviceConnectionState get connectionStatus;
  BleDeviceConnector get deviceConnector;
  Future<List<DiscoveredService>> Function() get discoverServices;

  DeviceInteractionViewModel copyWith({
    String? deviceId,
    DeviceConnectionState? connectionStatus,
    BleDeviceConnector? deviceConnector,
    Future<List<DiscoveredService>> Function()? discoverServices,
  }) =>
      DeviceInteractionViewModel(
        deviceId: deviceId ?? this.deviceId,
        connectionStatus: connectionStatus ?? this.connectionStatus,
        deviceConnector: deviceConnector ?? this.deviceConnector,
        discoverServices: discoverServices ?? this.discoverServices,
      );

  DeviceInteractionViewModel copyUsing(
      void Function(DeviceInteractionViewModel$Change change) mutator) {
    final change = DeviceInteractionViewModel$Change._(
      this.deviceId,
      this.connectionStatus,
      this.deviceConnector,
      this.discoverServices,
    );
    mutator(change);
    return DeviceInteractionViewModel(
      deviceId: change.deviceId,
      connectionStatus: change.connectionStatus,
      deviceConnector: change.deviceConnector,
      discoverServices: change.discoverServices,
    );
  }

  @override
  String toString() =>
      "DeviceInteractionViewModel(deviceId: $deviceId, connectionStatus: $connectionStatus, deviceConnector: $deviceConnector, discoverServices: $discoverServices)";

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      other is DeviceInteractionViewModel &&
      other.runtimeType == runtimeType &&
      deviceId == other.deviceId &&
      connectionStatus == other.connectionStatus &&
      deviceConnector == other.deviceConnector &&
      const Ignore().equals(discoverServices, other.discoverServices);

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    var result = 17;
    result = 37 * result + deviceId.hashCode;
    result = 37 * result + connectionStatus.hashCode;
    result = 37 * result + deviceConnector.hashCode;
    result = 37 * result + const Ignore().hash(discoverServices);
    return result;
  }
}

class DeviceInteractionViewModel$Change {
  DeviceInteractionViewModel$Change._(
    this.deviceId,
    this.connectionStatus,
    this.deviceConnector,
    this.discoverServices,
  );

  String deviceId;
  DeviceConnectionState connectionStatus;
  BleDeviceConnector deviceConnector;
  Future<List<DiscoveredService>> Function() discoverServices;
}

// ignore: avoid_classes_with_only_static_members
class DeviceInteractionViewModel$ {
  static final deviceId = Lens<DeviceInteractionViewModel, String>(
    (deviceIdContainer) => deviceIdContainer.deviceId,
    (deviceIdContainer, deviceId) =>
        deviceIdContainer.copyWith(deviceId: deviceId),
  );

  static final connectionStatus =
      Lens<DeviceInteractionViewModel, DeviceConnectionState>(
    (connectionStatusContainer) => connectionStatusContainer.connectionStatus,
    (connectionStatusContainer, connectionStatus) =>
        connectionStatusContainer.copyWith(connectionStatus: connectionStatus),
  );

  static final deviceConnector =
      Lens<DeviceInteractionViewModel, BleDeviceConnector>(
    (deviceConnectorContainer) => deviceConnectorContainer.deviceConnector,
    (deviceConnectorContainer, deviceConnector) =>
        deviceConnectorContainer.copyWith(deviceConnector: deviceConnector),
  );

  static final discoverServices = Lens<DeviceInteractionViewModel,
      Future<List<DiscoveredService>> Function()>(
    (discoverServicesContainer) => discoverServicesContainer.discoverServices,
    (discoverServicesContainer, discoverServices) =>
        discoverServicesContainer.copyWith(discoverServices: discoverServices),
  );
}
