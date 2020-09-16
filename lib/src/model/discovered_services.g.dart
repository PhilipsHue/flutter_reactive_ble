// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovered_services.dart';

// **************************************************************************
// FunctionalDataGenerator
// **************************************************************************

// ignore_for_file: join_return_with_assignment
// ignore_for_file: avoid_classes_with_only_static_members
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes
abstract class $DiscoveredService {
  const $DiscoveredService();
  Uuid get serviceId;
  List<Uuid> get characteristicIds;
  List<DiscoveredService> get includedServices;
  DiscoveredService copyWith(
          {Uuid serviceId,
          List<Uuid> characteristicIds,
          List<DiscoveredService> includedServices}) =>
      DiscoveredService(
          serviceId: serviceId ?? this.serviceId,
          characteristicIds: characteristicIds ?? this.characteristicIds,
          includedServices: includedServices ?? this.includedServices);
  @override
  String toString() =>
      "DiscoveredService(serviceId: $serviceId, characteristicIds: $characteristicIds, includedServices: $includedServices)";
  @override
  bool operator ==(dynamic other) =>
      other.runtimeType == runtimeType &&
      serviceId == other.serviceId &&
      const DeepCollectionEquality()
          .equals(characteristicIds, other.characteristicIds) &&
      const DeepCollectionEquality()
          .equals(includedServices, other.includedServices);
  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + serviceId.hashCode;
    result =
        37 * result + const DeepCollectionEquality().hash(characteristicIds);
    result =
        37 * result + const DeepCollectionEquality().hash(includedServices);
    return result;
  }
}

class DiscoveredService$ {
  static final serviceId = Lens<DiscoveredService, Uuid>((s_) => s_.serviceId,
      (s_, serviceId) => s_.copyWith(serviceId: serviceId));
  static final characteristicIds = Lens<DiscoveredService, List<Uuid>>(
      (s_) => s_.characteristicIds,
      (s_, characteristicIds) =>
          s_.copyWith(characteristicIds: characteristicIds));
  static final includedServices =
      Lens<DiscoveredService, List<DiscoveredService>>(
          (s_) => s_.includedServices,
          (s_, includedServices) =>
              s_.copyWith(includedServices: includedServices));
}
