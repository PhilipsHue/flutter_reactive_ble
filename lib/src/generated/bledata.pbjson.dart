///
//  Generated code. Do not modify.
//  source: bledata.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const ScanForDevicesRequest$json = const {
  '1': 'ScanForDevicesRequest',
  '2': const [
    const {
      '1': 'serviceUuids',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.Uuid',
      '10': 'serviceUuids'
    },
    const {'1': 'scanMode', '3': 2, '4': 1, '5': 5, '10': 'scanMode'},
    const {
      '1': 'requireLocationServicesEnabled',
      '3': 3,
      '4': 1,
      '5': 8,
      '10': 'requireLocationServicesEnabled'
    },
  ],
};

const DeviceScanInfo$json = const {
  '1': 'DeviceScanInfo',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    const {
      '1': 'failure',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.GenericFailure',
      '10': 'failure'
    },
    const {
      '1': 'serviceData',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.ServiceDataEntry',
      '10': 'serviceData'
    },
    const {
      '1': 'manufacturerData',
      '3': 6,
      '4': 1,
      '5': 12,
      '10': 'manufacturerData'
    },
    const {'1': 'rssi', '3': 5, '4': 1, '5': 5, '10': 'rssi'},
  ],
};

const ConnectToDeviceRequest$json = const {
  '1': 'ConnectToDeviceRequest',
  '2': const [
    const {'1': 'deviceId', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    const {
      '1': 'servicesWithCharacteristicsToDiscover',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.ServicesWithCharacteristics',
      '10': 'servicesWithCharacteristicsToDiscover'
    },
    const {'1': 'timeoutInMs', '3': 3, '4': 1, '5': 5, '10': 'timeoutInMs'},
  ],
};

const DeviceInfo$json = const {
  '1': 'DeviceInfo',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {
      '1': 'connectionState',
      '3': 2,
      '4': 1,
      '5': 5,
      '10': 'connectionState'
    },
    const {
      '1': 'failure',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.GenericFailure',
      '10': 'failure'
    },
  ],
};

