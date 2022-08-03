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
<<<<<<< HEAD
  Future<List<Service>> Function() get discoverServices;

  DeviceInteractionViewModel copyWith({
    String? deviceId,
    Connectable? connectableStatus,
    DeviceConnectionState? connectionStatus,
    BleDeviceConnector? deviceConnector,
    Future<List<Service>> Function()? discoverServices,
  }) =>
      DeviceInteractionViewModel(
        deviceId: deviceId ?? this.deviceId,
        connectableStatus: connectableStatus ?? this.connectableStatus,
        connectionStatus: connectionStatus ?? this.connectionStatus,
        deviceConnector: deviceConnector ?? this.deviceConnector,
        discoverServices: discoverServices ?? this.discoverServices,
=======
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
>>>>>>> c451aba (Read RSSI of connected device)
      );

  DeviceInteractionViewModel copyUsing(
      void Function(DeviceInteractionViewModel$Change change) mutator) {
    final change = DeviceInteractionViewModel$Change._(
      this.deviceId,
<<<<<<< HEAD
      this.connectableStatus,
      this.connectionStatus,
      this.deviceConnector,
      this.discoverServices,
=======
      this.connectionStatus,
      this.deviceConnector,
      this.discoverServices,
      this.readRssi,
>>>>>>> c451aba (Read RSSI of connected device)
    );
    mutator(change);
    return DeviceInteractionViewModel(
      deviceId: change.deviceId,
<<<<<<< HEAD
      connectableStatus: change.connectableStatus,
      connectionStatus: change.connectionStatus,
      deviceConnector: change.deviceConnector,
      discoverServices: change.discoverServices,
=======
      connectionStatus: change.connectionStatus,
      deviceConnector: change.deviceConnector,
      discoverServices: change.discoverServices,
      readRssi: change.readRssi,
>>>>>>> c451aba (Read RSSI of connected device)
    );
  }

  @override
  String toString() =>
<<<<<<< HEAD
      "DeviceInteractionViewModel(deviceId: $deviceId, connectableStatus: $connectableStatus, connectionStatus: $connectionStatus, deviceConnector: $deviceConnector, discoverServices: $discoverServices)";
=======
      "DeviceInteractionViewModel(deviceId: $deviceId, connectionStatus: $connectionStatus, deviceConnector: $deviceConnector, discoverServices: $discoverServices, readRssi: $readRssi)";
>>>>>>> c451aba (Read RSSI of connected device)

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      other is DeviceInteractionViewModel &&
      other.runtimeType == runtimeType &&
      deviceId == other.deviceId &&
      connectableStatus == other.connectableStatus &&
      connectionStatus == other.connectionStatus &&
      deviceConnector == other.deviceConnector &&
<<<<<<< HEAD
      const Ignore().equals(discoverServices, other.discoverServices);
=======
      const Ignore().equals(discoverServices, other.discoverServices) &&
      readRssi == other.readRssi;
>>>>>>> c451aba (Read RSSI of connected device)

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    var result = 17;
    result = 37 * result + deviceId.hashCode;
    result = 37 * result + connectableStatus.hashCode;
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
<<<<<<< HEAD
    this.connectableStatus,
    this.connectionStatus,
    this.deviceConnector,
    this.discoverServices,
  );

  String deviceId;
  Connectable connectableStatus;
  DeviceConnectionState connectionStatus;
  BleDeviceConnector deviceConnector;
  Future<List<Service>> Function() discoverServices;
=======
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
>>>>>>> c451aba (Read RSSI of connected device)
}

// ignore: avoid_classes_with_only_static_members
class DeviceInteractionViewModel$ {
  static final deviceId = Lens<DeviceInteractionViewModel, String>(
    (deviceIdContainer) => deviceIdContainer.deviceId,
    (deviceIdContainer, deviceId) =>
        deviceIdContainer.copyWith(deviceId: deviceId),
  );

<<<<<<< HEAD
  static final connectableStatus =
      Lens<DeviceInteractionViewModel, Connectable>(
    (connectableStatusContainer) =>
        connectableStatusContainer.connectableStatus,
    (connectableStatusContainer, connectableStatus) =>
        connectableStatusContainer.copyWith(
            connectableStatus: connectableStatus),
  );

=======
>>>>>>> c451aba (Read RSSI of connected device)
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
<<<<<<< HEAD
      Future<List<Service>> Function()>(
=======
      Future<List<DiscoveredService>> Function()>(
>>>>>>> c451aba (Read RSSI of connected device)
    (discoverServicesContainer) => discoverServicesContainer.discoverServices,
    (discoverServicesContainer, discoverServices) =>
        discoverServicesContainer.copyWith(discoverServices: discoverServices),
  );
<<<<<<< HEAD
=======

  static final readRssi =
      Lens<DeviceInteractionViewModel, Future<int> Function()>(
    (readRssiContainer) => readRssiContainer.readRssi,
    (readRssiContainer, readRssi) =>
        readRssiContainer.copyWith(readRssi: readRssi),
  );
>>>>>>> c451aba (Read RSSI of connected device)
}
