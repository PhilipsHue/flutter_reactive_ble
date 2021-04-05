import 'package:functional_data/functional_data.dart';
import 'package:meta/meta.dart';

import 'generic_failure.dart';

part 'connection_state_update.g.dart';
//ignore_for_file: annotate_overrides

///Status update for a specific BLE device.
@immutable
@FunctionalData()
class ConnectionStateUpdate extends $ConnectionStateUpdate {
  final String deviceId;
  final DeviceConnectionState connectionState;

  /// Field `error` is null if there is no error reported.
  final GenericFailure<ConnectionError>? failure;

  const ConnectionStateUpdate({
    required this.deviceId,
    required this.connectionState,
    required this.failure,
  });
}

/// Connection status.
enum DeviceConnectionState {
  /// Currently establishing a connection.
  connecting,

  /// Connection is established.
  connected,

  /// Terminating the connection.
  disconnecting,

  /// Device is disconnected.
  disconnected
}

/// Type of connection error.
enum ConnectionError {
  /// Connection failed for an unknown reason.
  unknown,

  /// An attempt to connect was made but it failed.
  failedToConnect,
}
