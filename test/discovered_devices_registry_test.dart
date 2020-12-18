import 'package:flutter_reactive_ble/src/discovered_devices_registry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("$DiscoveredDevicesRegistry", () {
    DiscoveredDevicesRegistry sut;
    const device = "Testdevice";
    final timestamp = DateTime(2019);

    setUp(() {
      sut = DiscoveredDevicesRegistry(getTimestamp: () => timestamp);
    });
    group('Given device is added', () {
      setUp(() {
        sut.add(device);
      });

      test("Device is in cache", () {
        expect(
            sut.deviceIsDiscoveredRecently(
                deviceId: device, cacheValidity: const Duration(minutes: 10)),
            true);
      });

      test("Device is not in cache", () {
        expect(
            sut.deviceIsDiscoveredRecently(
                deviceId: "NotInCacheDevice",
                cacheValidity: const Duration(seconds: 10)),
            false);
      });

      test("Does not have duplicate entries", () {
        sut.add(device);

        expect(sut.discoveredDevices.length, 1);
      });

      test("Returns false when entry exceeds cache limit", () {
        final dateTime = DateTime(2018, 1, 1);

        final responses = [dateTime, timestamp];

        sut = DiscoveredDevicesRegistry(
          getTimestamp: () => responses.removeAt(0),
        )..add(device);

        expect(
            sut.deviceIsDiscoveredRecently(
                deviceId: device, cacheValidity: const Duration(days: 1)),
            false);
      });

      test("Registry is empty in case last device is removed", () {
        sut.remove(device);
        expect(sut.isEmpty(), true);
      });
    });
  });
}
