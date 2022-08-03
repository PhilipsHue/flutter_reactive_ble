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
  Future<int> Function() get readRssi;

  DeviceInteractionViewModel copyWith({
    String? deviceId,
    DeviceConnectionState? connectionStatus,
    BleDeviceConnector? deviceConnector,
    Future<List<DiscoveredService>> Function()? discoverServices,
    Future<int> Function()? readRssi,
  }) =>
      DeviceInteractionViewModel(
        deviceId: deviceId ?? this.deviceId,
        connectionStatus: connectionStatus ?? this.connectionStatus,
        deviceConnector: deviceConnector ?? this.deviceConnector,
        discoverServices: discoverServices ?? this.discoverServices,
        readRssi: readRssi ?? this.readRssi,
      );

  DeviceInteractionViewModel copyUsing(
      void Function(DeviceInteractionViewModel$Change change) mutator) {
    final change = DeviceInteractionViewModel$Change._(
      this.deviceId,
      this.connectionStatus,
      this.deviceConnector,
      this.discoverServices,
      this.readRssi,
    );
    mutator(change);
    return DeviceInteractionViewModel(
      deviceId: change.deviceId,
      connectionStatus: change.connectionStatus,
      deviceConnector: change.deviceConnector,
      discoverServices: change.discoverServices,
      readRssi: change.readRssi,
    );
  }

  @override
  String toString() =>
      "DeviceInteractionViewModel(deviceId: $deviceId, connectionStatus: $connectionStatus, deviceConnector: $deviceConnector, discoverServices: $discoverServices, readRssi: $readRssi)";

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      other is DeviceInteractionViewModel &&
      other.runtimeType == runtimeType &&
      deviceId == other.deviceId &&
      connectionStatus == other.connectionStatus &&
      deviceConnector == other.deviceConnector &&
      const Ignore().equals(discoverServices, other.discoverServices) &&
      readRssi == other.readRssi;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    var result = 17;
    result = 37 * result + deviceId.hashCode;
    result = 37 * result + connectionStatus.hashCode;
    result = 37 * result + deviceConnector.hashCode;
    result = 37 * result + const Ignore().hash(discoverServices);
    result = 37 * result + readRssi.hashCode;
    return result;
  }
}

class DeviceInteractionViewModel$Change {
  DeviceInteractionViewModel$Change._(
    this.deviceId,
    this.connectionStatus,
    this.deviceConnector,
    this.discoverServices,
    this.readRssi,
  );

  String deviceId;
  DeviceConnectionState connectionStatus;
  BleDeviceConnector deviceConnector;
  Future<List<DiscoveredService>> Function() discoverServices;
  Future<int> Function() readRssi;
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

  static final readRssi =
      Lens<DeviceInteractionViewModel, Future<int> Function()>(
    (readRssiContainer) => readRssiContainer.readRssi,
    (readRssiContainer, readRssi) =>
        readRssiContainer.copyWith(readRssi: readRssi),
  );
}
