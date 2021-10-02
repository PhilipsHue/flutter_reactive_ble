///
//  Generated code. Do not modify.
//  source: bledata.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ScanForDevicesRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ScanForDevicesRequest',
      createEmptyInstance: create)
    ..pc<Uuid>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'serviceUuids',
        $pb.PbFieldType.PM,
        protoName: 'serviceUuids',
        subBuilder: Uuid.create)
    ..a<$core.int>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'scanMode',
        $pb.PbFieldType.O3,
        protoName: 'scanMode')
    ..aOB(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'requireLocationServicesEnabled',
        protoName: 'requireLocationServicesEnabled')
    ..hasRequiredFields = false;

  ScanForDevicesRequest._() : super();
  factory ScanForDevicesRequest({
    $core.Iterable<Uuid>? serviceUuids,
    $core.int? scanMode,
    $core.bool? requireLocationServicesEnabled,
  }) {
    final _result = create();
    if (serviceUuids != null) {
      _result.serviceUuids.addAll(serviceUuids);
    }
    if (scanMode != null) {
      _result.scanMode = scanMode;
    }
    if (requireLocationServicesEnabled != null) {
      _result.requireLocationServicesEnabled = requireLocationServicesEnabled;
    }
    return _result;
  }
  factory ScanForDevicesRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ScanForDevicesRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ScanForDevicesRequest clone() =>
      ScanForDevicesRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ScanForDevicesRequest copyWith(
          void Function(ScanForDevicesRequest) updates) =>
      super.copyWith((message) => updates(message as ScanForDevicesRequest))
          as ScanForDevicesRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ScanForDevicesRequest create() => ScanForDevicesRequest._();
  ScanForDevicesRequest createEmptyInstance() => create();
  static $pb.PbList<ScanForDevicesRequest> createRepeated() =>
      $pb.PbList<ScanForDevicesRequest>();
  @$core.pragma('dart2js:noInline')
  static ScanForDevicesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScanForDevicesRequest>(create);
  static ScanForDevicesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Uuid> get serviceUuids => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get scanMode => $_getIZ(1);
  @$pb.TagNumber(2)
  set scanMode($core.int v) {
    $_setSignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasScanMode() => $_has(1);
  @$pb.TagNumber(2)
  void clearScanMode() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get requireLocationServicesEnabled => $_getBF(2);
  @$pb.TagNumber(3)
  set requireLocationServicesEnabled($core.bool v) {
    $_setBool(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasRequireLocationServicesEnabled() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequireLocationServicesEnabled() => clearField(3);
}

class DeviceScanInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DeviceScanInfo',
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'id')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'name')
    ..aOM<GenericFailure>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'failure',
        subBuilder: GenericFailure.create)
    ..pc<ServiceDataEntry>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'serviceData',
        $pb.PbFieldType.PM,
        protoName: 'serviceData',
        subBuilder: ServiceDataEntry.create)
    ..a<$core.int>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'rssi',
        $pb.PbFieldType.O3)
    ..a<$core.List<$core.int>>(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'manufacturerData',
        $pb.PbFieldType.OY,
        protoName: 'manufacturerData')
    ..pc<Uuid>(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'serviceUuids',
        $pb.PbFieldType.PM,
        protoName: 'serviceUuids',
        subBuilder: Uuid.create)
    ..hasRequiredFields = false;

  DeviceScanInfo._() : super();
  factory DeviceScanInfo({
    $core.String? id,
    $core.String? name,
    GenericFailure? failure,
    $core.Iterable<ServiceDataEntry>? serviceData,
    $core.int? rssi,
    $core.List<$core.int>? manufacturerData,
    $core.Iterable<Uuid>? serviceUuids,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (name != null) {
      _result.name = name;
    }
    if (failure != null) {
      _result.failure = failure;
    }
    if (serviceData != null) {
      _result.serviceData.addAll(serviceData);
    }
    if (rssi != null) {
      _result.rssi = rssi;
    }
    if (manufacturerData != null) {
      _result.manufacturerData = manufacturerData;
    }
    if (serviceUuids != null) {
      _result.serviceUuids.addAll(serviceUuids);
    }
    return _result;
  }
  factory DeviceScanInfo.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DeviceScanInfo.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DeviceScanInfo clone() => DeviceScanInfo()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DeviceScanInfo copyWith(void Function(DeviceScanInfo) updates) =>
      super.copyWith((message) => updates(message as DeviceScanInfo))
          as DeviceScanInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DeviceScanInfo create() => DeviceScanInfo._();
  DeviceScanInfo createEmptyInstance() => create();
  static $pb.PbList<DeviceScanInfo> createRepeated() =>
      $pb.PbList<DeviceScanInfo>();
  @$core.pragma('dart2js:noInline')
  static DeviceScanInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeviceScanInfo>(create);
  static DeviceScanInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  GenericFailure get failure => $_getN(2);
  @$pb.TagNumber(3)
  set failure(GenericFailure v) {
    setField(3, v);
  }

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
  set rssi($core.int v) {
    $_setSignedInt32(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasRssi() => $_has(4);
  @$pb.TagNumber(5)
  void clearRssi() => clearField(5);

  @$pb.TagNumber(6)
  $core.List<$core.int> get manufacturerData => $_getN(5);
  @$pb.TagNumber(6)
  set manufacturerData($core.List<$core.int> v) {
    $_setBytes(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasManufacturerData() => $_has(5);
  @$pb.TagNumber(6)
  void clearManufacturerData() => clearField(6);

  @$pb.TagNumber(7)
  $core.List<Uuid> get serviceUuids => $_getList(6);
}

class ConnectToDeviceRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ConnectToDeviceRequest',
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'deviceId',
        protoName: 'deviceId')
    ..aOM<ServicesWithCharacteristics>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'servicesWithCharacteristicsToDiscover',
        protoName: 'servicesWithCharacteristicsToDiscover',
        subBuilder: ServicesWithCharacteristics.create)
    ..a<$core.int>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'timeoutInMs',
        $pb.PbFieldType.O3,
        protoName: 'timeoutInMs')
    ..hasRequiredFields = false;

  ConnectToDeviceRequest._() : super();
  factory ConnectToDeviceRequest({
    $core.String? deviceId,
    ServicesWithCharacteristics? servicesWithCharacteristicsToDiscover,
    $core.int? timeoutInMs,
  }) {
    final _result = create();
    if (deviceId != null) {
      _result.deviceId = deviceId;
    }
    if (servicesWithCharacteristicsToDiscover != null) {
      _result.servicesWithCharacteristicsToDiscover =
          servicesWithCharacteristicsToDiscover;
    }
    if (timeoutInMs != null) {
      _result.timeoutInMs = timeoutInMs;
    }
    return _result;
  }
  factory ConnectToDeviceRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ConnectToDeviceRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ConnectToDeviceRequest clone() =>
      ConnectToDeviceRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ConnectToDeviceRequest copyWith(
          void Function(ConnectToDeviceRequest) updates) =>
      super.copyWith((message) => updates(message as ConnectToDeviceRequest))
          as ConnectToDeviceRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ConnectToDeviceRequest create() => ConnectToDeviceRequest._();
  ConnectToDeviceRequest createEmptyInstance() => create();
  static $pb.PbList<ConnectToDeviceRequest> createRepeated() =>
      $pb.PbList<ConnectToDeviceRequest>();
  @$core.pragma('dart2js:noInline')
  static ConnectToDeviceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConnectToDeviceRequest>(create);
  static ConnectToDeviceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => clearField(1);

  @$pb.TagNumber(2)
  ServicesWithCharacteristics get servicesWithCharacteristicsToDiscover =>
      $_getN(1);
  @$pb.TagNumber(2)
  set servicesWithCharacteristicsToDiscover(ServicesWithCharacteristics v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasServicesWithCharacteristicsToDiscover() => $_has(1);
  @$pb.TagNumber(2)
  void clearServicesWithCharacteristicsToDiscover() => clearField(2);
  @$pb.TagNumber(2)
  ServicesWithCharacteristics ensureServicesWithCharacteristicsToDiscover() =>
      $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get timeoutInMs => $_getIZ(2);
  @$pb.TagNumber(3)
  set timeoutInMs($core.int v) {
    $_setSignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasTimeoutInMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimeoutInMs() => clearField(3);
}

class DeviceInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DeviceInfo',
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'id')
    ..a<$core.int>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'connectionState',
        $pb.PbFieldType.O3,
        protoName: 'connectionState')
    ..aOM<GenericFailure>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'failure',
        subBuilder: GenericFailure.create)
    ..hasRequiredFields = false;

  DeviceInfo._() : super();
  factory DeviceInfo({
    $core.String? id,
    $core.int? connectionState,
    GenericFailure? failure,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (connectionState != null) {
      _result.connectionState = connectionState;
    }
    if (failure != null) {
      _result.failure = failure;
    }
    return _result;
  }
  factory DeviceInfo.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DeviceInfo.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DeviceInfo clone() => DeviceInfo()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DeviceInfo copyWith(void Function(DeviceInfo) updates) =>
      super.copyWith((message) => updates(message as DeviceInfo))
          as DeviceInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DeviceInfo create() => DeviceInfo._();
  DeviceInfo createEmptyInstance() => create();
  static $pb.PbList<DeviceInfo> createRepeated() => $pb.PbList<DeviceInfo>();
  @$core.pragma('dart2js:noInline')
  static DeviceInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeviceInfo>(create);
  static DeviceInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get connectionState => $_getIZ(1);
  @$pb.TagNumber(2)
  set connectionState($core.int v) {
    $_setSignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasConnectionState() => $_has(1);
  @$pb.TagNumber(2)
  void clearConnectionState() => clearField(2);

  @$pb.TagNumber(3)
  GenericFailure get failure => $_getN(2);
  @$pb.TagNumber(3)
  set failure(GenericFailure v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasFailure() => $_has(2);
  @$pb.TagNumber(3)
  void clearFailure() => clearField(3);
  @$pb.TagNumber(3)
  GenericFailure ensureFailure() => $_ensure(2);
}

class DisconnectFromDeviceRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DisconnectFromDeviceRequest',
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'deviceId',
        protoName: 'deviceId')
    ..hasRequiredFields = false;

  DisconnectFromDeviceRequest._() : super();
  factory DisconnectFromDeviceRequest({
    $core.String? deviceId,
  }) {
    final _result = create();
    if (deviceId != null) {
      _result.deviceId = deviceId;
    }
    return _result;
  }
  factory DisconnectFromDeviceRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DisconnectFromDeviceRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DisconnectFromDeviceRequest clone() =>
      DisconnectFromDeviceRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DisconnectFromDeviceRequest copyWith(
          void Function(DisconnectFromDeviceRequest) updates) =>
      super.copyWith(
              (message) => updates(message as DisconnectFromDeviceRequest))
          as DisconnectFromDeviceRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DisconnectFromDeviceRequest create() =>
      DisconnectFromDeviceRequest._();
  DisconnectFromDeviceRequest createEmptyInstance() => create();
  static $pb.PbList<DisconnectFromDeviceRequest> createRepeated() =>
      $pb.PbList<DisconnectFromDeviceRequest>();
  @$core.pragma('dart2js:noInline')
  static DisconnectFromDeviceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DisconnectFromDeviceRequest>(create);
  static DisconnectFromDeviceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => clearField(1);
}

class ClearGattCacheRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ClearGattCacheRequest',
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'deviceId',
        protoName: 'deviceId')
    ..hasRequiredFields = false;

  ClearGattCacheRequest._() : super();
  factory ClearGattCacheRequest({
    $core.String? deviceId,
  }) {
    final _result = create();
    if (deviceId != null) {
      _result.deviceId = deviceId;
    }
    return _result;
  }
  factory ClearGattCacheRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ClearGattCacheRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ClearGattCacheRequest clone() =>
      ClearGattCacheRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ClearGattCacheRequest copyWith(
          void Function(ClearGattCacheRequest) updates) =>
      super.copyWith((message) => updates(message as ClearGattCacheRequest))
          as ClearGattCacheRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ClearGattCacheRequest create() => ClearGattCacheRequest._();
  ClearGattCacheRequest createEmptyInstance() => create();
  static $pb.PbList<ClearGattCacheRequest> createRepeated() =>
      $pb.PbList<ClearGattCacheRequest>();
  @$core.pragma('dart2js:noInline')
  static ClearGattCacheRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClearGattCacheRequest>(create);
  static ClearGattCacheRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => clearField(1);
}

class ClearGattCacheInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ClearGattCacheInfo',
      createEmptyInstance: create)
    ..aOM<GenericFailure>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'failure',
        subBuilder: GenericFailure.create)
    ..hasRequiredFields = false;

  ClearGattCacheInfo._() : super();
  factory ClearGattCacheInfo({
    GenericFailure? failure,
  }) {
    final _result = create();
    if (failure != null) {
      _result.failure = failure;
    }
    return _result;
  }
  factory ClearGattCacheInfo.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ClearGattCacheInfo.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ClearGattCacheInfo clone() => ClearGattCacheInfo()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ClearGattCacheInfo copyWith(void Function(ClearGattCacheInfo) updates) =>
      super.copyWith((message) => updates(message as ClearGattCacheInfo))
          as ClearGattCacheInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ClearGattCacheInfo create() => ClearGattCacheInfo._();
  ClearGattCacheInfo createEmptyInstance() => create();
  static $pb.PbList<ClearGattCacheInfo> createRepeated() =>
      $pb.PbList<ClearGattCacheInfo>();
  @$core.pragma('dart2js:noInline')
  static ClearGattCacheInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClearGattCacheInfo>(create);
  static ClearGattCacheInfo? _defaultInstance;

  @$pb.TagNumber(1)
  GenericFailure get failure => $_getN(0);
  @$pb.TagNumber(1)
  set failure(GenericFailure v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasFailure() => $_has(0);
  @$pb.TagNumber(1)
  void clearFailure() => clearField(1);
  @$pb.TagNumber(1)
  GenericFailure ensureFailure() => $_ensure(0);
}

class NotifyCharacteristicRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NotifyCharacteristicRequest',
      createEmptyInstance: create)
    ..aOM<CharacteristicAddress>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'characteristic',
        subBuilder: CharacteristicAddress.create)
    ..hasRequiredFields = false;

  NotifyCharacteristicRequest._() : super();
  factory NotifyCharacteristicRequest({
    CharacteristicAddress? characteristic,
  }) {
    final _result = create();
    if (characteristic != null) {
      _result.characteristic = characteristic;
    }
    return _result;
  }
  factory NotifyCharacteristicRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NotifyCharacteristicRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NotifyCharacteristicRequest clone() =>
      NotifyCharacteristicRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NotifyCharacteristicRequest copyWith(
          void Function(NotifyCharacteristicRequest) updates) =>
      super.copyWith(
              (message) => updates(message as NotifyCharacteristicRequest))
          as NotifyCharacteristicRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NotifyCharacteristicRequest create() =>
      NotifyCharacteristicRequest._();
  NotifyCharacteristicRequest createEmptyInstance() => create();
  static $pb.PbList<NotifyCharacteristicRequest> createRepeated() =>
      $pb.PbList<NotifyCharacteristicRequest>();
  @$core.pragma('dart2js:noInline')
  static NotifyCharacteristicRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotifyCharacteristicRequest>(create);
  static NotifyCharacteristicRequest? _defaultInstance;

  @$pb.TagNumber(1)
  CharacteristicAddress get characteristic => $_getN(0);
  @$pb.TagNumber(1)
  set characteristic(CharacteristicAddress v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCharacteristic() => $_has(0);
  @$pb.TagNumber(1)
  void clearCharacteristic() => clearField(1);
  @$pb.TagNumber(1)
  CharacteristicAddress ensureCharacteristic() => $_ensure(0);
}

class NotifyNoMoreCharacteristicRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NotifyNoMoreCharacteristicRequest',
      createEmptyInstance: create)
    ..aOM<CharacteristicAddress>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'characteristic',
        subBuilder: CharacteristicAddress.create)
    ..hasRequiredFields = false;

  NotifyNoMoreCharacteristicRequest._() : super();
  factory NotifyNoMoreCharacteristicRequest({
    CharacteristicAddress? characteristic,
  }) {
    final _result = create();
    if (characteristic != null) {
      _result.characteristic = characteristic;
    }
    return _result;
  }
  factory NotifyNoMoreCharacteristicRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NotifyNoMoreCharacteristicRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NotifyNoMoreCharacteristicRequest clone() =>
      NotifyNoMoreCharacteristicRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NotifyNoMoreCharacteristicRequest copyWith(
          void Function(NotifyNoMoreCharacteristicRequest) updates) =>
      super.copyWith((message) =>
              updates(message as NotifyNoMoreCharacteristicRequest))
          as NotifyNoMoreCharacteristicRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NotifyNoMoreCharacteristicRequest create() =>
      NotifyNoMoreCharacteristicRequest._();
  NotifyNoMoreCharacteristicRequest createEmptyInstance() => create();
  static $pb.PbList<NotifyNoMoreCharacteristicRequest> createRepeated() =>
      $pb.PbList<NotifyNoMoreCharacteristicRequest>();
  @$core.pragma('dart2js:noInline')
  static NotifyNoMoreCharacteristicRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NotifyNoMoreCharacteristicRequest>(
          create);
  static NotifyNoMoreCharacteristicRequest? _defaultInstance;

  @$pb.TagNumber(1)
  CharacteristicAddress get characteristic => $_getN(0);
  @$pb.TagNumber(1)
  set characteristic(CharacteristicAddress v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCharacteristic() => $_has(0);
  @$pb.TagNumber(1)
  void clearCharacteristic() => clearField(1);
  @$pb.TagNumber(1)
  CharacteristicAddress ensureCharacteristic() => $_ensure(0);
}

class ReadCharacteristicRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ReadCharacteristicRequest',
      createEmptyInstance: create)
    ..aOM<CharacteristicAddress>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'characteristic',
        subBuilder: CharacteristicAddress.create)
    ..hasRequiredFields = false;

  ReadCharacteristicRequest._() : super();
  factory ReadCharacteristicRequest({
    CharacteristicAddress? characteristic,
  }) {
    final _result = create();
    if (characteristic != null) {
      _result.characteristic = characteristic;
    }
    return _result;
  }
  factory ReadCharacteristicRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ReadCharacteristicRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ReadCharacteristicRequest clone() =>
      ReadCharacteristicRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ReadCharacteristicRequest copyWith(
          void Function(ReadCharacteristicRequest) updates) =>
      super.copyWith((message) => updates(message as ReadCharacteristicRequest))
          as ReadCharacteristicRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ReadCharacteristicRequest create() => ReadCharacteristicRequest._();
  ReadCharacteristicRequest createEmptyInstance() => create();
  static $pb.PbList<ReadCharacteristicRequest> createRepeated() =>
      $pb.PbList<ReadCharacteristicRequest>();
  @$core.pragma('dart2js:noInline')
  static ReadCharacteristicRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReadCharacteristicRequest>(create);
  static ReadCharacteristicRequest? _defaultInstance;

  @$pb.TagNumber(1)
  CharacteristicAddress get characteristic => $_getN(0);
  @$pb.TagNumber(1)
  set characteristic(CharacteristicAddress v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCharacteristic() => $_has(0);
  @$pb.TagNumber(1)
  void clearCharacteristic() => clearField(1);
  @$pb.TagNumber(1)
  CharacteristicAddress ensureCharacteristic() => $_ensure(0);
}

class CharacteristicValueInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'CharacteristicValueInfo',
      createEmptyInstance: create)
    ..aOM<CharacteristicAddress>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'characteristic',
        subBuilder: CharacteristicAddress.create)
    ..a<$core.List<$core.int>>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'value',
        $pb.PbFieldType.OY)
    ..aOM<GenericFailure>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'failure',
        subBuilder: GenericFailure.create)
    ..hasRequiredFields = false;

  CharacteristicValueInfo._() : super();
  factory CharacteristicValueInfo({
    CharacteristicAddress? characteristic,
    $core.List<$core.int>? value,
    GenericFailure? failure,
  }) {
    final _result = create();
    if (characteristic != null) {
      _result.characteristic = characteristic;
    }
    if (value != null) {
      _result.value = value;
    }
    if (failure != null) {
      _result.failure = failure;
    }
    return _result;
  }
  factory CharacteristicValueInfo.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory CharacteristicValueInfo.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  CharacteristicValueInfo clone() =>
      CharacteristicValueInfo()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  CharacteristicValueInfo copyWith(
          void Function(CharacteristicValueInfo) updates) =>
      super.copyWith((message) => updates(message as CharacteristicValueInfo))
          as CharacteristicValueInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CharacteristicValueInfo create() => CharacteristicValueInfo._();
  CharacteristicValueInfo createEmptyInstance() => create();
  static $pb.PbList<CharacteristicValueInfo> createRepeated() =>
      $pb.PbList<CharacteristicValueInfo>();
  @$core.pragma('dart2js:noInline')
  static CharacteristicValueInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CharacteristicValueInfo>(create);
  static CharacteristicValueInfo? _defaultInstance;

  @$pb.TagNumber(1)
  CharacteristicAddress get characteristic => $_getN(0);
  @$pb.TagNumber(1)
  set characteristic(CharacteristicAddress v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCharacteristic() => $_has(0);
  @$pb.TagNumber(1)
  void clearCharacteristic() => clearField(1);
  @$pb.TagNumber(1)
  CharacteristicAddress ensureCharacteristic() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<$core.int> get value => $_getN(1);
  @$pb.TagNumber(2)
  set value($core.List<$core.int> v) {
    $_setBytes(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => clearField(2);

  @$pb.TagNumber(3)
  GenericFailure get failure => $_getN(2);
  @$pb.TagNumber(3)
  set failure(GenericFailure v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasFailure() => $_has(2);
  @$pb.TagNumber(3)
  void clearFailure() => clearField(3);
  @$pb.TagNumber(3)
  GenericFailure ensureFailure() => $_ensure(2);
}

class WriteCharacteristicRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'WriteCharacteristicRequest',
      createEmptyInstance: create)
    ..aOM<CharacteristicAddress>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'characteristic',
        subBuilder: CharacteristicAddress.create)
    ..a<$core.List<$core.int>>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'value',
        $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  WriteCharacteristicRequest._() : super();
  factory WriteCharacteristicRequest({
    CharacteristicAddress? characteristic,
    $core.List<$core.int>? value,
  }) {
    final _result = create();
    if (characteristic != null) {
      _result.characteristic = characteristic;
    }
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory WriteCharacteristicRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory WriteCharacteristicRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  WriteCharacteristicRequest clone() =>
      WriteCharacteristicRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  WriteCharacteristicRequest copyWith(
          void Function(WriteCharacteristicRequest) updates) =>
      super.copyWith(
              (message) => updates(message as WriteCharacteristicRequest))
          as WriteCharacteristicRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static WriteCharacteristicRequest create() => WriteCharacteristicRequest._();
  WriteCharacteristicRequest createEmptyInstance() => create();
  static $pb.PbList<WriteCharacteristicRequest> createRepeated() =>
      $pb.PbList<WriteCharacteristicRequest>();
  @$core.pragma('dart2js:noInline')
  static WriteCharacteristicRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WriteCharacteristicRequest>(create);
  static WriteCharacteristicRequest? _defaultInstance;

  @$pb.TagNumber(1)
  CharacteristicAddress get characteristic => $_getN(0);
  @$pb.TagNumber(1)
  set characteristic(CharacteristicAddress v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCharacteristic() => $_has(0);
  @$pb.TagNumber(1)
  void clearCharacteristic() => clearField(1);
  @$pb.TagNumber(1)
  CharacteristicAddress ensureCharacteristic() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<$core.int> get value => $_getN(1);
  @$pb.TagNumber(2)
  set value($core.List<$core.int> v) {
    $_setBytes(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => clearField(2);
}

class WriteCharacteristicInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'WriteCharacteristicInfo',
      createEmptyInstance: create)
    ..aOM<CharacteristicAddress>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'characteristic',
        subBuilder: CharacteristicAddress.create)
    ..aOM<GenericFailure>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'failure',
        subBuilder: GenericFailure.create)
    ..hasRequiredFields = false;

  WriteCharacteristicInfo._() : super();
  factory WriteCharacteristicInfo({
    CharacteristicAddress? characteristic,
    GenericFailure? failure,
  }) {
    final _result = create();
    if (characteristic != null) {
      _result.characteristic = characteristic;
    }
    if (failure != null) {
      _result.failure = failure;
    }
    return _result;
  }
  factory WriteCharacteristicInfo.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory WriteCharacteristicInfo.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  WriteCharacteristicInfo clone() =>
      WriteCharacteristicInfo()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  WriteCharacteristicInfo copyWith(
          void Function(WriteCharacteristicInfo) updates) =>
      super.copyWith((message) => updates(message as WriteCharacteristicInfo))
          as WriteCharacteristicInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static WriteCharacteristicInfo create() => WriteCharacteristicInfo._();
  WriteCharacteristicInfo createEmptyInstance() => create();
  static $pb.PbList<WriteCharacteristicInfo> createRepeated() =>
      $pb.PbList<WriteCharacteristicInfo>();
  @$core.pragma('dart2js:noInline')
  static WriteCharacteristicInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WriteCharacteristicInfo>(create);
  static WriteCharacteristicInfo? _defaultInstance;

  @$pb.TagNumber(1)
  CharacteristicAddress get characteristic => $_getN(0);
  @$pb.TagNumber(1)
  set characteristic(CharacteristicAddress v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCharacteristic() => $_has(0);
  @$pb.TagNumber(1)
  void clearCharacteristic() => clearField(1);
  @$pb.TagNumber(1)
  CharacteristicAddress ensureCharacteristic() => $_ensure(0);

  @$pb.TagNumber(3)
  GenericFailure get failure => $_getN(1);
  @$pb.TagNumber(3)
  set failure(GenericFailure v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasFailure() => $_has(1);
  @$pb.TagNumber(3)
  void clearFailure() => clearField(3);
  @$pb.TagNumber(3)
  GenericFailure ensureFailure() => $_ensure(1);
}

class NegotiateMtuRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NegotiateMtuRequest',
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'deviceId',
        protoName: 'deviceId')
    ..a<$core.int>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'mtuSize',
        $pb.PbFieldType.O3,
        protoName: 'mtuSize')
    ..hasRequiredFields = false;

  NegotiateMtuRequest._() : super();
  factory NegotiateMtuRequest({
    $core.String? deviceId,
    $core.int? mtuSize,
  }) {
    final _result = create();
    if (deviceId != null) {
      _result.deviceId = deviceId;
    }
    if (mtuSize != null) {
      _result.mtuSize = mtuSize;
    }
    return _result;
  }
  factory NegotiateMtuRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NegotiateMtuRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NegotiateMtuRequest clone() => NegotiateMtuRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NegotiateMtuRequest copyWith(void Function(NegotiateMtuRequest) updates) =>
      super.copyWith((message) => updates(message as NegotiateMtuRequest))
          as NegotiateMtuRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NegotiateMtuRequest create() => NegotiateMtuRequest._();
  NegotiateMtuRequest createEmptyInstance() => create();
  static $pb.PbList<NegotiateMtuRequest> createRepeated() =>
      $pb.PbList<NegotiateMtuRequest>();
  @$core.pragma('dart2js:noInline')
  static NegotiateMtuRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NegotiateMtuRequest>(create);
  static NegotiateMtuRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get mtuSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set mtuSize($core.int v) {
    $_setSignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasMtuSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearMtuSize() => clearField(2);
}

class NegotiateMtuInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'NegotiateMtuInfo',
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'deviceId',
        protoName: 'deviceId')
    ..a<$core.int>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'mtuSize',
        $pb.PbFieldType.O3,
        protoName: 'mtuSize')
    ..aOM<GenericFailure>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'failure',
        subBuilder: GenericFailure.create)
    ..hasRequiredFields = false;

  NegotiateMtuInfo._() : super();
  factory NegotiateMtuInfo({
    $core.String? deviceId,
    $core.int? mtuSize,
    GenericFailure? failure,
  }) {
    final _result = create();
    if (deviceId != null) {
      _result.deviceId = deviceId;
    }
    if (mtuSize != null) {
      _result.mtuSize = mtuSize;
    }
    if (failure != null) {
      _result.failure = failure;
    }
    return _result;
  }
  factory NegotiateMtuInfo.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NegotiateMtuInfo.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  NegotiateMtuInfo clone() => NegotiateMtuInfo()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  NegotiateMtuInfo copyWith(void Function(NegotiateMtuInfo) updates) =>
      super.copyWith((message) => updates(message as NegotiateMtuInfo))
          as NegotiateMtuInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NegotiateMtuInfo create() => NegotiateMtuInfo._();
  NegotiateMtuInfo createEmptyInstance() => create();
  static $pb.PbList<NegotiateMtuInfo> createRepeated() =>
      $pb.PbList<NegotiateMtuInfo>();
  @$core.pragma('dart2js:noInline')
  static NegotiateMtuInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NegotiateMtuInfo>(create);
  static NegotiateMtuInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get mtuSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set mtuSize($core.int v) {
    $_setSignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasMtuSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearMtuSize() => clearField(2);

  @$pb.TagNumber(3)
  GenericFailure get failure => $_getN(2);
  @$pb.TagNumber(3)
  set failure(GenericFailure v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasFailure() => $_has(2);
  @$pb.TagNumber(3)
  void clearFailure() => clearField(3);
  @$pb.TagNumber(3)
  GenericFailure ensureFailure() => $_ensure(2);
}

class BleStatusInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'BleStatusInfo',
      createEmptyInstance: create)
    ..a<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'status',
        $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  BleStatusInfo._() : super();
  factory BleStatusInfo({
    $core.int? status,
  }) {
    final _result = create();
    if (status != null) {
      _result.status = status;
    }
    return _result;
  }
  factory BleStatusInfo.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory BleStatusInfo.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  BleStatusInfo clone() => BleStatusInfo()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  BleStatusInfo copyWith(void Function(BleStatusInfo) updates) =>
      super.copyWith((message) => updates(message as BleStatusInfo))
          as BleStatusInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BleStatusInfo create() => BleStatusInfo._();
  BleStatusInfo createEmptyInstance() => create();
  static $pb.PbList<BleStatusInfo> createRepeated() =>
      $pb.PbList<BleStatusInfo>();
  @$core.pragma('dart2js:noInline')
  static BleStatusInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BleStatusInfo>(create);
  static BleStatusInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get status => $_getIZ(0);
  @$pb.TagNumber(1)
  set status($core.int v) {
    $_setSignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);
}

class ChangeConnectionPriorityRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ChangeConnectionPriorityRequest',
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'deviceId',
        protoName: 'deviceId')
    ..a<$core.int>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'priority',
        $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  ChangeConnectionPriorityRequest._() : super();
  factory ChangeConnectionPriorityRequest({
    $core.String? deviceId,
    $core.int? priority,
  }) {
    final _result = create();
    if (deviceId != null) {
      _result.deviceId = deviceId;
    }
    if (priority != null) {
      _result.priority = priority;
    }
    return _result;
  }
  factory ChangeConnectionPriorityRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ChangeConnectionPriorityRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ChangeConnectionPriorityRequest clone() =>
      ChangeConnectionPriorityRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ChangeConnectionPriorityRequest copyWith(
          void Function(ChangeConnectionPriorityRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ChangeConnectionPriorityRequest))
          as ChangeConnectionPriorityRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ChangeConnectionPriorityRequest create() =>
      ChangeConnectionPriorityRequest._();
  ChangeConnectionPriorityRequest createEmptyInstance() => create();
  static $pb.PbList<ChangeConnectionPriorityRequest> createRepeated() =>
      $pb.PbList<ChangeConnectionPriorityRequest>();
  @$core.pragma('dart2js:noInline')
  static ChangeConnectionPriorityRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChangeConnectionPriorityRequest>(
          create);
  static ChangeConnectionPriorityRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get priority => $_getIZ(1);
  @$pb.TagNumber(2)
  set priority($core.int v) {
    $_setSignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasPriority() => $_has(1);
  @$pb.TagNumber(2)
  void clearPriority() => clearField(2);
}

class ChangeConnectionPriorityInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ChangeConnectionPriorityInfo',
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'deviceId',
        protoName: 'deviceId')
    ..aOM<GenericFailure>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'failure',
        subBuilder: GenericFailure.create)
    ..hasRequiredFields = false;

  ChangeConnectionPriorityInfo._() : super();
  factory ChangeConnectionPriorityInfo({
    $core.String? deviceId,
    GenericFailure? failure,
  }) {
    final _result = create();
    if (deviceId != null) {
      _result.deviceId = deviceId;
    }
    if (failure != null) {
      _result.failure = failure;
    }
    return _result;
  }
  factory ChangeConnectionPriorityInfo.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ChangeConnectionPriorityInfo.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ChangeConnectionPriorityInfo clone() =>
      ChangeConnectionPriorityInfo()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ChangeConnectionPriorityInfo copyWith(
          void Function(ChangeConnectionPriorityInfo) updates) =>
      super.copyWith(
              (message) => updates(message as ChangeConnectionPriorityInfo))
          as ChangeConnectionPriorityInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ChangeConnectionPriorityInfo create() =>
      ChangeConnectionPriorityInfo._();
  ChangeConnectionPriorityInfo createEmptyInstance() => create();
  static $pb.PbList<ChangeConnectionPriorityInfo> createRepeated() =>
      $pb.PbList<ChangeConnectionPriorityInfo>();
  @$core.pragma('dart2js:noInline')
  static ChangeConnectionPriorityInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChangeConnectionPriorityInfo>(create);
  static ChangeConnectionPriorityInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => clearField(1);

  @$pb.TagNumber(2)
  GenericFailure get failure => $_getN(1);
  @$pb.TagNumber(2)
  set failure(GenericFailure v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasFailure() => $_has(1);
  @$pb.TagNumber(2)
  void clearFailure() => clearField(2);
  @$pb.TagNumber(2)
  GenericFailure ensureFailure() => $_ensure(1);
}

class CharacteristicAddress extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'CharacteristicAddress',
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'deviceId',
        protoName: 'deviceId')
    ..aOM<Uuid>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'serviceUuid',
        protoName: 'serviceUuid',
        subBuilder: Uuid.create)
    ..aOM<Uuid>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'characteristicUuid',
        protoName: 'characteristicUuid',
        subBuilder: Uuid.create)
    ..hasRequiredFields = false;

  CharacteristicAddress._() : super();
  factory CharacteristicAddress({
    $core.String? deviceId,
    Uuid? serviceUuid,
    Uuid? characteristicUuid,
  }) {
    final _result = create();
    if (deviceId != null) {
      _result.deviceId = deviceId;
    }
    if (serviceUuid != null) {
      _result.serviceUuid = serviceUuid;
    }
    if (characteristicUuid != null) {
      _result.characteristicUuid = characteristicUuid;
    }
    return _result;
  }
  factory CharacteristicAddress.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory CharacteristicAddress.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  CharacteristicAddress clone() =>
      CharacteristicAddress()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  CharacteristicAddress copyWith(
          void Function(CharacteristicAddress) updates) =>
      super.copyWith((message) => updates(message as CharacteristicAddress))
          as CharacteristicAddress; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CharacteristicAddress create() => CharacteristicAddress._();
  CharacteristicAddress createEmptyInstance() => create();
  static $pb.PbList<CharacteristicAddress> createRepeated() =>
      $pb.PbList<CharacteristicAddress>();
  @$core.pragma('dart2js:noInline')
  static CharacteristicAddress getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CharacteristicAddress>(create);
  static CharacteristicAddress? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => clearField(1);

  @$pb.TagNumber(2)
  Uuid get serviceUuid => $_getN(1);
  @$pb.TagNumber(2)
  set serviceUuid(Uuid v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasServiceUuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearServiceUuid() => clearField(2);
  @$pb.TagNumber(2)
  Uuid ensureServiceUuid() => $_ensure(1);

  @$pb.TagNumber(3)
  Uuid get characteristicUuid => $_getN(2);
  @$pb.TagNumber(3)
  set characteristicUuid(Uuid v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasCharacteristicUuid() => $_has(2);
  @$pb.TagNumber(3)
  void clearCharacteristicUuid() => clearField(3);
  @$pb.TagNumber(3)
  Uuid ensureCharacteristicUuid() => $_ensure(2);
}

class ServiceDataEntry extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ServiceDataEntry',
      createEmptyInstance: create)
    ..aOM<Uuid>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'serviceUuid',
        protoName: 'serviceUuid',
        subBuilder: Uuid.create)
    ..a<$core.List<$core.int>>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'data',
        $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  ServiceDataEntry._() : super();
  factory ServiceDataEntry({
    Uuid? serviceUuid,
    $core.List<$core.int>? data,
  }) {
    final _result = create();
    if (serviceUuid != null) {
      _result.serviceUuid = serviceUuid;
    }
    if (data != null) {
      _result.data = data;
    }
    return _result;
  }
  factory ServiceDataEntry.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ServiceDataEntry.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ServiceDataEntry clone() => ServiceDataEntry()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ServiceDataEntry copyWith(void Function(ServiceDataEntry) updates) =>
      super.copyWith((message) => updates(message as ServiceDataEntry))
          as ServiceDataEntry; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ServiceDataEntry create() => ServiceDataEntry._();
  ServiceDataEntry createEmptyInstance() => create();
  static $pb.PbList<ServiceDataEntry> createRepeated() =>
      $pb.PbList<ServiceDataEntry>();
  @$core.pragma('dart2js:noInline')
  static ServiceDataEntry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceDataEntry>(create);
  static ServiceDataEntry? _defaultInstance;

  @$pb.TagNumber(1)
  Uuid get serviceUuid => $_getN(0);
  @$pb.TagNumber(1)
  set serviceUuid(Uuid v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasServiceUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceUuid() => clearField(1);
  @$pb.TagNumber(1)
  Uuid ensureServiceUuid() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<$core.int> get data => $_getN(1);
  @$pb.TagNumber(2)
  set data($core.List<$core.int> v) {
    $_setBytes(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasData() => $_has(1);
  @$pb.TagNumber(2)
  void clearData() => clearField(2);
}

class ServicesWithCharacteristics extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ServicesWithCharacteristics',
      createEmptyInstance: create)
    ..pc<ServiceWithCharacteristics>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'items',
        $pb.PbFieldType.PM,
        subBuilder: ServiceWithCharacteristics.create)
    ..hasRequiredFields = false;

  ServicesWithCharacteristics._() : super();
  factory ServicesWithCharacteristics({
    $core.Iterable<ServiceWithCharacteristics>? items,
  }) {
    final _result = create();
    if (items != null) {
      _result.items.addAll(items);
    }
    return _result;
  }
  factory ServicesWithCharacteristics.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ServicesWithCharacteristics.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ServicesWithCharacteristics clone() =>
      ServicesWithCharacteristics()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ServicesWithCharacteristics copyWith(
          void Function(ServicesWithCharacteristics) updates) =>
      super.copyWith(
              (message) => updates(message as ServicesWithCharacteristics))
          as ServicesWithCharacteristics; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ServicesWithCharacteristics create() =>
      ServicesWithCharacteristics._();
  ServicesWithCharacteristics createEmptyInstance() => create();
  static $pb.PbList<ServicesWithCharacteristics> createRepeated() =>
      $pb.PbList<ServicesWithCharacteristics>();
  @$core.pragma('dart2js:noInline')
  static ServicesWithCharacteristics getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServicesWithCharacteristics>(create);
  static ServicesWithCharacteristics? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<ServiceWithCharacteristics> get items => $_getList(0);
}

