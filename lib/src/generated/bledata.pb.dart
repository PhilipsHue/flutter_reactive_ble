///
//  Generated code. Do not modify.
//  source: bledata.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ScanForDevicesRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo('ScanForDevicesRequest', createEmptyInstance: create)
        ..pc<Uuid>(1, 'serviceUuids', $pb.PbFieldType.PM,
            protoName: 'serviceUuids', subBuilder: Uuid.create)
        ..a<$core.int>(2, 'scanMode', $pb.PbFieldType.O3, protoName: 'scanMode')
        ..aOB(3, 'requireLocationServicesEnabled',
            protoName: 'requireLocationServicesEnabled')
        ..hasRequiredFields = false;

  ScanForDevicesRequest._() : super();
  factory ScanForDevicesRequest() => create();
  factory ScanForDevicesRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ScanForDevicesRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  ScanForDevicesRequest clone() =>
      ScanForDevicesRequest()..mergeFromMessage(this);
  ScanForDevicesRequest copyWith(
          void Function(ScanForDevicesRequest) updates) =>
      super.copyWith((message) => updates(message as ScanForDevicesRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ScanForDevicesRequest create() => ScanForDevicesRequest._();
  ScanForDevicesRequest createEmptyInstance() => create();
  static $pb.PbList<ScanForDevicesRequest> createRepeated() =>
      $pb.PbList<ScanForDevicesRequest>();
  @$core.pragma('dart2js:noInline')
  static ScanForDevicesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScanForDevicesRequest>(create);
  static ScanForDevicesRequest _defaultInstance;

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
  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo('DeviceScanInfo', createEmptyInstance: create)
        ..aOS(1, 'id')
        ..aOS(2, 'name')
        ..aOM<GenericFailure>(3, 'failure', subBuilder: GenericFailure.create)
        ..pc<ServiceDataEntry>(4, 'serviceData', $pb.PbFieldType.PM,
            protoName: 'serviceData', subBuilder: ServiceDataEntry.create)
        ..a<$core.int>(5, 'rssi', $pb.PbFieldType.O3)
        ..a<$core.List<$core.int>>(6, 'manufacturerData', $pb.PbFieldType.OY,
            protoName: 'manufacturerData')
        ..hasRequiredFields = false;

  DeviceScanInfo._() : super();
  factory DeviceScanInfo() => create();
  factory DeviceScanInfo.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DeviceScanInfo.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  DeviceScanInfo clone() => DeviceScanInfo()..mergeFromMessage(this);
  DeviceScanInfo copyWith(void Function(DeviceScanInfo) updates) =>
      super.copyWith((message) => updates(message as DeviceScanInfo));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DeviceScanInfo create() => DeviceScanInfo._();
  DeviceScanInfo createEmptyInstance() => create();
  static $pb.PbList<DeviceScanInfo> createRepeated() =>
      $pb.PbList<DeviceScanInfo>();
  @$core.pragma('dart2js:noInline')
  static DeviceScanInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeviceScanInfo>(create);
  static DeviceScanInfo _defaultInstance;

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
}

class ConnectToDeviceRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo('ConnectToDeviceRequest', createEmptyInstance: create)
        ..aOS(1, 'deviceId', protoName: 'deviceId')
        ..aOM<ServicesWithCharacteristics>(
            2, 'servicesWithCharacteristicsToDiscover',
            protoName: 'servicesWithCharacteristicsToDiscover',
            subBuilder: ServicesWithCharacteristics.create)
        ..a<$core.int>(3, 'timeoutInMs', $pb.PbFieldType.O3,
            protoName: 'timeoutInMs')
        ..hasRequiredFields = false;

  ConnectToDeviceRequest._() : super();
  factory ConnectToDeviceRequest() => create();
  factory ConnectToDeviceRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ConnectToDeviceRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  ConnectToDeviceRequest clone() =>
      ConnectToDeviceRequest()..mergeFromMessage(this);
  ConnectToDeviceRequest copyWith(
          void Function(ConnectToDeviceRequest) updates) =>
      super.copyWith((message) => updates(message as ConnectToDeviceRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ConnectToDeviceRequest create() => ConnectToDeviceRequest._();
  ConnectToDeviceRequest createEmptyInstance() => create();
  static $pb.PbList<ConnectToDeviceRequest> createRepeated() =>
      $pb.PbList<ConnectToDeviceRequest>();
  @$core.pragma('dart2js:noInline')
  static ConnectToDeviceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConnectToDeviceRequest>(create);
  static ConnectToDeviceRequest _defaultInstance;

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
  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo('DeviceInfo', createEmptyInstance: create)
        ..aOS(1, 'id')
        ..a<$core.int>(2, 'connectionState', $pb.PbFieldType.O3,
            protoName: 'connectionState')
        ..aOM<GenericFailure>(3, 'failure', subBuilder: GenericFailure.create)
        ..hasRequiredFields = false;

  DeviceInfo._() : super();
  factory DeviceInfo() => create();
  factory DeviceInfo.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DeviceInfo.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  DeviceInfo clone() => DeviceInfo()..mergeFromMessage(this);
  DeviceInfo copyWith(void Function(DeviceInfo) updates) =>
      super.copyWith((message) => updates(message as DeviceInfo));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DeviceInfo create() => DeviceInfo._();
  DeviceInfo createEmptyInstance() => create();
  static $pb.PbList<DeviceInfo> createRepeated() => $pb.PbList<DeviceInfo>();
  @$core.pragma('dart2js:noInline')
  static DeviceInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeviceInfo>(create);
  static DeviceInfo _defaultInstance;

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
      'DisconnectFromDeviceRequest',
      createEmptyInstance: create)
    ..aOS(1, 'deviceId', protoName: 'deviceId')
    ..hasRequiredFields = false;

  DisconnectFromDeviceRequest._() : super();
  factory DisconnectFromDeviceRequest() => create();
  factory DisconnectFromDeviceRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DisconnectFromDeviceRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  DisconnectFromDeviceRequest clone() =>
      DisconnectFromDeviceRequest()..mergeFromMessage(this);
  DisconnectFromDeviceRequest copyWith(
          void Function(DisconnectFromDeviceRequest) updates) =>
      super.copyWith(
          (message) => updates(message as DisconnectFromDeviceRequest));
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
  static DisconnectFromDeviceRequest _defaultInstance;

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
  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo('ClearGattCacheRequest', createEmptyInstance: create)
        ..aOS(1, 'deviceId', protoName: 'deviceId')
        ..hasRequiredFields = false;

  ClearGattCacheRequest._() : super();
  factory ClearGattCacheRequest() => create();
  factory ClearGattCacheRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ClearGattCacheRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  ClearGattCacheRequest clone() =>
      ClearGattCacheRequest()..mergeFromMessage(this);
  ClearGattCacheRequest copyWith(
          void Function(ClearGattCacheRequest) updates) =>
      super.copyWith((message) => updates(message as ClearGattCacheRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ClearGattCacheRequest create() => ClearGattCacheRequest._();
  ClearGattCacheRequest createEmptyInstance() => create();
  static $pb.PbList<ClearGattCacheRequest> createRepeated() =>
      $pb.PbList<ClearGattCacheRequest>();
  @$core.pragma('dart2js:noInline')
  static ClearGattCacheRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClearGattCacheRequest>(create);
  static ClearGattCacheRequest _defaultInstance;

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
  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo('ClearGattCacheInfo', createEmptyInstance: create)
        ..aOM<GenericFailure>(1, 'failure', subBuilder: GenericFailure.create)
        ..hasRequiredFields = false;

  ClearGattCacheInfo._() : super();
  factory ClearGattCacheInfo() => create();
  factory ClearGattCacheInfo.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ClearGattCacheInfo.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  ClearGattCacheInfo clone() => ClearGattCacheInfo()..mergeFromMessage(this);
  ClearGattCacheInfo copyWith(void Function(ClearGattCacheInfo) updates) =>
      super.copyWith((message) => updates(message as ClearGattCacheInfo));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ClearGattCacheInfo create() => ClearGattCacheInfo._();
  ClearGattCacheInfo createEmptyInstance() => create();
  static $pb.PbList<ClearGattCacheInfo> createRepeated() =>
      $pb.PbList<ClearGattCacheInfo>();
  @$core.pragma('dart2js:noInline')
  static ClearGattCacheInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClearGattCacheInfo>(create);
  static ClearGattCacheInfo _defaultInstance;

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
      'NotifyCharacteristicRequest',
      createEmptyInstance: create)
    ..aOM<CharacteristicAddress>(1, 'characteristic',
        subBuilder: CharacteristicAddress.create)
    ..hasRequiredFields = false;

  NotifyCharacteristicRequest._() : super();
  factory NotifyCharacteristicRequest() => create();
  factory NotifyCharacteristicRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NotifyCharacteristicRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  NotifyCharacteristicRequest clone() =>
      NotifyCharacteristicRequest()..mergeFromMessage(this);
  NotifyCharacteristicRequest copyWith(
          void Function(NotifyCharacteristicRequest) updates) =>
      super.copyWith(
          (message) => updates(message as NotifyCharacteristicRequest));
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
  static NotifyCharacteristicRequest _defaultInstance;

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
      'NotifyNoMoreCharacteristicRequest',
      createEmptyInstance: create)
    ..aOM<CharacteristicAddress>(1, 'characteristic',
        subBuilder: CharacteristicAddress.create)
    ..hasRequiredFields = false;

  NotifyNoMoreCharacteristicRequest._() : super();
  factory NotifyNoMoreCharacteristicRequest() => create();
  factory NotifyNoMoreCharacteristicRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NotifyNoMoreCharacteristicRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  NotifyNoMoreCharacteristicRequest clone() =>
      NotifyNoMoreCharacteristicRequest()..mergeFromMessage(this);
  NotifyNoMoreCharacteristicRequest copyWith(
          void Function(NotifyNoMoreCharacteristicRequest) updates) =>
      super.copyWith(
          (message) => updates(message as NotifyNoMoreCharacteristicRequest));
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
  static NotifyNoMoreCharacteristicRequest _defaultInstance;

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
  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo('ReadCharacteristicRequest', createEmptyInstance: create)
        ..aOM<CharacteristicAddress>(1, 'characteristic',
            subBuilder: CharacteristicAddress.create)
        ..hasRequiredFields = false;

  ReadCharacteristicRequest._() : super();
  factory ReadCharacteristicRequest() => create();
  factory ReadCharacteristicRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ReadCharacteristicRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  ReadCharacteristicRequest clone() =>
      ReadCharacteristicRequest()..mergeFromMessage(this);
  ReadCharacteristicRequest copyWith(
          void Function(ReadCharacteristicRequest) updates) =>
      super
          .copyWith((message) => updates(message as ReadCharacteristicRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ReadCharacteristicRequest create() => ReadCharacteristicRequest._();
  ReadCharacteristicRequest createEmptyInstance() => create();
  static $pb.PbList<ReadCharacteristicRequest> createRepeated() =>
      $pb.PbList<ReadCharacteristicRequest>();
  @$core.pragma('dart2js:noInline')
  static ReadCharacteristicRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReadCharacteristicRequest>(create);
  static ReadCharacteristicRequest _defaultInstance;

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
  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo('CharacteristicValueInfo', createEmptyInstance: create)
        ..aOM<CharacteristicAddress>(1, 'characteristic',
            subBuilder: CharacteristicAddress.create)
        ..a<$core.List<$core.int>>(2, 'value', $pb.PbFieldType.OY)
        ..aOM<GenericFailure>(3, 'failure', subBuilder: GenericFailure.create)
        ..hasRequiredFields = false;

  CharacteristicValueInfo._() : super();
  factory CharacteristicValueInfo() => create();
  factory CharacteristicValueInfo.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory CharacteristicValueInfo.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  CharacteristicValueInfo clone() =>
      CharacteristicValueInfo()..mergeFromMessage(this);
  CharacteristicValueInfo copyWith(
          void Function(CharacteristicValueInfo) updates) =>
      super.copyWith((message) => updates(message as CharacteristicValueInfo));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CharacteristicValueInfo create() => CharacteristicValueInfo._();
  CharacteristicValueInfo createEmptyInstance() => create();
  static $pb.PbList<CharacteristicValueInfo> createRepeated() =>
      $pb.PbList<CharacteristicValueInfo>();
  @$core.pragma('dart2js:noInline')
  static CharacteristicValueInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CharacteristicValueInfo>(create);
  static CharacteristicValueInfo _defaultInstance;

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
  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo('WriteCharacteristicRequest', createEmptyInstance: create)
        ..aOM<CharacteristicAddress>(1, 'characteristic',
            subBuilder: CharacteristicAddress.create)
        ..a<$core.List<$core.int>>(2, 'value', $pb.PbFieldType.OY)
        ..hasRequiredFields = false;

  WriteCharacteristicRequest._() : super();
  factory WriteCharacteristicRequest() => create();
  factory WriteCharacteristicRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory WriteCharacteristicRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  WriteCharacteristicRequest clone() =>
      WriteCharacteristicRequest()..mergeFromMessage(this);
  WriteCharacteristicRequest copyWith(
          void Function(WriteCharacteristicRequest) updates) =>
      super.copyWith(
          (message) => updates(message as WriteCharacteristicRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static WriteCharacteristicRequest create() => WriteCharacteristicRequest._();
  WriteCharacteristicRequest createEmptyInstance() => create();
  static $pb.PbList<WriteCharacteristicRequest> createRepeated() =>
      $pb.PbList<WriteCharacteristicRequest>();
  @$core.pragma('dart2js:noInline')
  static WriteCharacteristicRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WriteCharacteristicRequest>(create);
  static WriteCharacteristicRequest _defaultInstance;

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
  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo('WriteCharacteristicInfo', createEmptyInstance: create)
        ..aOM<CharacteristicAddress>(1, 'characteristic',
            subBuilder: CharacteristicAddress.create)
        ..aOM<GenericFailure>(3, 'failure', subBuilder: GenericFailure.create)
        ..hasRequiredFields = false;

  WriteCharacteristicInfo._() : super();
  factory WriteCharacteristicInfo() => create();
  factory WriteCharacteristicInfo.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory WriteCharacteristicInfo.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  WriteCharacteristicInfo clone() =>
      WriteCharacteristicInfo()..mergeFromMessage(this);
  WriteCharacteristicInfo copyWith(
          void Function(WriteCharacteristicInfo) updates) =>
      super.copyWith((message) => updates(message as WriteCharacteristicInfo));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static WriteCharacteristicInfo create() => WriteCharacteristicInfo._();
  WriteCharacteristicInfo createEmptyInstance() => create();
  static $pb.PbList<WriteCharacteristicInfo> createRepeated() =>
      $pb.PbList<WriteCharacteristicInfo>();
  @$core.pragma('dart2js:noInline')
  static WriteCharacteristicInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WriteCharacteristicInfo>(create);
  static WriteCharacteristicInfo _defaultInstance;

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
  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo('NegotiateMtuRequest', createEmptyInstance: create)
        ..aOS(1, 'deviceId', protoName: 'deviceId')
        ..a<$core.int>(2, 'mtuSize', $pb.PbFieldType.O3, protoName: 'mtuSize')
        ..hasRequiredFields = false;

  NegotiateMtuRequest._() : super();
  factory NegotiateMtuRequest() => create();
  factory NegotiateMtuRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NegotiateMtuRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  NegotiateMtuRequest clone() => NegotiateMtuRequest()..mergeFromMessage(this);
  NegotiateMtuRequest copyWith(void Function(NegotiateMtuRequest) updates) =>
      super.copyWith((message) => updates(message as NegotiateMtuRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NegotiateMtuRequest create() => NegotiateMtuRequest._();
  NegotiateMtuRequest createEmptyInstance() => create();
  static $pb.PbList<NegotiateMtuRequest> createRepeated() =>
      $pb.PbList<NegotiateMtuRequest>();
  @$core.pragma('dart2js:noInline')
  static NegotiateMtuRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NegotiateMtuRequest>(create);
  static NegotiateMtuRequest _defaultInstance;

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
  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo('NegotiateMtuInfo', createEmptyInstance: create)
        ..aOS(1, 'deviceId', protoName: 'deviceId')
        ..a<$core.int>(2, 'mtuSize', $pb.PbFieldType.O3, protoName: 'mtuSize')
        ..aOM<GenericFailure>(3, 'failure', subBuilder: GenericFailure.create)
        ..hasRequiredFields = false;

  NegotiateMtuInfo._() : super();
  factory NegotiateMtuInfo() => create();
  factory NegotiateMtuInfo.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NegotiateMtuInfo.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  NegotiateMtuInfo clone() => NegotiateMtuInfo()..mergeFromMessage(this);
  NegotiateMtuInfo copyWith(void Function(NegotiateMtuInfo) updates) =>
      super.copyWith((message) => updates(message as NegotiateMtuInfo));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static NegotiateMtuInfo create() => NegotiateMtuInfo._();
  NegotiateMtuInfo createEmptyInstance() => create();
  static $pb.PbList<NegotiateMtuInfo> createRepeated() =>
      $pb.PbList<NegotiateMtuInfo>();
  @$core.pragma('dart2js:noInline')
  static NegotiateMtuInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NegotiateMtuInfo>(create);
  static NegotiateMtuInfo _defaultInstance;

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
  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo('BleStatusInfo', createEmptyInstance: create)
        ..a<$core.int>(1, 'status', $pb.PbFieldType.O3)
        ..hasRequiredFields = false;

  BleStatusInfo._() : super();
  factory BleStatusInfo() => create();
  factory BleStatusInfo.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory BleStatusInfo.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  BleStatusInfo clone() => BleStatusInfo()..mergeFromMessage(this);
  BleStatusInfo copyWith(void Function(BleStatusInfo) updates) =>
      super.copyWith((message) => updates(message as BleStatusInfo));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BleStatusInfo create() => BleStatusInfo._();
  BleStatusInfo createEmptyInstance() => create();
  static $pb.PbList<BleStatusInfo> createRepeated() =>
      $pb.PbList<BleStatusInfo>();
  @$core.pragma('dart2js:noInline')
  static BleStatusInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BleStatusInfo>(create);
  static BleStatusInfo _defaultInstance;

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
      'ChangeConnectionPriorityRequest',
      createEmptyInstance: create)
    ..aOS(1, 'deviceId', protoName: 'deviceId')
    ..a<$core.int>(2, 'priority', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  ChangeConnectionPriorityRequest._() : super();
  factory ChangeConnectionPriorityRequest() => create();
  factory ChangeConnectionPriorityRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ChangeConnectionPriorityRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  ChangeConnectionPriorityRequest clone() =>
      ChangeConnectionPriorityRequest()..mergeFromMessage(this);
  ChangeConnectionPriorityRequest copyWith(
          void Function(ChangeConnectionPriorityRequest) updates) =>
      super.copyWith(
          (message) => updates(message as ChangeConnectionPriorityRequest));
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
  static ChangeConnectionPriorityRequest _defaultInstance;

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
      'ChangeConnectionPriorityInfo',
      createEmptyInstance: create)
    ..aOS(1, 'deviceId', protoName: 'deviceId')
    ..aOM<GenericFailure>(2, 'failure', subBuilder: GenericFailure.create)
    ..hasRequiredFields = false;

  ChangeConnectionPriorityInfo._() : super();
  factory ChangeConnectionPriorityInfo() => create();
  factory ChangeConnectionPriorityInfo.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ChangeConnectionPriorityInfo.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  ChangeConnectionPriorityInfo clone() =>
      ChangeConnectionPriorityInfo()..mergeFromMessage(this);
  ChangeConnectionPriorityInfo copyWith(
          void Function(ChangeConnectionPriorityInfo) updates) =>
      super.copyWith(
          (message) => updates(message as ChangeConnectionPriorityInfo));
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
  static ChangeConnectionPriorityInfo _defaultInstance;

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
  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo('CharacteristicAddress', createEmptyInstance: create)
        ..aOS(1, 'deviceId', protoName: 'deviceId')
        ..aOM<Uuid>(2, 'serviceUuid',
            protoName: 'serviceUuid', subBuilder: Uuid.create)
        ..aOM<Uuid>(3, 'characteristicUuid',
            protoName: 'characteristicUuid', subBuilder: Uuid.create)
        ..hasRequiredFields = false;

  CharacteristicAddress._() : super();
  factory CharacteristicAddress() => create();
  factory CharacteristicAddress.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory CharacteristicAddress.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  CharacteristicAddress clone() =>
      CharacteristicAddress()..mergeFromMessage(this);
  CharacteristicAddress copyWith(
          void Function(CharacteristicAddress) updates) =>
      super.copyWith((message) => updates(message as CharacteristicAddress));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CharacteristicAddress create() => CharacteristicAddress._();
  CharacteristicAddress createEmptyInstance() => create();
  static $pb.PbList<CharacteristicAddress> createRepeated() =>
      $pb.PbList<CharacteristicAddress>();
  @$core.pragma('dart2js:noInline')
  static CharacteristicAddress getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CharacteristicAddress>(create);
  static CharacteristicAddress _defaultInstance;

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
  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo('ServiceDataEntry', createEmptyInstance: create)
        ..aOM<Uuid>(1, 'serviceUuid',
            protoName: 'serviceUuid', subBuilder: Uuid.create)
        ..a<$core.List<$core.int>>(2, 'data', $pb.PbFieldType.OY)
        ..hasRequiredFields = false;

  ServiceDataEntry._() : super();
  factory ServiceDataEntry() => create();
  factory ServiceDataEntry.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ServiceDataEntry.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  ServiceDataEntry clone() => ServiceDataEntry()..mergeFromMessage(this);
  ServiceDataEntry copyWith(void Function(ServiceDataEntry) updates) =>
      super.copyWith((message) => updates(message as ServiceDataEntry));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ServiceDataEntry create() => ServiceDataEntry._();
  ServiceDataEntry createEmptyInstance() => create();
  static $pb.PbList<ServiceDataEntry> createRepeated() =>
      $pb.PbList<ServiceDataEntry>();
  @$core.pragma('dart2js:noInline')
  static ServiceDataEntry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceDataEntry>(create);
  static ServiceDataEntry _defaultInstance;

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
      'ServicesWithCharacteristics',
      createEmptyInstance: create)
    ..pc<ServiceWithCharacteristics>(1, 'items', $pb.PbFieldType.PM,
        subBuilder: ServiceWithCharacteristics.create)
    ..hasRequiredFields = false;

  ServicesWithCharacteristics._() : super();
  factory ServicesWithCharacteristics() => create();
  factory ServicesWithCharacteristics.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ServicesWithCharacteristics.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  ServicesWithCharacteristics clone() =>
      ServicesWithCharacteristics()..mergeFromMessage(this);
  ServicesWithCharacteristics copyWith(
          void Function(ServicesWithCharacteristics) updates) =>
      super.copyWith(
          (message) => updates(message as ServicesWithCharacteristics));
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
  static ServicesWithCharacteristics _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<ServiceWithCharacteristics> get items => $_getList(0);
}

class ServiceWithCharacteristics extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      'ServiceWithCharacteristics',
      createEmptyInstance: create)
    ..aOM<Uuid>(1, 'serviceId', protoName: 'serviceId', subBuilder: Uuid.create)
    ..pc<Uuid>(2, 'characteristics', $pb.PbFieldType.PM,
        subBuilder: Uuid.create)
    ..hasRequiredFields = false;

  ServiceWithCharacteristics._() : super();
  factory ServiceWithCharacteristics() => create();
  factory ServiceWithCharacteristics.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ServiceWithCharacteristics.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  ServiceWithCharacteristics clone() =>
      ServiceWithCharacteristics()..mergeFromMessage(this);
  ServiceWithCharacteristics copyWith(
          void Function(ServiceWithCharacteristics) updates) =>
      super.copyWith(
          (message) => updates(message as ServiceWithCharacteristics));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ServiceWithCharacteristics create() => ServiceWithCharacteristics._();
  ServiceWithCharacteristics createEmptyInstance() => create();
  static $pb.PbList<ServiceWithCharacteristics> createRepeated() =>
      $pb.PbList<ServiceWithCharacteristics>();
  @$core.pragma('dart2js:noInline')
  static ServiceWithCharacteristics getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceWithCharacteristics>(create);
  static ServiceWithCharacteristics _defaultInstance;

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
  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo('DiscoverServicesRequest', createEmptyInstance: create)
        ..aOS(1, 'deviceId', protoName: 'deviceId')
        ..hasRequiredFields = false;

  DiscoverServicesRequest._() : super();
  factory DiscoverServicesRequest() => create();
  factory DiscoverServicesRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DiscoverServicesRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  DiscoverServicesRequest clone() =>
      DiscoverServicesRequest()..mergeFromMessage(this);
  DiscoverServicesRequest copyWith(
          void Function(DiscoverServicesRequest) updates) =>
      super.copyWith((message) => updates(message as DiscoverServicesRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DiscoverServicesRequest create() => DiscoverServicesRequest._();
  DiscoverServicesRequest createEmptyInstance() => create();
  static $pb.PbList<DiscoverServicesRequest> createRepeated() =>
      $pb.PbList<DiscoverServicesRequest>();
  @$core.pragma('dart2js:noInline')
  static DiscoverServicesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DiscoverServicesRequest>(create);
  static DiscoverServicesRequest _defaultInstance;

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
  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo('DiscoverServicesInfo', createEmptyInstance: create)
        ..aOS(1, 'deviceId', protoName: 'deviceId')
        ..pc<DiscoveredService>(2, 'services', $pb.PbFieldType.PM,
            subBuilder: DiscoveredService.create)
        ..hasRequiredFields = false;

  DiscoverServicesInfo._() : super();
  factory DiscoverServicesInfo() => create();
  factory DiscoverServicesInfo.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DiscoverServicesInfo.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  DiscoverServicesInfo clone() =>
      DiscoverServicesInfo()..mergeFromMessage(this);
  DiscoverServicesInfo copyWith(void Function(DiscoverServicesInfo) updates) =>
      super.copyWith((message) => updates(message as DiscoverServicesInfo));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DiscoverServicesInfo create() => DiscoverServicesInfo._();
  DiscoverServicesInfo createEmptyInstance() => create();
  static $pb.PbList<DiscoverServicesInfo> createRepeated() =>
      $pb.PbList<DiscoverServicesInfo>();
  @$core.pragma('dart2js:noInline')
  static DiscoverServicesInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DiscoverServicesInfo>(create);
  static DiscoverServicesInfo _defaultInstance;

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
  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo('DiscoveredService', createEmptyInstance: create)
        ..aOM<Uuid>(1, 'serviceUuid',
            protoName: 'serviceUuid', subBuilder: Uuid.create)
        ..pc<Uuid>(2, 'characteristicUuids', $pb.PbFieldType.PM,
            protoName: 'characteristicUuids', subBuilder: Uuid.create)
        ..pc<DiscoveredService>(3, 'includedServices', $pb.PbFieldType.PM,
            protoName: 'includedServices', subBuilder: DiscoveredService.create)
        ..hasRequiredFields = false;

  DiscoveredService._() : super();
  factory DiscoveredService() => create();
  factory DiscoveredService.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DiscoveredService.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  DiscoveredService clone() => DiscoveredService()..mergeFromMessage(this);
  DiscoveredService copyWith(void Function(DiscoveredService) updates) =>
      super.copyWith((message) => updates(message as DiscoveredService));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DiscoveredService create() => DiscoveredService._();
  DiscoveredService createEmptyInstance() => create();
  static $pb.PbList<DiscoveredService> createRepeated() =>
      $pb.PbList<DiscoveredService>();
  @$core.pragma('dart2js:noInline')
  static DiscoveredService getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DiscoveredService>(create);
  static DiscoveredService _defaultInstance;

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
}

class Uuid extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo('Uuid', createEmptyInstance: create)
        ..a<$core.List<$core.int>>(1, 'data', $pb.PbFieldType.OY)
        ..hasRequiredFields = false;

  Uuid._() : super();
  factory Uuid() => create();
  factory Uuid.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Uuid.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  Uuid clone() => Uuid()..mergeFromMessage(this);
  Uuid copyWith(void Function(Uuid) updates) =>
      super.copyWith((message) => updates(message as Uuid));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Uuid create() => Uuid._();
  Uuid createEmptyInstance() => create();
  static $pb.PbList<Uuid> createRepeated() => $pb.PbList<Uuid>();
  @$core.pragma('dart2js:noInline')
  static Uuid getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Uuid>(create);
  static Uuid _defaultInstance;

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
  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo('GenericFailure', createEmptyInstance: create)
        ..a<$core.int>(1, 'code', $pb.PbFieldType.O3)
        ..aOS(2, 'message')
        ..hasRequiredFields = false;

  GenericFailure._() : super();
  factory GenericFailure() => create();
  factory GenericFailure.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GenericFailure.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  GenericFailure clone() => GenericFailure()..mergeFromMessage(this);
  GenericFailure copyWith(void Function(GenericFailure) updates) =>
      super.copyWith((message) => updates(message as GenericFailure));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GenericFailure create() => GenericFailure._();
  GenericFailure createEmptyInstance() => create();
  static $pb.PbList<GenericFailure> createRepeated() =>
      $pb.PbList<GenericFailure>();
  @$core.pragma('dart2js:noInline')
  static GenericFailure getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GenericFailure>(create);
  static GenericFailure _defaultInstance;

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
