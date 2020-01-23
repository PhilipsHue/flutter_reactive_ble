// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovered_device.dart';

// **************************************************************************
// FunctionalDataGenerator
// **************************************************************************

abstract class $DiscoveredDevice {
  String get id;
  String get name;
  Map<Uuid, Uint8List> get serviceData;
  int get rssi;
  const $DiscoveredDevice();
  DiscoveredDevice copyWith(
          {String id,
          String name,
          Map<Uuid, Uint8List> serviceData,
          int rssi}) =>
      DiscoveredDevice(
          id: id ?? this.id,
          name: name ?? this.name,
          serviceData: serviceData ?? this.serviceData,
          rssi: rssi ?? this.rssi);
  String toString() =>
      "DiscoveredDevice(id: $id, name: $name, serviceData: $serviceData, rssi: $rssi)";
  bool operator ==(dynamic other) =>
      other.runtimeType == runtimeType &&
      id == other.id &&
      name == other.name &&
      const DeepCollectionEquality().equals(serviceData, other.serviceData) &&
      const Ignore().equals(rssi, other.rssi);
  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + id.hashCode;
    result = 37 * result + name.hashCode;
    result = 37 * result + const DeepCollectionEquality().hash(serviceData);
    result = 37 * result + const Ignore().hash(rssi);
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
  static final rssi = Lens<DiscoveredDevice, int>(
      (s_) => s_.rssi, (s_, rssi) => s_.copyWith(rssi: rssi));
}