class ServiceWithCharacteristics extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'ServiceWithCharacteristics',
      createEmptyInstance: create)
    ..aOM<Uuid>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'serviceId',
        protoName: 'serviceId',
        subBuilder: Uuid.create)
    ..pc<Uuid>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'characteristics',
        $pb.PbFieldType.PM,
        subBuilder: Uuid.create)
    ..hasRequiredFields = false;

  ServiceWithCharacteristics._() : super();
  factory ServiceWithCharacteristics({
    Uuid? serviceId,
    $core.Iterable<Uuid>? characteristics,
  }) {
    final _result = create();
    if (serviceId != null) {
      _result.serviceId = serviceId;
    }
    if (characteristics != null) {
      _result.characteristics.addAll(characteristics);
    }
    return _result;
  }
  factory ServiceWithCharacteristics.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ServiceWithCharacteristics.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  ServiceWithCharacteristics clone() =>
      ServiceWithCharacteristics()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  ServiceWithCharacteristics copyWith(
          void Function(ServiceWithCharacteristics) updates) =>
      super.copyWith(
              (message) => updates(message as ServiceWithCharacteristics))
          as ServiceWithCharacteristics; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ServiceWithCharacteristics create() => ServiceWithCharacteristics._();
  ServiceWithCharacteristics createEmptyInstance() => create();
  static $pb.PbList<ServiceWithCharacteristics> createRepeated() =>
      $pb.PbList<ServiceWithCharacteristics>();
  @$core.pragma('dart2js:noInline')
  static ServiceWithCharacteristics getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceWithCharacteristics>(create);
  static ServiceWithCharacteristics? _defaultInstance;

  @$pb.TagNumber(1)
  Uuid get serviceId => $_getN(0);
  @$pb.TagNumber(1)
  set serviceId(Uuid v) {
    setField(1, v);
  }

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DiscoverServicesRequest',
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'deviceId',
        protoName: 'deviceId')
    ..hasRequiredFields = false;

  DiscoverServicesRequest._() : super();
  factory DiscoverServicesRequest({
    $core.String? deviceId,
  }) {
    final _result = create();
    if (deviceId != null) {
      _result.deviceId = deviceId;
    }
    return _result;
  }
  factory DiscoverServicesRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DiscoverServicesRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DiscoverServicesRequest clone() =>
      DiscoverServicesRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DiscoverServicesRequest copyWith(
          void Function(DiscoverServicesRequest) updates) =>
      super.copyWith((message) => updates(message as DiscoverServicesRequest))
          as DiscoverServicesRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DiscoverServicesRequest create() => DiscoverServicesRequest._();
  DiscoverServicesRequest createEmptyInstance() => create();
  static $pb.PbList<DiscoverServicesRequest> createRepeated() =>
      $pb.PbList<DiscoverServicesRequest>();
  @$core.pragma('dart2js:noInline')
  static DiscoverServicesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DiscoverServicesRequest>(create);
  static DiscoverServicesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => clearField(1);
}

class DiscoverServicesInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DiscoverServicesInfo',
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'deviceId',
        protoName: 'deviceId')
    ..pc<DiscoveredService>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'services',
        $pb.PbFieldType.PM,
        subBuilder: DiscoveredService.create)
    ..hasRequiredFields = false;

  DiscoverServicesInfo._() : super();
  factory DiscoverServicesInfo({
    $core.String? deviceId,
    $core.Iterable<DiscoveredService>? services,
  }) {
    final _result = create();
    if (deviceId != null) {
      _result.deviceId = deviceId;
    }
    if (services != null) {
      _result.services.addAll(services);
    }
    return _result;
  }
  factory DiscoverServicesInfo.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DiscoverServicesInfo.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DiscoverServicesInfo clone() =>
      DiscoverServicesInfo()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DiscoverServicesInfo copyWith(void Function(DiscoverServicesInfo) updates) =>
      super.copyWith((message) => updates(message as DiscoverServicesInfo))
          as DiscoverServicesInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DiscoverServicesInfo create() => DiscoverServicesInfo._();
  DiscoverServicesInfo createEmptyInstance() => create();
  static $pb.PbList<DiscoverServicesInfo> createRepeated() =>
      $pb.PbList<DiscoverServicesInfo>();
  @$core.pragma('dart2js:noInline')
  static DiscoverServicesInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DiscoverServicesInfo>(create);
  static DiscoverServicesInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<DiscoveredService> get services => $_getList(1);
}

