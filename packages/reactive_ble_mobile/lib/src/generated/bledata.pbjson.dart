//
//  Generated code. Do not modify.
//  source: bledata.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use launchCompanionRequestDescriptor instead')
const LaunchCompanionRequest$json = {
  '1': 'LaunchCompanionRequest',
  '2': [
    {'1': 'pattern', '3': 1, '4': 1, '5': 9, '10': 'pattern'},
    {'1': 'singleDeviceScan', '3': 2, '4': 1, '5': 8, '10': 'singleDeviceScan'},
    {'1': 'forceConfirmation', '3': 3, '4': 1, '5': 8, '10': 'forceConfirmation'},
  ],
};

/// Descriptor for `LaunchCompanionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List launchCompanionRequestDescriptor = $convert.base64Decode(
    'ChZMYXVuY2hDb21wYW5pb25SZXF1ZXN0EhgKB3BhdHRlcm4YASABKAlSB3BhdHRlcm4SKgoQc2'
    'luZ2xlRGV2aWNlU2NhbhgCIAEoCFIQc2luZ2xlRGV2aWNlU2NhbhIsChFmb3JjZUNvbmZpcm1h'
    'dGlvbhgDIAEoCFIRZm9yY2VDb25maXJtYXRpb24=');

@$core.Deprecated('Use associationInfoDescriptor instead')
const AssociationInfo$json = {
  '1': 'AssociationInfo',
  '2': [
    {'1': 'deviceMacAddress', '3': 1, '4': 1, '5': 9, '10': 'deviceMacAddress'},
  ],
};

/// Descriptor for `AssociationInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List associationInfoDescriptor = $convert.base64Decode(
    'Cg9Bc3NvY2lhdGlvbkluZm8SKgoQZGV2aWNlTWFjQWRkcmVzcxgBIAEoCVIQZGV2aWNlTWFjQW'
    'RkcmVzcw==');

@$core.Deprecated('Use scanForDevicesRequestDescriptor instead')
const ScanForDevicesRequest$json = {
  '1': 'ScanForDevicesRequest',
  '2': [
    {'1': 'serviceUuids', '3': 1, '4': 3, '5': 11, '6': '.Uuid', '10': 'serviceUuids'},
    {'1': 'scanMode', '3': 2, '4': 1, '5': 5, '10': 'scanMode'},
    {'1': 'requireLocationServicesEnabled', '3': 3, '4': 1, '5': 8, '10': 'requireLocationServicesEnabled'},
  ],
};

/// Descriptor for `ScanForDevicesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scanForDevicesRequestDescriptor = $convert.base64Decode(
    'ChVTY2FuRm9yRGV2aWNlc1JlcXVlc3QSKQoMc2VydmljZVV1aWRzGAEgAygLMgUuVXVpZFIMc2'
    'VydmljZVV1aWRzEhoKCHNjYW5Nb2RlGAIgASgFUghzY2FuTW9kZRJGCh5yZXF1aXJlTG9jYXRp'
    'b25TZXJ2aWNlc0VuYWJsZWQYAyABKAhSHnJlcXVpcmVMb2NhdGlvblNlcnZpY2VzRW5hYmxlZA'
    '==');

@$core.Deprecated('Use deviceScanInfoDescriptor instead')
const DeviceScanInfo$json = {
  '1': 'DeviceScanInfo',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'failure', '3': 3, '4': 1, '5': 11, '6': '.GenericFailure', '10': 'failure'},
    {'1': 'serviceData', '3': 4, '4': 3, '5': 11, '6': '.ServiceDataEntry', '10': 'serviceData'},
    {'1': 'manufacturerData', '3': 6, '4': 1, '5': 12, '10': 'manufacturerData'},
    {'1': 'serviceUuids', '3': 7, '4': 3, '5': 11, '6': '.Uuid', '10': 'serviceUuids'},
    {'1': 'rssi', '3': 5, '4': 1, '5': 5, '10': 'rssi'},
    {'1': 'isConnectable', '3': 8, '4': 1, '5': 11, '6': '.IsConnectable', '10': 'isConnectable'},
  ],
};

