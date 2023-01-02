import 'package:flutter/services.dart';
import 'package:reactive_ble_platform_interface/reactive_ble_platform_interface.dart';

import 'converter/args_to_protubuf_converter.dart';
import 'converter/protobuf_converter.dart';

class ReactiveBleMobilePlatform extends ReactiveBlePlatform {
  ReactiveBleMobilePlatform({
    required ArgsToProtobufConverter argsToProtobufConverter,
    required ProtobufConverter protobufConverter,
    required MethodChannel bleMethodChannel,
    required Stream<List<int>> connectedDeviceChannel,
    required Stream<List<int>> charUpdateChannel,
    required Stream<List<int>> bleDeviceScanChannel,
    required Stream<List<int>> bleStatusChannel,
    required Stream<List<int>> connectedCentralChannel,
    required Stream<List<int>> charCentralUpdateChannel,
    Logger? logger,
  })  : _argsToProtobufConverter = argsToProtobufConverter,
        _protobufConverter = protobufConverter,
        _bleMethodChannel = bleMethodChannel,
        _connectedDeviceRawStream = connectedDeviceChannel,
        _charUpdateRawStream = charUpdateChannel,
        _bleStatusRawChannel = bleStatusChannel,
        _bleDeviceScanRawStream = bleDeviceScanChannel,
        _connectedCentralRawStream = connectedCentralChannel,
        _charCentralUpdateRawStream = charCentralUpdateChannel,
        _logger = logger;

  final ArgsToProtobufConverter _argsToProtobufConverter;
  final ProtobufConverter _protobufConverter;
  final MethodChannel _bleMethodChannel;
  final Stream<List<int>> _connectedDeviceRawStream;
  final Stream<List<int>> _charUpdateRawStream;
  final Stream<List<int>> _bleDeviceScanRawStream;
  final Stream<List<int>> _bleStatusRawChannel;
  final Stream<List<int>> _connectedCentralRawStream;
  final Stream<List<int>> _charCentralUpdateRawStream;
  final Logger? _logger;

  Stream<ConnectionStateUpdate>? _connectionUpdateStream;
  Stream<CharacteristicValue>? _charValueStream;
  Stream<ScanResult>? _scanResultStream;
  Stream<BleStatus>? _bleStatusStream;
  Stream<ConnectionStateUpdate>? _connectionCentralStream;
  Stream<CharacteristicValue>? _charCentralValueStream;

  @override
  Stream<ConnectionStateUpdate> get connectionUpdateStream =>
      _connectionUpdateStream ??= _connectedDeviceRawStream
          .map(_protobufConverter.connectionStateUpdateFrom)
          .map(
        (update) {
          _logger?.log(
            'Received $ConnectionStateUpdate(deviceId: ${update.deviceId}, connectionState: ${update.connectionState}, failure: ${update.failure})',
          );
          return update;
        },
      );

  @override
  Stream<CharacteristicValue> get charValueUpdateStream =>
      _charValueStream ??= _charUpdateRawStream
          .map(_protobufConverter.characteristicValueFrom)
          .map(
        (update) {
          _logger?.log(
            'Received $CharacteristicValue(characteristic: ${update.characteristic}, result: ${update.runtimeType})',
          );
          return update;
        },
      );

  @override
  Stream<ScanResult> get scanStream => _scanResultStream ??=
          _bleDeviceScanRawStream.map(_protobufConverter.scanResultFrom).map(
        (scanResult) {
          _logger?.log(
            'Received $ScanResult(result: ${scanResult.result})',
          );
          return scanResult;
        },
      );

  @override
  Stream<BleStatus> get bleStatusStream =>
      _bleStatusStream ??= _bleStatusRawChannel
          .map(_protobufConverter.bleStatusFrom)
          .map((status) {
        _logger?.log('Received $BleStatus update: $status');
        return status;
      });