class DiscoveredService extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DiscoveredService',
      createEmptyInstance: create)
    ..aOM<Uuid>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'serviceUuid',
        protoName: 'serviceUuid',
        subBuilder: Uuid.create)
    ..pc<Uuid>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'characteristicUuids',
        $pb.PbFieldType.PM,
        protoName: 'characteristicUuids',
        subBuilder: Uuid.create)
    ..pc<DiscoveredService>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'includedServices',
        $pb.PbFieldType.PM,
        protoName: 'includedServices',
        subBuilder: DiscoveredService.create)
    ..pc<DiscoveredCharacteristic>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'characteristics',
        $pb.PbFieldType.PM,
        subBuilder: DiscoveredCharacteristic.create)
    ..hasRequiredFields = false;

  DiscoveredService._() : super();
  factory DiscoveredService({
    Uuid? serviceUuid,
    $core.Iterable<Uuid>? characteristicUuids,
    $core.Iterable<DiscoveredService>? includedServices,
    $core.Iterable<DiscoveredCharacteristic>? characteristics,
  }) {
    final _result = create();
    if (serviceUuid != null) {
      _result.serviceUuid = serviceUuid;
    }
    if (characteristicUuids != null) {
      _result.characteristicUuids.addAll(characteristicUuids);
    }
    if (includedServices != null) {
      _result.includedServices.addAll(includedServices);
    }
    if (characteristics != null) {
      _result.characteristics.addAll(characteristics);
    }
    return _result;
  }
  factory DiscoveredService.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DiscoveredService.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DiscoveredService clone() => DiscoveredService()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DiscoveredService copyWith(void Function(DiscoveredService) updates) =>
      super.copyWith((message) => updates(message as DiscoveredService))
          as DiscoveredService; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DiscoveredService create() => DiscoveredService._();
  DiscoveredService createEmptyInstance() => create();
  static $pb.PbList<DiscoveredService> createRepeated() =>
      $pb.PbList<DiscoveredService>();
  @$core.pragma('dart2js:noInline')
  static DiscoveredService getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DiscoveredService>(create);
  static DiscoveredService? _defaultInstance;

  @$pb.TagNumber(1)
  Uuid get serviceUuid => $_getN(0);
  @$pb.TagNumber(1)
  set serviceUuid(Uuid v) {
    setField(1, v);
  }

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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DiscoveredCharacteristic',
      createEmptyInstance: create)
    ..aOM<Uuid>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'characteristicId',
        protoName: 'characteristicId',
        subBuilder: Uuid.create)
    ..aOM<Uuid>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'serviceId',
        protoName: 'serviceId',
        subBuilder: Uuid.create)
    ..aOB(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'isReadable',
        protoName: 'isReadable')
    ..aOB(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'isWritableWithResponse',
        protoName: 'isWritableWithResponse')
    ..aOB(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'isWritableWithoutResponse',
        protoName: 'isWritableWithoutResponse')
    ..aOB(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'isNotifiable',
        protoName: 'isNotifiable')
    ..aOB(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'isIndicatable',
        protoName: 'isIndicatable')
    ..hasRequiredFields = false;

  DiscoveredCharacteristic._() : super();
  factory DiscoveredCharacteristic({
    Uuid? characteristicId,
    Uuid? serviceId,
    $core.bool? isReadable,
    $core.bool? isWritableWithResponse,
    $core.bool? isWritableWithoutResponse,
    $core.bool? isNotifiable,
    $core.bool? isIndicatable,
  }) {
    final _result = create();
    if (characteristicId != null) {
      _result.characteristicId = characteristicId;
    }
    if (serviceId != null) {
      _result.serviceId = serviceId;
    }
    if (isReadable != null) {
      _result.isReadable = isReadable;
    }
    if (isWritableWithResponse != null) {
      _result.isWritableWithResponse = isWritableWithResponse;
    }
    if (isWritableWithoutResponse != null) {
      _result.isWritableWithoutResponse = isWritableWithoutResponse;
    }
    if (isNotifiable != null) {
      _result.isNotifiable = isNotifiable;
    }
    if (isIndicatable != null) {
      _result.isIndicatable = isIndicatable;
    }
    return _result;
  }
  factory DiscoveredCharacteristic.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DiscoveredCharacteristic.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DiscoveredCharacteristic clone() =>
      DiscoveredCharacteristic()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DiscoveredCharacteristic copyWith(
          void Function(DiscoveredCharacteristic) updates) =>
      super.copyWith((message) => updates(message as DiscoveredCharacteristic))
          as DiscoveredCharacteristic; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DiscoveredCharacteristic create() => DiscoveredCharacteristic._();
  DiscoveredCharacteristic createEmptyInstance() => create();
  static $pb.PbList<DiscoveredCharacteristic> createRepeated() =>
      $pb.PbList<DiscoveredCharacteristic>();
  @$core.pragma('dart2js:noInline')
  static DiscoveredCharacteristic getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DiscoveredCharacteristic>(create);
  static DiscoveredCharacteristic? _defaultInstance;

  @$pb.TagNumber(1)
  Uuid get characteristicId => $_getN(0);
  @$pb.TagNumber(1)
  set characteristicId(Uuid v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCharacteristicId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCharacteristicId() => clearField(1);
  @$pb.TagNumber(1)
  Uuid ensureCharacteristicId() => $_ensure(0);

  @$pb.TagNumber(2)
  Uuid get serviceId => $_getN(1);
  @$pb.TagNumber(2)
  set serviceId(Uuid v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasServiceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearServiceId() => clearField(2);
  @$pb.TagNumber(2)
  Uuid ensureServiceId() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get isReadable => $_getBF(2);
  @$pb.TagNumber(3)
  set isReadable($core.bool v) {
    $_setBool(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasIsReadable() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsReadable() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isWritableWithResponse => $_getBF(3);
  @$pb.TagNumber(4)
  set isWritableWithResponse($core.bool v) {
    $_setBool(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasIsWritableWithResponse() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsWritableWithResponse() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get isWritableWithoutResponse => $_getBF(4);
  @$pb.TagNumber(5)
  set isWritableWithoutResponse($core.bool v) {
    $_setBool(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasIsWritableWithoutResponse() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsWritableWithoutResponse() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isNotifiable => $_getBF(5);
  @$pb.TagNumber(6)
  set isNotifiable($core.bool v) {
    $_setBool(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasIsNotifiable() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsNotifiable() => clearField(6);

  @$pb.TagNumber(7)
  $core.bool get isIndicatable => $_getBF(6);
  @$pb.TagNumber(7)
  set isIndicatable($core.bool v) {
    $_setBool(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasIsIndicatable() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsIndicatable() => clearField(7);
}

class Uuid extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'Uuid',
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'data',
        $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  Uuid._() : super();
  factory Uuid({
    $core.List<$core.int>? data,
  }) {
    final _result = create();
    if (data != null) {
      _result.data = data;
    }
    return _result;
  }
  factory Uuid.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Uuid.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Uuid clone() => Uuid()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Uuid copyWith(void Function(Uuid) updates) =>
      super.copyWith((message) => updates(message as Uuid))
          as Uuid; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Uuid create() => Uuid._();
  Uuid createEmptyInstance() => create();
  static $pb.PbList<Uuid> createRepeated() => $pb.PbList<Uuid>();
  @$core.pragma('dart2js:noInline')
  static Uuid getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Uuid>(create);
  static Uuid? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get data => $_getN(0);
  @$pb.TagNumber(1)
  set data($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
}

class GenericFailure extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'GenericFailure',
      createEmptyInstance: create)
    ..a<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'code',
        $pb.PbFieldType.O3)
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'message')
    ..hasRequiredFields = false;

  GenericFailure._() : super();
  factory GenericFailure({
    $core.int? code,
    $core.String? message,
  }) {
    final _result = create();
    if (code != null) {
      _result.code = code;
    }
    if (message != null) {
      _result.message = message;
    }
    return _result;
  }
  factory GenericFailure.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GenericFailure.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  GenericFailure clone() => GenericFailure()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  GenericFailure copyWith(void Function(GenericFailure) updates) =>
      super.copyWith((message) => updates(message as GenericFailure))
          as GenericFailure; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GenericFailure create() => GenericFailure._();
  GenericFailure createEmptyInstance() => create();
  static $pb.PbList<GenericFailure> createRepeated() =>
      $pb.PbList<GenericFailure>();
  @$core.pragma('dart2js:noInline')
  static GenericFailure getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GenericFailure>(create);
  static GenericFailure? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get code => $_getIZ(0);
  @$pb.TagNumber(1)
  set code($core.int v) {
    $_setSignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);
}
