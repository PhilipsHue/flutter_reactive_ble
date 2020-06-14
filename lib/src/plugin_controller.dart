import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/converter/args_to_protubuf_converter.dart';
import 'package:flutter_reactive_ble/src/model/uuid.dart';
import 'package:flutter_reactive_ble/src/model/write_characteristic_info.dart';
import 'package:meta/meta.dart';

import 'converter/protobuf_converter.dart';
import 'model/characteristic_value.dart';
import 'model/clear_gatt_cache_error.dart';
import 'model/connection_state_update.dart';
import 'model/qualified_characteristic.dart';
import 'model/unit.dart';

class PluginController {
  const PluginController({
    @required ArgsToProtobufConverter argsToProtobufConverter,
    @required ProtobufConverter protobufConverter,
    @required MethodChannel bleMethodChannel,
    @required EventChannel connectedDeviceChannel,
    @required EventChannel charUpdateChannel,
    @required EventChannel bleDeviceScanChannel,
  })  : assert(argsToProtobufConverter != null),
        assert(protobufConverter != null),
        assert(bleMethodChannel != null),
        assert(connectedDeviceChannel != null),
        assert(bleDeviceScanChannel != null),
        assert(charUpdateChannel != null),
        _argsToProtobufConverter = argsToProtobufConverter,
        _protobufConverter = protobufConverter,
        _bleMethodChannel = bleMethodChannel,
        _connectedDeviceChannel = connectedDeviceChannel,
        _charUpdateChannel = charUpdateChannel,
        _bleDeviceScanChannel = bleDeviceScanChannel;

  final ArgsToProtobufConverter _argsToProtobufConverter;
  final ProtobufConverter _protobufConverter;
  final MethodChannel _bleMethodChannel;
  final EventChannel _connectedDeviceChannel;
  final EventChannel _charUpdateChannel;
  final EventChannel _bleDeviceScanChannel;

  Stream<ConnectionStateUpdate> get connectionUpdateStream =>
      _connectedDeviceChannel
          .receiveBroadcastStream()
          .cast<List<int>>()
          .map(_protobufConverter.connectionStateUpdateFrom);

  Stream<CharacteristicValue> get charValueUpdateStream => _charUpdateChannel
      .receiveBroadcastStream()
      .cast<List<int>>()
      .map(_protobufConverter.characteristicValueFrom);

  Stream<ScanResult> get scanStream =>
      _bleDeviceScanChannel.receiveBroadcastStream().cast<List<int>>().map(
            _protobufConverter.scanResultFrom,
          );

  Future<void> initialize() => _bleMethodChannel.invokeMethod("initialize");
  Future<void> deInitialize() =>
      _bleMethodChannel.invokeMethod<void>("deinitialize");

  Stream<Object> scanForDevices({
    @required List<Uuid> withServices,
    @required ScanMode scanMode,
    @required bool requireLocationServicesEnabled,
  }) =>
      _bleMethodChannel
          .invokeMethod<void>(
            "scanForDevices",
            _argsToProtobufConverter
                .createScanForDevicesRequest(
                  withServices: withServices,
                  scanMode: scanMode,
                  requireLocationServicesEnabled:
                      requireLocationServicesEnabled,
                )
                .writeToBuffer(),
          )
          .asStream();

  Stream<Object> connectToDevice(
    String id,
    Map<Uuid, List<Uuid>> servicesWithCharacteristicsToDiscover,
    Duration connectionTimeout,
  ) =>
      _bleMethodChannel
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

  Future<void> disconnectDevice(String deviceId) =>
      _bleMethodChannel.invokeMethod<void>(
        "disconnectFromDevice",
        _argsToProtobufConverter
            .createDisconnectDeviceArgs(deviceId)
            .writeToBuffer(),
      );