/// Descriptor for `DeviceScanInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceScanInfoDescriptor = $convert.base64Decode(
    'Cg5EZXZpY2VTY2FuSW5mbxIOCgJpZBgBIAEoCVICaWQSEgoEbmFtZRgCIAEoCVIEbmFtZRIpCg'
    'dmYWlsdXJlGAMgASgLMg8uR2VuZXJpY0ZhaWx1cmVSB2ZhaWx1cmUSMwoLc2VydmljZURhdGEY'
    'BCADKAsyES5TZXJ2aWNlRGF0YUVudHJ5UgtzZXJ2aWNlRGF0YRIqChBtYW51ZmFjdHVyZXJEYX'
    'RhGAYgASgMUhBtYW51ZmFjdHVyZXJEYXRhEikKDHNlcnZpY2VVdWlkcxgHIAMoCzIFLlV1aWRS'
    'DHNlcnZpY2VVdWlkcxISCgRyc3NpGAUgASgFUgRyc3NpEjQKDWlzQ29ubmVjdGFibGUYCCABKA'
    'syDi5Jc0Nvbm5lY3RhYmxlUg1pc0Nvbm5lY3RhYmxl');

@$core.Deprecated('Use establishBondRequestDescriptor instead')
const EstablishBondRequest$json = {
  '1': 'EstablishBondRequest',
  '2': [
    {'1': 'deviceId', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
  ],
};

/// Descriptor for `EstablishBondRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List establishBondRequestDescriptor = $convert.base64Decode(
    'ChRFc3RhYmxpc2hCb25kUmVxdWVzdBIaCghkZXZpY2VJZBgBIAEoCVIIZGV2aWNlSWQ=');

@$core.Deprecated('Use establishBondInfoDescriptor instead')
const EstablishBondInfo$json = {
  '1': 'EstablishBondInfo',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 14, '6': '.EstablishBondInfo.BondState', '10': 'status'},
  ],
  '4': [EstablishBondInfo_BondState$json],
};

@$core.Deprecated('Use establishBondInfoDescriptor instead')
const EstablishBondInfo_BondState$json = {
  '1': 'BondState',
  '2': [
    {'1': 'BOND_BONDING', '2': 0},
    {'1': 'BOND_BONDED', '2': 1},
    {'1': 'BOND_NONE', '2': 2},
  ],
};

/// Descriptor for `EstablishBondInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List establishBondInfoDescriptor = $convert.base64Decode(
    'ChFFc3RhYmxpc2hCb25kSW5mbxI0CgZzdGF0dXMYASABKA4yHC5Fc3RhYmxpc2hCb25kSW5mby'
    '5Cb25kU3RhdGVSBnN0YXR1cyI9CglCb25kU3RhdGUSEAoMQk9ORF9CT05ESU5HEAASDwoLQk9O'
    'RF9CT05ERUQQARINCglCT05EX05PTkUQAg==');

@$core.Deprecated('Use connectToDeviceRequestDescriptor instead')
const ConnectToDeviceRequest$json = {
  '1': 'ConnectToDeviceRequest',
  '2': [
    {'1': 'deviceId', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'servicesWithCharacteristicsToDiscover', '3': 2, '4': 1, '5': 11, '6': '.ServicesWithCharacteristics', '10': 'servicesWithCharacteristicsToDiscover'},
    {'1': 'timeoutInMs', '3': 3, '4': 1, '5': 5, '10': 'timeoutInMs'},
  ],
};

/// Descriptor for `ConnectToDeviceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectToDeviceRequestDescriptor = $convert.base64Decode(
    'ChZDb25uZWN0VG9EZXZpY2VSZXF1ZXN0EhoKCGRldmljZUlkGAEgASgJUghkZXZpY2VJZBJyCi'
    'VzZXJ2aWNlc1dpdGhDaGFyYWN0ZXJpc3RpY3NUb0Rpc2NvdmVyGAIgASgLMhwuU2VydmljZXNX'
    'aXRoQ2hhcmFjdGVyaXN0aWNzUiVzZXJ2aWNlc1dpdGhDaGFyYWN0ZXJpc3RpY3NUb0Rpc2Nvdm'
    'VyEiAKC3RpbWVvdXRJbk1zGAMgASgFUgt0aW1lb3V0SW5Ncw==');

