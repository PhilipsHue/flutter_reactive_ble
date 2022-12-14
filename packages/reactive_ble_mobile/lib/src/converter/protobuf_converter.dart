import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:reactive_ble_platform_interface/reactive_ble_platform_interface.dart';

import '../generated/bledata.pb.dart' as pb;
import '../select_from.dart';

abstract class ProtobufConverter {
  BleStatus bleStatusFrom(List<int> data);

  ScanResult scanResultFrom(List<int> data);

  ConnectionStateUpdate connectionStateUpdateFrom(List<int> data);

  Result<Unit, GenericFailure<ClearGattCacheError>?> clearGattCacheResultFrom(
    List<int> data,
  );

  CharacteristicValue characteristicValueFrom(List<int> data);

  WriteCharacteristicInfo writeCharacteristicInfoFrom(List<int> data);

  ConnectionPriorityInfo connectionPriorityInfoFrom(List<int> data);

  int mtuSizeFrom(List<int> data) =>
      pb.NegotiateMtuInfo.fromBuffer(data).mtuSize;

  List<DiscoveredService> discoveredServicesFrom(List<int> data);
}

class ProtobufConverterImpl implements ProtobufConverter {
  const ProtobufConverterImpl();

  @override
  BleStatus bleStatusFrom(List<int> data) {
    final message = pb.BleStatusInfo.fromBuffer(data);
    return selectFrom(
      BleStatus.values,
      index: message.status,
      fallback: (_) => BleStatus.unknown,
    );
  }

  @override
  ScanResult scanResultFrom(List<int> data) {
    final message = pb.DeviceScanInfo.fromBuffer(data);

    final serviceData = Map.fromIterables(
      message.serviceData.map((entry) => Uuid(entry.serviceUuid.data)),
      message.serviceData.map((entry) => Uint8List.fromList(entry.data)),
    );

    final serviceUuids = message.serviceUuids
        .map((entry) => Uuid(entry.data))
        .toList(growable: false);

    return ScanResult(
      result: resultFrom(
        getValue: () => DiscoveredDevice(
          id: message.id,
          name: message.name,
          serviceData: serviceData,
          serviceUuids: serviceUuids,
          manufacturerData: Uint8List.fromList(message.manufacturerData),
          rssi: message.rssi,
        ),
        failure: genericFailureFrom(
            hasFailure: message.hasFailure(),
            getFailure: () => message.failure,
            codes: ScanFailure.values,
            fallback: (rawOrNull) => ScanFailure.unknown),
      ),
    );
  }

  @override
  ConnectionStateUpdate connectionStateUpdateFrom(List<int> data) {
    final deviceInfo = pb.DeviceInfo.fromBuffer(data);
    return ConnectionStateUpdate(
      deviceId: deviceInfo.id,
      connectionState: selectFrom(
        DeviceConnectionState.values,
        index: deviceInfo.connectionState,
        fallback: (int? raw) => throw _InvalidConnectionState(raw),
      ),
      failure: genericFailureFrom(
        hasFailure: deviceInfo.hasFailure(),
        getFailure: () => deviceInfo.failure,
        codes: ConnectionError.values,
        fallback: (int? rawOrNull) => ConnectionError.unknown,
      ),
    );
  }

  @override
  Result<Unit, GenericFailure<ClearGattCacheError>?> clearGattCacheResultFrom(
      List<int> data) {
    final message = pb.ClearGattCacheInfo.fromBuffer(data);
    return resultFrom(
      getValue: () => const Unit(),
      failure: genericFailureFrom(
        hasFailure: message.hasFailure(),
        getFailure: () => message.failure,
        codes: ClearGattCacheError.values,
        fallback: (rawOrNull) => ClearGattCacheError.unknown,
      ),
    );
  }

