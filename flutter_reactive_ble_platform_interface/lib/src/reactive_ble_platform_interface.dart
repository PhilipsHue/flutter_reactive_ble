import 'package:flutter_reactive_ble_platform_interface/src/plugin_controller.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'models.dart';

abstract class ReactiveBlePlatform extends PlatformInterface {
  ReactiveBlePlatform() : super(token: _token);
  static final Object _token = Object();

  static ReactiveBlePlatform _instance =
      const PluginControllerFactory().create();

  static ReactiveBlePlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [ReactiveBlePlatform] when they register themselves.
  static set instance(ReactiveBlePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Stream<ScanResult> get scanStream {
    throw UnimplementedError('scanStream has not been implemented.');
  }

  Stream<BleStatus> get bleStatusStream {
    throw UnimplementedError('bleStatusStream has not been implemented.');
  }

  Stream<ConnectionStateUpdate> get connectionUpdateStream {
    throw UnimplementedError('connectionStream has not been implemented.');
  }

  Stream<CharacteristicValue> get charValueUpdateStream {
    throw UnimplementedError('charValueUpdateStream has not been implemented.');
  }

  Future<void> initialize() {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  Future<void> deinitialize() {
    throw UnimplementedError('deInitialize() has not been implemented.');
  }

  Stream<void> scanForDevices({
    required List<Uuid> withServices,
    required ScanMode scanMode,
    required bool requireLocationServicesEnabled,
  }) {
    throw UnimplementedError('scanForDevices has not been implemented.');
  }

  Future<Result<Unit, GenericFailure<ClearGattCacheError>?>> clearGattCache(
      String deviceId) {
    throw UnimplementedError('clearGattCache() has not been implemented.');
  }

  Stream<void> connectToDevice(
    String id,
    Map<Uuid, List<Uuid>>? servicesWithCharacteristicsToDiscover,
    Duration? connectionTimeout,
  ) {
    throw UnimplementedError('connectToDevice has not been implemented.');
  }

  Future<void> disconnectDevice(String deviceId) {
    throw UnimplementedError('disconnectDevice has not been implemented.');
  }

  Future<List<DiscoveredService>> discoverServices(String deviceId) {
    throw UnimplementedError('discoverServices has not been implemented.');
  }

  Stream<void> readCharacteristic(QualifiedCharacteristic characteristic) {
    throw UnimplementedError('readCharacteristic has not been implemented.');
  }

  Future<WriteCharacteristicInfo> writeCharacteristicWithResponse(
    QualifiedCharacteristic characteristic,
    List<int> value,
  ) {
    {
      throw UnimplementedError(
          'writeCharacteristicWithResponse has not been implemented.');
    }
  }

  Future<WriteCharacteristicInfo> writeCharacteristicWithoutResponse(
    QualifiedCharacteristic characteristic,
    List<int> value,
  ) {
    throw UnimplementedError(
        'writeCharacteristicWithoutResponse has not been implemented.');
  }

  Stream<void> subscribeToNotifications(
    QualifiedCharacteristic characteristic,
  ) {
    throw UnimplementedError(
        'subscribeToNotifications has not been implemented.');
  }

  Future<void> stopSubscribingToNotifications(
    QualifiedCharacteristic characteristic,
  ) {
    throw UnimplementedError(
        'stopSubscribingToNotifiations has not been implemented.');
  }

  Future<int> requestMtuSize(String deviceId, int? mtu) {
    throw UnimplementedError('requestMtuSize has not been implemented.');
  }

  Future<ConnectionPriorityInfo> requestConnectionPriority(
      String deviceId, ConnectionPriority priority) {
    throw UnimplementedError(
        'requesConnectionPriority has not been implemented.');
  }
}
