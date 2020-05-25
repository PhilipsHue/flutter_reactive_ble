import 'package:flutter_reactive_ble/src/generated/bledata.pb.dart' as pb;
import 'package:flutter_reactive_ble/src/model/uuid.dart';

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
}
