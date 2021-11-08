// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovered_device.dart';

// **************************************************************************
// FunctionalDataGenerator
// **************************************************************************

abstract class $ScanResult {
  const $ScanResult();

  Result<DiscoveredDevice, GenericFailure<ScanFailure>?> get result;

  ScanResult copyWith({
    Result<DiscoveredDevice, GenericFailure<ScanFailure>?>? result,
  }) =>
      ScanResult(
        result: result ?? this.result,
      );

  ScanResult copyUsing(void Function(ScanResult$Change change) mutator) {
    final change = ScanResult$Change._(
      this.result,
    );
    mutator(change);
    return ScanResult(
      result: change.result,
    );
  }

  @override
  String toString() => "ScanResult(result: $result)";

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      other is ScanResult &&
      other.runtimeType == runtimeType &&
      result == other.result;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    return result.hashCode;
  }
}

class ScanResult$Change {
  ScanResult$Change._(
    this.result,
  );

  Result<DiscoveredDevice, GenericFailure<ScanFailure>?> result;
}

// ignore: avoid_classes_with_only_static_members
class ScanResult$ {
  static final result =
      Lens<ScanResult, Result<DiscoveredDevice, GenericFailure<ScanFailure>?>>(
    (resultContainer) => resultContainer.result,
    (resultContainer, result) => resultContainer.copyWith(result: result),
  );
}

abstract class $DiscoveredDevice {
  const $DiscoveredDevice();

  String get id;
  String get name;
  Map<Uuid, Uint8List> get serviceData;
  List<Uuid> get serviceUuids;
  Uint8List get manufacturerData;
  int get rssi;

  DiscoveredDevice copyWith({
    String? id,
    String? name,
    Map<Uuid, Uint8List>? serviceData,
    List<Uuid>? serviceUuids,
    Uint8List? manufacturerData,
    int? rssi,
  }) =>
      DiscoveredDevice(
        id: id ?? this.id,
        name: name ?? this.name,
        serviceData: serviceData ?? this.serviceData,
        serviceUuids: serviceUuids ?? this.serviceUuids,
        manufacturerData: manufacturerData ?? this.manufacturerData,
        rssi: rssi ?? this.rssi,
      );

  DiscoveredDevice copyUsing(
      void Function(DiscoveredDevice$Change change) mutator) {
    final change = DiscoveredDevice$Change._(
      this.id,
      this.name,
      this.serviceData,
      this.serviceUuids,
      this.manufacturerData,
      this.rssi,
    );
    mutator(change);
    return DiscoveredDevice(
      id: change.id,
      name: change.name,
      serviceData: change.serviceData,
      serviceUuids: change.serviceUuids,
      manufacturerData: change.manufacturerData,
      rssi: change.rssi,
    );
  }

  @override
  String toString() =>
      "DiscoveredDevice(id: $id, name: $name, serviceData: $serviceData, serviceUuids: $serviceUuids, manufacturerData: $manufacturerData, rssi: $rssi)";

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      other is DiscoveredDevice &&
      other.runtimeType == runtimeType &&
      id == other.id &&
      name == other.name &&
      const DeepCollectionEquality().equals(serviceData, other.serviceData) &&
      const DeepCollectionEquality().equals(serviceUuids, other.serviceUuids) &&
      const DeepCollectionEquality()
          .equals(manufacturerData, other.manufacturerData) &&
      rssi == other.rssi;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    var result = 17;
    result = 37 * result + id.hashCode;
    result = 37 * result + name.hashCode;
    result = 37 * result + const DeepCollectionEquality().hash(serviceData);
    result = 37 * result + const DeepCollectionEquality().hash(serviceUuids);
    result =
        37 * result + const DeepCollectionEquality().hash(manufacturerData);
    result = 37 * result + rssi.hashCode;
    return result;
  }
}

class DiscoveredDevice$Change {
  DiscoveredDevice$Change._(
    this.id,
    this.name,
    this.serviceData,
    this.serviceUuids,
    this.manufacturerData,
    this.rssi,
  );

  String id;
  String name;
  Map<Uuid, Uint8List> serviceData;
  List<Uuid> serviceUuids;
  Uint8List manufacturerData;
  int rssi;
}

// ignore: avoid_classes_with_only_static_members
class DiscoveredDevice$ {
  static final id = Lens<DiscoveredDevice, String>(
    (idContainer) => idContainer.id,
    (idContainer, id) => idContainer.copyWith(id: id),
  );

  static final name = Lens<DiscoveredDevice, String>(
    (nameContainer) => nameContainer.name,
    (nameContainer, name) => nameContainer.copyWith(name: name),
  );

  static final serviceData = Lens<DiscoveredDevice, Map<Uuid, Uint8List>>(
    (serviceDataContainer) => serviceDataContainer.serviceData,
    (serviceDataContainer, serviceData) =>
        serviceDataContainer.copyWith(serviceData: serviceData),
  );

  static final serviceUuids = Lens<DiscoveredDevice, List<Uuid>>(
    (serviceUuidsContainer) => serviceUuidsContainer.serviceUuids,
    (serviceUuidsContainer, serviceUuids) =>
        serviceUuidsContainer.copyWith(serviceUuids: serviceUuids),
  );

  static final manufacturerData = Lens<DiscoveredDevice, Uint8List>(
    (manufacturerDataContainer) => manufacturerDataContainer.manufacturerData,
    (manufacturerDataContainer, manufacturerData) =>
        manufacturerDataContainer.copyWith(manufacturerData: manufacturerData),
  );

  static final rssi = Lens<DiscoveredDevice, int>(
    (rssiContainer) => rssiContainer.rssi,
    (rssiContainer, rssi) => rssiContainer.copyWith(rssi: rssi),
  );
}
