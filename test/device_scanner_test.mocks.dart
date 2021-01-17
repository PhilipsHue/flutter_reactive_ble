import 'package:mockito/mockito.dart' as _i1;
import 'package:flutter_reactive_ble/src/plugin_controller.dart' as _i2;
import 'dart:async' as _i3;
import 'package:flutter_reactive_ble/src/model/discovered_device.dart' as _i4;
import 'package:flutter_reactive_ble/src/model/uuid.dart' as _i5;
import 'package:flutter_reactive_ble/src/model/scan_mode.dart' as _i6;

/// A class which mocks [ScanOperationController].
///
/// See the documentation for Mockito's code generation for more information.
class MockScanOperationController extends _i1.Mock
    implements _i2.ScanOperationController {
  MockScanOperationController() {
    _i1.throwOnMissingStub(this);
  }

  _i3.Stream<_i4.ScanResult> get scanStream => super.noSuchMethod(
      Invocation.getter(#scanStream), Stream<_i4.ScanResult>.empty());
  _i3.Stream<void> scanForDevices(
          {List<_i5.Uuid>? withServices,
          _i6.ScanMode? scanMode,
          bool? requireLocationServicesEnabled}) =>
      (super.noSuchMethod(
          Invocation.method(#scanForDevices, [], {
            #withServices: withServices,
            #scanMode: scanMode,
            #requireLocationServicesEnabled: requireLocationServicesEnabled
          }),
          Stream<void>.empty()) as _i3.Stream<void>);
}