@$core.Deprecated('Use deviceInfoDescriptor instead')
const DeviceInfo$json = {
  '1': 'DeviceInfo',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'connectionState', '3': 2, '4': 1, '5': 5, '10': 'connectionState'},
    {'1': 'failure', '3': 3, '4': 1, '5': 11, '6': '.GenericFailure', '10': 'failure'},
  ],
};

/// Descriptor for `DeviceInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceInfoDescriptor = $convert.base64Decode(
    'CgpEZXZpY2VJbmZvEg4KAmlkGAEgASgJUgJpZBIoCg9jb25uZWN0aW9uU3RhdGUYAiABKAVSD2'
    'Nvbm5lY3Rpb25TdGF0ZRIpCgdmYWlsdXJlGAMgASgLMg8uR2VuZXJpY0ZhaWx1cmVSB2ZhaWx1'
    'cmU=');

@$core.Deprecated('Use getDeviceNameRequestDescriptor instead')
const GetDeviceNameRequest$json = {
  '1': 'GetDeviceNameRequest',
  '2': [
    {'1': 'deviceId', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
  ],
};

/// Descriptor for `GetDeviceNameRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDeviceNameRequestDescriptor = $convert.base64Decode(
    'ChRHZXREZXZpY2VOYW1lUmVxdWVzdBIaCghkZXZpY2VJZBgBIAEoCVIIZGV2aWNlSWQ=');

@$core.Deprecated('Use deviceNameInfoDescriptor instead')
const DeviceNameInfo$json = {
  '1': 'DeviceNameInfo',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'deviceName', '3': 2, '4': 1, '5': 9, '10': 'deviceName'},
  ],
};

/// Descriptor for `DeviceNameInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceNameInfoDescriptor = $convert.base64Decode(
    'Cg5EZXZpY2VOYW1lSW5mbxIOCgJpZBgBIAEoCVICaWQSHgoKZGV2aWNlTmFtZRgCIAEoCVIKZG'
    'V2aWNlTmFtZQ==');

@$core.Deprecated('Use disconnectFromDeviceRequestDescriptor instead')
const DisconnectFromDeviceRequest$json = {
  '1': 'DisconnectFromDeviceRequest',
  '2': [
    {'1': 'deviceId', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
  ],
};

/// Descriptor for `DisconnectFromDeviceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List disconnectFromDeviceRequestDescriptor = $convert.base64Decode(
    'ChtEaXNjb25uZWN0RnJvbURldmljZVJlcXVlc3QSGgoIZGV2aWNlSWQYASABKAlSCGRldmljZU'
    'lk');

@$core.Deprecated('Use clearGattCacheRequestDescriptor instead')
const ClearGattCacheRequest$json = {
  '1': 'ClearGattCacheRequest',
  '2': [
    {'1': 'deviceId', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
  ],
};

/// Descriptor for `ClearGattCacheRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clearGattCacheRequestDescriptor = $convert.base64Decode(
    'ChVDbGVhckdhdHRDYWNoZVJlcXVlc3QSGgoIZGV2aWNlSWQYASABKAlSCGRldmljZUlk');

@$core.Deprecated('Use clearGattCacheInfoDescriptor instead')
const ClearGattCacheInfo$json = {
  '1': 'ClearGattCacheInfo',
  '2': [
    {'1': 'failure', '3': 1, '4': 1, '5': 11, '6': '.GenericFailure', '10': 'failure'},
  ],
};

