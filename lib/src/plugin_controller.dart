import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/src/converter/args_to_protubuf_converter.dart';
import 'package:flutter_reactive_ble/src/model/uuid.dart';

class PluginController {
  const PluginController(this.converter, this.bleMethodChannel);

  final ArgsToProtobufConverter converter;
  final MethodChannel bleMethodChannel;

  Stream<Object> connectToDevice(
    String id,
    Map<Uuid, List<Uuid>> servicesWithCharacteristicsToDiscover,
    Duration connectionTimeout,
  ) =>
      bleMethodChannel
          .invokeMethod<void>(
            "connectToDevice",
            converter
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
        converter.createDisconnectDeviceArgs(deviceId).writeToBuffer(),
      );
}
