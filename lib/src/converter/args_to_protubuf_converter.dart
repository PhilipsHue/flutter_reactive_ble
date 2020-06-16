import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/generated/bledata.pb.dart' as pb;
import 'package:flutter_reactive_ble/src/model/uuid.dart';
import 'package:meta/meta.dart';

class ArgsToProtobufConverter {
  const ArgsToProtobufConverter();
  pb.ConnectToDeviceRequest createConnectToDeviceArgs(
    String id,
    Map<Uuid, List<Uuid>> servicesWithCharacteristicsToDiscover,
    Duration connectionTimeout,
  ) {
    assert(id != null);

    final args = pb.ConnectToDeviceRequest()..deviceId = id;

    if (connectionTimeout != null) {
      args.timeoutInMs = connectionTimeout.inMilliseconds;
    }

    if (servicesWithCharacteristicsToDiscover != null) {
      final items = <pb.ServiceWithCharacteristics>[];
      for (final serviceId in servicesWithCharacteristicsToDiscover.keys) {
        final characteristicIds =
            servicesWithCharacteristicsToDiscover[serviceId];
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

  pb.DisconnectFromDeviceRequest createDisconnectDeviceArgs(String deviceId) =>
      pb.DisconnectFromDeviceRequest()..deviceId = deviceId;

  pb.ReadCharacteristicRequest createReadCharacteristicRequest(
    QualifiedCharacteristic characteristic,
  ) {
    final args = pb.ReadCharacteristicRequest()
      ..characteristic = (pb.CharacteristicAddress()
        ..deviceId = characteristic.deviceId
        ..serviceUuid = (pb.Uuid()..data = characteristic.serviceId.data)
        ..characteristicUuid =
            (pb.Uuid()..data = characteristic.characteristicId.data));

    return args;
  }

  pb.WriteCharacteristicRequest createWriteChacracteristicRequest(
    QualifiedCharacteristic characteristic,
    List<int> value,
  ) {
    final args = pb.WriteCharacteristicRequest()
      ..characteristic = (pb.CharacteristicAddress()
        ..deviceId = characteristic.deviceId
        ..serviceUuid = (pb.Uuid()..data = characteristic.serviceId.data)
        ..characteristicUuid =
            (pb.Uuid()..data = characteristic.characteristicId.data))
      ..value = value;

    return args;
  }

  pb.NotifyCharacteristicRequest createNotifyCharacteristicRequest(
    QualifiedCharacteristic characteristic,
  ) {
    final args = pb.NotifyCharacteristicRequest()
      ..characteristic = (pb.CharacteristicAddress()
        ..deviceId = characteristic.deviceId
        ..serviceUuid = (pb.Uuid()..data = characteristic.serviceId.data)
        ..characteristicUuid =
            (pb.Uuid()..data = characteristic.characteristicId.data));

    return args;
  }

  pb.NotifyNoMoreCharacteristicRequest createNotifyNoMoreCharacteristicRequest(
    QualifiedCharacteristic characteristic,
  ) {
    final args = pb.NotifyNoMoreCharacteristicRequest()
      ..characteristic = (pb.CharacteristicAddress()
        ..deviceId = characteristic.deviceId
        ..serviceUuid = (pb.Uuid()..data = characteristic.serviceId.data)
        ..characteristicUuid =
            (pb.Uuid()..data = characteristic.characteristicId.data));

    return args;
  }

  pb.NegotiateMtuRequest createNegotiateMtuRequest(
    String deviceId,
    int mtu,
  ) {
    final args = pb.NegotiateMtuRequest()
      ..deviceId = deviceId
      ..mtuSize = mtu;

    return args;
  }

  pb.ChangeConnectionPriorityRequest createChangeConnectionPrioRequest(
    String deviceId,
    ConnectionPriority priority,
  ) {
    final args = pb.ChangeConnectionPriorityRequest()
      ..deviceId = deviceId
      ..priority = convertPriorityToInt(priority);

    return args;
  }

  pb.ScanForDevicesRequest createScanForDevicesRequest({
    @required List<Uuid> withServices,
    @required ScanMode scanMode,
    @required bool requireLocationServicesEnabled,
  }) {
    final args = pb.ScanForDevicesRequest()
      ..scanMode = convertScanModeToArgs(scanMode)
      ..requireLocationServicesEnabled = requireLocationServicesEnabled;

    if (withServices != null) {
      for (final withService in withServices) {
        args.serviceUuids.add((pb.Uuid()..data = withService.data));
      }
    }

    return args;
  }

  pb.ClearGattCacheRequest createClearGattCacheRequest(String deviceId) {
    final args = pb.ClearGattCacheRequest()..deviceId = deviceId;
    return args;
  }
}
