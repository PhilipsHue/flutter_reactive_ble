import 'package:meta/meta.dart';

class DiscoveredDevicesRegistry {
  DateTime Function() getTimestamp;

  DiscoveredDevicesRegistry() {
    getTimestamp = () => DateTime.now();
  }

  DiscoveredDevicesRegistry.withGetTimestamp(DateTime Function() dateFunction)
      :
        // ignore: prefer_initializing_formals
        getTimestamp = dateFunction;

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