/// Descriptor for `ClearGattCacheInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clearGattCacheInfoDescriptor = $convert.base64Decode(
    'ChJDbGVhckdhdHRDYWNoZUluZm8SKQoHZmFpbHVyZRgBIAEoCzIPLkdlbmVyaWNGYWlsdXJlUg'
    'dmYWlsdXJl');

@$core.Deprecated('Use notifyCharacteristicRequestDescriptor instead')
const NotifyCharacteristicRequest$json = {
  '1': 'NotifyCharacteristicRequest',
  '2': [
    {'1': 'characteristic', '3': 1, '4': 1, '5': 11, '6': '.CharacteristicAddress', '10': 'characteristic'},
  ],
};

/// Descriptor for `NotifyCharacteristicRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notifyCharacteristicRequestDescriptor = $convert.base64Decode(
    'ChtOb3RpZnlDaGFyYWN0ZXJpc3RpY1JlcXVlc3QSPgoOY2hhcmFjdGVyaXN0aWMYASABKAsyFi'
    '5DaGFyYWN0ZXJpc3RpY0FkZHJlc3NSDmNoYXJhY3RlcmlzdGlj');

@$core.Deprecated('Use notifyNoMoreCharacteristicRequestDescriptor instead')
const NotifyNoMoreCharacteristicRequest$json = {
  '1': 'NotifyNoMoreCharacteristicRequest',
  '2': [
    {'1': 'characteristic', '3': 1, '4': 1, '5': 11, '6': '.CharacteristicAddress', '10': 'characteristic'},
  ],
};

/// Descriptor for `NotifyNoMoreCharacteristicRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notifyNoMoreCharacteristicRequestDescriptor = $convert.base64Decode(
    'CiFOb3RpZnlOb01vcmVDaGFyYWN0ZXJpc3RpY1JlcXVlc3QSPgoOY2hhcmFjdGVyaXN0aWMYAS'
    'ABKAsyFi5DaGFyYWN0ZXJpc3RpY0FkZHJlc3NSDmNoYXJhY3RlcmlzdGlj');

@$core.Deprecated('Use readCharacteristicRequestDescriptor instead')
const ReadCharacteristicRequest$json = {
  '1': 'ReadCharacteristicRequest',
  '2': [
    {'1': 'characteristic', '3': 1, '4': 1, '5': 11, '6': '.CharacteristicAddress', '10': 'characteristic'},
  ],
};

/// Descriptor for `ReadCharacteristicRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List readCharacteristicRequestDescriptor = $convert.base64Decode(
    'ChlSZWFkQ2hhcmFjdGVyaXN0aWNSZXF1ZXN0Ej4KDmNoYXJhY3RlcmlzdGljGAEgASgLMhYuQ2'
    'hhcmFjdGVyaXN0aWNBZGRyZXNzUg5jaGFyYWN0ZXJpc3RpYw==');

@$core.Deprecated('Use characteristicValueInfoDescriptor instead')
const CharacteristicValueInfo$json = {
  '1': 'CharacteristicValueInfo',
  '2': [
    {'1': 'characteristic', '3': 1, '4': 1, '5': 11, '6': '.CharacteristicAddress', '10': 'characteristic'},
    {'1': 'value', '3': 2, '4': 1, '5': 12, '10': 'value'},
    {'1': 'failure', '3': 3, '4': 1, '5': 11, '6': '.GenericFailure', '10': 'failure'},
  ],
};

/// Descriptor for `CharacteristicValueInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List characteristicValueInfoDescriptor = $convert.base64Decode(
    'ChdDaGFyYWN0ZXJpc3RpY1ZhbHVlSW5mbxI+Cg5jaGFyYWN0ZXJpc3RpYxgBIAEoCzIWLkNoYX'
    'JhY3RlcmlzdGljQWRkcmVzc1IOY2hhcmFjdGVyaXN0aWMSFAoFdmFsdWUYAiABKAxSBXZhbHVl'
    'EikKB2ZhaWx1cmUYAyABKAsyDy5HZW5lcmljRmFpbHVyZVIHZmFpbHVyZQ==');

