import 'package:collection/collection.dart';
import 'package:functional_data/functional_data.dart';
import 'package:reactive_ble_platform_interface/src/model/discovered_characteristic.dart';

import 'uuid.dart';

part 'discovered_service.g.dart';
//ignore_for_file: annotate_overrides

@FunctionalData()
class DiscoveredService extends $DiscoveredService {
  const DiscoveredService({
    required this.serviceId,
    required this.characteristicIds,
    required this.characteristics,
    this.includedServices = const [],
  });

  final Uuid serviceId;

  @CustomEquality(DeepCollectionEquality())
  final List<Uuid> characteristicIds;

  @CustomEquality(DeepCollectionEquality())
  final List<DiscoveredCharacteristic> characteristics;

  @CustomEquality(DeepCollectionEquality())
  final List<DiscoveredService> includedServices;
}
