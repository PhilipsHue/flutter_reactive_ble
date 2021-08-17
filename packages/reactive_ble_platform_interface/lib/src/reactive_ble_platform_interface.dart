import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'models.dart';

/// The interface that implementations of `reactive_ble` must implement.
///
// Platform implementations should extend this class rather than implement it as
// `reactive_ble`does not consider newly added methods to be breaking changes.
// Extending this class (using `extends`) ensures that the subclass will get
// the default implementation, while platform implementations that `implements`
// this interface will be broken by newly added [ReactiveBlePlatform] methods.
abstract class ReactiveBlePlatform extends PlatformInterface {
  ReactiveBlePlatform() : super(token: _token);
  static final Object _token = Object();

  static late ReactiveBlePlatform _instance;

  static ReactiveBlePlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [ReactiveBlePlatform] when they register themselves.
  static set instance(ReactiveBlePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Stream providing ble scan results.
  ///
  /// It is important to subscribe to this stream before scanning for devices
  /// since it can happen that some results are missed.
  Stream<ScanResult> get scanStream {
    throw UnimplementedError('scanStream has not been implemented.');
  }

  /// Stream that provides status updates regarding the host device BLE sub system.
  ///
  /// In general this stream will be listened to on app startup to determine
  /// whether or not ble is switched on or authorized.
  Stream<BleStatus> get bleStatusStream {
    throw UnimplementedError('bleStatusStream has not been implemented.');
  }

  /// Listen to this stream to get connection updates for all the connected BLE
  /// devices.
  ///
  /// It is important to subscribe to this stream before connecting to a
  /// device since it can happen that some results are missed.
  Stream<ConnectionStateUpdate> get connectionUpdateStream {
    throw UnimplementedError('connectionStream has not been implemented.');
  }

  /// Stream that provides value updates about the characteristics that are read
  /// or subscribed to.
  Stream<CharacteristicValue> get charValueUpdateStream {
    throw UnimplementedError('charValueUpdateStream has not been implemented.');
  }

  /// Initializes the ble plugin platform specific counter parts.
  ///
  /// The initialization is performed automatically the first time any BLE
  /// operation is triggered.
  Future<void> initialize() {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  /// De-initializes the ble plugin platform specific counter parts.
  Future<void> deinitialize() {
    throw UnimplementedError('deInitialize() has not been implemented.');
  }

  /// Stream that handles triggers scanning for Ble devices.
  ///
  /// As long as the stream has been `listened` to the scanning continues. When
  /// the stream is `cancelled ` the ble scanning should stop.
  Stream<void> scanForDevices({
    required List<Uuid> withServices,
    required ScanMode scanMode,
    required bool requireLocationServicesEnabled,
  }) {
    throw UnimplementedError('scanForDevices has not been implemented.');
  }

  /// Clears GATT attribute cache on Android using undocumented API. This method
  /// should not be implemented for other platforms.
  Future<Result<Unit, GenericFailure<ClearGattCacheError>?>> clearGattCache(
      String deviceId) {
    throw UnimplementedError('clearGattCache() has not been implemented.');
  }

  /// Connects to a specific device and the connection remains `established` until
  /// the stream is `cancelled` or the connection is closed by the peripheral.
  ///
  /// The actual `connection updates` should be propagated to the [connectionUpdateStream].
  Stream<void> connectToDevice(
    String id,
    Map<Uuid, List<Uuid>>? servicesWithCharacteristicsToDiscover,
    Duration? connectionTimeout,
  ) {
    throw UnimplementedError('connectToDevice has not been implemented.');
  }

  /// Operation that disconnects the host with the peripheral.
  Future<void> disconnectDevice(String deviceId) {
    throw UnimplementedError('disconnectDevice has not been implemented.');
  }

  /// Performs service discovery on the peripheral and returns the discovered
  /// services.
  ///
  /// This operation can only succeed when the host is `connected` with the peripheral.
  Future<List<DiscoveredService>> discoverServices(String deviceId) {
    throw UnimplementedError('discoverServices has not been implemented.');
  }

  /// Performs service discovery on the peripheral and returns the discovered
  /// services.
  ///
  /// This operation can only succeed when the host is `connected` with the
  /// peripheral. Only the success or failure of this operation should be propagated
  /// to this stream. The read value is distributed to [charValueUpdateStream].
  Stream<void> readCharacteristic(QualifiedCharacteristic characteristic) {
    throw UnimplementedError('readCharacteristic has not been implemented.');
  }

  /// Perform writing a value to a specific characteristic and awaiting the
  /// acknowledgment from the peripheral.
  ///
  /// When implement this operation on the platform make sure that you return a
  /// response only when the peripheral `acknowledged` the write operation
  Future<WriteCharacteristicInfo> writeCharacteristicWithResponse(
    QualifiedCharacteristic characteristic,
    List<int> value,
  ) {
    throw UnimplementedError(
        'writeCharacteristicWithResponse has not been implemented.');
  }

  /// Perform writing a value to a specific characteristic without awaiting the
  /// acknowledgment from the peripheral.
  ///
  /// When implementing this operation on the platform make sure that it directly
  /// returns a response to the dart layer when the command arrived.
  Future<WriteCharacteristicInfo> writeCharacteristicWithoutResponse(
    QualifiedCharacteristic characteristic,
    List<int> value,
  ) {
    throw UnimplementedError(
        'writeCharacteristicWithoutResponse has not been implemented.');
  }

  /// Starts subscribing to notifications for a specificied characteristic.
  ///
  /// This stream only returns the result of the operation. Value updates should
  /// be propagated to [charValueUpdateStream].
  Stream<void> subscribeToNotifications(
    QualifiedCharacteristic characteristic,
  ) {
    throw UnimplementedError(
        'subscribeToNotifications has not been implemented.');
  }

  /// Stops subscribing to notifications for a specificied characteristic.
  Future<void> stopSubscribingToNotifications(
    QualifiedCharacteristic characteristic,
  ) {
    throw UnimplementedError(
        'stopSubscribingToNotifiations has not been implemented.');
  }

  /// Requests a specific MTU for a connected device.
  Future<int> requestMtuSize(String deviceId, int? mtu) {
    throw UnimplementedError('requestMtuSize has not been implemented.');
  }

  /// Requests for a connection parameter update on the connected device.
  ///
  /// This operation is specific to the Android ecosystem and should not be
  /// implemented by other platforms.
  Future<ConnectionPriorityInfo> requestConnectionPriority(
      String deviceId, ConnectionPriority priority) {
    throw UnimplementedError(
        'requesConnectionPriority has not been implemented.');
  }
}
