import 'package:flutter_reactive_ble/src/model/generic_failure.dart';
import 'package:meta/meta.dart';

@immutable
class ConnectionStateUpdate {
  final String deviceId;
  final DeviceConnectionState connectionState;

  /// Field `error` is null if there is no error reported
  final GenericFailure<ConnectionError> failure;

  const ConnectionStateUpdate({
    @required this.deviceId,
    @required this.connectionState,
    @required this.failure,
  });

  @override
  String toString() =>
      "$runtimeType(deviceId: $deviceId, connectionState: $connectionState, error: $failure)";
}

enum DeviceConnectionState {
  connecting,
  connected,
  disconnecting,
  disconnected
}
enum ConnectionError { unknown, failedToConnect }
