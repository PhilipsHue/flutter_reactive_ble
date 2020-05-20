import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/src/generated/bledata.pb.dart' as pb;
import 'package:flutter_reactive_ble/src/model/connection_state_update.dart';
import 'package:flutter_reactive_ble/src/rx_ext/repeater.dart';
import 'package:meta/meta.dart';

import 'model/uuid.dart';

class DeviceConnector {
  const DeviceConnector({
    @required MethodChannel bleMethodChannel,
    @required Stream<ConnectionStateUpdate> connectionStateUpdateStream,
  })  : assert(bleMethodChannel != null),
        assert(connectionStateUpdateStream != null),
        _connectionStateUpdateStream = connectionStateUpdateStream,
        _bleMethodChannel = bleMethodChannel;

  final MethodChannel _bleMethodChannel;
  final Stream<ConnectionStateUpdate> _connectionStateUpdateStream;

  Stream<ConnectionStateUpdate> connect(
    String id,
    Map<Uuid, List<Uuid>> servicesWithCharacteristicsToDiscover,
    Duration connectionTimeout,
  ) {
    final specificConnectedDeviceStream = _connectionStateUpdateStream
        .where((update) => update.deviceId == id)
        .expand((update) =>
            update.connectionState != DeviceConnectionState.disconnected
                ? [update]
                : [update, null])
        .takeWhile((update) => update != null);

    final autoconnectingRepeater = Repeater.broadcast(
      onListenEmitFrom: () {
        final args = pb.ConnectToDeviceRequest()..deviceId = id;

        if (connectionTimeout != null) {
          args.timeoutInMs = connectionTimeout.inMilliseconds;
        }

        if (servicesWithCharacteristicsToDiscover != null) {
          final items = <pb.ServiceWithCharacteristics>[];
          for (final serviceId in servicesWithCharacteristicsToDiscover.keys) {
            final characteristicIds =
                servicesWithCharacteristicsToDiscover[serviceId];
            items.add(
              pb.ServiceWithCharacteristics()
                ..serviceId = (pb.Uuid()..data = serviceId.data)
                ..characteristics.addAll(
                    characteristicIds.map((c) => pb.Uuid()..data = c.data)),
            );
          }
          args.servicesWithCharacteristicsToDiscover =
              pb.ServicesWithCharacteristics()..items.addAll(items);
        }
        return _bleMethodChannel
            .invokeMethod<void>("connectToDevice", args.writeToBuffer())
            .asStream()
            .asyncExpand((Object _) => specificConnectedDeviceStream);
      },
      onCancel: () {
        final args = pb.DisconnectFromDeviceRequest()..deviceId = id;
        return _bleMethodChannel.invokeMethod<void>(
            "disconnectFromDevice", args.writeToBuffer());
      },
    );

    return autoconnectingRepeater.stream;
  }
}
