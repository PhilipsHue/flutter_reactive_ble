// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovered_service.dart';

// **************************************************************************
// FunctionalDataGenerator
// **************************************************************************

abstract class $DiscoveredService {
  const $DiscoveredService();

  Uuid get serviceId;
  List<Uuid> get characteristicIds;
  List<DiscoveredCharacteristic> get characteristics;
  List<DiscoveredService> get includedServices;

  DiscoveredService copyWith({
    Uuid? serviceId,
    List<Uuid>? characteristicIds,
    List<DiscoveredCharacteristic>? characteristics,
    List<DiscoveredService>? includedServices,
  }) =>
      DiscoveredService(
        serviceId: serviceId ?? this.serviceId,
        characteristicIds: characteristicIds ?? this.characteristicIds,
        characteristics: characteristics ?? this.characteristics,
        includedServices: includedServices ?? this.includedServices,
      );

  DiscoveredService copyUsing(
      void Function(DiscoveredService$Change change) mutator) {
    final change = DiscoveredService$Change._(
      this.serviceId,
      this.characteristicIds,
      this.characteristics,
      this.includedServices,
    );
    mutator(change);
    return DiscoveredService(
      serviceId: change.serviceId,
      characteristicIds: change.characteristicIds,
      characteristics: change.characteristics,
      includedServices: change.includedServices,
    );
  }

  @override
  String toString() =>
      "DiscoveredService(serviceId: $serviceId, characteristicIds: $characteristicIds, characteristics: $characteristics, includedServices: $includedServices)";

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      other is DiscoveredService &&
      other.runtimeType == runtimeType &&
      serviceId == other.serviceId &&
      const DeepCollectionEquality()
          .equals(characteristicIds, other.characteristicIds) &&
      const DeepCollectionEquality()
          .equals(characteristics, other.characteristics) &&
      const DeepCollectionEquality()
          .equals(includedServices, other.includedServices);

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    var result = 17;
    result = 37 * result + serviceId.hashCode;
    result =
        37 * result + const DeepCollectionEquality().hash(characteristicIds);
    result = 37 * result + const DeepCollectionEquality().hash(characteristics);
    result =
        37 * result + const DeepCollectionEquality().hash(includedServices);
    return result;
  }
}

class DiscoveredService$Change {
  DiscoveredService$Change._(
    this.serviceId,
    this.characteristicIds,
    this.characteristics,
    this.includedServices,
  );

  Uuid serviceId;
  List<Uuid> characteristicIds;
  List<DiscoveredCharacteristic> characteristics;
  List<DiscoveredService> includedServices;
}

// ignore: avoid_classes_with_only_static_members
class DiscoveredService$ {
  static final serviceId = Lens<DiscoveredService, Uuid>(
    (serviceIdContainer) => serviceIdContainer.serviceId,
    (serviceIdContainer, serviceId) =>
        serviceIdContainer.copyWith(serviceId: serviceId),
  );

  static final characteristicIds = Lens<DiscoveredService, List<Uuid>>(
    (characteristicIdsContainer) =>
        characteristicIdsContainer.characteristicIds,
    (characteristicIdsContainer, characteristicIds) =>
        characteristicIdsContainer.copyWith(
            characteristicIds: characteristicIds),
  );

  static final characteristics =
      Lens<DiscoveredService, List<DiscoveredCharacteristic>>(
    (characteristicsContainer) => characteristicsContainer.characteristics,
    (characteristicsContainer, characteristics) =>
        characteristicsContainer.copyWith(characteristics: characteristics),
  );

  static final includedServices =
      Lens<DiscoveredService, List<DiscoveredService>>(
    (includedServicesContainer) => includedServicesContainer.includedServices,
    (includedServicesContainer, includedServices) =>
        includedServicesContainer.copyWith(includedServices: includedServices),
  );
}
