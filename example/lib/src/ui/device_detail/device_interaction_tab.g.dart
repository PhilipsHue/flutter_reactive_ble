// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_interaction_tab.dart';

// **************************************************************************
// FunctionalDataGenerator
// **************************************************************************

abstract class $DeviceInteractionViewModel {
  const $DeviceInteractionViewModel();

  String get deviceId;
  Connectable get connectableStatus;
  DeviceConnectionState get connectionStatus;
  BleDeviceConnector get deviceConnector;
  Future<int> Function() get readRssi;
  Future<List<Service>> Function() get discoverServices;

  DeviceInteractionViewModel copyWith({
    String? deviceId,
    Connectable? connectableStatus,
    DeviceConnectionState? connectionStatus,
    BleDeviceConnector? deviceConnector,
    Future<int> Function()? readRssi,
    Future<List<Service>> Function()? discoverServices,
  }) =>
      DeviceInteractionViewModel(
        deviceId: deviceId ?? this.deviceId,
        connectableStatus: connectableStatus ?? this.connectableStatus,
        connectionStatus: connectionStatus ?? this.connectionStatus,
        deviceConnector: deviceConnector ?? this.deviceConnector,
        readRssi: readRssi ?? this.readRssi,
        discoverServices: discoverServices ?? this.discoverServices,
      );

  DeviceInteractionViewModel copyUsing(
      void Function(DeviceInteractionViewModel$Change change) mutator) {
    final change = DeviceInteractionViewModel$Change._(
      this.deviceId,
      this.connectableStatus,
      this.connectionStatus,
      this.deviceConnector,
      this.readRssi,
      this.discoverServices,
    );
    mutator(change);
    return DeviceInteractionViewModel(
      deviceId: change.deviceId,
      connectableStatus: change.connectableStatus,
      connectionStatus: change.connectionStatus,
      deviceConnector: change.deviceConnector,
      readRssi: change.readRssi,
      discoverServices: change.discoverServices,
    );
  }

  @override
  String toString() =>
      "DeviceInteractionViewModel(deviceId: $deviceId, connectableStatus: $connectableStatus, connectionStatus: $connectionStatus, deviceConnector: $deviceConnector, readRssi: $readRssi, discoverServices: $discoverServices)";

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      other is DeviceInteractionViewModel &&
      other.runtimeType == runtimeType &&
      deviceId == other.deviceId &&
      connectableStatus == other.connectableStatus &&
      connectionStatus == other.connectionStatus &&
      deviceConnector == other.deviceConnector &&
      readRssi == other.readRssi &&
      const Ignore().equals(discoverServices, other.discoverServices);

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    var result = 17;
    result = 37 * result + deviceId.hashCode;
    result = 37 * result + connectableStatus.hashCode;
    result = 37 * result + connectionStatus.hashCode;
    result = 37 * result + deviceConnector.hashCode;
    result = 37 * result + readRssi.hashCode;
    result = 37 * result + const Ignore().hash(discoverServices);
    return result;
  }
}

class DeviceInteractionViewModel$Change {
  DeviceInteractionViewModel$Change._(
    this.deviceId,
    this.connectableStatus,
    this.connectionStatus,
    this.deviceConnector,
    this.readRssi,
    this.discoverServices,
  );

  String deviceId;
  Connectable connectableStatus;
  DeviceConnectionState connectionStatus;
  BleDeviceConnector deviceConnector;
  Future<int> Function() readRssi;
  Future<List<Service>> Function() discoverServices;
}

// ignore: avoid_classes_with_only_static_members
class DeviceInteractionViewModel$ {
  static final deviceId = Lens<DeviceInteractionViewModel, String>(
    (deviceIdContainer) => deviceIdContainer.deviceId,
    (deviceIdContainer, deviceId) =>
        deviceIdContainer.copyWith(deviceId: deviceId),
  );

  static final connectableStatus =
      Lens<DeviceInteractionViewModel, Connectable>(
    (connectableStatusContainer) =>
        connectableStatusContainer.connectableStatus,
    (connectableStatusContainer, connectableStatus) =>
        connectableStatusContainer.copyWith(
            connectableStatus: connectableStatus),
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

  static final readRssi =
      Lens<DeviceInteractionViewModel, Future<int> Function()>(
    (readRssiContainer) => readRssiContainer.readRssi,
    (readRssiContainer, readRssi) =>
        readRssiContainer.copyWith(readRssi: readRssi),
  );

  static final discoverServices =
      Lens<DeviceInteractionViewModel, Future<List<Service>> Function()>(
    (discoverServicesContainer) => discoverServicesContainer.discoverServices,
    (discoverServicesContainer, discoverServices) =>
        discoverServicesContainer.copyWith(discoverServices: discoverServices),
  );
}
