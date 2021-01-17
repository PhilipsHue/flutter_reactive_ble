import 'package:collection/collection.dart';
import 'package:flutter_reactive_ble/src/model/uuid.dart';
import 'package:functional_data/functional_data.dart';

part 'discovered_service.g.dart';
//ignore_for_file: annotate_overrides

@FunctionalData()
class DiscoveredService extends $DiscoveredService {
  const DiscoveredService({
    required this.serviceId,
    required this.characteristicIds,
    this.includedServices = const [],
  });

  final Uuid serviceId;

  @CustomEquality(DeepCollectionEquality())
  final List<Uuid> characteristicIds;

  @CustomEquality(DeepCollectionEquality())
  final List<DiscoveredService> includedServices;
}
