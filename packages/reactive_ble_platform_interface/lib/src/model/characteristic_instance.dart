import 'package:meta/meta.dart';

import 'uuid.dart';

@immutable
class CharacteristicInstance {
  /// Unique uuid of the specific characteristic
  final Uuid characteristicId;

  /// The id that identifies the specific instance of all characteristics with [characteristicId] in a given service.
  /// This should no be exposed to user of the plugin as it may be different each time a device is connected to, so it
  /// should not be used to identify characteristics across sessions.
  final String characteristicInstanceId;

  /// Service uuid of the characteristic
  final Uuid serviceId;

  /// The id that identifies the specific instance of all services with [serviceId] in a given device.
  /// This should no be exposed to user of the plugin as it may be different each time a device is connected to, so it
  /// should not be used to identify characteristics across sessions.
  final String serviceInstanceId;

  /// Device id of the BLE device
  final String deviceId;

  const CharacteristicInstance({
    required this.characteristicId,
    required this.characteristicInstanceId,
    required this.serviceId,
    required this.serviceInstanceId,
    required this.deviceId,
  });

  @override
  String toString() => "$runtimeType(characteristicId: $characteristicId($characteristicInstanceId), "
      "serviceId: $serviceId($serviceInstanceId), deviceId: $deviceId)";

  @override
  int get hashCode => Object.hash(
        characteristicId.expanded,
        characteristicInstanceId,
        serviceId.expanded,
        serviceInstanceId,
        deviceId,
      );

  @override
  bool operator ==(Object other) =>
      other is CharacteristicInstance &&
      runtimeType == other.runtimeType &&
      characteristicId.expanded == other.characteristicId.expanded &&
      characteristicInstanceId == other.characteristicInstanceId &&
      serviceId.expanded == other.serviceId.expanded &&
      serviceInstanceId == other.serviceInstanceId &&
      deviceId == other.deviceId;
}