  @override
  Stream<ConnectionStateUpdate> get connectionCentralStream =>
      _connectionCentralStream ??= _connectedCentralRawStream
          .map(_protobufConverter.connectionStateUpdateFrom)
          .map(
            (update) => update,
          );

  @override
  Stream<CharacteristicValue> get charCentralValueUpdateStream =>
      _charCentralValueStream ??= _charCentralUpdateRawStream
          .map(_protobufConverter.characteristicValueFrom)
          .map(
            (update) => update,
          );

  @override
  Future<void> initialize() {
    _logger?.log('Initialize BLE platform');
    return _bleMethodChannel.invokeMethod("initialize");
  }

  @override
  Future<void> deinitialize() {
    _logger?.log('Deinitialize BLE platform');
    return _bleMethodChannel.invokeMethod<void>("deinitialize");
  }

  @override
  Stream<void> scanForDevices({
    required List<Uuid> withServices,
    required ScanMode scanMode,
    required bool requireLocationServicesEnabled,
  }) {
    _logger?.log(
      'Scan for devices with services:$withServices, scanMode: $scanMode, requireLocationServicesEnabled: $requireLocationServicesEnabled',
    );
    return _bleMethodChannel
          .invokeMethod<void>(
            "scanForDevices",
            _argsToProtobufConverter
                .createScanForDevicesRequest(
                  withServices: withServices,
                  scanMode: scanMode,
                requireLocationServicesEnabled: requireLocationServicesEnabled,
                )
                .writeToBuffer(),
          )
          .asStream();
  }

  @override
  Stream<void> connectToDevice(
    String id,
    Map<Uuid, List<Uuid>>? servicesWithCharacteristicsToDiscover,
    Duration? connectionTimeout,
  ) {
    _logger?.log(
      'Connect to device: $id, servicesWithCharacteristicsToDiscover: $servicesWithCharacteristicsToDiscover, timeout: $connectionTimeout',
    );
    return _bleMethodChannel
          .invokeMethod<void>(
            "connectToDevice",
            _argsToProtobufConverter
                .createConnectToDeviceArgs(
                  id,
                  servicesWithCharacteristicsToDiscover,
                  connectionTimeout,
                )
                .writeToBuffer(),
          )
          .asStream();
  }

  @override
  Future<void> disconnectDevice(String deviceId) {
    _logger?.log(
      'Disconnect device: $deviceId',
    );
    return _bleMethodChannel.invokeMethod<void>(
        "disconnectFromDevice",
        _argsToProtobufConverter
            .createDisconnectDeviceArgs(deviceId)
            .writeToBuffer(),
      );
  }

  @override
  Stream<void> readCharacteristic(QualifiedCharacteristic characteristic) {
    _logger?.log(
      'Read characteristic: $characteristic',
    );
    return _bleMethodChannel
          .invokeMethod<void>(
            "readCharacteristic",
            _argsToProtobufConverter
                .createReadCharacteristicRequest(characteristic)
                .writeToBuffer(),
          )
          .asStream();
  }

  @override
  Future<WriteCharacteristicInfo> writeCharacteristicWithResponse(
    QualifiedCharacteristic characteristic,
    List<int> value,
  ) async {
    _logger?.log('Write with response to $characteristic, value: $value');
    return _bleMethodChannel
          .invokeMethod<List<int>>(
              "writeCharacteristicWithResponse",
              _argsToProtobufConverter
                  .createWriteCharacteristicRequest(characteristic, value)
                  .writeToBuffer())
        .then((data) => _protobufConverter.writeCharacteristicInfoFrom(data!));
  }

  @override
  Future<WriteCharacteristicInfo> writeCharacteristicWithoutResponse(
    QualifiedCharacteristic characteristic,
    List<int> value,
  ) async {
    _logger?.log(
      'Write without response to $characteristic, value: $value',
    );
    return _bleMethodChannel
          .invokeMethod<List<int>>(
            "writeCharacteristicWithoutResponse",
            _argsToProtobufConverter
                .createWriteCharacteristicRequest(characteristic, value)
                .writeToBuffer(),
          )
        .then((data) => _protobufConverter.writeCharacteristicInfoFrom(data!));
  }