@$core.Deprecated('Use writeCharacteristicRequestDescriptor instead')
const WriteCharacteristicRequest$json = {
  '1': 'WriteCharacteristicRequest',
  '2': [
    {'1': 'characteristic', '3': 1, '4': 1, '5': 11, '6': '.CharacteristicAddress', '10': 'characteristic'},
    {'1': 'value', '3': 2, '4': 1, '5': 12, '10': 'value'},
  ],
};

/// Descriptor for `WriteCharacteristicRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List writeCharacteristicRequestDescriptor = $convert.base64Decode(
    'ChpXcml0ZUNoYXJhY3RlcmlzdGljUmVxdWVzdBI+Cg5jaGFyYWN0ZXJpc3RpYxgBIAEoCzIWLk'
    'NoYXJhY3RlcmlzdGljQWRkcmVzc1IOY2hhcmFjdGVyaXN0aWMSFAoFdmFsdWUYAiABKAxSBXZh'
    'bHVl');

@$core.Deprecated('Use writeCharacteristicInfoDescriptor instead')
const WriteCharacteristicInfo$json = {
  '1': 'WriteCharacteristicInfo',
  '2': [
    {'1': 'characteristic', '3': 1, '4': 1, '5': 11, '6': '.CharacteristicAddress', '10': 'characteristic'},
    {'1': 'failure', '3': 3, '4': 1, '5': 11, '6': '.GenericFailure', '10': 'failure'},
  ],
};

/// Descriptor for `WriteCharacteristicInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List writeCharacteristicInfoDescriptor = $convert.base64Decode(
    'ChdXcml0ZUNoYXJhY3RlcmlzdGljSW5mbxI+Cg5jaGFyYWN0ZXJpc3RpYxgBIAEoCzIWLkNoYX'
    'JhY3RlcmlzdGljQWRkcmVzc1IOY2hhcmFjdGVyaXN0aWMSKQoHZmFpbHVyZRgDIAEoCzIPLkdl'
    'bmVyaWNGYWlsdXJlUgdmYWlsdXJl');

@$core.Deprecated('Use negotiateMtuRequestDescriptor instead')
const NegotiateMtuRequest$json = {
  '1': 'NegotiateMtuRequest',
  '2': [
    {'1': 'deviceId', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'mtuSize', '3': 2, '4': 1, '5': 5, '10': 'mtuSize'},
  ],
};

/// Descriptor for `NegotiateMtuRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List negotiateMtuRequestDescriptor = $convert.base64Decode(
    'ChNOZWdvdGlhdGVNdHVSZXF1ZXN0EhoKCGRldmljZUlkGAEgASgJUghkZXZpY2VJZBIYCgdtdH'
    'VTaXplGAIgASgFUgdtdHVTaXpl');

@$core.Deprecated('Use negotiateMtuInfoDescriptor instead')
const NegotiateMtuInfo$json = {
  '1': 'NegotiateMtuInfo',
  '2': [
    {'1': 'deviceId', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'mtuSize', '3': 2, '4': 1, '5': 5, '10': 'mtuSize'},
    {'1': 'failure', '3': 3, '4': 1, '5': 11, '6': '.GenericFailure', '10': 'failure'},
  ],
};

/// Descriptor for `NegotiateMtuInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List negotiateMtuInfoDescriptor = $convert.base64Decode(
    'ChBOZWdvdGlhdGVNdHVJbmZvEhoKCGRldmljZUlkGAEgASgJUghkZXZpY2VJZBIYCgdtdHVTaX'
    'plGAIgASgFUgdtdHVTaXplEikKB2ZhaWx1cmUYAyABKAsyDy5HZW5lcmljRmFpbHVyZVIHZmFp'
    'bHVyZQ==');

@$core.Deprecated('Use bleStatusInfoDescriptor instead')
const BleStatusInfo$json = {
  '1': 'BleStatusInfo',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 5, '10': 'status'},
  ],
};

