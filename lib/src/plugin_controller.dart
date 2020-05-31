import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/converter/args_to_protubuf_converter.dart';
import 'package:flutter_reactive_ble/src/model/uuid.dart';
import 'package:meta/meta.dart';

import 'converter/protobuf_converter.dart';

class PluginController {
  const PluginController({
    @required this.argsToProtobufConverter,
    @required this.protobufConverter,
    @required this.bleMethodChannel,
    @required this.connectedDeviceChannel,
  })  : assert(argsToProtobufConverter != null),
        assert(bleMethodChannel != null);

  final ArgsToProtobufConverter argsToProtobufConverter;
  final ProtobufConverter protobufConverter;
  final MethodChannel bleMethodChannel;
  final EventChannel connectedDeviceChannel;

  Stream<Object> connectToDevice(
    String id,
    Map<Uuid, List<Uuid>> servicesWithCharacteristicsToDiscover,
    Duration connectionTimeout,
  ) =>
      bleMethodChannel
          .invokeMethod<void>(
            "connectToDevice",
            argsToProtobufConverter
                .createConnectToDeviceArgs(
                  id,
                  servicesWithCharacteristicsToDiscover,
                  connectionTimeout,
                )
                .writeToBuffer(),
          )
          .asStream();

  Future<void> disconnectDevice(String deviceId) =>
      bleMethodChannel.invokeMethod<void>(
        "disconnectFromDevice",
        argsToProtobufConverter
            .createDisconnectDeviceArgs(deviceId)
            .writeToBuffer(),
      );

  Stream<ConnectionStateUpdate> get connectionUpdateStream =>
      connectedDeviceChannel
          .receiveBroadcastStream()
          .cast<List<int>>()
          .map(protobufConverter.connectionStateUpdateFrom);
}

class PluginControllerFactory {
  // this injection is temporarily until we moved everythin out
  const PluginControllerFactory(this._bleMethodChannel);

  final MethodChannel _bleMethodChannel;

  PluginController create() {
    const connectedDeviceChannel =
        EventChannel("flutter_reactive_ble_connected_device");

    return PluginController(
      protobufConverter: const ProtobufConverter(),
      argsToProtobufConverter: const ArgsToProtobufConverter(),
      bleMethodChannel: _bleMethodChannel,
      connectedDeviceChannel: connectedDeviceChannel,
    );
  }
}
