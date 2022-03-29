import 'dart:async';

class ConnectedDeviceStreams {
  final String deviceId;
  final StreamSubscription stream;

  const ConnectedDeviceStreams({
    required this.deviceId,
    required this.stream,
  });
}
