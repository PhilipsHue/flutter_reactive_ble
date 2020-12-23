import 'package:mockito/mockito.dart' as _i1;
import 'package:flutter_reactive_ble/src/plugin_controller.dart' as _i2;
import 'package:flutter_reactive_ble/src/device_scanner.dart' as _i3;
import 'package:flutter_reactive_ble/src/discovered_devices_registry.dart'
    as _i4;

/// A class which mocks [DeviceConnectionController].
///
/// See the documentation for Mockito's code generation for more information.
class MockDeviceConnectionController extends _i1.Mock
    implements _i2.DeviceConnectionController {
  MockDeviceConnectionController() {
    _i1.throwOnMissingStub(this);
  }
}

/// A class which mocks [DeviceScanner].
///
/// See the documentation for Mockito's code generation for more information.
class MockDeviceScanner extends _i1.Mock implements _i3.DeviceScanner {
  MockDeviceScanner() {
    _i1.throwOnMissingStub(this);
  }
}

/// A class which mocks [DiscoveredDevicesRegistry].
///
/// See the documentation for Mockito's code generation for more information.
class MockDiscoveredDevicesRegistry extends _i1.Mock
    implements _i4.DiscoveredDevicesRegistry {
  MockDiscoveredDevicesRegistry() {
    _i1.throwOnMissingStub(this);
  }
}
