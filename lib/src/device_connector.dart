import 'package:flutter_reactive_ble/src/model/connection_state_update.dart';
import 'package:flutter_reactive_ble/src/plugin_controller.dart';
import 'package:flutter_reactive_ble/src/rx_ext/repeater.dart';
import 'package:meta/meta.dart';

import 'model/uuid.dart';

class DeviceConnector {
  const DeviceConnector({
    @required Stream<ConnectionStateUpdate> connectionStateUpdateStream,
    @required PluginController pluginController,
  })  : assert(connectionStateUpdateStream != null),
        assert(pluginController != null),
        _connectionStateUpdateStream = connectionStateUpdateStream,
        _controller = pluginController;

  final Stream<ConnectionStateUpdate> _connectionStateUpdateStream;
  final PluginController _controller;

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
      onListenEmitFrom: () => _controller
          .connectToDevice(
              id, servicesWithCharacteristicsToDiscover, connectionTimeout)
          .asyncExpand((Object _) => specificConnectedDeviceStream),
      onCancel: () => _controller.disconnectDevice(id),
    );

    return autoconnectingRepeater.stream;
  }
}
