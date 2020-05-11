// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovered_device.dart';

// **************************************************************************
// FunctionalDataGenerator
// **************************************************************************

// ignore_for_file: join_return_with_assignment
// ignore_for_file: avoid_classes_with_only_static_members
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes
abstract class $DiscoveredDevice {
  const $DiscoveredDevice();
  String get id;
  String get name;
  Map<Uuid, Uint8List> get serviceData;
  Uint8List get manufacturerData;
  int get rssi;
  DiscoveredDevice copyWith(
          {String id,
          String name,
          Map<Uuid, Uint8List> serviceData,
          Uint8List manufacturerData,
          int rssi}) =>
      DiscoveredDevice(
          id: id ?? this.id,
          name: name ?? this.name,
          serviceData: serviceData ?? this.serviceData,
          manufacturerData: manufacturerData ?? this.manufacturerData,
          rssi: rssi ?? this.rssi);
  @override
  String toString() =>
      "DiscoveredDevice(id: $id, name: $name, serviceData: $serviceData, manufacturerData: $manufacturerData, rssi: $rssi)";
  @override
  bool operator ==(dynamic other) =>
      other.runtimeType == runtimeType &&
      id == other.id &&
      name == other.name &&
      const DeepCollectionEquality().equals(serviceData, other.serviceData) &&
      manufacturerData == other.manufacturerData &&
      rssi == other.rssi;
  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + id.hashCode;
    result = 37 * result + name.hashCode;
    result = 37 * result + const DeepCollectionEquality().hash(serviceData);
    result = 37 * result + manufacturerData.hashCode;
    result = 37 * result + rssi.hashCode;
    return result;
  }
}

class DiscoveredDevice$ {
  static final id = Lens<DiscoveredDevice, String>(
      (s_) => s_.id, (s_, id) => s_.copyWith(id: id));
  static final name = Lens<DiscoveredDevice, String>(
      (s_) => s_.name, (s_, name) => s_.copyWith(name: name));
  static final serviceData = Lens<DiscoveredDevice, Map<Uuid, Uint8List>>(
      (s_) => s_.serviceData,
      (s_, serviceData) => s_.copyWith(serviceData: serviceData));
  static final manufacturerData = Lens<DiscoveredDevice, Uint8List>(
      (s_) => s_.manufacturerData,
      (s_, manufacturerData) =>
          s_.copyWith(manufacturerData: manufacturerData));
  static final rssi = Lens<DiscoveredDevice, int>(
      (s_) => s_.rssi, (s_, rssi) => s_.copyWith(rssi: rssi));
}