  @override
  CharacteristicValue characteristicValueFrom(List<int> data) {
    final message = pb.CharacteristicValueInfo.fromBuffer(data);

    return CharacteristicValue(
      characteristic: qualifiedCharacteristicFrom(message.characteristic),
      result: resultFrom(
        getValue: () => message.value,
        failure: genericFailureFrom(
          hasFailure: message.hasFailure(),
          getFailure: () => message.failure,
          codes: CharacteristicValueUpdateError.values,
          fallback: (rawOrNull) => CharacteristicValueUpdateError.unknown,
        ),
      ),
    );
  }

  @override
  WriteCharacteristicInfo writeCharacteristicInfoFrom(List<int> data) {
    final message = pb.WriteCharacteristicInfo.fromBuffer(data);

    return WriteCharacteristicInfo(
      characteristic: qualifiedCharacteristicFrom(message.characteristic),
      result: resultFrom(
        getValue: () => const Unit(),
        failure: genericFailureFrom(
          hasFailure: message.hasFailure(),
          getFailure: () => message.failure,
          codes: WriteCharacteristicFailure.values,
          fallback: (rawOrNull) => WriteCharacteristicFailure.unknown,
        ),
      ),
    );
  }

  @override
  ConnectionPriorityInfo connectionPriorityInfoFrom(List<int> data) {
    final message = pb.ChangeConnectionPriorityInfo.fromBuffer(data);
    return ConnectionPriorityInfo(
      result: resultFrom(
        getValue: () => const Unit(),
        failure: genericFailureFrom(
          hasFailure: message.hasFailure(),
          getFailure: () => message.failure,
          codes: ConnectionPriorityFailure.values,
          fallback: (rawOrNull) => ConnectionPriorityFailure.unknown,
        ),
      ),
    );
  }

  @override
  int mtuSizeFrom(List<int> data) =>
      pb.NegotiateMtuInfo.fromBuffer(data).mtuSize;

  QualifiedCharacteristic qualifiedCharacteristicFrom(
          pb.CharacteristicAddress message) =>
      QualifiedCharacteristic(
        characteristicId: Uuid(message.characteristicUuid.data),
        serviceId: Uuid(message.serviceUuid.data),
        deviceId: message.deviceId,
      );

  @visibleForTesting
  GenericFailure<T>? genericFailureFrom<T>({
    required bool hasFailure,
    required pb.GenericFailure Function() getFailure,
    required List<T> codes,
    required T Function(int? rawOrNull) fallback,
  }) {
    if (hasFailure) {
      final error = getFailure();
      return GenericFailure(
        code: error.hasCode()
            ? selectFrom(codes, index: error.code, fallback: fallback)
            : fallback(null),
        message: error.message,
      );
    }
    return null;
  }

  @override
  List<DiscoveredService> discoveredServicesFrom(List<int> data) {
    final message = pb.DiscoverServicesInfo.fromBuffer(data);
    return message.services.map(_convertService).toList(growable: false);
  }

  DiscoveredService _convertService(pb.DiscoveredService service) =>
      DiscoveredService(
        serviceId: Uuid(service.serviceUuid.data),
        characteristicIds: service.characteristicUuids
            .map((c) => Uuid(c.data))
            .toList(growable: false),
        characteristics: service.characteristics
            .map((c) => DiscoveredCharacteristic(
                characteristicId: Uuid(c.characteristicId.data),
                serviceId: Uuid(c.serviceId.data),
                isReadable: c.isReadable,
                isWritableWithResponse: c.isWritableWithResponse,
                isWritableWithoutResponse: c.isWritableWithoutResponse,
                isNotifiable: c.isNotifiable,
                isIndicatable: c.isIndicatable))
            .toList(growable: false),
        includedServices: service.includedServices
            .map(_convertService)
            .toList(growable: false),
      );

  @visibleForTesting
  Result<Value, Failure> resultFrom<Value, Failure>({
    required Value Function() getValue,
    required Failure failure,
  }) =>
      failure != null
          ? Result<Value, Failure>.failure(failure)
          : Result.success(getValue());
}

class _InvalidConnectionState extends Error {
  final int? rawValue;

  _InvalidConnectionState(this.rawValue);

  @override
  String toString() => "Invalid $DeviceConnectionState value $rawValue";
}
