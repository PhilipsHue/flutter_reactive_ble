import 'package:mockito/mockito.dart' as _i1;
import 'package:flutter_reactive_ble/src/model/write_characteristic_info.dart'
    as _i2;
import 'package:flutter_reactive_ble/src/model/connection_priority.dart' as _i3;
import 'package:flutter_reactive_ble/src/plugin_controller.dart' as _i4;
import 'dart:async' as _i5;
import 'package:flutter_reactive_ble/src/model/characteristic_value.dart'
    as _i6;
import 'package:flutter_reactive_ble/src/model/discovered_service.dart' as _i7;
import 'package:flutter_reactive_ble/src/model/qualified_characteristic.dart'
    as _i8;

class _FakeWriteCharacteristicInfo extends _i1.Fake
    implements _i2.WriteCharacteristicInfo {}

class _FakeConnectionPriorityInfo extends _i1.Fake
    implements _i3.ConnectionPriorityInfo {}

/// A class which mocks [DeviceOperationController].
///
/// See the documentation for Mockito's code generation for more information.
class MockDeviceOperationController extends _i1.Mock
    implements _i4.DeviceOperationController {
  MockDeviceOperationController() {
    _i1.throwOnMissingStub(this);
  }

  _i5.Stream<_i6.CharacteristicValue> get charValueUpdateStream =>
      super.noSuchMethod(Invocation.getter(#charValueUpdateStream),
          Stream<_i6.CharacteristicValue>.empty());
  _i5.Future<List<_i7.DiscoveredService>> discoverServices(String? deviceId) =>
      (super.noSuchMethod(Invocation.method(#discoverServices, [deviceId]),
              Future.value(<_i7.DiscoveredService>[]))
          as _i5.Future<List<_i7.DiscoveredService>>);
  _i5.Stream<void> readCharacteristic(
          _i8.QualifiedCharacteristic? characteristic) =>
      (super.noSuchMethod(
          Invocation.method(#readCharacteristic, [characteristic]),
          Stream<void>.empty()) as _i5.Stream<void>);
  _i5.Future<_i2.WriteCharacteristicInfo> writeCharacteristicWithResponse(
          _i8.QualifiedCharacteristic? characteristic, List<int>? value) =>
      (super.noSuchMethod(
              Invocation.method(
                  #writeCharacteristicWithResponse, [characteristic, value]),
              Future.value(_FakeWriteCharacteristicInfo()))
          as _i5.Future<_i2.WriteCharacteristicInfo>);
  _i5.Future<_i2.WriteCharacteristicInfo> writeCharacteristicWithoutResponse(
          _i8.QualifiedCharacteristic? characteristic, List<int>? value) =>
      (super.noSuchMethod(
              Invocation.method(
                  #writeCharacteristicWithoutResponse, [characteristic, value]),
              Future.value(_FakeWriteCharacteristicInfo()))
          as _i5.Future<_i2.WriteCharacteristicInfo>);
  _i5.Stream<void> subscribeToNotifications(
          _i8.QualifiedCharacteristic? characteristic) =>
      (super.noSuchMethod(
          Invocation.method(#subscribeToNotifications, [characteristic]),
          Stream<void>.empty()) as _i5.Stream<void>);
  _i5.Future<void> stopSubscribingToNotifications(
          _i8.QualifiedCharacteristic? characteristic) =>
      (super.noSuchMethod(
          Invocation.method(#stopSubscribingToNotifications, [characteristic]),
          Future.value(null)) as _i5.Future<void>);
  _i5.Future<int> requestMtuSize(String? deviceId, int? mtu) =>
      (super.noSuchMethod(Invocation.method(#requestMtuSize, [deviceId, mtu]),
          Future.value(0)) as _i5.Future<int>);
  _i5.Future<_i3.ConnectionPriorityInfo> requestConnectionPriority(
          String? deviceId, _i3.ConnectionPriority? priority) =>
      (super
              .noSuchMethod(
                  Invocation.method(
                      #requestConnectionPriority, [deviceId, priority]),
                  Future.value(_FakeConnectionPriorityInfo()))
          as _i5.Future<_i3.ConnectionPriorityInfo>);
}
