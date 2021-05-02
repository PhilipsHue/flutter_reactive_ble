///
//  Generated code. Do not modify.
//  source: bledata.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use scanForDevicesRequestDescriptor instead')
const ScanForDevicesRequest$json = const {
  '1': 'ScanForDevicesRequest',
  '2': const [
    const {'1': 'serviceUuids', '3': 1, '4': 3, '5': 11, '6': '.Uuid', '10': 'serviceUuids'},
    const {'1': 'scanMode', '3': 2, '4': 1, '5': 5, '10': 'scanMode'},
    const {'1': 'requireLocationServicesEnabled', '3': 3, '4': 1, '5': 8, '10': 'requireLocationServicesEnabled'},
  ],
};

/// Descriptor for `ScanForDevicesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scanForDevicesRequestDescriptor = $convert.base64Decode('ChVTY2FuRm9yRGV2aWNlc1JlcXVlc3QSKQoMc2VydmljZVV1aWRzGAEgAygLMgUuVXVpZFIMc2VydmljZVV1aWRzEhoKCHNjYW5Nb2RlGAIgASgFUghzY2FuTW9kZRJGCh5yZXF1aXJlTG9jYXRpb25TZXJ2aWNlc0VuYWJsZWQYAyABKAhSHnJlcXVpcmVMb2NhdGlvblNlcnZpY2VzRW5hYmxlZA==');
@$core.Deprecated('Use deviceScanInfoDescriptor instead')
const DeviceScanInfo$json = const {
  '1': 'DeviceScanInfo',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'failure', '3': 3, '4': 1, '5': 11, '6': '.GenericFailure', '10': 'failure'},
    const {'1': 'serviceData', '3': 4, '4': 3, '5': 11, '6': '.ServiceDataEntry', '10': 'serviceData'},
    const {'1': 'manufacturerData', '3': 6, '4': 1, '5': 12, '10': 'manufacturerData'},
    const {'1': 'serviceUuids', '3': 7, '4': 3, '5': 11, '6': '.Uuid', '10': 'serviceUuids'},
    const {'1': 'rssi', '3': 5, '4': 1, '5': 5, '10': 'rssi'},
  ],
};

/// Descriptor for `DeviceScanInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceScanInfoDescriptor = $convert.base64Decode('Cg5EZXZpY2VTY2FuSW5mbxIOCgJpZBgBIAEoCVICaWQSEgoEbmFtZRgCIAEoCVIEbmFtZRIpCgdmYWlsdXJlGAMgASgLMg8uR2VuZXJpY0ZhaWx1cmVSB2ZhaWx1cmUSMwoLc2VydmljZURhdGEYBCADKAsyES5TZXJ2aWNlRGF0YUVudHJ5UgtzZXJ2aWNlRGF0YRIqChBtYW51ZmFjdHVyZXJEYXRhGAYgASgMUhBtYW51ZmFjdHVyZXJEYXRhEikKDHNlcnZpY2VVdWlkcxgHIAMoCzIFLlV1aWRSDHNlcnZpY2VVdWlkcxISCgRyc3NpGAUgASgFUgRyc3Np');
@$core.Deprecated('Use connectToDeviceRequestDescriptor instead')
const ConnectToDeviceRequest$json = const {
  '1': 'ConnectToDeviceRequest',
  '2': const [
    const {'1': 'deviceId', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    const {'1': 'servicesWithCharacteristicsToDiscover', '3': 2, '4': 1, '5': 11, '6': '.ServicesWithCharacteristics', '10': 'servicesWithCharacteristicsToDiscover'},
    const {'1': 'timeoutInMs', '3': 3, '4': 1, '5': 5, '10': 'timeoutInMs'},
  ],
};

/// Descriptor for `ConnectToDeviceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectToDeviceRequestDescriptor = $convert.base64Decode('ChZDb25uZWN0VG9EZXZpY2VSZXF1ZXN0EhoKCGRldmljZUlkGAEgASgJUghkZXZpY2VJZBJyCiVzZXJ2aWNlc1dpdGhDaGFyYWN0ZXJpc3RpY3NUb0Rpc2NvdmVyGAIgASgLMhwuU2VydmljZXNXaXRoQ2hhcmFjdGVyaXN0aWNzUiVzZXJ2aWNlc1dpdGhDaGFyYWN0ZXJpc3RpY3NUb0Rpc2NvdmVyEiAKC3RpbWVvdXRJbk1zGAMgASgFUgt0aW1lb3V0SW5Ncw==');
@$core.Deprecated('Use deviceInfoDescriptor instead')
const DeviceInfo$json = const {
  '1': 'DeviceInfo',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'connectionState', '3': 2, '4': 1, '5': 5, '10': 'connectionState'},
    const {'1': 'failure', '3': 3, '4': 1, '5': 11, '6': '.GenericFailure', '10': 'failure'},
  ],
};