  Stream<Object> readCharacteristic(QualifiedCharacteristic characteristic) =>
      _bleMethodChannel
          .invokeMethod<void>(
            "readCharacteristic",
            _argsToProtobufConverter
                .createReadCharacteristicRequest(characteristic)
                .writeToBuffer(),
          )
          .asStream();

  Future<WriteCharacteristicInfo> writeCharacteristicWithResponse(
          QualifiedCharacteristic characteristic, List<int> value) async =>
      _bleMethodChannel
          .invokeMethod<List<int>>(
              "writeCharacteristicWithResponse",
              _argsToProtobufConverter
                  .createWriteChacracteristicRequest(characteristic, value)
                  .writeToBuffer())
          .then(_protobufConverter.writeCharacteristicInfoFrom);

  Future<WriteCharacteristicInfo> writeCharacteristicWithoutResponse(
          QualifiedCharacteristic characteristic, List<int> value) async =>
      _bleMethodChannel
          .invokeMethod<List<int>>(
            "writeCharacteristicWithoutResponse",
            _argsToProtobufConverter
                .createWriteChacracteristicRequest(characteristic, value)
                .writeToBuffer(),
          )
          .then(_protobufConverter.writeCharacteristicInfoFrom);

  Stream<Object> subscribeToNotifications(
          QualifiedCharacteristic characteristic) =>
      _bleMethodChannel
          .invokeMethod<void>(
            "readNotifications",
            _argsToProtobufConverter
                .createNotifyCharacteristicRequest(characteristic)
                .writeToBuffer(),
          )
          .asStream();

  Future<void> stopSubscribingToNotifications(
          QualifiedCharacteristic characteristic) =>
      _bleMethodChannel
          .invokeMethod<void>(
            "stopNotifications",
            _argsToProtobufConverter
                .createNotifyNoMoreCharacteristicRequest(characteristic)
                .writeToBuffer(),
          )
          .catchError((Object e) =>
              print("Error unsubscribing from notifications: $e"));

  Future<int> requestMtuSize(String deviceId, int mtu) async =>
      _bleMethodChannel
          .invokeMethod<List<int>>(
            "negotiateMtuSize",
            _argsToProtobufConverter
                .createNegotiateMtuRequest(deviceId, mtu)
                .writeToBuffer(),
          )
          .then(_protobufConverter.mtuSizeFrom);

  Future<ConnectionPriorityInfo> requestConnectionPriority(
          String deviceId, ConnectionPriority priority) =>
      _bleMethodChannel
          .invokeMethod<List<int>>(
            "requestConnectionPriority",
            _argsToProtobufConverter
                .createChangeConnectionPrioRequest(deviceId, priority)
                .writeToBuffer(),
          )
          .then(_protobufConverter.connectionPriorityInfoFrom);

  Future<Result<Unit, GenericFailure<ClearGattCacheError>>> clearGattCache(
          String deviceId) =>
      _bleMethodChannel
          .invokeMethod<List<int>>(
            "clearGattCache",
            _argsToProtobufConverter
                .createClearGattCacheRequest(deviceId)
                .writeToBuffer(),
          )
          .then(_protobufConverter.clearGattCacheResultFrom);
}

class PluginControllerFactory {
  // this injection is temporarily until we moved everythin out
  const PluginControllerFactory();

  PluginController create() {
    const _bleMethodChannel = MethodChannel("flutter_reactive_ble_method");

    const connectedDeviceChannel =
        EventChannel("flutter_reactive_ble_connected_device");
    const charEventChannel = EventChannel("flutter_reactive_ble_char_update");
    const scanEventChannel = EventChannel("flutter_reactive_ble_scan");

    return const PluginController(
      protobufConverter: ProtobufConverter(),
      argsToProtobufConverter: ArgsToProtobufConverter(),
      bleMethodChannel: _bleMethodChannel,
      connectedDeviceChannel: connectedDeviceChannel,
      charUpdateChannel: charEventChannel,
      bleDeviceScanChannel: scanEventChannel,
    );
  }
}
