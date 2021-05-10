import 'package:meta/meta.dart';

abstract class DiscoveredDevicesRegistry {
  DiscoveredDevicesRegistry({required this.getTimestamp});

  final DateTime Function() getTimestamp;

  void add(String deviceId);

  void remove(String deviceId);

  bool isEmpty();

  bool deviceIsDiscoveredRecently(
      {required String deviceId, required Duration cacheValidity});
}

class DiscoveredDevicesRegistryImpl implements DiscoveredDevicesRegistry {
  DiscoveredDevicesRegistryImpl({required this.getTimestamp});

  DiscoveredDevicesRegistryImpl.standard()
      : this(getTimestamp: () => DateTime.now());

  @override
  final DateTime Function() getTimestamp;

  @visibleForTesting
  final discoveredDevices = <String, DateTime>{};

  @override
  void add(String deviceId) {
    discoveredDevices[deviceId] = getTimestamp();
  }

  @override
  void remove(String deviceId) {
    discoveredDevices.remove(deviceId);
  }

  @override
  bool isEmpty() => discoveredDevices.isEmpty;

  @override
  bool deviceIsDiscoveredRecently({
    required String deviceId,
    required Duration cacheValidity,
  }) =>
      discoveredDevices.containsKey(deviceId) &&
      (discoveredDevices[deviceId]
              ?.isAfter(getTimestamp().subtract(cacheValidity)) ??
          false);
}
