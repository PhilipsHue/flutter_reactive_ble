import 'package:meta/meta.dart';

import 'uuid.dart';

/// Specific BLE characteristic for a BLE device characterised by [deviceId], [serviceId] and
/// [characteristicId].
@immutable
class DiscoveredCharacteristic {
  /// Unique uuid of the specific characteristic
  final Uuid characteristicId;

  /// Service uuid of the characteristic
  final Uuid serviceId;

  /// Properties
  final bool isReadable;
  final bool isWritableWithResponse;
  final bool isWritableWithoutResponse;
  final bool isNotifiable;
  final bool isIndicatable;

  const DiscoveredCharacteristic({
    required this.characteristicId,
    required this.serviceId,
    required this.isReadable,
    required this.isWritableWithResponse,
    required this.isWritableWithoutResponse,
    required this.isNotifiable,
    required this.isIndicatable,
  });

  @override
  String toString() =>
      "$runtimeType(characteristicId: $characteristicId, serviceId: $serviceId)";

  @override
  int get hashCode =>
      (((17 * 37) + characteristicId.hashCode) * 37 + serviceId.hashCode) * 37;

  @override
  bool operator ==(Object other) =>
      other is DiscoveredCharacteristic &&
      runtimeType == other.runtimeType &&
      characteristicId == other.characteristicId &&
      serviceId == other.serviceId;
}
