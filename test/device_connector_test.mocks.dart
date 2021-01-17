import 'package:mockito/mockito.dart' as _i1;
import 'package:flutter_reactive_ble/src/plugin_controller.dart' as _i2;
import 'dart:async' as _i3;
import 'package:flutter_reactive_ble/src/model/connection_state_update.dart'
    as _i4;
import 'package:flutter_reactive_ble/src/model/uuid.dart' as _i5;
import 'package:flutter_reactive_ble/src/device_scanner.dart' as _i6;
import 'package:flutter_reactive_ble/src/model/discovered_device.dart' as _i7;
import 'package:flutter_reactive_ble/src/model/scan_mode.dart' as _i8;
import 'package:flutter_reactive_ble/src/discovered_devices_registry.dart'
    as _i9;

class _FakeDateTime extends _i1.Fake implements DateTime {}

/// A class which mocks [DeviceConnectionController].
///
/// See the documentation for Mockito's code generation for more information.
class MockDeviceConnectionController extends _i1.Mock
    implements _i2.DeviceConnectionController {
  MockDeviceConnectionController() {
    _i1.throwOnMissingStub(this);
  }

  _i3.Stream<_i4.ConnectionStateUpdate> get connectionUpdateStream =>
      super.noSuchMethod(Invocation.getter(#connectionUpdateStream),
          Stream<_i4.ConnectionStateUpdate>.empty());
  _i3.Stream<void> connectToDevice(
          String? id,
          Map<_i5.Uuid, List<_i5.Uuid>>? servicesWithCharacteristicsToDiscover,
          Duration? connectionTimeout) =>
      (super.noSuchMethod(
          Invocation.method(#connectToDevice,
              [id, servicesWithCharacteristicsToDiscover, connectionTimeout]),
          Stream<void>.empty()) as _i3.Stream<void>);
  _i3.Future<void> disconnectDevice(String? deviceId) => (super.noSuchMethod(
          Invocation.method(#disconnectDevice, [deviceId]), Future.value(null))
      as _i3.Future<void>);
}

/// A class which mocks [DeviceScanner].
///
/// See the documentation for Mockito's code generation for more information.
class MockDeviceScanner extends _i1.Mock implements _i6.DeviceScanner {
  MockDeviceScanner() {
    _i1.throwOnMissingStub(this);
  }

  _i3.Stream<_i7.DiscoveredDevice> scanForDevices(
          {List<_i5.Uuid>? withServices,
          _i8.ScanMode? scanMode = _i8.ScanMode.balanced,
          bool? requireLocationServicesEnabled = true}) =>
      (super.noSuchMethod(
              Invocation.method(#scanForDevices, [], {
                #withServices: withServices,
                #scanMode: scanMode,
                #requireLocationServicesEnabled: requireLocationServicesEnabled
              }),
              Stream<_i7.DiscoveredDevice>.empty())
          as _i3.Stream<_i7.DiscoveredDevice>);
}

/// A class which mocks [DiscoveredDevicesRegistry].
///
/// See the documentation for Mockito's code generation for more information.
class MockDiscoveredDevicesRegistry extends _i1.Mock
    implements _i9.DiscoveredDevicesRegistry {
  MockDiscoveredDevicesRegistry() {
    _i1.throwOnMissingStub(this);
  }

  DateTime Function() get getTimestamp => super
      .noSuchMethod(Invocation.getter(#getTimestamp), () => _FakeDateTime());
  void add(String? deviceId) =>
      super.noSuchMethod(Invocation.method(#add, [deviceId]));
  void remove(String? deviceId) =>
      super.noSuchMethod(Invocation.method(#remove, [deviceId]));
  bool isEmpty() =>
      (super.noSuchMethod(Invocation.method(#isEmpty, []), false) as bool);
  bool deviceIsDiscoveredRecently(
          {String? deviceId, Duration? cacheValidity}) =>
      (super.noSuchMethod(
          Invocation.method(#deviceIsDiscoveredRecently, [],
              {#deviceId: deviceId, #cacheValidity: cacheValidity}),
          false) as bool);
}
