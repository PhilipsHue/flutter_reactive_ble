// This is a generated file - do not edit.
//
// Generated from bledata.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class ScanForDevicesRequest extends $pb.GeneratedMessage {
  factory ScanForDevicesRequest({
    $core.Iterable<Uuid>? serviceUuids,
    $core.int? scanMode,
    $core.bool? requireLocationServicesEnabled,
  }) {
    final result = create();
    if (serviceUuids != null) result.serviceUuids.addAll(serviceUuids);
    if (scanMode != null) result.scanMode = scanMode;
    if (requireLocationServicesEnabled != null)
      result.requireLocationServicesEnabled = requireLocationServicesEnabled;
    return result;
  }

  ScanForDevicesRequest._();

  factory ScanForDevicesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ScanForDevicesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScanForDevicesRequest',
      createEmptyInstance: create)
    ..pPM<Uuid>(1, _omitFieldNames ? '' : 'serviceUuids',
        protoName: 'serviceUuids', subBuilder: Uuid.create)
    ..aI(2, _omitFieldNames ? '' : 'scanMode', protoName: 'scanMode')
    ..aOB(3, _omitFieldNames ? '' : 'requireLocationServicesEnabled',
        protoName: 'requireLocationServicesEnabled')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScanForDevicesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScanForDevicesRequest copyWith(
          void Function(ScanForDevicesRequest) updates) =>
      super.copyWith((message) => updates(message as ScanForDevicesRequest))
          as ScanForDevicesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScanForDevicesRequest create() => ScanForDevicesRequest._();
  @$core.override
  ScanForDevicesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ScanForDevicesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScanForDevicesRequest>(create);
  static ScanForDevicesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Uuid> get serviceUuids => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get scanMode => $_getIZ(1);
  @$pb.TagNumber(2)
  set scanMode($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScanMode() => $_has(1);
  @$pb.TagNumber(2)
  void clearScanMode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get requireLocationServicesEnabled => $_getBF(2);
  @$pb.TagNumber(3)
  set requireLocationServicesEnabled($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRequireLocationServicesEnabled() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequireLocationServicesEnabled() => $_clearField(3);
}

class DeviceScanInfo extends $pb.GeneratedMessage {
  factory DeviceScanInfo({
    $core.String? id,
    $core.String? name,
    GenericFailure? failure,
    $core.Iterable<ServiceDataEntry>? serviceData,
    $core.int? rssi,
    $core.List<$core.int>? manufacturerData,
    $core.Iterable<Uuid>? serviceUuids,
    IsConnectable? isConnectable,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (failure != null) result.failure = failure;
    if (serviceData != null) result.serviceData.addAll(serviceData);
    if (rssi != null) result.rssi = rssi;
    if (manufacturerData != null) result.manufacturerData = manufacturerData;
    if (serviceUuids != null) result.serviceUuids.addAll(serviceUuids);
    if (isConnectable != null) result.isConnectable = isConnectable;
    return result;
  }

  DeviceScanInfo._();

  factory DeviceScanInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeviceScanInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeviceScanInfo',
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOM<GenericFailure>(3, _omitFieldNames ? '' : 'failure',
        subBuilder: GenericFailure.create)
    ..pPM<ServiceDataEntry>(4, _omitFieldNames ? '' : 'serviceData',
        protoName: 'serviceData', subBuilder: ServiceDataEntry.create)
    ..aI(5, _omitFieldNames ? '' : 'rssi')
    ..a<$core.List<$core.int>>(
        6, _omitFieldNames ? '' : 'manufacturerData', $pb.PbFieldType.OY,
        protoName: 'manufacturerData')
    ..pPM<Uuid>(7, _omitFieldNames ? '' : 'serviceUuids',
        protoName: 'serviceUuids', subBuilder: Uuid.create)
    ..aOM<IsConnectable>(8, _omitFieldNames ? '' : 'isConnectable',
        protoName: 'isConnectable', subBuilder: IsConnectable.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceScanInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceScanInfo copyWith(void Function(DeviceScanInfo) updates) =>
      super.copyWith((message) => updates(message as DeviceScanInfo))
          as DeviceScanInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeviceScanInfo create() => DeviceScanInfo._();
  @$core.override
  DeviceScanInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeviceScanInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeviceScanInfo>(create);
  static DeviceScanInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  GenericFailure get failure => $_getN(2);
  @$pb.TagNumber(3)
  set failure(GenericFailure value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFailure() => $_has(2);
  @$pb.TagNumber(3)
  void clearFailure() => $_clearField(3);
  @$pb.TagNumber(3)
  GenericFailure ensureFailure() => $_ensure(2);

  @$pb.TagNumber(4)
  $pb.PbList<ServiceDataEntry> get serviceData => $_getList(3);

  @$pb.TagNumber(5)
  $core.int get rssi => $_getIZ(4);
  @$pb.TagNumber(5)
  set rssi($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRssi() => $_has(4);
  @$pb.TagNumber(5)
  void clearRssi() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.List<$core.int> get manufacturerData => $_getN(5);
  @$pb.TagNumber(6)
  set manufacturerData($core.List<$core.int> value) => $_setBytes(5, value);
  @$pb.TagNumber(6)
  $core.bool hasManufacturerData() => $_has(5);
  @$pb.TagNumber(6)
  void clearManufacturerData() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<Uuid> get serviceUuids => $_getList(6);

  @$pb.TagNumber(8)
  IsConnectable get isConnectable => $_getN(7);
  @$pb.TagNumber(8)
  set isConnectable(IsConnectable value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasIsConnectable() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsConnectable() => $_clearField(8);
  @$pb.TagNumber(8)
  IsConnectable ensureIsConnectable() => $_ensure(7);
}

class ConnectToDeviceRequest extends $pb.GeneratedMessage {
  factory ConnectToDeviceRequest({
    $core.String? deviceId,
    ServicesWithCharacteristics? servicesWithCharacteristicsToDiscover,
    $core.int? timeoutInMs,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    if (servicesWithCharacteristicsToDiscover != null)
      result.servicesWithCharacteristicsToDiscover =
          servicesWithCharacteristicsToDiscover;
    if (timeoutInMs != null) result.timeoutInMs = timeoutInMs;
    return result;
  }

  ConnectToDeviceRequest._();

  factory ConnectToDeviceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConnectToDeviceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConnectToDeviceRequest',
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId', protoName: 'deviceId')
    ..aOM<ServicesWithCharacteristics>(
        2, _omitFieldNames ? '' : 'servicesWithCharacteristicsToDiscover',
        protoName: 'servicesWithCharacteristicsToDiscover',
        subBuilder: ServicesWithCharacteristics.create)
    ..aI(3, _omitFieldNames ? '' : 'timeoutInMs', protoName: 'timeoutInMs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectToDeviceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectToDeviceRequest copyWith(
          void Function(ConnectToDeviceRequest) updates) =>
      super.copyWith((message) => updates(message as ConnectToDeviceRequest))
          as ConnectToDeviceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConnectToDeviceRequest create() => ConnectToDeviceRequest._();
  @$core.override
  ConnectToDeviceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConnectToDeviceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConnectToDeviceRequest>(create);
  static ConnectToDeviceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  ServicesWithCharacteristics get servicesWithCharacteristicsToDiscover =>
      $_getN(1);
  @$pb.TagNumber(2)
  set servicesWithCharacteristicsToDiscover(
          ServicesWithCharacteristics value) =>
      $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasServicesWithCharacteristicsToDiscover() => $_has(1);
  @$pb.TagNumber(2)
  void clearServicesWithCharacteristicsToDiscover() => $_clearField(2);
  @$pb.TagNumber(2)
  ServicesWithCharacteristics ensureServicesWithCharacteristicsToDiscover() =>
      $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get timeoutInMs => $_getIZ(2);
  @$pb.TagNumber(3)
  set timeoutInMs($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTimeoutInMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimeoutInMs() => $_clearField(3);
}

class DeviceInfo extends $pb.GeneratedMessage {
  factory DeviceInfo({
    $core.String? id,
    $core.int? connectionState,
    GenericFailure? failure,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (connectionState != null) result.connectionState = connectionState;
    if (failure != null) result.failure = failure;
    return result;
  }

  DeviceInfo._();

  factory DeviceInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeviceInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeviceInfo',
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aI(2, _omitFieldNames ? '' : 'connectionState',
        protoName: 'connectionState')
    ..aOM<GenericFailure>(3, _omitFieldNames ? '' : 'failure',
        subBuilder: GenericFailure.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceInfo copyWith(void Function(DeviceInfo) updates) =>
      super.copyWith((message) => updates(message as DeviceInfo)) as DeviceInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeviceInfo create() => DeviceInfo._();
  @$core.override
  DeviceInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeviceInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeviceInfo>(create);
  static DeviceInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get connectionState => $_getIZ(1);
  @$pb.TagNumber(2)
  set connectionState($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasConnectionState() => $_has(1);
  @$pb.TagNumber(2)
  void clearConnectionState() => $_clearField(2);

  @$pb.TagNumber(3)
  GenericFailure get failure => $_getN(2);
  @$pb.TagNumber(3)
  set failure(GenericFailure value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFailure() => $_has(2);
  @$pb.TagNumber(3)
  void clearFailure() => $_clearField(3);
  @$pb.TagNumber(3)
  GenericFailure ensureFailure() => $_ensure(2);
}

class DisconnectFromDeviceRequest extends $pb.GeneratedMessage {
  factory DisconnectFromDeviceRequest({
    $core.String? deviceId,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    return result;
  }

  DisconnectFromDeviceRequest._();

  factory DisconnectFromDeviceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DisconnectFromDeviceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DisconnectFromDeviceRequest',
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId', protoName: 'deviceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisconnectFromDeviceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisconnectFromDeviceRequest copyWith(
          void Function(DisconnectFromDeviceRequest) updates) =>
      super.copyWith(
              (message) => updates(message as DisconnectFromDeviceRequest))
          as DisconnectFromDeviceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DisconnectFromDeviceRequest create() =>
      DisconnectFromDeviceRequest._();
  @$core.override
  DisconnectFromDeviceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DisconnectFromDeviceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DisconnectFromDeviceRequest>(create);
  static DisconnectFromDeviceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);
}

class ClearGattCacheRequest extends $pb.GeneratedMessage {
  factory ClearGattCacheRequest({
    $core.String? deviceId,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    return result;
  }

  ClearGattCacheRequest._();

  factory ClearGattCacheRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClearGattCacheRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClearGattCacheRequest',
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId', protoName: 'deviceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearGattCacheRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearGattCacheRequest copyWith(
          void Function(ClearGattCacheRequest) updates) =>
      super.copyWith((message) => updates(message as ClearGattCacheRequest))
          as ClearGattCacheRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClearGattCacheRequest create() => ClearGattCacheRequest._();
  @$core.override
  ClearGattCacheRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClearGattCacheRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClearGattCacheRequest>(create);
  static ClearGattCacheRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);
}

class ClearGattCacheInfo extends $pb.GeneratedMessage {
  factory ClearGattCacheInfo({
    GenericFailure? failure,
  }) {
    final result = create();
    if (failure != null) result.failure = failure;
    return result;
  }

  ClearGattCacheInfo._();

  factory ClearGattCacheInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClearGattCacheInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClearGattCacheInfo',
      createEmptyInstance: create)
    ..aOM<GenericFailure>(1, _omitFieldNames ? '' : 'failure',
        subBuilder: GenericFailure.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearGattCacheInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearGattCacheInfo copyWith(void Function(ClearGattCacheInfo) updates) =>
      super.copyWith((message) => updates(message as ClearGattCacheInfo))
          as ClearGattCacheInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClearGattCacheInfo create() => ClearGattCacheInfo._();
  @$core.override
  ClearGattCacheInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClearGattCacheInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClearGattCacheInfo>(create);
  static ClearGattCacheInfo? _defaultInstance;

  @$pb.TagNumber(1)
  GenericFailure get failure => $_getN(0);
  @$pb.TagNumber(1)
  set failure(GenericFailure value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFailure() => $_has(0);
  @$pb.TagNumber(1)
  void clearFailure() => $_clearField(1);
  @$pb.TagNumber(1)
  GenericFailure ensureFailure() => $_ensure(0);
}

class NotifyCharacteristicRequest extends $pb.GeneratedMessage {
  factory NotifyCharacteristicRequest({
    CharacteristicAddress? characteristic,
  }) {
    final result = create();
    if (characteristic != null) result.characteristic = characteristic;
    return result;
  }

  NotifyCharacteristicRequest._();

  factory NotifyCharacteristicRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotifyCharacteristicRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotifyCharacteristicRequest',
      createEmptyInstance: create)
    ..aOM<CharacteristicAddress>(1, _omitFieldNames ? '' : 'characteristic',
        subBuilder: CharacteristicAddress.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotifyCharacteristicRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotifyCharacteristicRequest copyWith(
          void Function(NotifyCharacteristicRequest) updates) =>
      super.copyWith(
              (message) => updates(message as NotifyCharacteristicRequest))
          as NotifyCharacteristicRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotifyCharacteristicRequest create() =>
      NotifyCharacteristicRequest._();
  @$core.override
  NotifyCharacteristicRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NotifyCharacteristicRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotifyCharacteristicRequest>(create);
  static NotifyCharacteristicRequest? _defaultInstance;

  @$pb.TagNumber(1)
  CharacteristicAddress get characteristic => $_getN(0);
  @$pb.TagNumber(1)
  set characteristic(CharacteristicAddress value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCharacteristic() => $_has(0);
  @$pb.TagNumber(1)
  void clearCharacteristic() => $_clearField(1);
  @$pb.TagNumber(1)
  CharacteristicAddress ensureCharacteristic() => $_ensure(0);
}

class NotifyNoMoreCharacteristicRequest extends $pb.GeneratedMessage {
  factory NotifyNoMoreCharacteristicRequest({
    CharacteristicAddress? characteristic,
  }) {
    final result = create();
    if (characteristic != null) result.characteristic = characteristic;
    return result;
  }

  NotifyNoMoreCharacteristicRequest._();

  factory NotifyNoMoreCharacteristicRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NotifyNoMoreCharacteristicRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NotifyNoMoreCharacteristicRequest',
      createEmptyInstance: create)
    ..aOM<CharacteristicAddress>(1, _omitFieldNames ? '' : 'characteristic',
        subBuilder: CharacteristicAddress.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotifyNoMoreCharacteristicRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NotifyNoMoreCharacteristicRequest copyWith(
          void Function(NotifyNoMoreCharacteristicRequest) updates) =>
      super.copyWith((message) =>
              updates(message as NotifyNoMoreCharacteristicRequest))
          as NotifyNoMoreCharacteristicRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotifyNoMoreCharacteristicRequest create() =>
      NotifyNoMoreCharacteristicRequest._();
  @$core.override
  NotifyNoMoreCharacteristicRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NotifyNoMoreCharacteristicRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotifyNoMoreCharacteristicRequest>(
          create);
  static NotifyNoMoreCharacteristicRequest? _defaultInstance;

  @$pb.TagNumber(1)
  CharacteristicAddress get characteristic => $_getN(0);
  @$pb.TagNumber(1)
  set characteristic(CharacteristicAddress value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCharacteristic() => $_has(0);
  @$pb.TagNumber(1)
  void clearCharacteristic() => $_clearField(1);
  @$pb.TagNumber(1)
  CharacteristicAddress ensureCharacteristic() => $_ensure(0);
}

class ReadCharacteristicRequest extends $pb.GeneratedMessage {
  factory ReadCharacteristicRequest({
    CharacteristicAddress? characteristic,
  }) {
    final result = create();
    if (characteristic != null) result.characteristic = characteristic;
    return result;
  }

  ReadCharacteristicRequest._();

  factory ReadCharacteristicRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReadCharacteristicRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReadCharacteristicRequest',
      createEmptyInstance: create)
    ..aOM<CharacteristicAddress>(1, _omitFieldNames ? '' : 'characteristic',
        subBuilder: CharacteristicAddress.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReadCharacteristicRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReadCharacteristicRequest copyWith(
          void Function(ReadCharacteristicRequest) updates) =>
      super.copyWith((message) => updates(message as ReadCharacteristicRequest))
          as ReadCharacteristicRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReadCharacteristicRequest create() => ReadCharacteristicRequest._();
  @$core.override
  ReadCharacteristicRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReadCharacteristicRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReadCharacteristicRequest>(create);
  static ReadCharacteristicRequest? _defaultInstance;

  @$pb.TagNumber(1)
  CharacteristicAddress get characteristic => $_getN(0);
  @$pb.TagNumber(1)
  set characteristic(CharacteristicAddress value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCharacteristic() => $_has(0);
  @$pb.TagNumber(1)
  void clearCharacteristic() => $_clearField(1);
  @$pb.TagNumber(1)
  CharacteristicAddress ensureCharacteristic() => $_ensure(0);
}

class CharacteristicValueInfo extends $pb.GeneratedMessage {
  factory CharacteristicValueInfo({
    CharacteristicAddress? characteristic,
    $core.List<$core.int>? value,
    GenericFailure? failure,
  }) {
    final result = create();
    if (characteristic != null) result.characteristic = characteristic;
    if (value != null) result.value = value;
    if (failure != null) result.failure = failure;
    return result;
  }

  CharacteristicValueInfo._();

  factory CharacteristicValueInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CharacteristicValueInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CharacteristicValueInfo',
      createEmptyInstance: create)
    ..aOM<CharacteristicAddress>(1, _omitFieldNames ? '' : 'characteristic',
        subBuilder: CharacteristicAddress.create)
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'value', $pb.PbFieldType.OY)
    ..aOM<GenericFailure>(3, _omitFieldNames ? '' : 'failure',
        subBuilder: GenericFailure.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CharacteristicValueInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CharacteristicValueInfo copyWith(
          void Function(CharacteristicValueInfo) updates) =>
      super.copyWith((message) => updates(message as CharacteristicValueInfo))
          as CharacteristicValueInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CharacteristicValueInfo create() => CharacteristicValueInfo._();
  @$core.override
  CharacteristicValueInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CharacteristicValueInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CharacteristicValueInfo>(create);
  static CharacteristicValueInfo? _defaultInstance;

  @$pb.TagNumber(1)
  CharacteristicAddress get characteristic => $_getN(0);
  @$pb.TagNumber(1)
  set characteristic(CharacteristicAddress value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCharacteristic() => $_has(0);
  @$pb.TagNumber(1)
  void clearCharacteristic() => $_clearField(1);
  @$pb.TagNumber(1)
  CharacteristicAddress ensureCharacteristic() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<$core.int> get value => $_getN(1);
  @$pb.TagNumber(2)
  set value($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);

  @$pb.TagNumber(3)
  GenericFailure get failure => $_getN(2);
  @$pb.TagNumber(3)
  set failure(GenericFailure value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFailure() => $_has(2);
  @$pb.TagNumber(3)
  void clearFailure() => $_clearField(3);
  @$pb.TagNumber(3)
  GenericFailure ensureFailure() => $_ensure(2);
}

class WriteCharacteristicRequest extends $pb.GeneratedMessage {
  factory WriteCharacteristicRequest({
    CharacteristicAddress? characteristic,
    $core.List<$core.int>? value,
  }) {
    final result = create();
    if (characteristic != null) result.characteristic = characteristic;
    if (value != null) result.value = value;
    return result;
  }

  WriteCharacteristicRequest._();

  factory WriteCharacteristicRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WriteCharacteristicRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WriteCharacteristicRequest',
      createEmptyInstance: create)
    ..aOM<CharacteristicAddress>(1, _omitFieldNames ? '' : 'characteristic',
        subBuilder: CharacteristicAddress.create)
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'value', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WriteCharacteristicRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WriteCharacteristicRequest copyWith(
          void Function(WriteCharacteristicRequest) updates) =>
      super.copyWith(
              (message) => updates(message as WriteCharacteristicRequest))
          as WriteCharacteristicRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WriteCharacteristicRequest create() => WriteCharacteristicRequest._();
  @$core.override
  WriteCharacteristicRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WriteCharacteristicRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WriteCharacteristicRequest>(create);
  static WriteCharacteristicRequest? _defaultInstance;

  @$pb.TagNumber(1)
  CharacteristicAddress get characteristic => $_getN(0);
  @$pb.TagNumber(1)
  set characteristic(CharacteristicAddress value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCharacteristic() => $_has(0);
  @$pb.TagNumber(1)
  void clearCharacteristic() => $_clearField(1);
  @$pb.TagNumber(1)
  CharacteristicAddress ensureCharacteristic() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<$core.int> get value => $_getN(1);
  @$pb.TagNumber(2)
  set value($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);
}

class WriteCharacteristicInfo extends $pb.GeneratedMessage {
  factory WriteCharacteristicInfo({
    CharacteristicAddress? characteristic,
    GenericFailure? failure,
  }) {
    final result = create();
    if (characteristic != null) result.characteristic = characteristic;
    if (failure != null) result.failure = failure;
    return result;
  }

  WriteCharacteristicInfo._();

  factory WriteCharacteristicInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WriteCharacteristicInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WriteCharacteristicInfo',
      createEmptyInstance: create)
    ..aOM<CharacteristicAddress>(1, _omitFieldNames ? '' : 'characteristic',
        subBuilder: CharacteristicAddress.create)
    ..aOM<GenericFailure>(3, _omitFieldNames ? '' : 'failure',
        subBuilder: GenericFailure.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WriteCharacteristicInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WriteCharacteristicInfo copyWith(
          void Function(WriteCharacteristicInfo) updates) =>
      super.copyWith((message) => updates(message as WriteCharacteristicInfo))
          as WriteCharacteristicInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WriteCharacteristicInfo create() => WriteCharacteristicInfo._();
  @$core.override
  WriteCharacteristicInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WriteCharacteristicInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WriteCharacteristicInfo>(create);
  static WriteCharacteristicInfo? _defaultInstance;

  @$pb.TagNumber(1)
  CharacteristicAddress get characteristic => $_getN(0);
  @$pb.TagNumber(1)
  set characteristic(CharacteristicAddress value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCharacteristic() => $_has(0);
  @$pb.TagNumber(1)
  void clearCharacteristic() => $_clearField(1);
  @$pb.TagNumber(1)
  CharacteristicAddress ensureCharacteristic() => $_ensure(0);

  @$pb.TagNumber(3)
  GenericFailure get failure => $_getN(1);
  @$pb.TagNumber(3)
  set failure(GenericFailure value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFailure() => $_has(1);
  @$pb.TagNumber(3)
  void clearFailure() => $_clearField(3);
  @$pb.TagNumber(3)
  GenericFailure ensureFailure() => $_ensure(1);
}

class NegotiateMtuRequest extends $pb.GeneratedMessage {
  factory NegotiateMtuRequest({
    $core.String? deviceId,
    $core.int? mtuSize,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    if (mtuSize != null) result.mtuSize = mtuSize;
    return result;
  }

  NegotiateMtuRequest._();

  factory NegotiateMtuRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NegotiateMtuRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NegotiateMtuRequest',
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId', protoName: 'deviceId')
    ..aI(2, _omitFieldNames ? '' : 'mtuSize', protoName: 'mtuSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NegotiateMtuRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NegotiateMtuRequest copyWith(void Function(NegotiateMtuRequest) updates) =>
      super.copyWith((message) => updates(message as NegotiateMtuRequest))
          as NegotiateMtuRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NegotiateMtuRequest create() => NegotiateMtuRequest._();
  @$core.override
  NegotiateMtuRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NegotiateMtuRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NegotiateMtuRequest>(create);
  static NegotiateMtuRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get mtuSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set mtuSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMtuSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearMtuSize() => $_clearField(2);
}

class NegotiateMtuInfo extends $pb.GeneratedMessage {
  factory NegotiateMtuInfo({
    $core.String? deviceId,
    $core.int? mtuSize,
    GenericFailure? failure,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    if (mtuSize != null) result.mtuSize = mtuSize;
    if (failure != null) result.failure = failure;
    return result;
  }

  NegotiateMtuInfo._();

  factory NegotiateMtuInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NegotiateMtuInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NegotiateMtuInfo',
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId', protoName: 'deviceId')
    ..aI(2, _omitFieldNames ? '' : 'mtuSize', protoName: 'mtuSize')
    ..aOM<GenericFailure>(3, _omitFieldNames ? '' : 'failure',
        subBuilder: GenericFailure.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NegotiateMtuInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NegotiateMtuInfo copyWith(void Function(NegotiateMtuInfo) updates) =>
      super.copyWith((message) => updates(message as NegotiateMtuInfo))
          as NegotiateMtuInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NegotiateMtuInfo create() => NegotiateMtuInfo._();
  @$core.override
  NegotiateMtuInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NegotiateMtuInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NegotiateMtuInfo>(create);
  static NegotiateMtuInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get mtuSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set mtuSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMtuSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearMtuSize() => $_clearField(2);

  @$pb.TagNumber(3)
  GenericFailure get failure => $_getN(2);
  @$pb.TagNumber(3)
  set failure(GenericFailure value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFailure() => $_has(2);
  @$pb.TagNumber(3)
  void clearFailure() => $_clearField(3);
  @$pb.TagNumber(3)
  GenericFailure ensureFailure() => $_ensure(2);
}

class BleStatusInfo extends $pb.GeneratedMessage {
  factory BleStatusInfo({
    $core.int? status,
  }) {
    final result = create();
    if (status != null) result.status = status;
    return result;
  }

  BleStatusInfo._();

  factory BleStatusInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BleStatusInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BleStatusInfo',
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'status')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BleStatusInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BleStatusInfo copyWith(void Function(BleStatusInfo) updates) =>
      super.copyWith((message) => updates(message as BleStatusInfo))
          as BleStatusInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BleStatusInfo create() => BleStatusInfo._();
  @$core.override
  BleStatusInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BleStatusInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BleStatusInfo>(create);
  static BleStatusInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get status => $_getIZ(0);
  @$pb.TagNumber(1)
  set status($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);
}

class ChangeConnectionPriorityRequest extends $pb.GeneratedMessage {
  factory ChangeConnectionPriorityRequest({
    $core.String? deviceId,
    $core.int? priority,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    if (priority != null) result.priority = priority;
    return result;
  }

  ChangeConnectionPriorityRequest._();

  factory ChangeConnectionPriorityRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChangeConnectionPriorityRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChangeConnectionPriorityRequest',
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId', protoName: 'deviceId')
    ..aI(2, _omitFieldNames ? '' : 'priority')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeConnectionPriorityRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeConnectionPriorityRequest copyWith(
          void Function(ChangeConnectionPriorityRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ChangeConnectionPriorityRequest))
          as ChangeConnectionPriorityRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChangeConnectionPriorityRequest create() =>
      ChangeConnectionPriorityRequest._();
  @$core.override
  ChangeConnectionPriorityRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChangeConnectionPriorityRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChangeConnectionPriorityRequest>(
          create);
  static ChangeConnectionPriorityRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get priority => $_getIZ(1);
  @$pb.TagNumber(2)
  set priority($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPriority() => $_has(1);
  @$pb.TagNumber(2)
  void clearPriority() => $_clearField(2);
}

class ChangeConnectionPriorityInfo extends $pb.GeneratedMessage {
  factory ChangeConnectionPriorityInfo({
    $core.String? deviceId,
    GenericFailure? failure,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    if (failure != null) result.failure = failure;
    return result;
  }

  ChangeConnectionPriorityInfo._();

  factory ChangeConnectionPriorityInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChangeConnectionPriorityInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChangeConnectionPriorityInfo',
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId', protoName: 'deviceId')
    ..aOM<GenericFailure>(2, _omitFieldNames ? '' : 'failure',
        subBuilder: GenericFailure.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeConnectionPriorityInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeConnectionPriorityInfo copyWith(
          void Function(ChangeConnectionPriorityInfo) updates) =>
      super.copyWith(
              (message) => updates(message as ChangeConnectionPriorityInfo))
          as ChangeConnectionPriorityInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChangeConnectionPriorityInfo create() =>
      ChangeConnectionPriorityInfo._();
  @$core.override
  ChangeConnectionPriorityInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChangeConnectionPriorityInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChangeConnectionPriorityInfo>(create);
  static ChangeConnectionPriorityInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  GenericFailure get failure => $_getN(1);
  @$pb.TagNumber(2)
  set failure(GenericFailure value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFailure() => $_has(1);
  @$pb.TagNumber(2)
  void clearFailure() => $_clearField(2);
  @$pb.TagNumber(2)
  GenericFailure ensureFailure() => $_ensure(1);
}

class CharacteristicAddress extends $pb.GeneratedMessage {
  factory CharacteristicAddress({
    $core.String? deviceId,
    Uuid? serviceUuid,
    Uuid? characteristicUuid,
    $core.String? serviceInstanceId,
    $core.String? characteristicInstanceId,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    if (serviceUuid != null) result.serviceUuid = serviceUuid;
    if (characteristicUuid != null)
      result.characteristicUuid = characteristicUuid;
    if (serviceInstanceId != null) result.serviceInstanceId = serviceInstanceId;
    if (characteristicInstanceId != null)
      result.characteristicInstanceId = characteristicInstanceId;
    return result;
  }

  CharacteristicAddress._();

  factory CharacteristicAddress.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CharacteristicAddress.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CharacteristicAddress',
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId', protoName: 'deviceId')
    ..aOM<Uuid>(2, _omitFieldNames ? '' : 'serviceUuid',
        protoName: 'serviceUuid', subBuilder: Uuid.create)
    ..aOM<Uuid>(3, _omitFieldNames ? '' : 'characteristicUuid',
        protoName: 'characteristicUuid', subBuilder: Uuid.create)
    ..aOS(4, _omitFieldNames ? '' : 'serviceInstanceId',
        protoName: 'serviceInstanceId')
    ..aOS(5, _omitFieldNames ? '' : 'characteristicInstanceId',
        protoName: 'characteristicInstanceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CharacteristicAddress clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CharacteristicAddress copyWith(
          void Function(CharacteristicAddress) updates) =>
      super.copyWith((message) => updates(message as CharacteristicAddress))
          as CharacteristicAddress;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CharacteristicAddress create() => CharacteristicAddress._();
  @$core.override
  CharacteristicAddress createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CharacteristicAddress getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CharacteristicAddress>(create);
  static CharacteristicAddress? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  Uuid get serviceUuid => $_getN(1);
  @$pb.TagNumber(2)
  set serviceUuid(Uuid value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasServiceUuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearServiceUuid() => $_clearField(2);
  @$pb.TagNumber(2)
  Uuid ensureServiceUuid() => $_ensure(1);

  @$pb.TagNumber(3)
  Uuid get characteristicUuid => $_getN(2);
  @$pb.TagNumber(3)
  set characteristicUuid(Uuid value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCharacteristicUuid() => $_has(2);
  @$pb.TagNumber(3)
  void clearCharacteristicUuid() => $_clearField(3);
  @$pb.TagNumber(3)
  Uuid ensureCharacteristicUuid() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get serviceInstanceId => $_getSZ(3);
  @$pb.TagNumber(4)
  set serviceInstanceId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasServiceInstanceId() => $_has(3);
  @$pb.TagNumber(4)
  void clearServiceInstanceId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get characteristicInstanceId => $_getSZ(4);
  @$pb.TagNumber(5)
  set characteristicInstanceId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCharacteristicInstanceId() => $_has(4);
  @$pb.TagNumber(5)
  void clearCharacteristicInstanceId() => $_clearField(5);
}

class ServiceDataEntry extends $pb.GeneratedMessage {
  factory ServiceDataEntry({
    Uuid? serviceUuid,
    $core.List<$core.int>? data,
  }) {
    final result = create();
    if (serviceUuid != null) result.serviceUuid = serviceUuid;
    if (data != null) result.data = data;
    return result;
  }

  ServiceDataEntry._();

  factory ServiceDataEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceDataEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceDataEntry',
      createEmptyInstance: create)
    ..aOM<Uuid>(1, _omitFieldNames ? '' : 'serviceUuid',
        protoName: 'serviceUuid', subBuilder: Uuid.create)
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceDataEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceDataEntry copyWith(void Function(ServiceDataEntry) updates) =>
      super.copyWith((message) => updates(message as ServiceDataEntry))
          as ServiceDataEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceDataEntry create() => ServiceDataEntry._();
  @$core.override
  ServiceDataEntry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServiceDataEntry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceDataEntry>(create);
  static ServiceDataEntry? _defaultInstance;

  @$pb.TagNumber(1)
  Uuid get serviceUuid => $_getN(0);
  @$pb.TagNumber(1)
  set serviceUuid(Uuid value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasServiceUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceUuid() => $_clearField(1);
  @$pb.TagNumber(1)
  Uuid ensureServiceUuid() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<$core.int> get data => $_getN(1);
  @$pb.TagNumber(2)
  set data($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasData() => $_has(1);
  @$pb.TagNumber(2)
  void clearData() => $_clearField(2);
}

class ServicesWithCharacteristics extends $pb.GeneratedMessage {
  factory ServicesWithCharacteristics({
    $core.Iterable<ServiceWithCharacteristics>? items,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    return result;
  }

  ServicesWithCharacteristics._();

  factory ServicesWithCharacteristics.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServicesWithCharacteristics.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServicesWithCharacteristics',
      createEmptyInstance: create)
    ..pPM<ServiceWithCharacteristics>(1, _omitFieldNames ? '' : 'items',
        subBuilder: ServiceWithCharacteristics.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServicesWithCharacteristics clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServicesWithCharacteristics copyWith(
          void Function(ServicesWithCharacteristics) updates) =>
      super.copyWith(
              (message) => updates(message as ServicesWithCharacteristics))
          as ServicesWithCharacteristics;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServicesWithCharacteristics create() =>
      ServicesWithCharacteristics._();
  @$core.override
  ServicesWithCharacteristics createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServicesWithCharacteristics getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServicesWithCharacteristics>(create);
  static ServicesWithCharacteristics? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ServiceWithCharacteristics> get items => $_getList(0);
}

class ServiceWithCharacteristics extends $pb.GeneratedMessage {
  factory ServiceWithCharacteristics({
    Uuid? serviceId,
    $core.Iterable<Uuid>? characteristics,
  }) {
    final result = create();
    if (serviceId != null) result.serviceId = serviceId;
    if (characteristics != null) result.characteristics.addAll(characteristics);
    return result;
  }

  ServiceWithCharacteristics._();

  factory ServiceWithCharacteristics.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceWithCharacteristics.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceWithCharacteristics',
      createEmptyInstance: create)
    ..aOM<Uuid>(1, _omitFieldNames ? '' : 'serviceId',
        protoName: 'serviceId', subBuilder: Uuid.create)
    ..pPM<Uuid>(2, _omitFieldNames ? '' : 'characteristics',
        subBuilder: Uuid.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceWithCharacteristics clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceWithCharacteristics copyWith(
          void Function(ServiceWithCharacteristics) updates) =>
      super.copyWith(
              (message) => updates(message as ServiceWithCharacteristics))
          as ServiceWithCharacteristics;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceWithCharacteristics create() => ServiceWithCharacteristics._();
  @$core.override
  ServiceWithCharacteristics createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServiceWithCharacteristics getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceWithCharacteristics>(create);
  static ServiceWithCharacteristics? _defaultInstance;

  @$pb.TagNumber(1)
  Uuid get serviceId => $_getN(0);
  @$pb.TagNumber(1)
  set serviceId(Uuid value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasServiceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceId() => $_clearField(1);
  @$pb.TagNumber(1)
  Uuid ensureServiceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<Uuid> get characteristics => $_getList(1);
}

class DiscoverServicesRequest extends $pb.GeneratedMessage {
  factory DiscoverServicesRequest({
    $core.String? deviceId,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    return result;
  }

  DiscoverServicesRequest._();

  factory DiscoverServicesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DiscoverServicesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DiscoverServicesRequest',
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId', protoName: 'deviceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiscoverServicesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiscoverServicesRequest copyWith(
          void Function(DiscoverServicesRequest) updates) =>
      super.copyWith((message) => updates(message as DiscoverServicesRequest))
          as DiscoverServicesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DiscoverServicesRequest create() => DiscoverServicesRequest._();
  @$core.override
  DiscoverServicesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DiscoverServicesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DiscoverServicesRequest>(create);
  static DiscoverServicesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);
}

class DiscoverServicesInfo extends $pb.GeneratedMessage {
  factory DiscoverServicesInfo({
    $core.String? deviceId,
    $core.Iterable<DiscoveredService>? services,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    if (services != null) result.services.addAll(services);
    return result;
  }

  DiscoverServicesInfo._();

  factory DiscoverServicesInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DiscoverServicesInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DiscoverServicesInfo',
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId', protoName: 'deviceId')
    ..pPM<DiscoveredService>(2, _omitFieldNames ? '' : 'services',
        subBuilder: DiscoveredService.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiscoverServicesInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiscoverServicesInfo copyWith(void Function(DiscoverServicesInfo) updates) =>
      super.copyWith((message) => updates(message as DiscoverServicesInfo))
          as DiscoverServicesInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DiscoverServicesInfo create() => DiscoverServicesInfo._();
  @$core.override
  DiscoverServicesInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DiscoverServicesInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DiscoverServicesInfo>(create);
  static DiscoverServicesInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<DiscoveredService> get services => $_getList(1);
}

class DiscoveredService extends $pb.GeneratedMessage {
  factory DiscoveredService({
    Uuid? serviceUuid,
    $core.Iterable<Uuid>? characteristicUuids,
    $core.Iterable<DiscoveredService>? includedServices,
    $core.Iterable<DiscoveredCharacteristic>? characteristics,
    $core.String? serviceInstanceId,
  }) {
    final result = create();
    if (serviceUuid != null) result.serviceUuid = serviceUuid;
    if (characteristicUuids != null)
      result.characteristicUuids.addAll(characteristicUuids);
    if (includedServices != null)
      result.includedServices.addAll(includedServices);
    if (characteristics != null) result.characteristics.addAll(characteristics);
    if (serviceInstanceId != null) result.serviceInstanceId = serviceInstanceId;
    return result;
  }

  DiscoveredService._();

  factory DiscoveredService.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DiscoveredService.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DiscoveredService',
      createEmptyInstance: create)
    ..aOM<Uuid>(1, _omitFieldNames ? '' : 'serviceUuid',
        protoName: 'serviceUuid', subBuilder: Uuid.create)
    ..pPM<Uuid>(2, _omitFieldNames ? '' : 'characteristicUuids',
        protoName: 'characteristicUuids', subBuilder: Uuid.create)
    ..pPM<DiscoveredService>(3, _omitFieldNames ? '' : 'includedServices',
        protoName: 'includedServices', subBuilder: DiscoveredService.create)
    ..pPM<DiscoveredCharacteristic>(4, _omitFieldNames ? '' : 'characteristics',
        subBuilder: DiscoveredCharacteristic.create)
    ..aOS(5, _omitFieldNames ? '' : 'serviceInstanceId',
        protoName: 'serviceInstanceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiscoveredService clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiscoveredService copyWith(void Function(DiscoveredService) updates) =>
      super.copyWith((message) => updates(message as DiscoveredService))
          as DiscoveredService;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DiscoveredService create() => DiscoveredService._();
  @$core.override
  DiscoveredService createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DiscoveredService getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DiscoveredService>(create);
  static DiscoveredService? _defaultInstance;

  @$pb.TagNumber(1)
  Uuid get serviceUuid => $_getN(0);
  @$pb.TagNumber(1)
  set serviceUuid(Uuid value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasServiceUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceUuid() => $_clearField(1);
  @$pb.TagNumber(1)
  Uuid ensureServiceUuid() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<Uuid> get characteristicUuids => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<DiscoveredService> get includedServices => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<DiscoveredCharacteristic> get characteristics => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get serviceInstanceId => $_getSZ(4);
  @$pb.TagNumber(5)
  set serviceInstanceId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasServiceInstanceId() => $_has(4);
  @$pb.TagNumber(5)
  void clearServiceInstanceId() => $_clearField(5);
}

class DiscoveredCharacteristic extends $pb.GeneratedMessage {
  factory DiscoveredCharacteristic({
    Uuid? characteristicId,
    Uuid? serviceId,
    $core.bool? isReadable,
    $core.bool? isWritableWithResponse,
    $core.bool? isWritableWithoutResponse,
    $core.bool? isNotifiable,
    $core.bool? isIndicatable,
    $core.String? characteristicInstanceId,
  }) {
    final result = create();
    if (characteristicId != null) result.characteristicId = characteristicId;
    if (serviceId != null) result.serviceId = serviceId;
    if (isReadable != null) result.isReadable = isReadable;
    if (isWritableWithResponse != null)
      result.isWritableWithResponse = isWritableWithResponse;
    if (isWritableWithoutResponse != null)
      result.isWritableWithoutResponse = isWritableWithoutResponse;
    if (isNotifiable != null) result.isNotifiable = isNotifiable;
    if (isIndicatable != null) result.isIndicatable = isIndicatable;
    if (characteristicInstanceId != null)
      result.characteristicInstanceId = characteristicInstanceId;
    return result;
  }

  DiscoveredCharacteristic._();

  factory DiscoveredCharacteristic.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DiscoveredCharacteristic.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DiscoveredCharacteristic',
      createEmptyInstance: create)
    ..aOM<Uuid>(1, _omitFieldNames ? '' : 'characteristicId',
        protoName: 'characteristicId', subBuilder: Uuid.create)
    ..aOM<Uuid>(2, _omitFieldNames ? '' : 'serviceId',
        protoName: 'serviceId', subBuilder: Uuid.create)
    ..aOB(3, _omitFieldNames ? '' : 'isReadable', protoName: 'isReadable')
    ..aOB(4, _omitFieldNames ? '' : 'isWritableWithResponse',
        protoName: 'isWritableWithResponse')
    ..aOB(5, _omitFieldNames ? '' : 'isWritableWithoutResponse',
        protoName: 'isWritableWithoutResponse')
    ..aOB(6, _omitFieldNames ? '' : 'isNotifiable', protoName: 'isNotifiable')
    ..aOB(7, _omitFieldNames ? '' : 'isIndicatable', protoName: 'isIndicatable')
    ..aOS(8, _omitFieldNames ? '' : 'characteristicInstanceId',
        protoName: 'characteristicInstanceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiscoveredCharacteristic clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiscoveredCharacteristic copyWith(
          void Function(DiscoveredCharacteristic) updates) =>
      super.copyWith((message) => updates(message as DiscoveredCharacteristic))
          as DiscoveredCharacteristic;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DiscoveredCharacteristic create() => DiscoveredCharacteristic._();
  @$core.override
  DiscoveredCharacteristic createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DiscoveredCharacteristic getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DiscoveredCharacteristic>(create);
  static DiscoveredCharacteristic? _defaultInstance;

  @$pb.TagNumber(1)
  Uuid get characteristicId => $_getN(0);
  @$pb.TagNumber(1)
  set characteristicId(Uuid value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCharacteristicId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCharacteristicId() => $_clearField(1);
  @$pb.TagNumber(1)
  Uuid ensureCharacteristicId() => $_ensure(0);

  @$pb.TagNumber(2)
  Uuid get serviceId => $_getN(1);
  @$pb.TagNumber(2)
  set serviceId(Uuid value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasServiceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearServiceId() => $_clearField(2);
  @$pb.TagNumber(2)
  Uuid ensureServiceId() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get isReadable => $_getBF(2);
  @$pb.TagNumber(3)
  set isReadable($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIsReadable() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsReadable() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isWritableWithResponse => $_getBF(3);
  @$pb.TagNumber(4)
  set isWritableWithResponse($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsWritableWithResponse() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsWritableWithResponse() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get isWritableWithoutResponse => $_getBF(4);
  @$pb.TagNumber(5)
  set isWritableWithoutResponse($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsWritableWithoutResponse() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsWritableWithoutResponse() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isNotifiable => $_getBF(5);
  @$pb.TagNumber(6)
  set isNotifiable($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsNotifiable() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsNotifiable() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get isIndicatable => $_getBF(6);
  @$pb.TagNumber(7)
  set isIndicatable($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIsIndicatable() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsIndicatable() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get characteristicInstanceId => $_getSZ(7);
  @$pb.TagNumber(8)
  set characteristicInstanceId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCharacteristicInstanceId() => $_has(7);
  @$pb.TagNumber(8)
  void clearCharacteristicInstanceId() => $_clearField(8);
}

class ReadRssiRequest extends $pb.GeneratedMessage {
  factory ReadRssiRequest({
    $core.String? deviceId,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    return result;
  }

  ReadRssiRequest._();

  factory ReadRssiRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReadRssiRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReadRssiRequest',
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId', protoName: 'deviceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReadRssiRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReadRssiRequest copyWith(void Function(ReadRssiRequest) updates) =>
      super.copyWith((message) => updates(message as ReadRssiRequest))
          as ReadRssiRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReadRssiRequest create() => ReadRssiRequest._();
  @$core.override
  ReadRssiRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReadRssiRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReadRssiRequest>(create);
  static ReadRssiRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);
}

class ReadRssiResult extends $pb.GeneratedMessage {
  factory ReadRssiResult({
    $core.int? rssi,
  }) {
    final result = create();
    if (rssi != null) result.rssi = rssi;
    return result;
  }

  ReadRssiResult._();

  factory ReadRssiResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReadRssiResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReadRssiResult',
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'rssi')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReadRssiResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReadRssiResult copyWith(void Function(ReadRssiResult) updates) =>
      super.copyWith((message) => updates(message as ReadRssiResult))
          as ReadRssiResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReadRssiResult create() => ReadRssiResult._();
  @$core.override
  ReadRssiResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReadRssiResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReadRssiResult>(create);
  static ReadRssiResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get rssi => $_getIZ(0);
  @$pb.TagNumber(1)
  set rssi($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRssi() => $_has(0);
  @$pb.TagNumber(1)
  void clearRssi() => $_clearField(1);
}

class Uuid extends $pb.GeneratedMessage {
  factory Uuid({
    $core.List<$core.int>? data,
  }) {
    final result = create();
    if (data != null) result.data = data;
    return result;
  }

  Uuid._();

  factory Uuid.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Uuid.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Uuid',
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Uuid clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Uuid copyWith(void Function(Uuid) updates) =>
      super.copyWith((message) => updates(message as Uuid)) as Uuid;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Uuid create() => Uuid._();
  @$core.override
  Uuid createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Uuid getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Uuid>(create);
  static Uuid? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get data => $_getN(0);
  @$pb.TagNumber(1)
  set data($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => $_clearField(1);
}

class GenericFailure extends $pb.GeneratedMessage {
  factory GenericFailure({
    $core.int? code,
    $core.String? message,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (message != null) result.message = message;
    return result;
  }

  GenericFailure._();

  factory GenericFailure.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GenericFailure.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GenericFailure',
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GenericFailure clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GenericFailure copyWith(void Function(GenericFailure) updates) =>
      super.copyWith((message) => updates(message as GenericFailure))
          as GenericFailure;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GenericFailure create() => GenericFailure._();
  @$core.override
  GenericFailure createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GenericFailure getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GenericFailure>(create);
  static GenericFailure? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get code => $_getIZ(0);
  @$pb.TagNumber(1)
  set code($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);
}

class IsConnectable extends $pb.GeneratedMessage {
  factory IsConnectable({
    $core.int? code,
  }) {
    final result = create();
    if (code != null) result.code = code;
    return result;
  }

  IsConnectable._();

  factory IsConnectable.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IsConnectable.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IsConnectable',
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'code')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IsConnectable clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IsConnectable copyWith(void Function(IsConnectable) updates) =>
      super.copyWith((message) => updates(message as IsConnectable))
          as IsConnectable;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IsConnectable create() => IsConnectable._();
  @$core.override
  IsConnectable createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IsConnectable getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IsConnectable>(create);
  static IsConnectable? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get code => $_getIZ(0);
  @$pb.TagNumber(1)
  set code($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
