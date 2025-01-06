import 'package:reactive_ble_platform_interface/reactive_ble_platform_interface.dart';

import '../generated/bledata.pb.dart' as pb;

abstract class ArgsToProtobufConverter {
  pb.ConnectToDeviceRequest createConnectToDeviceArgs(
    String id,
    Map<Uuid, List<Uuid>>? servicesWithCharacteristicsToDiscover,
    Duration? connectionTimeout,
  );

  pb.DisconnectFromDeviceRequest createDisconnectDeviceArgs(String deviceId);

  pb.ReadCharacteristicRequest createReadCharacteristicRequest(
    CharacteristicInstance characteristic,
  );

  pb.WriteCharacteristicRequest createWriteCharacteristicRequest(
      CharacteristicInstance characteristic,
    List<int> value,
  );

  pb.NotifyCharacteristicRequest createNotifyCharacteristicRequest(
      CharacteristicInstance characteristic,
  );

  pb.NotifyNoMoreCharacteristicRequest createNotifyNoMoreCharacteristicRequest(
      CharacteristicInstance characteristic,
  );

  pb.NegotiateMtuRequest createNegotiateMtuRequest(
    String deviceId,
    int mtu,
  );

  pb.ChangeConnectionPriorityRequest createChangeConnectionPrioRequest(
    String deviceId,
    ConnectionPriority priority,
  );

  pb.ScanForDevicesRequest createScanForDevicesRequest({
    required List<Uuid>? withServices,
    required ScanMode scanMode,
    required bool requireLocationServicesEnabled,
  });

  pb.ClearGattCacheRequest createClearGattCacheRequest(String deviceId);

  pb.DiscoverServicesRequest createDiscoverServicesRequest(String deviceId);

  pb.ReadRssiRequest createReadRssiRequest(String deviceId);
}

class ArgsToProtobufConverterImpl implements ArgsToProtobufConverter {
  const ArgsToProtobufConverterImpl();

  @override
  pb.ConnectToDeviceRequest createConnectToDeviceArgs(
    String id,
    Map<Uuid, List<Uuid>>? servicesWithCharacteristicsToDiscover,
    Duration? connectionTimeout,
  ) {
    final args = pb.ConnectToDeviceRequest()..deviceId = id;

    if (connectionTimeout != null) {
      args.timeoutInMs = connectionTimeout.inMilliseconds;
    }

    if (servicesWithCharacteristicsToDiscover != null) {
      final items = <pb.ServiceWithCharacteristics>[];
      for (final serviceId in servicesWithCharacteristicsToDiscover.keys) {
        final characteristicIds =
            servicesWithCharacteristicsToDiscover[serviceId]!;
        items.add(
          pb.ServiceWithCharacteristics()
            ..serviceId = (pb.Uuid()..data = serviceId.data)
            ..characteristics
                .addAll(characteristicIds.map((c) => pb.Uuid()..data = c.data)),
        );
      }
      args.servicesWithCharacteristicsToDiscover =
          pb.ServicesWithCharacteristics()..items.addAll(items);
    }
    return args;
  }

  @override
  pb.DisconnectFromDeviceRequest createDisconnectDeviceArgs(String deviceId) =>
      pb.DisconnectFromDeviceRequest()..deviceId = deviceId;

  @override
  pb.ReadCharacteristicRequest createReadCharacteristicRequest(
    CharacteristicInstance characteristic,
  ) {
    final args = pb.ReadCharacteristicRequest()
      ..characteristic = (pb.CharacteristicAddress()
        ..deviceId = characteristic.deviceId
        ..serviceUuid = (pb.Uuid()..data = characteristic.serviceId.data)
        ..serviceInstanceId = characteristic.serviceInstanceId
        ..characteristicUuid =
            (pb.Uuid()..data = characteristic.characteristicId.data)
        ..characteristicInstanceId = characteristic.characteristicInstanceId);

    return args;
  }

  @override
  pb.WriteCharacteristicRequest createWriteCharacteristicRequest(
    CharacteristicInstance characteristic,
    List<int> value,
  ) {
    final args = pb.WriteCharacteristicRequest()
      ..characteristic = (pb.CharacteristicAddress()
        ..deviceId = characteristic.deviceId
        ..serviceUuid = (pb.Uuid()..data = characteristic.serviceId.data)
        ..serviceInstanceId = characteristic.serviceInstanceId
        ..characteristicUuid =
            (pb.Uuid()..data = characteristic.characteristicId.data)
        ..characteristicInstanceId = characteristic.characteristicInstanceId)
      ..value = value;

    return args;
  }

  @override
  pb.NotifyCharacteristicRequest createNotifyCharacteristicRequest(
    CharacteristicInstance characteristic,
  ) {
    final args = pb.NotifyCharacteristicRequest()
      ..characteristic = (pb.CharacteristicAddress()
        ..deviceId = characteristic.deviceId
        ..serviceUuid = (pb.Uuid()..data = characteristic.serviceId.data)
        ..serviceInstanceId = characteristic.serviceInstanceId
        ..characteristicUuid =
            (pb.Uuid()..data = characteristic.characteristicId.data)
        ..characteristicInstanceId = characteristic.characteristicInstanceId);

    return args;
  }

  @override
  pb.NotifyNoMoreCharacteristicRequest createNotifyNoMoreCharacteristicRequest(
    CharacteristicInstance characteristic,
  ) {
    final args = pb.NotifyNoMoreCharacteristicRequest()
      ..characteristic = (pb.CharacteristicAddress()
        ..deviceId = characteristic.deviceId
        ..serviceUuid = (pb.Uuid()..data = characteristic.serviceId.data)
        ..serviceInstanceId = characteristic.serviceInstanceId
        ..characteristicUuid =
            (pb.Uuid()..data = characteristic.characteristicId.data)
        ..characteristicInstanceId = characteristic.characteristicInstanceId);

    return args;
  }

  @override
  pb.NegotiateMtuRequest createNegotiateMtuRequest(
    String deviceId,
    int mtu,
  ) {
    final args = pb.NegotiateMtuRequest()
      ..deviceId = deviceId
      ..mtuSize = mtu;

    return args;
  }

  @override
  pb.ChangeConnectionPriorityRequest createChangeConnectionPrioRequest(
    String deviceId,
    ConnectionPriority priority,
  ) {
    final args = pb.ChangeConnectionPriorityRequest()
      ..deviceId = deviceId
      ..priority = convertPriorityToInt(priority);

    return args;
  }

  @override
  pb.ScanForDevicesRequest createScanForDevicesRequest({
    required List<Uuid>? withServices,
    required ScanMode scanMode,
    required bool requireLocationServicesEnabled,
  }) {
    final args = pb.ScanForDevicesRequest()
      ..scanMode = convertScanModeToArgs(scanMode)
      ..requireLocationServicesEnabled = requireLocationServicesEnabled;

    if (withServices != null) {
      for (final withService in withServices) {
        args.serviceUuids.add(pb.Uuid()..data = withService.data);
      }
    }

    return args;
  }

  @override
  pb.ClearGattCacheRequest createClearGattCacheRequest(String deviceId) {
    final args = pb.ClearGattCacheRequest()..deviceId = deviceId;
    return args;
  }

  @override
  pb.DiscoverServicesRequest createDiscoverServicesRequest(String deviceId) {
    final args = pb.DiscoverServicesRequest()..deviceId = deviceId;
    return args;
  }

  @override
  pb.ReadRssiRequest createReadRssiRequest(String deviceId) {
    final args = pb.ReadRssiRequest()..deviceId = deviceId;
    return args;
  }
}
