import 'package:collection/collection.dart';
import 'package:flutter_reactive_ble/src/model/result.dart';
import 'package:flutter_reactive_ble/src/model/uuid.dart';
import 'package:functional_data/functional_data.dart';
import 'package:meta/meta.dart';

import 'generic_failure.dart';

part 'discovered_services.g.dart';
//ignore_for_file: annotate_overrides

@FunctionalData()
class DiscoverServicesInfo extends $DiscoverServicesInfo {
  const DiscoverServicesInfo({
    @required this.deviceId,
    @required this.result,
  });

  final String deviceId;
  @CustomEquality(DeepCollectionEquality())
  final Result<List<DiscoveredServices>,
      GenericFailure<DiscoverServicesFailure>> result;
}

@FunctionalData()
class DiscoveredServices extends $DiscoveredServices {
  const DiscoveredServices({
    @required this.serviceUuid,
    @required this.characteristics,
    this.includedServices = const [],
  });

  final Uuid serviceUuid;

  @CustomEquality(DeepCollectionEquality())
  final List<Uuid> characteristics;

  @CustomEquality(DeepCollectionEquality())
  final List<DiscoveredServices> includedServices;
}

enum DiscoverServicesFailure { unknown }
