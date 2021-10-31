// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connected_device.dart';

// **************************************************************************
// FunctionalDataGenerator
// **************************************************************************

abstract class $ConnectedDevicesInfo {
  const $ConnectedDevicesInfo();

  Result<List<ConnectedDevice>, GenericFailure<FetchConnectedDeviceError>?>
      get result;
  GenericFailure<FetchConnectedDeviceError>? get failure;

  ConnectedDevicesInfo copyWith({
    Result<List<ConnectedDevice>, GenericFailure<FetchConnectedDeviceError>?>?
        result,
    GenericFailure<FetchConnectedDeviceError>? failure,
  }) =>
      ConnectedDevicesInfo(
        result: result ?? this.result,
        failure: failure ?? this.failure,
      );

  ConnectedDevicesInfo copyUsing(
      void Function(ConnectedDevicesInfo$Change change) mutator) {
    final change = ConnectedDevicesInfo$Change._(
      this.result,
      this.failure,
    );
    mutator(change);
    return ConnectedDevicesInfo(
      result: change.result,
      failure: change.failure,
    );
  }

  @override
  String toString() =>
      "ConnectedDevicesInfo(result: $result, failure: $failure)";

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      other is ConnectedDevicesInfo &&
      other.runtimeType == runtimeType &&
      result == other.result &&
      failure == other.failure;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    var result = 17;
    result = 37 * result + result.hashCode;
    result = 37 * result + failure.hashCode;
    return result;
  }
}

class ConnectedDevicesInfo$Change {
  ConnectedDevicesInfo$Change._(
    this.result,
    this.failure,
  );

  Result<List<ConnectedDevice>, GenericFailure<FetchConnectedDeviceError>?>
      result;
  GenericFailure<FetchConnectedDeviceError>? failure;
}

// ignore: avoid_classes_with_only_static_members
class ConnectedDevicesInfo$ {
  static final result = Lens<
      ConnectedDevicesInfo,
      Result<List<ConnectedDevice>,
          GenericFailure<FetchConnectedDeviceError>?>>(
    (resultContainer) => resultContainer.result,
    (resultContainer, result) => resultContainer.copyWith(result: result),
  );

  static final failure =
      Lens<ConnectedDevicesInfo, GenericFailure<FetchConnectedDeviceError>?>(
    (failureContainer) => failureContainer.failure,
    (failureContainer, failure) => failureContainer.copyWith(failure: failure),
  );
}

abstract class $ConnectedDevice {
  const $ConnectedDevice();

  String get deviceId;
  String get deviceName;

  ConnectedDevice copyWith({
    String? deviceId,
    String? deviceName,
  }) =>
      ConnectedDevice(
        deviceId: deviceId ?? this.deviceId,
        deviceName: deviceName ?? this.deviceName,
      );

  ConnectedDevice copyUsing(
      void Function(ConnectedDevice$Change change) mutator) {
    final change = ConnectedDevice$Change._(
      this.deviceId,
      this.deviceName,
    );
    mutator(change);
    return ConnectedDevice(
      deviceId: change.deviceId,
      deviceName: change.deviceName,
    );
  }

  @override
  String toString() =>
      "ConnectedDevice(deviceId: $deviceId, deviceName: $deviceName)";

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      other is ConnectedDevice &&
      other.runtimeType == runtimeType &&
      deviceId == other.deviceId &&
      deviceName == other.deviceName;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode {
    var result = 17;
    result = 37 * result + deviceId.hashCode;
    result = 37 * result + deviceName.hashCode;
    return result;
  }
}

class ConnectedDevice$Change {
  ConnectedDevice$Change._(
    this.deviceId,
    this.deviceName,
  );

  String deviceId;
  String deviceName;
}

// ignore: avoid_classes_with_only_static_members
class ConnectedDevice$ {
  static final deviceId = Lens<ConnectedDevice, String>(
    (deviceIdContainer) => deviceIdContainer.deviceId,
    (deviceIdContainer, deviceId) =>
        deviceIdContainer.copyWith(deviceId: deviceId),
  );

  static final deviceName = Lens<ConnectedDevice, String>(
    (deviceNameContainer) => deviceNameContainer.deviceName,
    (deviceNameContainer, deviceName) =>
        deviceNameContainer.copyWith(deviceName: deviceName),
  );
}
