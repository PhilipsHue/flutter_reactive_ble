import 'package:meta/meta.dart';

import 'uuid.dart';

@immutable
class CharacteristicInstance {
  /// Unique uuid of the specific characteristic
  final Uuid characteristicId;

  /// When empty, the first characteristic with [characteristicId] is used
  final String characteristicInstanceId;

  /// Service uuid of the characteristic
  final Uuid serviceId;

  /// When empty, the first service with [serviceId] is used
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
  String toString() => "$runtimeType(characteristicId: $characteristicId, serviceId: $serviceId, deviceId: $deviceId)";

  // @override
  // int get hashCode => Object.hash(
  //       characteristicId,
  //       characteristicInstanceId,
  //       serviceId,
  //       serviceInstanceId,
  //       deviceId,
  //     );

  @override
  bool operator ==(Object other) =>
      other is CharacteristicInstance &&
      runtimeType == other.runtimeType &&
      characteristicId == other.characteristicId &&
      (characteristicInstanceId == other.characteristicInstanceId ||
          characteristicInstanceId.isEmpty ||
          other.characteristicInstanceId.isEmpty) &&
      serviceId == other.serviceId &&
      (serviceInstanceId == other.serviceInstanceId || serviceInstanceId.isEmpty || other.serviceInstanceId.isEmpty) &&
      deviceId == other.deviceId;
}