/// Descriptor for `BleStatusInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bleStatusInfoDescriptor = $convert.base64Decode(
    'Cg1CbGVTdGF0dXNJbmZvEhYKBnN0YXR1cxgBIAEoBVIGc3RhdHVz');

@$core.Deprecated('Use changeConnectionPriorityRequestDescriptor instead')
const ChangeConnectionPriorityRequest$json = {
  '1': 'ChangeConnectionPriorityRequest',
  '2': [
    {'1': 'deviceId', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'priority', '3': 2, '4': 1, '5': 5, '10': 'priority'},
  ],
};

/// Descriptor for `ChangeConnectionPriorityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changeConnectionPriorityRequestDescriptor = $convert.base64Decode(
    'Ch9DaGFuZ2VDb25uZWN0aW9uUHJpb3JpdHlSZXF1ZXN0EhoKCGRldmljZUlkGAEgASgJUghkZX'
    'ZpY2VJZBIaCghwcmlvcml0eRgCIAEoBVIIcHJpb3JpdHk=');

@$core.Deprecated('Use changeConnectionPriorityInfoDescriptor instead')
const ChangeConnectionPriorityInfo$json = {
  '1': 'ChangeConnectionPriorityInfo',
  '2': [
    {'1': 'deviceId', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'failure', '3': 2, '4': 1, '5': 11, '6': '.GenericFailure', '10': 'failure'},
  ],
};

/// Descriptor for `ChangeConnectionPriorityInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changeConnectionPriorityInfoDescriptor = $convert.base64Decode(
    'ChxDaGFuZ2VDb25uZWN0aW9uUHJpb3JpdHlJbmZvEhoKCGRldmljZUlkGAEgASgJUghkZXZpY2'
    'VJZBIpCgdmYWlsdXJlGAIgASgLMg8uR2VuZXJpY0ZhaWx1cmVSB2ZhaWx1cmU=');

@$core.Deprecated('Use characteristicAddressDescriptor instead')
const CharacteristicAddress$json = {
  '1': 'CharacteristicAddress',
  '2': [
    {'1': 'deviceId', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'serviceUuid', '3': 2, '4': 1, '5': 11, '6': '.Uuid', '10': 'serviceUuid'},
    {'1': 'characteristicUuid', '3': 3, '4': 1, '5': 11, '6': '.Uuid', '10': 'characteristicUuid'},
  ],
};

/// Descriptor for `CharacteristicAddress`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List characteristicAddressDescriptor = $convert.base64Decode(
    'ChVDaGFyYWN0ZXJpc3RpY0FkZHJlc3MSGgoIZGV2aWNlSWQYASABKAlSCGRldmljZUlkEicKC3'
    'NlcnZpY2VVdWlkGAIgASgLMgUuVXVpZFILc2VydmljZVV1aWQSNQoSY2hhcmFjdGVyaXN0aWNV'
    'dWlkGAMgASgLMgUuVXVpZFISY2hhcmFjdGVyaXN0aWNVdWlk');

