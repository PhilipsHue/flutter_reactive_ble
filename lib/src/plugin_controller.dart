import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/src/converter/args_to_protubuf_converter.dart';
import 'package:flutter_reactive_ble/src/model/uuid.dart';
import 'package:meta/meta.dart';

class PluginController {
  const PluginController({
    @required this.argsToProtobufConverter,
    @required this.bleMethodChannel,
  })  : assert(argsToProtobufConverter != null),
        assert(bleMethodChannel != null);

  final ArgsToProtobufConverter argsToProtobufConverter;
  final MethodChannel bleMethodChannel;

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
}
