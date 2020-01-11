import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/model/uuid.dart';
import 'package:functional_data/functional_data.dart';
import 'package:meta/meta.dart';

part 'discovered_device.g.dart';

// ignore_for_file: annotate_overrides, avoid_classes_with_only_static_members, non_constant_identifier_names

@immutable
class ScanResult {
  final Result<DiscoveredDevice, GenericFailure<ScanFailure>> result;
  const ScanResult({@required this.result});

  @override
  String toString() => "$ScanResult(result: $result)";
}

@immutable
@FunctionalData()
class DiscoveredDevice extends $DiscoveredDevice {
  final String id;
  final String name;
  @CustomEquality(DeepCollectionEquality())
  final Map<Uuid, Uint8List> serviceData;

  const DiscoveredDevice({@required this.id, @required this.name, @required this.serviceData});
}

enum ConnectionStatus { disconnected, connecting, connected, disconnecting }
enum ScanFailure { unknown }
