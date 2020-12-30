import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/model/uuid.dart';
import 'package:functional_data/functional_data.dart';
import 'package:meta/meta.dart';

part 'discovered_device.g.dart';

// ignore_for_file: annotate_overrides, avoid_classes_with_only_static_members, non_constant_identifier_names

/// Result of a scan interval.
@immutable
class ScanResult {
  final Result<DiscoveredDevice, GenericFailure<ScanFailure>/*!*/> result;
  const ScanResult({@required this.result});

  @override
  String toString() => "$ScanResult(result: $result)";
}

///Ble device that is discovered during scanning.
@immutable
@FunctionalData()
class DiscoveredDevice extends $DiscoveredDevice {
  /// The unique identifier of the device.
  final String id;
  final String name;
  @CustomEquality(DeepCollectionEquality())
  final Map<Uuid, Uint8List> serviceData;

  /// Manufacturer specific data. The first 2 bytes are the Company Identifier Codes.
  final Uint8List/*!*/ manufacturerData;

  final int rssi;

  const DiscoveredDevice({
    @required this.id,
    @required this.name,
    @required this.serviceData,
    @required this.manufacturerData,
    @required this.rssi,
  });
}

///Connection status of the BLE device.
enum ConnectionStatus {
  /// Device is disconnected.
  disconnected,

  /// A connection is being established.
  connecting,

  /// Connected with Device.
  connected,

  /// Device is being disconnected.
  disconnecting,
}

/// Failure type of device discovery.
enum ScanFailure { unknown }
