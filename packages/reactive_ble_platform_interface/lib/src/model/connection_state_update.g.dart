// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_state_update.dart';

// **************************************************************************
// FunctionalDataGenerator
// **************************************************************************

abstract class $ConnectionStateUpdate {
  const $ConnectionStateUpdate();

  String get deviceId;
  DeviceConnectionState get connectionState;
  GenericFailure<ConnectionError>? get failure;

  ConnectionStateUpdate copyWith({
    String? deviceId,
    DeviceConnectionState? connectionState,
    GenericFailure<ConnectionError>? failure,
  }) =>
      ConnectionStateUpdate(
        deviceId: deviceId ?? this.deviceId,
        connectionState: connectionState ?? this.connectionState,
        failure: failure ?? this.failure,
      );

  ConnectionStateUpdate copyUsing(
      void Function(ConnectionStateUpdate$Change change) mutator) {
    final change = ConnectionStateUpdate$Change._(
      this.deviceId,
      this.connectionState,
      this.failure,
    );
    mutator(change);
    return ConnectionStateUpdate(
      deviceId: change.deviceId,
      connectionState: change.connectionState,
      failure: change.failure,
    );
  }

  @override
  String toString() =>
      "ConnectionStateUpdate(deviceId: $deviceId, connectionState: $connectionState, failure: $failure)";

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      other is ConnectionStateUpdate &&
      other.runtimeType == runtimeType &&
      deviceId == other.deviceId &&
      connectionState == other.connectionState &&
      failure == other.failure;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    var result = 17;
    result = 37 * result + deviceId.hashCode;
    result = 37 * result + connectionState.hashCode;
    result = 37 * result + failure.hashCode;
    return result;
  }
}

class ConnectionStateUpdate$Change {
  ConnectionStateUpdate$Change._(
    this.deviceId,
    this.connectionState,
    this.failure,
  );

  String deviceId;
  DeviceConnectionState connectionState;
  GenericFailure<ConnectionError>? failure;
}

// ignore: avoid_classes_with_only_static_members
class ConnectionStateUpdate$ {
  static final deviceId = Lens<ConnectionStateUpdate, String>(
    (deviceIdContainer) => deviceIdContainer.deviceId,
    (deviceIdContainer, deviceId) =>
        deviceIdContainer.copyWith(deviceId: deviceId),
  );

  static final connectionState =
      Lens<ConnectionStateUpdate, DeviceConnectionState>(
    (connectionStateContainer) => connectionStateContainer.connectionState,
    (connectionStateContainer, connectionState) =>
        connectionStateContainer.copyWith(connectionState: connectionState),
  );

  static final failure =
      Lens<ConnectionStateUpdate, GenericFailure<ConnectionError>?>(
    (failureContainer) => failureContainer.failure,
    (failureContainer, failure) => failureContainer.copyWith(failure: failure),
  );
}