@$core.Deprecated('Use serviceDataEntryDescriptor instead')
const ServiceDataEntry$json = {
  '1': 'ServiceDataEntry',
  '2': [
    {'1': 'serviceUuid', '3': 1, '4': 1, '5': 11, '6': '.Uuid', '10': 'serviceUuid'},
    {'1': 'data', '3': 2, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `ServiceDataEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceDataEntryDescriptor = $convert.base64Decode(
    'ChBTZXJ2aWNlRGF0YUVudHJ5EicKC3NlcnZpY2VVdWlkGAEgASgLMgUuVXVpZFILc2VydmljZV'
    'V1aWQSEgoEZGF0YRgCIAEoDFIEZGF0YQ==');

@$core.Deprecated('Use servicesWithCharacteristicsDescriptor instead')
const ServicesWithCharacteristics$json = {
  '1': 'ServicesWithCharacteristics',
  '2': [
    {'1': 'items', '3': 1, '4': 3, '5': 11, '6': '.ServiceWithCharacteristics', '10': 'items'},
  ],
};

/// Descriptor for `ServicesWithCharacteristics`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List servicesWithCharacteristicsDescriptor = $convert.base64Decode(
    'ChtTZXJ2aWNlc1dpdGhDaGFyYWN0ZXJpc3RpY3MSMQoFaXRlbXMYASADKAsyGy5TZXJ2aWNlV2'
    'l0aENoYXJhY3RlcmlzdGljc1IFaXRlbXM=');

@$core.Deprecated('Use serviceWithCharacteristicsDescriptor instead')
const ServiceWithCharacteristics$json = {
  '1': 'ServiceWithCharacteristics',
  '2': [
    {'1': 'serviceId', '3': 1, '4': 1, '5': 11, '6': '.Uuid', '10': 'serviceId'},
    {'1': 'characteristics', '3': 2, '4': 3, '5': 11, '6': '.Uuid', '10': 'characteristics'},
  ],
};

/// Descriptor for `ServiceWithCharacteristics`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceWithCharacteristicsDescriptor = $convert.base64Decode(
    'ChpTZXJ2aWNlV2l0aENoYXJhY3RlcmlzdGljcxIjCglzZXJ2aWNlSWQYASABKAsyBS5VdWlkUg'
    'lzZXJ2aWNlSWQSLwoPY2hhcmFjdGVyaXN0aWNzGAIgAygLMgUuVXVpZFIPY2hhcmFjdGVyaXN0'
    'aWNz');

@$core.Deprecated('Use discoverServicesRequestDescriptor instead')
const DiscoverServicesRequest$json = {
  '1': 'DiscoverServicesRequest',
  '2': [
    {'1': 'deviceId', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
  ],
};

/// Descriptor for `DiscoverServicesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List discoverServicesRequestDescriptor = $convert.base64Decode(
    'ChdEaXNjb3ZlclNlcnZpY2VzUmVxdWVzdBIaCghkZXZpY2VJZBgBIAEoCVIIZGV2aWNlSWQ=');

@$core.Deprecated('Use discoverServicesInfoDescriptor instead')
const DiscoverServicesInfo$json = {
  '1': 'DiscoverServicesInfo',
  '2': [
    {'1': 'deviceId', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'services', '3': 2, '4': 3, '5': 11, '6': '.DiscoveredService', '10': 'services'},
  ],
};

/// Descriptor for `DiscoverServicesInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List discoverServicesInfoDescriptor = $convert.base64Decode(
    'ChREaXNjb3ZlclNlcnZpY2VzSW5mbxIaCghkZXZpY2VJZBgBIAEoCVIIZGV2aWNlSWQSLgoIc2'
    'VydmljZXMYAiADKAsyEi5EaXNjb3ZlcmVkU2VydmljZVIIc2VydmljZXM=');

@$core.Deprecated('Use discoveredServiceDescriptor instead')
const DiscoveredService$json = {
  '1': 'DiscoveredService',
  '2': [
    {'1': 'serviceUuid', '3': 1, '4': 1, '5': 11, '6': '.Uuid', '10': 'serviceUuid'},
    {'1': 'characteristicUuids', '3': 2, '4': 3, '5': 11, '6': '.Uuid', '10': 'characteristicUuids'},
    {'1': 'includedServices', '3': 3, '4': 3, '5': 11, '6': '.DiscoveredService', '10': 'includedServices'},
    {'1': 'characteristics', '3': 4, '4': 3, '5': 11, '6': '.DiscoveredCharacteristic', '10': 'characteristics'},
  ],
};

/// Descriptor for `DiscoveredService`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List discoveredServiceDescriptor = $convert.base64Decode(
    'ChFEaXNjb3ZlcmVkU2VydmljZRInCgtzZXJ2aWNlVXVpZBgBIAEoCzIFLlV1aWRSC3NlcnZpY2'
    'VVdWlkEjcKE2NoYXJhY3RlcmlzdGljVXVpZHMYAiADKAsyBS5VdWlkUhNjaGFyYWN0ZXJpc3Rp'
    'Y1V1aWRzEj4KEGluY2x1ZGVkU2VydmljZXMYAyADKAsyEi5EaXNjb3ZlcmVkU2VydmljZVIQaW'
    '5jbHVkZWRTZXJ2aWNlcxJDCg9jaGFyYWN0ZXJpc3RpY3MYBCADKAsyGS5EaXNjb3ZlcmVkQ2hh'
    'cmFjdGVyaXN0aWNSD2NoYXJhY3RlcmlzdGljcw==');

@$core.Deprecated('Use discoveredCharacteristicDescriptor instead')
const DiscoveredCharacteristic$json = {
  '1': 'DiscoveredCharacteristic',
  '2': [
    {'1': 'characteristicId', '3': 1, '4': 1, '5': 11, '6': '.Uuid', '10': 'characteristicId'},
    {'1': 'serviceId', '3': 2, '4': 1, '5': 11, '6': '.Uuid', '10': 'serviceId'},
    {'1': 'isReadable', '3': 3, '4': 1, '5': 8, '10': 'isReadable'},
    {'1': 'isWritableWithResponse', '3': 4, '4': 1, '5': 8, '10': 'isWritableWithResponse'},
    {'1': 'isWritableWithoutResponse', '3': 5, '4': 1, '5': 8, '10': 'isWritableWithoutResponse'},
    {'1': 'isNotifiable', '3': 6, '4': 1, '5': 8, '10': 'isNotifiable'},
    {'1': 'isIndicatable', '3': 7, '4': 1, '5': 8, '10': 'isIndicatable'},
  ],
};

/// Descriptor for `DiscoveredCharacteristic`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List discoveredCharacteristicDescriptor = $convert.base64Decode(
    'ChhEaXNjb3ZlcmVkQ2hhcmFjdGVyaXN0aWMSMQoQY2hhcmFjdGVyaXN0aWNJZBgBIAEoCzIFLl'
    'V1aWRSEGNoYXJhY3RlcmlzdGljSWQSIwoJc2VydmljZUlkGAIgASgLMgUuVXVpZFIJc2Vydmlj'
    'ZUlkEh4KCmlzUmVhZGFibGUYAyABKAhSCmlzUmVhZGFibGUSNgoWaXNXcml0YWJsZVdpdGhSZX'
    'Nwb25zZRgEIAEoCFIWaXNXcml0YWJsZVdpdGhSZXNwb25zZRI8Chlpc1dyaXRhYmxlV2l0aG91'
    'dFJlc3BvbnNlGAUgASgIUhlpc1dyaXRhYmxlV2l0aG91dFJlc3BvbnNlEiIKDGlzTm90aWZpYW'
    'JsZRgGIAEoCFIMaXNOb3RpZmlhYmxlEiQKDWlzSW5kaWNhdGFibGUYByABKAhSDWlzSW5kaWNh'
    'dGFibGU=');

@$core.Deprecated('Use uuidDescriptor instead')
const Uuid$json = {
  '1': 'Uuid',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `Uuid`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uuidDescriptor = $convert.base64Decode(
    'CgRVdWlkEhIKBGRhdGEYASABKAxSBGRhdGE=');

@$core.Deprecated('Use genericFailureDescriptor instead')
const GenericFailure$json = {
  '1': 'GenericFailure',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 5, '10': 'code'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `GenericFailure`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List genericFailureDescriptor = $convert.base64Decode(
    'Cg5HZW5lcmljRmFpbHVyZRISCgRjb2RlGAEgASgFUgRjb2RlEhgKB21lc3NhZ2UYAiABKAlSB2'
    '1lc3NhZ2U=');

@$core.Deprecated('Use isConnectableDescriptor instead')
const IsConnectable$json = {
  '1': 'IsConnectable',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 5, '10': 'code'},
  ],
};

/// Descriptor for `IsConnectable`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List isConnectableDescriptor = $convert.base64Decode(
    'Cg1Jc0Nvbm5lY3RhYmxlEhIKBGNvZGUYASABKAVSBGNvZGU=');

