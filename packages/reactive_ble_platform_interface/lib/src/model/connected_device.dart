import 'package:flutter/foundation.dart';
import 'package:functional_data/functional_data.dart';
import 'package:reactive_ble_platform_interface/src/model/generic_failure.dart';
import 'package:reactive_ble_platform_interface/src/model/result.dart';

part 'connected_device.g.dart';
//ignore_for_file: annotate_overrides

@immutable
@FunctionalData()
class ConnectedDevicesInfo extends $ConnectedDevicesInfo {
  const ConnectedDevicesInfo({
    required this.result,
  });

  /// Result of fetching the connected devices
  final Result<List<ConnectedDevice>,
      GenericFailure<FetchConnectedDeviceError>?> result;

}

@immutable
@FunctionalData()
class ConnectedDevice extends $ConnectedDevice {
  const ConnectedDevice({
    required this.deviceId,
    required this.deviceName,
  });

  /// The unique identifier of the device
  final String deviceId;
  final String deviceName;
}

enum FetchConnectedDeviceError { unknown }