  @override
  Stream<void> subscribeToNotifications(
    QualifiedCharacteristic characteristic,
  ) {
    _logger?.log('Start subscribing to notifications for $characteristic');
    return _bleMethodChannel
          .invokeMethod<void>(
            "readNotifications",
            _argsToProtobufConverter
                .createNotifyCharacteristicRequest(characteristic)
                .writeToBuffer(),
          )
          .asStream();
  }

  @override
  Future<void> stopSubscribingToNotifications(
    QualifiedCharacteristic characteristic,
  ) {
    _logger?.log('Stop subscribing to notifications for $characteristic');
    return _bleMethodChannel
          .invokeMethod<void>(
            "stopNotifications",
            _argsToProtobufConverter
                .createNotifyNoMoreCharacteristicRequest(characteristic)
                .writeToBuffer(),
          )
          .catchError(
            // ignore: avoid_print
            (Object e) => print("Error unsubscribing from notifications: $e"),
          );
  }
  @override
  Future<void> startAdvertising() => _bleMethodChannel
          .invokeMethod<void>(
        "startAdvertising"/*,
        _argsToProtobufConverter
            .createNotifyNoMoreCharacteristicRequest(characteristic)
            .writeToBuffer(),*/
      )
          .catchError(
        // ignore: avoid_print
            (Object e) => print("Error starting advertising: $e"),
      );

  @override
  Future<void> stopAdvertising() => _bleMethodChannel
          .invokeMethod<void>(
          "stopAdvertising"/*,
        _argsToProtobufConverter
            .createNotifyNoMoreCharacteristicRequest(characteristic)
            .writeToBuffer(),*/
      )
          .catchError(
        // ignore: avoid_print
            (Object e) => print("Error stopping advertising: $e"),
      );

  @override
  Future<void> startGattServer() => _bleMethodChannel
          .invokeMethod<void>(
          "startGattServer"/*,
        _argsToProtobufConverter
            .createNotifyNoMoreCharacteristicRequest(characteristic)
            .writeToBuffer(),*/
      )
          .catchError(
        // ignore: avoid_print
            (Object e) => print("Error starting gattserver: $e"),
      );

  @override
  Future<void> stopGattServer() => _bleMethodChannel
          .invokeMethod<void>(
          "stopGattServer"/*,
        _argsToProtobufConverter
            .createNotifyNoMoreCharacteristicRequest(characteristic)
            .writeToBuffer(),*/
      )
          .catchError(
        // ignore: avoid_print
            (Object e) => print("Error stopping gattserver: $e"),
      );

  @override
  Future<void> addGattService() => _bleMethodChannel
          .invokeMethod<void>(
          "addGattService"/*,
        _argsToProtobufConverter
            .createNotifyNoMoreCharacteristicRequest(characteristic)
            .writeToBuffer(),*/
      )
          .catchError(
        // ignore: avoid_print
            (Object e) => print("Error adding gattservice: $e"),
      );

  @override
  Future<void> addGattCharacteristic() => _bleMethodChannel
          .invokeMethod<void>(
          "addGattCharacteristic"/*,
        _argsToProtobufConverter
            .createNotifyNoMoreCharacteristicRequest(characteristic)
            .writeToBuffer(),*/
      )
          .catchError(
        // ignore: avoid_print
            (Object e) => print("Error adding gattcharacteristic: $e"),
      );

  @override
  Future<void/*WriteCharacteristicInfo*/> writeLocalCharacteristic(
    QualifiedCharacteristic characteristic,
    List<int> value,
  ) async =>
      _bleMethodChannel
          .invokeMethod<List<int>>(
            "writeLocalCharacteristic",
            _argsToProtobufConverter
                .createWriteCharacteristicRequest(characteristic, value)
                .writeToBuffer(),
          );
          //.then((data) => _protobufConverter.writeCharacteristicInfoFrom(data!));

