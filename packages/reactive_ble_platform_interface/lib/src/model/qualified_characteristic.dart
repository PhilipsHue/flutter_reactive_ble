import 'package:meta/meta.dart';

import 'uuid.dart';

/// Specific BLE characteristic for a BLE device characterised by [deviceId], [serviceId] and
/// [characteristicId].
@immutable
class QualifiedCharacteristic {
  /// Unique uuid of the specific characteristic
  final Uuid characteristicId;

  /// Service uuid of the characteristic
  final Uuid serviceId;

  /// Device id of the BLE device
  final String deviceId;

  const QualifiedCharacteristic({
    required this.characteristicId,
    required this.serviceId,
    required this.deviceId,
  });

  @override
  String toString() =>
      "$runtimeType(characteristicId: $characteristicId, serviceId: $serviceId, deviceId: $deviceId)";

  @override
  int get hashCode =>
      (((17 * 37) + characteristicId.hashCode) * 37 + serviceId.hashCode) * 37 +
      deviceId.hashCode;

  @override
  bool operator ==(Object other) =>
      other is QualifiedCharacteristic &&
      runtimeType == other.runtimeType &&
      characteristicId == other.characteristicId &&
      serviceId == other.serviceId &&
      deviceId == other.deviceId;
}
