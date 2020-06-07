import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/src/converter/args_to_protubuf_converter.dart';
import 'package:flutter_reactive_ble/src/model/uuid.dart';
import 'package:flutter_reactive_ble/src/model/write_characteristic_info.dart';
import 'package:meta/meta.dart';

import 'converter/protobuf_converter.dart';
import 'model/characteristic_value.dart';
import 'model/connection_state_update.dart';
import 'model/qualified_characteristic.dart';

class PluginController {
  const PluginController({
    @required ArgsToProtobufConverter argsToProtobufConverter,
    @required ProtobufConverter protobufConverter,
    @required MethodChannel bleMethodChannel,
    @required EventChannel connectedDeviceChannel,
    @required EventChannel charUpdateChannel,
  })  : assert(argsToProtobufConverter != null),
        assert(protobufConverter != null),
        assert(bleMethodChannel != null),
        assert(connectedDeviceChannel != null),
        assert(charUpdateChannel != null),
        _argsToProtobufConverter = argsToProtobufConverter,
        _protobufConverter = protobufConverter,
        _bleMethodChannel = bleMethodChannel,
        _connectedDeviceChannel = connectedDeviceChannel,
        _charUpdateChannel = charUpdateChannel;

  final ArgsToProtobufConverter _argsToProtobufConverter;
  final ProtobufConverter _protobufConverter;
  final MethodChannel _bleMethodChannel;
  final EventChannel _connectedDeviceChannel;
  final EventChannel _charUpdateChannel;

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

  Stream<ConnectionStateUpdate> get connectionUpdateStream =>
      _connectedDeviceChannel
          .receiveBroadcastStream()
          .cast<List<int>>()
          .map(_protobufConverter.connectionStateUpdateFrom);

  Stream<CharacteristicValue> get charValueUpdateStream => _charUpdateChannel
      .receiveBroadcastStream()
      .cast<List<int>>()
      .map(_protobufConverter.characteristicValueFrom);
}

class PluginControllerFactory {
  // this injection is temporarily until we moved everythin out
  const PluginControllerFactory(this._bleMethodChannel);

  final MethodChannel _bleMethodChannel;

  PluginController create() {
    const connectedDeviceChannel =
        EventChannel("flutter_reactive_ble_connected_device");
    const charEventChannel = EventChannel("flutter_reactive_ble_char_update");

    return PluginController(
      protobufConverter: const ProtobufConverter(),
      argsToProtobufConverter: const ArgsToProtobufConverter(),
      bleMethodChannel: _bleMethodChannel,
      connectedDeviceChannel: connectedDeviceChannel,
      charUpdateChannel: charEventChannel,
    );
  }
}
