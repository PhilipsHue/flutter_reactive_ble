import 'package:meta/meta.dart';

class DiscoveredDevicesRegistry {
  DiscoveredDevicesRegistry({@required this.getTimestamp});

  DiscoveredDevicesRegistry.standard()
      : this(getTimestamp: () => DateTime.now());

  final DateTime Function() getTimestamp;
  @visibleForTesting
  final discoveredDevices = <String, DateTime>{};

  void add(String deviceId) {
    discoveredDevices[deviceId] = getTimestamp();
  }

  void remove(String deviceId) {
    discoveredDevices.remove(deviceId);
  }

  bool isEmpty() => discoveredDevices.isEmpty;

  bool deviceIsDiscoveredRecently({String deviceId, Duration cacheValidity}) =>
      discoveredDevices.containsKey(deviceId) &&
      discoveredDevices[deviceId]
          .isAfter(getTimestamp().subtract(cacheValidity));
}
