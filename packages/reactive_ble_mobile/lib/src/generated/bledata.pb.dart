//
//  Generated code. Do not modify.
//  source: bledata.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class LaunchCompanionRequest extends $pb.GeneratedMessage {
  factory LaunchCompanionRequest() => create();
  LaunchCompanionRequest._() : super();
  factory LaunchCompanionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LaunchCompanionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LaunchCompanionRequest', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'pattern')
    ..aOB(2, _omitFieldNames ? '' : 'singleDeviceScan', protoName: 'singleDeviceScan')
    ..aOB(3, _omitFieldNames ? '' : 'forceConfirmation', protoName: 'forceConfirmation')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LaunchCompanionRequest clone() => LaunchCompanionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LaunchCompanionRequest copyWith(void Function(LaunchCompanionRequest) updates) => super.copyWith((message) => updates(message as LaunchCompanionRequest)) as LaunchCompanionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LaunchCompanionRequest create() => LaunchCompanionRequest._();
  LaunchCompanionRequest createEmptyInstance() => create();
  static $pb.PbList<LaunchCompanionRequest> createRepeated() => $pb.PbList<LaunchCompanionRequest>();
  @$core.pragma('dart2js:noInline')
  static LaunchCompanionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LaunchCompanionRequest>(create);
  static LaunchCompanionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pattern => $_getSZ(0);
  @$pb.TagNumber(1)
  set pattern($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPattern() => $_has(0);
  @$pb.TagNumber(1)
  void clearPattern() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get singleDeviceScan => $_getBF(1);
  @$pb.TagNumber(2)
  set singleDeviceScan($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSingleDeviceScan() => $_has(1);
  @$pb.TagNumber(2)
  void clearSingleDeviceScan() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get forceConfirmation => $_getBF(2);
  @$pb.TagNumber(3)
  set forceConfirmation($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasForceConfirmation() => $_has(2);
  @$pb.TagNumber(3)
  void clearForceConfirmation() => clearField(3);
}

class AssociationInfo extends $pb.GeneratedMessage {
  factory AssociationInfo() => create();
  AssociationInfo._() : super();
  factory AssociationInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AssociationInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AssociationInfo', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceMacAddress', protoName: 'deviceMacAddress')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AssociationInfo clone() => AssociationInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AssociationInfo copyWith(void Function(AssociationInfo) updates) => super.copyWith((message) => updates(message as AssociationInfo)) as AssociationInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AssociationInfo create() => AssociationInfo._();
  AssociationInfo createEmptyInstance() => create();
  static $pb.PbList<AssociationInfo> createRepeated() => $pb.PbList<AssociationInfo>();
  @$core.pragma('dart2js:noInline')
  static AssociationInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AssociationInfo>(create);
  static AssociationInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceMacAddress => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceMacAddress($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDeviceMacAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceMacAddress() => clearField(1);
}

class ScanForDevicesRequest extends $pb.GeneratedMessage {
  factory ScanForDevicesRequest() => create();
  ScanForDevicesRequest._() : super();
  factory ScanForDevicesRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ScanForDevicesRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ScanForDevicesRequest', createEmptyInstance: create)
    ..pc<Uuid>(1, _omitFieldNames ? '' : 'serviceUuids', $pb.PbFieldType.PM, protoName: 'serviceUuids', subBuilder: Uuid.create)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'scanMode', $pb.PbFieldType.O3, protoName: 'scanMode')
    ..aOB(3, _omitFieldNames ? '' : 'requireLocationServicesEnabled', protoName: 'requireLocationServicesEnabled')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ScanForDevicesRequest clone() => ScanForDevicesRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ScanForDevicesRequest copyWith(void Function(ScanForDevicesRequest) updates) => super.copyWith((message) => updates(message as ScanForDevicesRequest)) as ScanForDevicesRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScanForDevicesRequest create() => ScanForDevicesRequest._();
  ScanForDevicesRequest createEmptyInstance() => create();
  static $pb.PbList<ScanForDevicesRequest> createRepeated() => $pb.PbList<ScanForDevicesRequest>();
  @$core.pragma('dart2js:noInline')
  static ScanForDevicesRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ScanForDevicesRequest>(create);
  static ScanForDevicesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Uuid> get serviceUuids => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get scanMode => $_getIZ(1);
  @$pb.TagNumber(2)
  set scanMode($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasScanMode() => $_has(1);
  @$pb.TagNumber(2)
  void clearScanMode() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get requireLocationServicesEnabled => $_getBF(2);
  @$pb.TagNumber(3)
  set requireLocationServicesEnabled($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRequireLocationServicesEnabled() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequireLocationServicesEnabled() => clearField(3);
}

class DeviceScanInfo extends $pb.GeneratedMessage {
  factory DeviceScanInfo() => create();
  DeviceScanInfo._() : super();
  factory DeviceScanInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeviceScanInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeviceScanInfo', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOM<GenericFailure>(3, _omitFieldNames ? '' : 'failure', subBuilder: GenericFailure.create)
    ..pc<ServiceDataEntry>(4, _omitFieldNames ? '' : 'serviceData', $pb.PbFieldType.PM, protoName: 'serviceData', subBuilder: ServiceDataEntry.create)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'rssi', $pb.PbFieldType.O3)
    ..a<$core.List<$core.int>>(6, _omitFieldNames ? '' : 'manufacturerData', $pb.PbFieldType.OY, protoName: 'manufacturerData')
    ..pc<Uuid>(7, _omitFieldNames ? '' : 'serviceUuids', $pb.PbFieldType.PM, protoName: 'serviceUuids', subBuilder: Uuid.create)
    ..aOM<IsConnectable>(8, _omitFieldNames ? '' : 'isConnectable', protoName: 'isConnectable', subBuilder: IsConnectable.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeviceScanInfo clone() => DeviceScanInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeviceScanInfo copyWith(void Function(DeviceScanInfo) updates) => super.copyWith((message) => updates(message as DeviceScanInfo)) as DeviceScanInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeviceScanInfo create() => DeviceScanInfo._();
  DeviceScanInfo createEmptyInstance() => create();
  static $pb.PbList<DeviceScanInfo> createRepeated() => $pb.PbList<DeviceScanInfo>();
  @$core.pragma('dart2js:noInline')
  static DeviceScanInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeviceScanInfo>(create);
  static DeviceScanInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  GenericFailure get failure => $_getN(2);
  @$pb.TagNumber(3)
  set failure(GenericFailure v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasFailure() => $_has(2);
  @$pb.TagNumber(3)
  void clearFailure() => clearField(3);
  @$pb.TagNumber(3)
  GenericFailure ensureFailure() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.List<ServiceDataEntry> get serviceData => $_getList(3);

  @$pb.TagNumber(5)
  $core.int get rssi => $_getIZ(4);
  @$pb.TagNumber(5)
  set rssi($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasRssi() => $_has(4);
  @$pb.TagNumber(5)
  void clearRssi() => clearField(5);

  @$pb.TagNumber(6)
  $core.List<$core.int> get manufacturerData => $_getN(5);
  @$pb.TagNumber(6)
  set manufacturerData($core.List<$core.int> v) { $_setBytes(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasManufacturerData() => $_has(5);
  @$pb.TagNumber(6)
  void clearManufacturerData() => clearField(6);

  @$pb.TagNumber(7)
  $core.List<Uuid> get serviceUuids => $_getList(6);

  @$pb.TagNumber(8)
  IsConnectable get isConnectable => $_getN(7);
  @$pb.TagNumber(8)
  set isConnectable(IsConnectable v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasIsConnectable() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsConnectable() => clearField(8);
  @$pb.TagNumber(8)
  IsConnectable ensureIsConnectable() => $_ensure(7);
}

class ConnectToDeviceRequest extends $pb.GeneratedMessage {
  factory ConnectToDeviceRequest() => create();
  ConnectToDeviceRequest._() : super();
  factory ConnectToDeviceRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ConnectToDeviceRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ConnectToDeviceRequest', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId', protoName: 'deviceId')
    ..aOM<ServicesWithCharacteristics>(2, _omitFieldNames ? '' : 'servicesWithCharacteristicsToDiscover', protoName: 'servicesWithCharacteristicsToDiscover', subBuilder: ServicesWithCharacteristics.create)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'timeoutInMs', $pb.PbFieldType.O3, protoName: 'timeoutInMs')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'bondingMode', $pb.PbFieldType.O3, protoName: 'bondingMode')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ConnectToDeviceRequest clone() => ConnectToDeviceRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ConnectToDeviceRequest copyWith(void Function(ConnectToDeviceRequest) updates) => super.copyWith((message) => updates(message as ConnectToDeviceRequest)) as ConnectToDeviceRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConnectToDeviceRequest create() => ConnectToDeviceRequest._();
  ConnectToDeviceRequest createEmptyInstance() => create();
  static $pb.PbList<ConnectToDeviceRequest> createRepeated() => $pb.PbList<ConnectToDeviceRequest>();
  @$core.pragma('dart2js:noInline')
  static ConnectToDeviceRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConnectToDeviceRequest>(create);
  static ConnectToDeviceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => clearField(1);

  @$pb.TagNumber(2)
  ServicesWithCharacteristics get servicesWithCharacteristicsToDiscover => $_getN(1);
  @$pb.TagNumber(2)
  set servicesWithCharacteristicsToDiscover(ServicesWithCharacteristics v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasServicesWithCharacteristicsToDiscover() => $_has(1);
  @$pb.TagNumber(2)
  void clearServicesWithCharacteristicsToDiscover() => clearField(2);
  @$pb.TagNumber(2)
  ServicesWithCharacteristics ensureServicesWithCharacteristicsToDiscover() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get timeoutInMs => $_getIZ(2);
  @$pb.TagNumber(3)
  set timeoutInMs($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTimeoutInMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimeoutInMs() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get bondingMode => $_getIZ(3);
  @$pb.TagNumber(4)
  set bondingMode($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasBondingMode() => $_has(3);
  @$pb.TagNumber(4)
  void clearBondingMode() => clearField(4);
}

class DeviceInfo extends $pb.GeneratedMessage {
  factory DeviceInfo() => create();
  DeviceInfo._() : super();
  factory DeviceInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeviceInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeviceInfo', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'connectionState', $pb.PbFieldType.O3, protoName: 'connectionState')
    ..aOM<GenericFailure>(3, _omitFieldNames ? '' : 'failure', subBuilder: GenericFailure.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeviceInfo clone() => DeviceInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeviceInfo copyWith(void Function(DeviceInfo) updates) => super.copyWith((message) => updates(message as DeviceInfo)) as DeviceInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeviceInfo create() => DeviceInfo._();
  DeviceInfo createEmptyInstance() => create();
  static $pb.PbList<DeviceInfo> createRepeated() => $pb.PbList<DeviceInfo>();
  @$core.pragma('dart2js:noInline')
  static DeviceInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeviceInfo>(create);
  static DeviceInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get connectionState => $_getIZ(1);
  @$pb.TagNumber(2)
  set connectionState($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasConnectionState() => $_has(1);
  @$pb.TagNumber(2)
  void clearConnectionState() => clearField(2);

  @$pb.TagNumber(3)
  GenericFailure get failure => $_getN(2);
  @$pb.TagNumber(3)
  set failure(GenericFailure v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasFailure() => $_has(2);
  @$pb.TagNumber(3)
  void clearFailure() => clearField(3);
  @$pb.TagNumber(3)
  GenericFailure ensureFailure() => $_ensure(2);
}

class GetDeviceNameRequest extends $pb.GeneratedMessage {
  factory GetDeviceNameRequest() => create();
  GetDeviceNameRequest._() : super();
  factory GetDeviceNameRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetDeviceNameRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetDeviceNameRequest', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId', protoName: 'deviceId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetDeviceNameRequest clone() => GetDeviceNameRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetDeviceNameRequest copyWith(void Function(GetDeviceNameRequest) updates) => super.copyWith((message) => updates(message as GetDeviceNameRequest)) as GetDeviceNameRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDeviceNameRequest create() => GetDeviceNameRequest._();
  GetDeviceNameRequest createEmptyInstance() => create();
  static $pb.PbList<GetDeviceNameRequest> createRepeated() => $pb.PbList<GetDeviceNameRequest>();
  @$core.pragma('dart2js:noInline')
  static GetDeviceNameRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetDeviceNameRequest>(create);
  static GetDeviceNameRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => clearField(1);
}

class DeviceNameInfo extends $pb.GeneratedMessage {
  factory DeviceNameInfo() => create();
  DeviceNameInfo._() : super();
  factory DeviceNameInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeviceNameInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeviceNameInfo', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'deviceName', protoName: 'deviceName')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeviceNameInfo clone() => DeviceNameInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeviceNameInfo copyWith(void Function(DeviceNameInfo) updates) => super.copyWith((message) => updates(message as DeviceNameInfo)) as DeviceNameInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeviceNameInfo create() => DeviceNameInfo._();
  DeviceNameInfo createEmptyInstance() => create();
  static $pb.PbList<DeviceNameInfo> createRepeated() => $pb.PbList<DeviceNameInfo>();
  @$core.pragma('dart2js:noInline')
  static DeviceNameInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeviceNameInfo>(create);
  static DeviceNameInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get deviceName => $_getSZ(1);
  @$pb.TagNumber(2)
  set deviceName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDeviceName() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeviceName() => clearField(2);
}

class DisconnectFromDeviceRequest extends $pb.GeneratedMessage {
  factory DisconnectFromDeviceRequest() => create();
  DisconnectFromDeviceRequest._() : super();
  factory DisconnectFromDeviceRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DisconnectFromDeviceRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DisconnectFromDeviceRequest', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId', protoName: 'deviceId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DisconnectFromDeviceRequest clone() => DisconnectFromDeviceRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DisconnectFromDeviceRequest copyWith(void Function(DisconnectFromDeviceRequest) updates) => super.copyWith((message) => updates(message as DisconnectFromDeviceRequest)) as DisconnectFromDeviceRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DisconnectFromDeviceRequest create() => DisconnectFromDeviceRequest._();
  DisconnectFromDeviceRequest createEmptyInstance() => create();
  static $pb.PbList<DisconnectFromDeviceRequest> createRepeated() => $pb.PbList<DisconnectFromDeviceRequest>();
  @$core.pragma('dart2js:noInline')
  static DisconnectFromDeviceRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DisconnectFromDeviceRequest>(create);
  static DisconnectFromDeviceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => clearField(1);
}

class ClearGattCacheRequest extends $pb.GeneratedMessage {
  factory ClearGattCacheRequest() => create();
  ClearGattCacheRequest._() : super();
  factory ClearGattCacheRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ClearGattCacheRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ClearGattCacheRequest', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId', protoName: 'deviceId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ClearGattCacheRequest clone() => ClearGattCacheRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ClearGattCacheRequest copyWith(void Function(ClearGattCacheRequest) updates) => super.copyWith((message) => updates(message as ClearGattCacheRequest)) as ClearGattCacheRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClearGattCacheRequest create() => ClearGattCacheRequest._();
  ClearGattCacheRequest createEmptyInstance() => create();
  static $pb.PbList<ClearGattCacheRequest> createRepeated() => $pb.PbList<ClearGattCacheRequest>();
  @$core.pragma('dart2js:noInline')
  static ClearGattCacheRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClearGattCacheRequest>(create);
  static ClearGattCacheRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => clearField(1);
}

class ClearGattCacheInfo extends $pb.GeneratedMessage {
  factory ClearGattCacheInfo() => create();
  ClearGattCacheInfo._() : super();
  factory ClearGattCacheInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ClearGattCacheInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ClearGattCacheInfo', createEmptyInstance: create)
    ..aOM<GenericFailure>(1, _omitFieldNames ? '' : 'failure', subBuilder: GenericFailure.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ClearGattCacheInfo clone() => ClearGattCacheInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ClearGattCacheInfo copyWith(void Function(ClearGattCacheInfo) updates) => super.copyWith((message) => updates(message as ClearGattCacheInfo)) as ClearGattCacheInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClearGattCacheInfo create() => ClearGattCacheInfo._();
  ClearGattCacheInfo createEmptyInstance() => create();
  static $pb.PbList<ClearGattCacheInfo> createRepeated() => $pb.PbList<ClearGattCacheInfo>();
  @$core.pragma('dart2js:noInline')
  static ClearGattCacheInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClearGattCacheInfo>(create);
  static ClearGattCacheInfo? _defaultInstance;

  @$pb.TagNumber(1)
  GenericFailure get failure => $_getN(0);
  @$pb.TagNumber(1)
  set failure(GenericFailure v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasFailure() => $_has(0);
  @$pb.TagNumber(1)
  void clearFailure() => clearField(1);
  @$pb.TagNumber(1)
  GenericFailure ensureFailure() => $_ensure(0);
}

class NotifyCharacteristicRequest extends $pb.GeneratedMessage {
  factory NotifyCharacteristicRequest() => create();
  NotifyCharacteristicRequest._() : super();
  factory NotifyCharacteristicRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory NotifyCharacteristicRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'NotifyCharacteristicRequest', createEmptyInstance: create)
    ..aOM<CharacteristicAddress>(1, _omitFieldNames ? '' : 'characteristic', subBuilder: CharacteristicAddress.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  NotifyCharacteristicRequest clone() => NotifyCharacteristicRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  NotifyCharacteristicRequest copyWith(void Function(NotifyCharacteristicRequest) updates) => super.copyWith((message) => updates(message as NotifyCharacteristicRequest)) as NotifyCharacteristicRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotifyCharacteristicRequest create() => NotifyCharacteristicRequest._();
  NotifyCharacteristicRequest createEmptyInstance() => create();
  static $pb.PbList<NotifyCharacteristicRequest> createRepeated() => $pb.PbList<NotifyCharacteristicRequest>();
  @$core.pragma('dart2js:noInline')
  static NotifyCharacteristicRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NotifyCharacteristicRequest>(create);
  static NotifyCharacteristicRequest? _defaultInstance;

  @$pb.TagNumber(1)
  CharacteristicAddress get characteristic => $_getN(0);
  @$pb.TagNumber(1)
  set characteristic(CharacteristicAddress v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCharacteristic() => $_has(0);
  @$pb.TagNumber(1)
  void clearCharacteristic() => clearField(1);
  @$pb.TagNumber(1)
  CharacteristicAddress ensureCharacteristic() => $_ensure(0);
}

class NotifyNoMoreCharacteristicRequest extends $pb.GeneratedMessage {
  factory NotifyNoMoreCharacteristicRequest() => create();
  NotifyNoMoreCharacteristicRequest._() : super();
  factory NotifyNoMoreCharacteristicRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory NotifyNoMoreCharacteristicRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'NotifyNoMoreCharacteristicRequest', createEmptyInstance: create)
    ..aOM<CharacteristicAddress>(1, _omitFieldNames ? '' : 'characteristic', subBuilder: CharacteristicAddress.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  NotifyNoMoreCharacteristicRequest clone() => NotifyNoMoreCharacteristicRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  NotifyNoMoreCharacteristicRequest copyWith(void Function(NotifyNoMoreCharacteristicRequest) updates) => super.copyWith((message) => updates(message as NotifyNoMoreCharacteristicRequest)) as NotifyNoMoreCharacteristicRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NotifyNoMoreCharacteristicRequest create() => NotifyNoMoreCharacteristicRequest._();
  NotifyNoMoreCharacteristicRequest createEmptyInstance() => create();
  static $pb.PbList<NotifyNoMoreCharacteristicRequest> createRepeated() => $pb.PbList<NotifyNoMoreCharacteristicRequest>();
  @$core.pragma('dart2js:noInline')
  static NotifyNoMoreCharacteristicRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NotifyNoMoreCharacteristicRequest>(create);
  static NotifyNoMoreCharacteristicRequest? _defaultInstance;

  @$pb.TagNumber(1)
  CharacteristicAddress get characteristic => $_getN(0);
  @$pb.TagNumber(1)
  set characteristic(CharacteristicAddress v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCharacteristic() => $_has(0);
  @$pb.TagNumber(1)
  void clearCharacteristic() => clearField(1);
  @$pb.TagNumber(1)
  CharacteristicAddress ensureCharacteristic() => $_ensure(0);
}

class ReadCharacteristicRequest extends $pb.GeneratedMessage {
  factory ReadCharacteristicRequest() => create();
  ReadCharacteristicRequest._() : super();
  factory ReadCharacteristicRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReadCharacteristicRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ReadCharacteristicRequest', createEmptyInstance: create)
    ..aOM<CharacteristicAddress>(1, _omitFieldNames ? '' : 'characteristic', subBuilder: CharacteristicAddress.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReadCharacteristicRequest clone() => ReadCharacteristicRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReadCharacteristicRequest copyWith(void Function(ReadCharacteristicRequest) updates) => super.copyWith((message) => updates(message as ReadCharacteristicRequest)) as ReadCharacteristicRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReadCharacteristicRequest create() => ReadCharacteristicRequest._();
  ReadCharacteristicRequest createEmptyInstance() => create();
  static $pb.PbList<ReadCharacteristicRequest> createRepeated() => $pb.PbList<ReadCharacteristicRequest>();
  @$core.pragma('dart2js:noInline')
  static ReadCharacteristicRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReadCharacteristicRequest>(create);
  static ReadCharacteristicRequest? _defaultInstance;

  @$pb.TagNumber(1)
  CharacteristicAddress get characteristic => $_getN(0);
  @$pb.TagNumber(1)
  set characteristic(CharacteristicAddress v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCharacteristic() => $_has(0);
  @$pb.TagNumber(1)
  void clearCharacteristic() => clearField(1);
  @$pb.TagNumber(1)
  CharacteristicAddress ensureCharacteristic() => $_ensure(0);
}

class CharacteristicValueInfo extends $pb.GeneratedMessage {
  factory CharacteristicValueInfo() => create();
  CharacteristicValueInfo._() : super();
  factory CharacteristicValueInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CharacteristicValueInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CharacteristicValueInfo', createEmptyInstance: create)
    ..aOM<CharacteristicAddress>(1, _omitFieldNames ? '' : 'characteristic', subBuilder: CharacteristicAddress.create)
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'value', $pb.PbFieldType.OY)
    ..aOM<GenericFailure>(3, _omitFieldNames ? '' : 'failure', subBuilder: GenericFailure.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CharacteristicValueInfo clone() => CharacteristicValueInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CharacteristicValueInfo copyWith(void Function(CharacteristicValueInfo) updates) => super.copyWith((message) => updates(message as CharacteristicValueInfo)) as CharacteristicValueInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CharacteristicValueInfo create() => CharacteristicValueInfo._();
  CharacteristicValueInfo createEmptyInstance() => create();
  static $pb.PbList<CharacteristicValueInfo> createRepeated() => $pb.PbList<CharacteristicValueInfo>();
  @$core.pragma('dart2js:noInline')
  static CharacteristicValueInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CharacteristicValueInfo>(create);
  static CharacteristicValueInfo? _defaultInstance;

  @$pb.TagNumber(1)
  CharacteristicAddress get characteristic => $_getN(0);
  @$pb.TagNumber(1)
  set characteristic(CharacteristicAddress v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCharacteristic() => $_has(0);
  @$pb.TagNumber(1)
  void clearCharacteristic() => clearField(1);
  @$pb.TagNumber(1)
  CharacteristicAddress ensureCharacteristic() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<$core.int> get value => $_getN(1);
  @$pb.TagNumber(2)
  set value($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => clearField(2);

  @$pb.TagNumber(3)
  GenericFailure get failure => $_getN(2);
  @$pb.TagNumber(3)
  set failure(GenericFailure v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasFailure() => $_has(2);
  @$pb.TagNumber(3)
  void clearFailure() => clearField(3);
  @$pb.TagNumber(3)
  GenericFailure ensureFailure() => $_ensure(2);
}

class WriteCharacteristicRequest extends $pb.GeneratedMessage {
  factory WriteCharacteristicRequest() => create();
  WriteCharacteristicRequest._() : super();
  factory WriteCharacteristicRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WriteCharacteristicRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'WriteCharacteristicRequest', createEmptyInstance: create)
    ..aOM<CharacteristicAddress>(1, _omitFieldNames ? '' : 'characteristic', subBuilder: CharacteristicAddress.create)
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'value', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WriteCharacteristicRequest clone() => WriteCharacteristicRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WriteCharacteristicRequest copyWith(void Function(WriteCharacteristicRequest) updates) => super.copyWith((message) => updates(message as WriteCharacteristicRequest)) as WriteCharacteristicRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WriteCharacteristicRequest create() => WriteCharacteristicRequest._();
  WriteCharacteristicRequest createEmptyInstance() => create();
  static $pb.PbList<WriteCharacteristicRequest> createRepeated() => $pb.PbList<WriteCharacteristicRequest>();
  @$core.pragma('dart2js:noInline')
  static WriteCharacteristicRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WriteCharacteristicRequest>(create);
  static WriteCharacteristicRequest? _defaultInstance;

  @$pb.TagNumber(1)
  CharacteristicAddress get characteristic => $_getN(0);
  @$pb.TagNumber(1)
  set characteristic(CharacteristicAddress v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCharacteristic() => $_has(0);
  @$pb.TagNumber(1)
  void clearCharacteristic() => clearField(1);
  @$pb.TagNumber(1)
  CharacteristicAddress ensureCharacteristic() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<$core.int> get value => $_getN(1);
  @$pb.TagNumber(2)
  set value($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => clearField(2);
}

class WriteCharacteristicInfo extends $pb.GeneratedMessage {
  factory WriteCharacteristicInfo() => create();
  WriteCharacteristicInfo._() : super();
  factory WriteCharacteristicInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WriteCharacteristicInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'WriteCharacteristicInfo', createEmptyInstance: create)
    ..aOM<CharacteristicAddress>(1, _omitFieldNames ? '' : 'characteristic', subBuilder: CharacteristicAddress.create)
    ..aOM<GenericFailure>(3, _omitFieldNames ? '' : 'failure', subBuilder: GenericFailure.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WriteCharacteristicInfo clone() => WriteCharacteristicInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WriteCharacteristicInfo copyWith(void Function(WriteCharacteristicInfo) updates) => super.copyWith((message) => updates(message as WriteCharacteristicInfo)) as WriteCharacteristicInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WriteCharacteristicInfo create() => WriteCharacteristicInfo._();
  WriteCharacteristicInfo createEmptyInstance() => create();
  static $pb.PbList<WriteCharacteristicInfo> createRepeated() => $pb.PbList<WriteCharacteristicInfo>();
  @$core.pragma('dart2js:noInline')
  static WriteCharacteristicInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WriteCharacteristicInfo>(create);
  static WriteCharacteristicInfo? _defaultInstance;

  @$pb.TagNumber(1)
  CharacteristicAddress get characteristic => $_getN(0);
  @$pb.TagNumber(1)
  set characteristic(CharacteristicAddress v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCharacteristic() => $_has(0);
  @$pb.TagNumber(1)
  void clearCharacteristic() => clearField(1);
  @$pb.TagNumber(1)
  CharacteristicAddress ensureCharacteristic() => $_ensure(0);

  @$pb.TagNumber(3)
  GenericFailure get failure => $_getN(1);
  @$pb.TagNumber(3)
  set failure(GenericFailure v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasFailure() => $_has(1);
  @$pb.TagNumber(3)
  void clearFailure() => clearField(3);
  @$pb.TagNumber(3)
  GenericFailure ensureFailure() => $_ensure(1);
}

class NegotiateMtuRequest extends $pb.GeneratedMessage {
  factory NegotiateMtuRequest() => create();
  NegotiateMtuRequest._() : super();
  factory NegotiateMtuRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory NegotiateMtuRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'NegotiateMtuRequest', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId', protoName: 'deviceId')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'mtuSize', $pb.PbFieldType.O3, protoName: 'mtuSize')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  NegotiateMtuRequest clone() => NegotiateMtuRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  NegotiateMtuRequest copyWith(void Function(NegotiateMtuRequest) updates) => super.copyWith((message) => updates(message as NegotiateMtuRequest)) as NegotiateMtuRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NegotiateMtuRequest create() => NegotiateMtuRequest._();
  NegotiateMtuRequest createEmptyInstance() => create();
  static $pb.PbList<NegotiateMtuRequest> createRepeated() => $pb.PbList<NegotiateMtuRequest>();
  @$core.pragma('dart2js:noInline')
  static NegotiateMtuRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NegotiateMtuRequest>(create);
  static NegotiateMtuRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get mtuSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set mtuSize($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMtuSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearMtuSize() => clearField(2);
}

class NegotiateMtuInfo extends $pb.GeneratedMessage {
  factory NegotiateMtuInfo() => create();
  NegotiateMtuInfo._() : super();
  factory NegotiateMtuInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory NegotiateMtuInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'NegotiateMtuInfo', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId', protoName: 'deviceId')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'mtuSize', $pb.PbFieldType.O3, protoName: 'mtuSize')
    ..aOM<GenericFailure>(3, _omitFieldNames ? '' : 'failure', subBuilder: GenericFailure.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  NegotiateMtuInfo clone() => NegotiateMtuInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  NegotiateMtuInfo copyWith(void Function(NegotiateMtuInfo) updates) => super.copyWith((message) => updates(message as NegotiateMtuInfo)) as NegotiateMtuInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NegotiateMtuInfo create() => NegotiateMtuInfo._();
  NegotiateMtuInfo createEmptyInstance() => create();
  static $pb.PbList<NegotiateMtuInfo> createRepeated() => $pb.PbList<NegotiateMtuInfo>();
  @$core.pragma('dart2js:noInline')
  static NegotiateMtuInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NegotiateMtuInfo>(create);
  static NegotiateMtuInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get mtuSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set mtuSize($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMtuSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearMtuSize() => clearField(2);

  @$pb.TagNumber(3)
  GenericFailure get failure => $_getN(2);
  @$pb.TagNumber(3)
  set failure(GenericFailure v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasFailure() => $_has(2);
  @$pb.TagNumber(3)
  void clearFailure() => clearField(3);
  @$pb.TagNumber(3)
  GenericFailure ensureFailure() => $_ensure(2);
}

class BleStatusInfo extends $pb.GeneratedMessage {
  factory BleStatusInfo() => create();
  BleStatusInfo._() : super();
  factory BleStatusInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BleStatusInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BleStatusInfo', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'status', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BleStatusInfo clone() => BleStatusInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BleStatusInfo copyWith(void Function(BleStatusInfo) updates) => super.copyWith((message) => updates(message as BleStatusInfo)) as BleStatusInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BleStatusInfo create() => BleStatusInfo._();
  BleStatusInfo createEmptyInstance() => create();
  static $pb.PbList<BleStatusInfo> createRepeated() => $pb.PbList<BleStatusInfo>();
  @$core.pragma('dart2js:noInline')
  static BleStatusInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BleStatusInfo>(create);
  static BleStatusInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get status => $_getIZ(0);
  @$pb.TagNumber(1)
  set status($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);
}

class ChangeConnectionPriorityRequest extends $pb.GeneratedMessage {
  factory ChangeConnectionPriorityRequest() => create();
  ChangeConnectionPriorityRequest._() : super();
  factory ChangeConnectionPriorityRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ChangeConnectionPriorityRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChangeConnectionPriorityRequest', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId', protoName: 'deviceId')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'priority', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ChangeConnectionPriorityRequest clone() => ChangeConnectionPriorityRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ChangeConnectionPriorityRequest copyWith(void Function(ChangeConnectionPriorityRequest) updates) => super.copyWith((message) => updates(message as ChangeConnectionPriorityRequest)) as ChangeConnectionPriorityRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChangeConnectionPriorityRequest create() => ChangeConnectionPriorityRequest._();
  ChangeConnectionPriorityRequest createEmptyInstance() => create();
  static $pb.PbList<ChangeConnectionPriorityRequest> createRepeated() => $pb.PbList<ChangeConnectionPriorityRequest>();
  @$core.pragma('dart2js:noInline')
  static ChangeConnectionPriorityRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChangeConnectionPriorityRequest>(create);
  static ChangeConnectionPriorityRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get priority => $_getIZ(1);
  @$pb.TagNumber(2)
  set priority($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPriority() => $_has(1);
  @$pb.TagNumber(2)
  void clearPriority() => clearField(2);
}

class ChangeConnectionPriorityInfo extends $pb.GeneratedMessage {
  factory ChangeConnectionPriorityInfo() => create();
  ChangeConnectionPriorityInfo._() : super();
  factory ChangeConnectionPriorityInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ChangeConnectionPriorityInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChangeConnectionPriorityInfo', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId', protoName: 'deviceId')
    ..aOM<GenericFailure>(2, _omitFieldNames ? '' : 'failure', subBuilder: GenericFailure.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ChangeConnectionPriorityInfo clone() => ChangeConnectionPriorityInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ChangeConnectionPriorityInfo copyWith(void Function(ChangeConnectionPriorityInfo) updates) => super.copyWith((message) => updates(message as ChangeConnectionPriorityInfo)) as ChangeConnectionPriorityInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChangeConnectionPriorityInfo create() => ChangeConnectionPriorityInfo._();
  ChangeConnectionPriorityInfo createEmptyInstance() => create();
  static $pb.PbList<ChangeConnectionPriorityInfo> createRepeated() => $pb.PbList<ChangeConnectionPriorityInfo>();
  @$core.pragma('dart2js:noInline')
  static ChangeConnectionPriorityInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChangeConnectionPriorityInfo>(create);
  static ChangeConnectionPriorityInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => clearField(1);

  @$pb.TagNumber(2)
  GenericFailure get failure => $_getN(1);
  @$pb.TagNumber(2)
  set failure(GenericFailure v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasFailure() => $_has(1);
  @$pb.TagNumber(2)
  void clearFailure() => clearField(2);
  @$pb.TagNumber(2)
  GenericFailure ensureFailure() => $_ensure(1);
}

class CharacteristicAddress extends $pb.GeneratedMessage {
  factory CharacteristicAddress() => create();
  CharacteristicAddress._() : super();
  factory CharacteristicAddress.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CharacteristicAddress.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CharacteristicAddress', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId', protoName: 'deviceId')
    ..aOM<Uuid>(2, _omitFieldNames ? '' : 'serviceUuid', protoName: 'serviceUuid', subBuilder: Uuid.create)
    ..aOM<Uuid>(3, _omitFieldNames ? '' : 'characteristicUuid', protoName: 'characteristicUuid', subBuilder: Uuid.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CharacteristicAddress clone() => CharacteristicAddress()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CharacteristicAddress copyWith(void Function(CharacteristicAddress) updates) => super.copyWith((message) => updates(message as CharacteristicAddress)) as CharacteristicAddress;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CharacteristicAddress create() => CharacteristicAddress._();
  CharacteristicAddress createEmptyInstance() => create();
  static $pb.PbList<CharacteristicAddress> createRepeated() => $pb.PbList<CharacteristicAddress>();
  @$core.pragma('dart2js:noInline')
  static CharacteristicAddress getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CharacteristicAddress>(create);
  static CharacteristicAddress? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => clearField(1);

  @$pb.TagNumber(2)
  Uuid get serviceUuid => $_getN(1);
  @$pb.TagNumber(2)
  set serviceUuid(Uuid v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasServiceUuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearServiceUuid() => clearField(2);
  @$pb.TagNumber(2)
  Uuid ensureServiceUuid() => $_ensure(1);

  @$pb.TagNumber(3)
  Uuid get characteristicUuid => $_getN(2);
  @$pb.TagNumber(3)
  set characteristicUuid(Uuid v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasCharacteristicUuid() => $_has(2);
  @$pb.TagNumber(3)
  void clearCharacteristicUuid() => clearField(3);
  @$pb.TagNumber(3)
  Uuid ensureCharacteristicUuid() => $_ensure(2);
}

class ServiceDataEntry extends $pb.GeneratedMessage {
  factory ServiceDataEntry() => create();
  ServiceDataEntry._() : super();
  factory ServiceDataEntry.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServiceDataEntry.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ServiceDataEntry', createEmptyInstance: create)
    ..aOM<Uuid>(1, _omitFieldNames ? '' : 'serviceUuid', protoName: 'serviceUuid', subBuilder: Uuid.create)
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServiceDataEntry clone() => ServiceDataEntry()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServiceDataEntry copyWith(void Function(ServiceDataEntry) updates) => super.copyWith((message) => updates(message as ServiceDataEntry)) as ServiceDataEntry;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceDataEntry create() => ServiceDataEntry._();
  ServiceDataEntry createEmptyInstance() => create();
  static $pb.PbList<ServiceDataEntry> createRepeated() => $pb.PbList<ServiceDataEntry>();
  @$core.pragma('dart2js:noInline')
  static ServiceDataEntry getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServiceDataEntry>(create);
  static ServiceDataEntry? _defaultInstance;

  @$pb.TagNumber(1)
  Uuid get serviceUuid => $_getN(0);
  @$pb.TagNumber(1)
  set serviceUuid(Uuid v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasServiceUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceUuid() => clearField(1);
  @$pb.TagNumber(1)
  Uuid ensureServiceUuid() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<$core.int> get data => $_getN(1);
  @$pb.TagNumber(2)
  set data($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasData() => $_has(1);
  @$pb.TagNumber(2)
  void clearData() => clearField(2);
}

class ServicesWithCharacteristics extends $pb.GeneratedMessage {
  factory ServicesWithCharacteristics() => create();
  ServicesWithCharacteristics._() : super();
  factory ServicesWithCharacteristics.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServicesWithCharacteristics.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ServicesWithCharacteristics', createEmptyInstance: create)
    ..pc<ServiceWithCharacteristics>(1, _omitFieldNames ? '' : 'items', $pb.PbFieldType.PM, subBuilder: ServiceWithCharacteristics.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServicesWithCharacteristics clone() => ServicesWithCharacteristics()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServicesWithCharacteristics copyWith(void Function(ServicesWithCharacteristics) updates) => super.copyWith((message) => updates(message as ServicesWithCharacteristics)) as ServicesWithCharacteristics;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServicesWithCharacteristics create() => ServicesWithCharacteristics._();
  ServicesWithCharacteristics createEmptyInstance() => create();
  static $pb.PbList<ServicesWithCharacteristics> createRepeated() => $pb.PbList<ServicesWithCharacteristics>();
  @$core.pragma('dart2js:noInline')
  static ServicesWithCharacteristics getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServicesWithCharacteristics>(create);
  static ServicesWithCharacteristics? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<ServiceWithCharacteristics> get items => $_getList(0);
}

class ServiceWithCharacteristics extends $pb.GeneratedMessage {
  factory ServiceWithCharacteristics() => create();
  ServiceWithCharacteristics._() : super();
  factory ServiceWithCharacteristics.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServiceWithCharacteristics.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ServiceWithCharacteristics', createEmptyInstance: create)
    ..aOM<Uuid>(1, _omitFieldNames ? '' : 'serviceId', protoName: 'serviceId', subBuilder: Uuid.create)
    ..pc<Uuid>(2, _omitFieldNames ? '' : 'characteristics', $pb.PbFieldType.PM, subBuilder: Uuid.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServiceWithCharacteristics clone() => ServiceWithCharacteristics()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServiceWithCharacteristics copyWith(void Function(ServiceWithCharacteristics) updates) => super.copyWith((message) => updates(message as ServiceWithCharacteristics)) as ServiceWithCharacteristics;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceWithCharacteristics create() => ServiceWithCharacteristics._();
  ServiceWithCharacteristics createEmptyInstance() => create();
  static $pb.PbList<ServiceWithCharacteristics> createRepeated() => $pb.PbList<ServiceWithCharacteristics>();
  @$core.pragma('dart2js:noInline')
  static ServiceWithCharacteristics getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServiceWithCharacteristics>(create);
  static ServiceWithCharacteristics? _defaultInstance;

  @$pb.TagNumber(1)
  Uuid get serviceId => $_getN(0);
  @$pb.TagNumber(1)
  set serviceId(Uuid v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasServiceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceId() => clearField(1);
  @$pb.TagNumber(1)
  Uuid ensureServiceId() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<Uuid> get characteristics => $_getList(1);
}

class DiscoverServicesRequest extends $pb.GeneratedMessage {
  factory DiscoverServicesRequest() => create();
  DiscoverServicesRequest._() : super();
  factory DiscoverServicesRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DiscoverServicesRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DiscoverServicesRequest', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId', protoName: 'deviceId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DiscoverServicesRequest clone() => DiscoverServicesRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DiscoverServicesRequest copyWith(void Function(DiscoverServicesRequest) updates) => super.copyWith((message) => updates(message as DiscoverServicesRequest)) as DiscoverServicesRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DiscoverServicesRequest create() => DiscoverServicesRequest._();
  DiscoverServicesRequest createEmptyInstance() => create();
  static $pb.PbList<DiscoverServicesRequest> createRepeated() => $pb.PbList<DiscoverServicesRequest>();
  @$core.pragma('dart2js:noInline')
  static DiscoverServicesRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DiscoverServicesRequest>(create);
  static DiscoverServicesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => clearField(1);
}

class DiscoverServicesInfo extends $pb.GeneratedMessage {
  factory DiscoverServicesInfo() => create();
  DiscoverServicesInfo._() : super();
  factory DiscoverServicesInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DiscoverServicesInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DiscoverServicesInfo', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId', protoName: 'deviceId')
    ..pc<DiscoveredService>(2, _omitFieldNames ? '' : 'services', $pb.PbFieldType.PM, subBuilder: DiscoveredService.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DiscoverServicesInfo clone() => DiscoverServicesInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DiscoverServicesInfo copyWith(void Function(DiscoverServicesInfo) updates) => super.copyWith((message) => updates(message as DiscoverServicesInfo)) as DiscoverServicesInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DiscoverServicesInfo create() => DiscoverServicesInfo._();
  DiscoverServicesInfo createEmptyInstance() => create();
  static $pb.PbList<DiscoverServicesInfo> createRepeated() => $pb.PbList<DiscoverServicesInfo>();
  @$core.pragma('dart2js:noInline')
  static DiscoverServicesInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DiscoverServicesInfo>(create);
  static DiscoverServicesInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<DiscoveredService> get services => $_getList(1);
}

class DiscoveredService extends $pb.GeneratedMessage {
  factory DiscoveredService() => create();
  DiscoveredService._() : super();
  factory DiscoveredService.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DiscoveredService.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DiscoveredService', createEmptyInstance: create)
    ..aOM<Uuid>(1, _omitFieldNames ? '' : 'serviceUuid', protoName: 'serviceUuid', subBuilder: Uuid.create)
    ..pc<Uuid>(2, _omitFieldNames ? '' : 'characteristicUuids', $pb.PbFieldType.PM, protoName: 'characteristicUuids', subBuilder: Uuid.create)
    ..pc<DiscoveredService>(3, _omitFieldNames ? '' : 'includedServices', $pb.PbFieldType.PM, protoName: 'includedServices', subBuilder: DiscoveredService.create)
    ..pc<DiscoveredCharacteristic>(4, _omitFieldNames ? '' : 'characteristics', $pb.PbFieldType.PM, subBuilder: DiscoveredCharacteristic.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DiscoveredService clone() => DiscoveredService()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DiscoveredService copyWith(void Function(DiscoveredService) updates) => super.copyWith((message) => updates(message as DiscoveredService)) as DiscoveredService;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DiscoveredService create() => DiscoveredService._();
  DiscoveredService createEmptyInstance() => create();
  static $pb.PbList<DiscoveredService> createRepeated() => $pb.PbList<DiscoveredService>();
  @$core.pragma('dart2js:noInline')
  static DiscoveredService getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DiscoveredService>(create);
  static DiscoveredService? _defaultInstance;

  @$pb.TagNumber(1)
  Uuid get serviceUuid => $_getN(0);
  @$pb.TagNumber(1)
  set serviceUuid(Uuid v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasServiceUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceUuid() => clearField(1);
  @$pb.TagNumber(1)
  Uuid ensureServiceUuid() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<Uuid> get characteristicUuids => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<DiscoveredService> get includedServices => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<DiscoveredCharacteristic> get characteristics => $_getList(3);
}

class DiscoveredCharacteristic extends $pb.GeneratedMessage {
  factory DiscoveredCharacteristic() => create();
  DiscoveredCharacteristic._() : super();
  factory DiscoveredCharacteristic.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DiscoveredCharacteristic.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DiscoveredCharacteristic', createEmptyInstance: create)
    ..aOM<Uuid>(1, _omitFieldNames ? '' : 'characteristicId', protoName: 'characteristicId', subBuilder: Uuid.create)
    ..aOM<Uuid>(2, _omitFieldNames ? '' : 'serviceId', protoName: 'serviceId', subBuilder: Uuid.create)
    ..aOB(3, _omitFieldNames ? '' : 'isReadable', protoName: 'isReadable')
    ..aOB(4, _omitFieldNames ? '' : 'isWritableWithResponse', protoName: 'isWritableWithResponse')
    ..aOB(5, _omitFieldNames ? '' : 'isWritableWithoutResponse', protoName: 'isWritableWithoutResponse')
    ..aOB(6, _omitFieldNames ? '' : 'isNotifiable', protoName: 'isNotifiable')
    ..aOB(7, _omitFieldNames ? '' : 'isIndicatable', protoName: 'isIndicatable')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DiscoveredCharacteristic clone() => DiscoveredCharacteristic()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DiscoveredCharacteristic copyWith(void Function(DiscoveredCharacteristic) updates) => super.copyWith((message) => updates(message as DiscoveredCharacteristic)) as DiscoveredCharacteristic;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DiscoveredCharacteristic create() => DiscoveredCharacteristic._();
  DiscoveredCharacteristic createEmptyInstance() => create();
  static $pb.PbList<DiscoveredCharacteristic> createRepeated() => $pb.PbList<DiscoveredCharacteristic>();
  @$core.pragma('dart2js:noInline')
  static DiscoveredCharacteristic getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DiscoveredCharacteristic>(create);
  static DiscoveredCharacteristic? _defaultInstance;

  @$pb.TagNumber(1)
  Uuid get characteristicId => $_getN(0);
  @$pb.TagNumber(1)
  set characteristicId(Uuid v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCharacteristicId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCharacteristicId() => clearField(1);
  @$pb.TagNumber(1)
  Uuid ensureCharacteristicId() => $_ensure(0);

  @$pb.TagNumber(2)
  Uuid get serviceId => $_getN(1);
  @$pb.TagNumber(2)
  set serviceId(Uuid v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasServiceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearServiceId() => clearField(2);
  @$pb.TagNumber(2)
  Uuid ensureServiceId() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get isReadable => $_getBF(2);
  @$pb.TagNumber(3)
  set isReadable($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIsReadable() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsReadable() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isWritableWithResponse => $_getBF(3);
  @$pb.TagNumber(4)
  set isWritableWithResponse($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasIsWritableWithResponse() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsWritableWithResponse() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get isWritableWithoutResponse => $_getBF(4);
  @$pb.TagNumber(5)
  set isWritableWithoutResponse($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasIsWritableWithoutResponse() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsWritableWithoutResponse() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isNotifiable => $_getBF(5);
  @$pb.TagNumber(6)
  set isNotifiable($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasIsNotifiable() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsNotifiable() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get isIndicatable => $_getBF(6);
  @$pb.TagNumber(7)
  set isIndicatable($core.bool v) { $_setBool(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasIsIndicatable() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsIndicatable() => clearField(7);
}

class Uuid extends $pb.GeneratedMessage {
  factory Uuid() => create();
  Uuid._() : super();
  factory Uuid.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Uuid.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Uuid', createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Uuid clone() => Uuid()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Uuid copyWith(void Function(Uuid) updates) => super.copyWith((message) => updates(message as Uuid)) as Uuid;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Uuid create() => Uuid._();
  Uuid createEmptyInstance() => create();
  static $pb.PbList<Uuid> createRepeated() => $pb.PbList<Uuid>();
  @$core.pragma('dart2js:noInline')
  static Uuid getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Uuid>(create);
  static Uuid? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get data => $_getN(0);
  @$pb.TagNumber(1)
  set data($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
}

class GenericFailure extends $pb.GeneratedMessage {
  factory GenericFailure() => create();
  GenericFailure._() : super();
  factory GenericFailure.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GenericFailure.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GenericFailure', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'code', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GenericFailure clone() => GenericFailure()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GenericFailure copyWith(void Function(GenericFailure) updates) => super.copyWith((message) => updates(message as GenericFailure)) as GenericFailure;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GenericFailure create() => GenericFailure._();
  GenericFailure createEmptyInstance() => create();
  static $pb.PbList<GenericFailure> createRepeated() => $pb.PbList<GenericFailure>();
  @$core.pragma('dart2js:noInline')
  static GenericFailure getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GenericFailure>(create);
  static GenericFailure? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get code => $_getIZ(0);
  @$pb.TagNumber(1)
  set code($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);
}

class IsConnectable extends $pb.GeneratedMessage {
  factory IsConnectable() => create();
  IsConnectable._() : super();
  factory IsConnectable.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory IsConnectable.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'IsConnectable', createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'code', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  IsConnectable clone() => IsConnectable()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  IsConnectable copyWith(void Function(IsConnectable) updates) => super.copyWith((message) => updates(message as IsConnectable)) as IsConnectable;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IsConnectable create() => IsConnectable._();
  IsConnectable createEmptyInstance() => create();
  static $pb.PbList<IsConnectable> createRepeated() => $pb.PbList<IsConnectable>();
  @$core.pragma('dart2js:noInline')
  static IsConnectable getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<IsConnectable>(create);
  static IsConnectable? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get code => $_getIZ(0);
  @$pb.TagNumber(1)
  set code($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