  @override
  Future<int> requestMtuSize(String deviceId, int? mtu) async {
    _logger?.log('Request mtu size for device: $deviceId with mtuSize: $mtu');
    return _bleMethodChannel
          .invokeMethod<List<int>>(
            "negotiateMtuSize",
            _argsToProtobufConverter
                .createNegotiateMtuRequest(deviceId, mtu!)
                .writeToBuffer(),
          )
          .then((data) => _protobufConverter.mtuSizeFrom(data!));
  }

  @override
  Future<ConnectionPriorityInfo> requestConnectionPriority(
      String deviceId, ConnectionPriority priority) {
    _logger?.log(
        'Request connection priority for device: $deviceId, priority: $priority');
    return _bleMethodChannel
          .invokeMethod<List<int>>(
            "requestConnectionPriority",
            _argsToProtobufConverter
                .createChangeConnectionPrioRequest(deviceId, priority)
                .writeToBuffer(),
          )
          .then((data) => _protobufConverter.connectionPriorityInfoFrom(data!));
  }

  @override
  Future<Result<Unit, GenericFailure<ClearGattCacheError>?>> clearGattCache(
      String deviceId) {
    _logger?.log('Clear gatt cache for device: $deviceId');
    return _bleMethodChannel
          .invokeMethod<List<int>>(
            "clearGattCache",
            _argsToProtobufConverter
                .createClearGattCacheRequest(deviceId)
                .writeToBuffer(),
          )
          .then((data) => _protobufConverter.clearGattCacheResultFrom(data!));
  }

  @override
  Future<List<DiscoveredService>> discoverServices(String deviceId) async {
    _logger?.log('Discover services for device: $deviceId');
    return _bleMethodChannel
          .invokeMethod<List<int>>(
            'discoverServices',
            _argsToProtobufConverter
                .createDiscoverServicesRequest(deviceId)
                .writeToBuffer(),
          )
          .then((data) => _protobufConverter.discoveredServicesFrom(data!));
}
}

class ReactiveBleMobilePlatformFactory {
  const ReactiveBleMobilePlatformFactory();

  ReactiveBleMobilePlatform create({Logger? logger}) {
    const _bleMethodChannel = MethodChannel("flutter_reactive_ble_method");

    const connectedDeviceChannel =
        EventChannel("flutter_reactive_ble_connected_device");
    const charEventChannel = EventChannel("flutter_reactive_ble_char_update");
    const scanEventChannel = EventChannel("flutter_reactive_ble_scan");
    const bleStatusChannel = EventChannel("flutter_reactive_ble_status");
    const connectedCentralChannel =
        EventChannel("flutter_reactive_ble_connected_central");
    const charCentralUpdateChannel =
        EventChannel("flutter_reactive_ble_char_update_central");

    return ReactiveBleMobilePlatform(
      protobufConverter: const ProtobufConverterImpl(),
      argsToProtobufConverter: const ArgsToProtobufConverterImpl(),
      bleMethodChannel: _bleMethodChannel,
      connectedDeviceChannel:
          connectedDeviceChannel.receiveBroadcastStream().cast<List<int>>(),
      charUpdateChannel:
          charEventChannel.receiveBroadcastStream().cast<List<int>>(),
      bleDeviceScanChannel:
          scanEventChannel.receiveBroadcastStream().cast<List<int>>(),
      bleStatusChannel:
          bleStatusChannel.receiveBroadcastStream().cast<List<int>>(),
      connectedCentralChannel:
          connectedCentralChannel.receiveBroadcastStream().cast<List<int>>(),
      charCentralUpdateChannel:
          charCentralUpdateChannel.receiveBroadcastStream().cast<List<int>>(),
      logger: logger,
    );
  }
}