const DisconnectFromDeviceRequest$json = const {
  '1': 'DisconnectFromDeviceRequest',
  '2': const [
    const {'1': 'deviceId', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
  ],
};

const ClearGattCacheRequest$json = const {
  '1': 'ClearGattCacheRequest',
  '2': const [
    const {'1': 'deviceId', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
  ],
};

const ClearGattCacheInfo$json = const {
  '1': 'ClearGattCacheInfo',
  '2': const [
    const {
      '1': 'failure',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.GenericFailure',
      '10': 'failure'
    },
  ],
};

const NotifyCharacteristicRequest$json = const {
  '1': 'NotifyCharacteristicRequest',
  '2': const [
    const {
      '1': 'characteristic',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.CharacteristicAddress',
      '10': 'characteristic'
    },
  ],
};

const NotifyNoMoreCharacteristicRequest$json = const {
  '1': 'NotifyNoMoreCharacteristicRequest',
  '2': const [
    const {
      '1': 'characteristic',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.CharacteristicAddress',
      '10': 'characteristic'
    },
  ],
};

const ReadCharacteristicRequest$json = const {
  '1': 'ReadCharacteristicRequest',
  '2': const [
    const {
      '1': 'characteristic',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.CharacteristicAddress',
      '10': 'characteristic'
    },
  ],
};

const CharacteristicValueInfo$json = const {
  '1': 'CharacteristicValueInfo',
  '2': const [
    const {
      '1': 'characteristic',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.CharacteristicAddress',
      '10': 'characteristic'
    },
    const {'1': 'value', '3': 2, '4': 1, '5': 12, '10': 'value'},
    const {
      '1': 'failure',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.GenericFailure',
      '10': 'failure'
    },
  ],
};

const WriteCharacteristicRequest$json = const {
  '1': 'WriteCharacteristicRequest',
  '2': const [
    const {
      '1': 'characteristic',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.CharacteristicAddress',
      '10': 'characteristic'
    },
    const {'1': 'value', '3': 2, '4': 1, '5': 12, '10': 'value'},
  ],
};

const WriteCharacteristicInfo$json = const {
  '1': 'WriteCharacteristicInfo',
  '2': const [
    const {
      '1': 'characteristic',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.CharacteristicAddress',
      '10': 'characteristic'
    },
    const {
      '1': 'failure',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.GenericFailure',
      '10': 'failure'
    },
  ],
};

const NegotiateMtuRequest$json = const {
  '1': 'NegotiateMtuRequest',
  '2': const [
    const {'1': 'deviceId', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    const {'1': 'mtuSize', '3': 2, '4': 1, '5': 5, '10': 'mtuSize'},
  ],
};

const NegotiateMtuInfo$json = const {
  '1': 'NegotiateMtuInfo',
  '2': const [
    const {'1': 'deviceId', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    const {'1': 'mtuSize', '3': 2, '4': 1, '5': 5, '10': 'mtuSize'},
    const {
      '1': 'failure',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.GenericFailure',
      '10': 'failure'
    },
  ],
};

const BleStatusInfo$json = const {
  '1': 'BleStatusInfo',
  '2': const [
    const {'1': 'status', '3': 1, '4': 1, '5': 5, '10': 'status'},
  ],
};

const ChangeConnectionPriorityRequest$json = const {
  '1': 'ChangeConnectionPriorityRequest',
  '2': const [
    const {'1': 'deviceId', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    const {'1': 'priority', '3': 2, '4': 1, '5': 5, '10': 'priority'},
  ],
};

const ChangeConnectionPriorityInfo$json = const {
  '1': 'ChangeConnectionPriorityInfo',
  '2': const [
    const {'1': 'deviceId', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    const {
      '1': 'failure',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.GenericFailure',
      '10': 'failure'
    },
  ],
};

const CharacteristicAddress$json = const {
  '1': 'CharacteristicAddress',
  '2': const [
    const {'1': 'deviceId', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    const {
      '1': 'serviceUuid',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.Uuid',
      '10': 'serviceUuid'
    },
    const {
      '1': 'characteristicUuid',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.Uuid',
      '10': 'characteristicUuid'
    },
  ],
};

const ServiceDataEntry$json = const {
  '1': 'ServiceDataEntry',
  '2': const [
    const {
      '1': 'serviceUuid',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.Uuid',
      '10': 'serviceUuid'
    },
    const {'1': 'data', '3': 2, '4': 1, '5': 12, '10': 'data'},
  ],
};

const ServicesWithCharacteristics$json = const {
  '1': 'ServicesWithCharacteristics',
  '2': const [
    const {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.ServiceWithCharacteristics',
      '10': 'items'
    },
  ],
};

const ServiceWithCharacteristics$json = const {
  '1': 'ServiceWithCharacteristics',
  '2': const [
    const {
      '1': 'serviceId',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.Uuid',
      '10': 'serviceId'
    },
    const {
      '1': 'characteristics',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.Uuid',
      '10': 'characteristics'
    },
  ],
};

const Uuid$json = const {
  '1': 'Uuid',
  '2': const [
    const {'1': 'data', '3': 1, '4': 1, '5': 12, '10': 'data'},
  ],
};

const GenericFailure$json = const {
  '1': 'GenericFailure',
  '2': const [
    const {'1': 'code', '3': 1, '4': 1, '5': 5, '10': 'code'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
  ],
};

const DiscoverServicesRequest$json = const {
  '1': 'DiscoverServicesRequest',
  '2': const [
    const {'1': 'deviceId', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
  ],
};

const DiscoverServicesInfo$json = const {
  '1': 'DiscoverServicesInfo',
  '2': const [
    const {'1': 'deviceId', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    const {
      '1': 'services',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.DiscoveredServices',
      '10': 'services'
    },
    const {
      '1': 'failure',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.GenericFailure',
      '10': 'failure'
    },
  ],
};

const DiscoveredServices$json = const {
  '1': 'DiscoveredServices',
  '2': const [
    const {
      '1': 'serviceUuid',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.Uuid',
      '10': 'serviceUuid'
    },
    const {
      '1': 'characteristicUuid',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.Uuid',
      '10': 'characteristicUuid'
    },
    const {
      '1': 'includedServices',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.DiscoveredServices',
      '10': 'includedServices'
    },
  ],
};
