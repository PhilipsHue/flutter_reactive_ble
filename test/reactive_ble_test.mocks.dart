import 'package:mockito/mockito.dart' as _i1;
import 'package:flutter_reactive_ble/src/plugin_controller.dart' as _i2;
import 'package:flutter_reactive_ble/src/debug_logger.dart' as _i3;
import 'package:flutter_reactive_ble/src/connected_device_operation.dart'
    as _i4;
import 'package:flutter_reactive_ble/src/device_connector.dart' as _i5;
import 'package:flutter_reactive_ble/src/device_scanner.dart' as _i6;

/// A class which mocks [BleOperationController].
///
/// See the documentation for Mockito's code generation for more information.
class MockBleOperationController extends _i1.Mock
    implements _i2.BleOperationController {
  MockBleOperationController() {
    _i1.throwOnMissingStub(this);
  }
}

/// A class which mocks [Logger].
///
/// See the documentation for Mockito's code generation for more information.
class MockLogger extends _i1.Mock implements _i3.Logger {
  MockLogger() {
    _i1.throwOnMissingStub(this);
  }
}

/// A class which mocks [ConnectedDeviceOperation].
///
/// See the documentation for Mockito's code generation for more information.
class MockConnectedDeviceOperation extends _i1.Mock
    implements _i4.ConnectedDeviceOperation {
  MockConnectedDeviceOperation() {
    _i1.throwOnMissingStub(this);
  }
}

/// A class which mocks [DeviceConnector].
///
/// See the documentation for Mockito's code generation for more information.
class MockDeviceConnector extends _i1.Mock implements _i5.DeviceConnector {
  MockDeviceConnector() {
    _i1.throwOnMissingStub(this);
  }
}

/// A class which mocks [DeviceScanner].
///
/// See the documentation for Mockito's code generation for more information.
class MockDeviceScanner extends _i1.Mock implements _i6.DeviceScanner {
  MockDeviceScanner() {
    _i1.throwOnMissingStub(this);
  }
}
