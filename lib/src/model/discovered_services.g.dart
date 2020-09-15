// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovered_services.dart';

// **************************************************************************
// FunctionalDataGenerator
// **************************************************************************

// ignore_for_file: join_return_with_assignment
// ignore_for_file: avoid_classes_with_only_static_members
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes
abstract class $DiscoverServicesInfo {
  const $DiscoverServicesInfo();
  String get deviceId;
  Result<List<DiscoveredService>, GenericFailure<DiscoverServicesFailure>>
      get result;
  DiscoverServicesInfo copyWith(
          {String deviceId,
          Result<List<DiscoveredService>,
                  GenericFailure<DiscoverServicesFailure>>
              result}) =>
      DiscoverServicesInfo(
          deviceId: deviceId ?? this.deviceId, result: result ?? this.result);
  @override
  String toString() =>
      "DiscoverServicesInfo(deviceId: $deviceId, result: $result)";
  @override
  bool operator ==(dynamic other) =>
      other.runtimeType == runtimeType &&
      deviceId == other.deviceId &&
      const DeepCollectionEquality().equals(result, other.result);
  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + deviceId.hashCode;
    result = 37 * result + const DeepCollectionEquality().hash(result);
    return result;
  }
}

class DiscoverServicesInfo$ {
  static final deviceId = Lens<DiscoverServicesInfo, String>(
      (s_) => s_.deviceId, (s_, deviceId) => s_.copyWith(deviceId: deviceId));
  static final result = Lens<
          DiscoverServicesInfo,
          Result<List<DiscoveredService>,
              GenericFailure<DiscoverServicesFailure>>>(
      (s_) => s_.result, (s_, result) => s_.copyWith(result: result));
}

// ignore_for_file: join_return_with_assignment
// ignore_for_file: avoid_classes_with_only_static_members
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes
abstract class $DiscoveredServices {
  const $DiscoveredServices();
  Uuid get serviceUuid;
  List<Uuid> get characteristics;
  List<DiscoveredService> get includedServices;
  DiscoveredService copyWith(
          {Uuid serviceUuid,
          List<Uuid> characteristics,
          List<DiscoveredService> includedServices}) =>
      DiscoveredService(
          serviceUuid: serviceUuid ?? this.serviceUuid,
          characteristics: characteristics ?? this.characteristics,
          includedServices: includedServices ?? this.includedServices);
  @override
  String toString() =>
      "DiscoveredServices(serviceUuid: $serviceUuid, characteristics: $characteristics, includedServices: $includedServices)";
  @override
  bool operator ==(dynamic other) =>
      other.runtimeType == runtimeType &&
      serviceUuid == other.serviceUuid &&
      const DeepCollectionEquality()
          .equals(characteristics, other.characteristics) &&
      const DeepCollectionEquality()
          .equals(includedServices, other.includedServices);
  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + serviceUuid.hashCode;
    result = 37 * result + const DeepCollectionEquality().hash(characteristics);
    result =
        37 * result + const DeepCollectionEquality().hash(includedServices);
    return result;
  }
}

class DiscoveredServices$ {
  static final serviceUuid = Lens<DiscoveredService, Uuid>(
      (s_) => s_.serviceUuid,
      (s_, serviceUuid) => s_.copyWith(serviceUuid: serviceUuid));
  static final characteristics = Lens<DiscoveredService, List<Uuid>>(
      (s_) => s_.characteristics,
      (s_, characteristics) => s_.copyWith(characteristics: characteristics));
  static final includedServices =
      Lens<DiscoveredService, List<DiscoveredService>>(
          (s_) => s_.includedServices,
          (s_, includedServices) =>
              s_.copyWith(includedServices: includedServices));
}