/// Descriptor for `DeviceInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceInfoDescriptor = $convert.base64Decode('CgpEZXZpY2VJbmZvEg4KAmlkGAEgASgJUgJpZBIoCg9jb25uZWN0aW9uU3RhdGUYAiABKAVSD2Nvbm5lY3Rpb25TdGF0ZRIpCgdmYWlsdXJlGAMgASgLMg8uR2VuZXJpY0ZhaWx1cmVSB2ZhaWx1cmU=');
@$core.Deprecated('Use disconnectFromDeviceRequestDescriptor instead')
const DisconnectFromDeviceRequest$json = const {
  '1': 'DisconnectFromDeviceRequest',
  '2': const [
    const {'1': 'deviceId', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
  ],
};

/// Descriptor for `DisconnectFromDeviceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List disconnectFromDeviceRequestDescriptor = $convert.base64Decode('ChtEaXNjb25uZWN0RnJvbURldmljZVJlcXVlc3QSGgoIZGV2aWNlSWQYASABKAlSCGRldmljZUlk');
@$core.Deprecated('Use clearGattCacheRequestDescriptor instead')
const ClearGattCacheRequest$json = const {
  '1': 'ClearGattCacheRequest',
  '2': const [
    const {'1': 'deviceId', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
  ],
};

/// Descriptor for `ClearGattCacheRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clearGattCacheRequestDescriptor = $convert.base64Decode('ChVDbGVhckdhdHRDYWNoZVJlcXVlc3QSGgoIZGV2aWNlSWQYASABKAlSCGRldmljZUlk');
@$core.Deprecated('Use clearGattCacheInfoDescriptor instead')
const ClearGattCacheInfo$json = const {
  '1': 'ClearGattCacheInfo',
  '2': const [
    const {'1': 'failure', '3': 1, '4': 1, '5': 11, '6': '.GenericFailure', '10': 'failure'},
  ],
};

/// Descriptor for `ClearGattCacheInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clearGattCacheInfoDescriptor = $convert.base64Decode('ChJDbGVhckdhdHRDYWNoZUluZm8SKQoHZmFpbHVyZRgBIAEoCzIPLkdlbmVyaWNGYWlsdXJlUgdmYWlsdXJl');
@$core.Deprecated('Use notifyCharacteristicRequestDescriptor instead')
const NotifyCharacteristicRequest$json = const {
  '1': 'NotifyCharacteristicRequest',
  '2': const [
    const {'1': 'characteristic', '3': 1, '4': 1, '5': 11, '6': '.CharacteristicAddress', '10': 'characteristic'},
  ],
};

/// Descriptor for `NotifyCharacteristicRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notifyCharacteristicRequestDescriptor = $convert.base64Decode('ChtOb3RpZnlDaGFyYWN0ZXJpc3RpY1JlcXVlc3QSPgoOY2hhcmFjdGVyaXN0aWMYASABKAsyFi5DaGFyYWN0ZXJpc3RpY0FkZHJlc3NSDmNoYXJhY3RlcmlzdGlj');
@$core.Deprecated('Use notifyNoMoreCharacteristicRequestDescriptor instead')
const NotifyNoMoreCharacteristicRequest$json = const {
  '1': 'NotifyNoMoreCharacteristicRequest',
  '2': const [
    const {'1': 'characteristic', '3': 1, '4': 1, '5': 11, '6': '.CharacteristicAddress', '10': 'characteristic'},
  ],
};

/// Descriptor for `NotifyNoMoreCharacteristicRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notifyNoMoreCharacteristicRequestDescriptor = $convert.base64Decode('CiFOb3RpZnlOb01vcmVDaGFyYWN0ZXJpc3RpY1JlcXVlc3QSPgoOY2hhcmFjdGVyaXN0aWMYASABKAsyFi5DaGFyYWN0ZXJpc3RpY0FkZHJlc3NSDmNoYXJhY3RlcmlzdGlj');
@$core.Deprecated('Use readCharacteristicRequestDescriptor instead')
const ReadCharacteristicRequest$json = const {
  '1': 'ReadCharacteristicRequest',
  '2': const [
    const {'1': 'characteristic', '3': 1, '4': 1, '5': 11, '6': '.CharacteristicAddress', '10': 'characteristic'},
  ],
};

/// Descriptor for `ReadCharacteristicRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List readCharacteristicRequestDescriptor = $convert.base64Decode('ChlSZWFkQ2hhcmFjdGVyaXN0aWNSZXF1ZXN0Ej4KDmNoYXJhY3RlcmlzdGljGAEgASgLMhYuQ2hhcmFjdGVyaXN0aWNBZGRyZXNzUg5jaGFyYWN0ZXJpc3RpYw==');
@$core.Deprecated('Use characteristicValueInfoDescriptor instead')
const CharacteristicValueInfo$json = const {
  '1': 'CharacteristicValueInfo',
  '2': const [
    const {'1': 'characteristic', '3': 1, '4': 1, '5': 11, '6': '.CharacteristicAddress', '10': 'characteristic'},
    const {'1': 'value', '3': 2, '4': 1, '5': 12, '10': 'value'},
    const {'1': 'failure', '3': 3, '4': 1, '5': 11, '6': '.GenericFailure', '10': 'failure'},
  ],
};

/// Descriptor for `CharacteristicValueInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List characteristicValueInfoDescriptor = $convert.base64Decode('ChdDaGFyYWN0ZXJpc3RpY1ZhbHVlSW5mbxI+Cg5jaGFyYWN0ZXJpc3RpYxgBIAEoCzIWLkNoYXJhY3RlcmlzdGljQWRkcmVzc1IOY2hhcmFjdGVyaXN0aWMSFAoFdmFsdWUYAiABKAxSBXZhbHVlEikKB2ZhaWx1cmUYAyABKAsyDy5HZW5lcmljRmFpbHVyZVIHZmFpbHVyZQ==');
@$core.Deprecated('Use writeCharacteristicRequestDescriptor instead')
const WriteCharacteristicRequest$json = const {
  '1': 'WriteCharacteristicRequest',
  '2': const [
    const {'1': 'characteristic', '3': 1, '4': 1, '5': 11, '6': '.CharacteristicAddress', '10': 'characteristic'},
    const {'1': 'value', '3': 2, '4': 1, '5': 12, '10': 'value'},
  ],
};

/// Descriptor for `WriteCharacteristicRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List writeCharacteristicRequestDescriptor = $convert.base64Decode('ChpXcml0ZUNoYXJhY3RlcmlzdGljUmVxdWVzdBI+Cg5jaGFyYWN0ZXJpc3RpYxgBIAEoCzIWLkNoYXJhY3RlcmlzdGljQWRkcmVzc1IOY2hhcmFjdGVyaXN0aWMSFAoFdmFsdWUYAiABKAxSBXZhbHVl');
@$core.Deprecated('Use writeCharacteristicInfoDescriptor instead')
const WriteCharacteristicInfo$json = const {
  '1': 'WriteCharacteristicInfo',
  '2': const [
    const {'1': 'characteristic', '3': 1, '4': 1, '5': 11, '6': '.CharacteristicAddress', '10': 'characteristic'},
    const {'1': 'failure', '3': 3, '4': 1, '5': 11, '6': '.GenericFailure', '10': 'failure'},
  ],
};

/// Descriptor for `WriteCharacteristicInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List writeCharacteristicInfoDescriptor = $convert.base64Decode('ChdXcml0ZUNoYXJhY3RlcmlzdGljSW5mbxI+Cg5jaGFyYWN0ZXJpc3RpYxgBIAEoCzIWLkNoYXJhY3RlcmlzdGljQWRkcmVzc1IOY2hhcmFjdGVyaXN0aWMSKQoHZmFpbHVyZRgDIAEoCzIPLkdlbmVyaWNGYWlsdXJlUgdmYWlsdXJl');
@$core.Deprecated('Use negotiateMtuRequestDescriptor instead')
const NegotiateMtuRequest$json = const {
  '1': 'NegotiateMtuRequest',
  '2': const [
    const {'1': 'deviceId', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    const {'1': 'mtuSize', '3': 2, '4': 1, '5': 5, '10': 'mtuSize'},
  ],
};

/// Descriptor for `NegotiateMtuRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List negotiateMtuRequestDescriptor = $convert.base64Decode('ChNOZWdvdGlhdGVNdHVSZXF1ZXN0EhoKCGRldmljZUlkGAEgASgJUghkZXZpY2VJZBIYCgdtdHVTaXplGAIgASgFUgdtdHVTaXpl');
@$core.Deprecated('Use negotiateMtuInfoDescriptor instead')
const NegotiateMtuInfo$json = const {
  '1': 'NegotiateMtuInfo',
  '2': const [
    const {'1': 'deviceId', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    const {'1': 'mtuSize', '3': 2, '4': 1, '5': 5, '10': 'mtuSize'},
    const {'1': 'failure', '3': 3, '4': 1, '5': 11, '6': '.GenericFailure', '10': 'failure'},
  ],
};

/// Descriptor for `NegotiateMtuInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List negotiateMtuInfoDescriptor = $convert.base64Decode('ChBOZWdvdGlhdGVNdHVJbmZvEhoKCGRldmljZUlkGAEgASgJUghkZXZpY2VJZBIYCgdtdHVTaXplGAIgASgFUgdtdHVTaXplEikKB2ZhaWx1cmUYAyABKAsyDy5HZW5lcmljRmFpbHVyZVIHZmFpbHVyZQ==');
@$core.Deprecated('Use bleStatusInfoDescriptor instead')
const BleStatusInfo$json = const {
  '1': 'BleStatusInfo',
  '2': const [
    const {'1': 'status', '3': 1, '4': 1, '5': 5, '10': 'status'},
  ],
};

/// Descriptor for `BleStatusInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bleStatusInfoDescriptor = $convert.base64Decode('Cg1CbGVTdGF0dXNJbmZvEhYKBnN0YXR1cxgBIAEoBVIGc3RhdHVz');
@$core.Deprecated('Use changeConnectionPriorityRequestDescriptor instead')
const ChangeConnectionPriorityRequest$json = const {
  '1': 'ChangeConnectionPriorityRequest',
  '2': const [
    const {'1': 'deviceId', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    const {'1': 'priority', '3': 2, '4': 1, '5': 5, '10': 'priority'},
  ],
};

/// Descriptor for `ChangeConnectionPriorityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changeConnectionPriorityRequestDescriptor = $convert.base64Decode('Ch9DaGFuZ2VDb25uZWN0aW9uUHJpb3JpdHlSZXF1ZXN0EhoKCGRldmljZUlkGAEgASgJUghkZXZpY2VJZBIaCghwcmlvcml0eRgCIAEoBVIIcHJpb3JpdHk=');
@$core.Deprecated('Use changeConnectionPriorityInfoDescriptor instead')
const ChangeConnectionPriorityInfo$json = const {
  '1': 'ChangeConnectionPriorityInfo',
  '2': const [
    const {'1': 'deviceId', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    const {'1': 'failure', '3': 2, '4': 1, '5': 11, '6': '.GenericFailure', '10': 'failure'},
  ],
};

/// Descriptor for `ChangeConnectionPriorityInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changeConnectionPriorityInfoDescriptor = $convert.base64Decode('ChxDaGFuZ2VDb25uZWN0aW9uUHJpb3JpdHlJbmZvEhoKCGRldmljZUlkGAEgASgJUghkZXZpY2VJZBIpCgdmYWlsdXJlGAIgASgLMg8uR2VuZXJpY0ZhaWx1cmVSB2ZhaWx1cmU=');
@$core.Deprecated('Use characteristicAddressDescriptor instead')
const CharacteristicAddress$json = const {
  '1': 'CharacteristicAddress',
  '2': const [
    const {'1': 'deviceId', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    const {'1': 'serviceUuid', '3': 2, '4': 1, '5': 11, '6': '.Uuid', '10': 'serviceUuid'},
    const {'1': 'characteristicUuid', '3': 3, '4': 1, '5': 11, '6': '.Uuid', '10': 'characteristicUuid'},
  ],
};

/// Descriptor for `CharacteristicAddress`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List characteristicAddressDescriptor = $convert.base64Decode('ChVDaGFyYWN0ZXJpc3RpY0FkZHJlc3MSGgoIZGV2aWNlSWQYASABKAlSCGRldmljZUlkEicKC3NlcnZpY2VVdWlkGAIgASgLMgUuVXVpZFILc2VydmljZVV1aWQSNQoSY2hhcmFjdGVyaXN0aWNVdWlkGAMgASgLMgUuVXVpZFISY2hhcmFjdGVyaXN0aWNVdWlk');
@$core.Deprecated('Use serviceDataEntryDescriptor instead')
const ServiceDataEntry$json = const {
  '1': 'ServiceDataEntry',
  '2': const [
    const {'1': 'serviceUuid', '3': 1, '4': 1, '5': 11, '6': '.Uuid', '10': 'serviceUuid'},
    const {'1': 'data', '3': 2, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `ServiceDataEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceDataEntryDescriptor = $convert.base64Decode('ChBTZXJ2aWNlRGF0YUVudHJ5EicKC3NlcnZpY2VVdWlkGAEgASgLMgUuVXVpZFILc2VydmljZVV1aWQSEgoEZGF0YRgCIAEoDFIEZGF0YQ==');
@$core.Deprecated('Use servicesWithCharacteristicsDescriptor instead')
const ServicesWithCharacteristics$json = const {
  '1': 'ServicesWithCharacteristics',
  '2': const [
    const {'1': 'items', '3': 1, '4': 3, '5': 11, '6': '.ServiceWithCharacteristics', '10': 'items'},
  ],
};

/// Descriptor for `ServicesWithCharacteristics`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List servicesWithCharacteristicsDescriptor = $convert.base64Decode('ChtTZXJ2aWNlc1dpdGhDaGFyYWN0ZXJpc3RpY3MSMQoFaXRlbXMYASADKAsyGy5TZXJ2aWNlV2l0aENoYXJhY3RlcmlzdGljc1IFaXRlbXM=');
@$core.Deprecated('Use serviceWithCharacteristicsDescriptor instead')
const ServiceWithCharacteristics$json = const {
  '1': 'ServiceWithCharacteristics',
  '2': const [
    const {'1': 'serviceId', '3': 1, '4': 1, '5': 11, '6': '.Uuid', '10': 'serviceId'},
    const {'1': 'characteristics', '3': 2, '4': 3, '5': 11, '6': '.Uuid', '10': 'characteristics'},
  ],
};

/// Descriptor for `ServiceWithCharacteristics`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceWithCharacteristicsDescriptor = $convert.base64Decode('ChpTZXJ2aWNlV2l0aENoYXJhY3RlcmlzdGljcxIjCglzZXJ2aWNlSWQYASABKAsyBS5VdWlkUglzZXJ2aWNlSWQSLwoPY2hhcmFjdGVyaXN0aWNzGAIgAygLMgUuVXVpZFIPY2hhcmFjdGVyaXN0aWNz');
@$core.Deprecated('Use discoverServicesRequestDescriptor instead')
const DiscoverServicesRequest$json = const {
  '1': 'DiscoverServicesRequest',
  '2': const [
    const {'1': 'deviceId', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
  ],
};

/// Descriptor for `DiscoverServicesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List discoverServicesRequestDescriptor = $convert.base64Decode('ChdEaXNjb3ZlclNlcnZpY2VzUmVxdWVzdBIaCghkZXZpY2VJZBgBIAEoCVIIZGV2aWNlSWQ=');
@$core.Deprecated('Use discoverServicesInfoDescriptor instead')
const DiscoverServicesInfo$json = const {
  '1': 'DiscoverServicesInfo',
  '2': const [
    const {'1': 'deviceId', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    const {'1': 'services', '3': 2, '4': 3, '5': 11, '6': '.DiscoveredService', '10': 'services'},
  ],
};

/// Descriptor for `DiscoverServicesInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List discoverServicesInfoDescriptor = $convert.base64Decode('ChREaXNjb3ZlclNlcnZpY2VzSW5mbxIaCghkZXZpY2VJZBgBIAEoCVIIZGV2aWNlSWQSLgoIc2VydmljZXMYAiADKAsyEi5EaXNjb3ZlcmVkU2VydmljZVIIc2VydmljZXM=');
@$core.Deprecated('Use discoveredServiceDescriptor instead')
const DiscoveredService$json = const {
  '1': 'DiscoveredService',
  '2': const [
    const {'1': 'serviceUuid', '3': 1, '4': 1, '5': 11, '6': '.Uuid', '10': 'serviceUuid'},
    const {'1': 'characteristicUuids', '3': 2, '4': 3, '5': 11, '6': '.Uuid', '10': 'characteristicUuids'},
    const {'1': 'includedServices', '3': 3, '4': 3, '5': 11, '6': '.DiscoveredService', '10': 'includedServices'},
  ],
};

/// Descriptor for `DiscoveredService`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List discoveredServiceDescriptor = $convert.base64Decode('ChFEaXNjb3ZlcmVkU2VydmljZRInCgtzZXJ2aWNlVXVpZBgBIAEoCzIFLlV1aWRSC3NlcnZpY2VVdWlkEjcKE2NoYXJhY3RlcmlzdGljVXVpZHMYAiADKAsyBS5VdWlkUhNjaGFyYWN0ZXJpc3RpY1V1aWRzEj4KEGluY2x1ZGVkU2VydmljZXMYAyADKAsyEi5EaXNjb3ZlcmVkU2VydmljZVIQaW5jbHVkZWRTZXJ2aWNlcw==');
@$core.Deprecated('Use uuidDescriptor instead')
const Uuid$json = const {
  '1': 'Uuid',
  '2': const [
    const {'1': 'data', '3': 1, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `Uuid`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uuidDescriptor = $convert.base64Decode('CgRVdWlkEhIKBGRhdGEYASABKAxSBGRhdGE=');
@$core.Deprecated('Use genericFailureDescriptor instead')
const GenericFailure$json = const {
  '1': 'GenericFailure',
  '2': const [
    const {'1': 'code', '3': 1, '4': 1, '5': 5, '10': 'code'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `GenericFailure`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List genericFailureDescriptor = $convert.base64Decode('Cg5HZW5lcmljRmFpbHVyZRISCgRjb2RlGAEgASgFUgRjb2RlEhgKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2U=');
