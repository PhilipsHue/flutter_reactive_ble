// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_state_update.dart';

// **************************************************************************
// FunctionalDataGenerator
// **************************************************************************

// ignore_for_file: join_return_with_assignment
// ignore_for_file: avoid_classes_with_only_static_members
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes
abstract class $ConnectionStateUpdate {
  const $ConnectionStateUpdate();
  String get deviceId;
  DeviceConnectionState get connectionState;
  GenericFailure<ConnectionError>? get failure;
  ConnectionStateUpdate copyWith(
          {String? deviceId,
          DeviceConnectionState? connectionState,
          GenericFailure<ConnectionError>? failure}) =>
      ConnectionStateUpdate(
          deviceId: deviceId ?? this.deviceId,
          connectionState: connectionState ?? this.connectionState,
          failure: failure ?? this.failure);
  @override
  String toString() =>
      "ConnectionStateUpdate(deviceId: $deviceId, connectionState: $connectionState, failure: $failure)";
  @override
  bool operator ==(dynamic other) =>
      other.runtimeType == runtimeType &&
      deviceId == other.deviceId &&
      connectionState == other.connectionState &&
      failure == other.failure;
  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + deviceId.hashCode;
    result = 37 * result + connectionState.hashCode;
    result = 37 * result + failure.hashCode;
    return result;
  }
}

class ConnectionStateUpdate$ {
  static final deviceId = Lens<ConnectionStateUpdate, String>(
      (s_) => s_.deviceId, (s_, deviceId) => s_.copyWith(deviceId: deviceId));
  static final connectionState =
      Lens<ConnectionStateUpdate, DeviceConnectionState>(
          (s_) => s_.connectionState,
          (s_, connectionState) =>
              s_.copyWith(connectionState: connectionState));
  static final failure =
      Lens<ConnectionStateUpdate, GenericFailure<ConnectionError>?>(
          (s_) => s_.failure, (s_, failure) => s_.copyWith(failure: failure));
}
