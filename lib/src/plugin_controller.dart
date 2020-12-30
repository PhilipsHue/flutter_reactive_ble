import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/converter/args_to_protubuf_converter.dart';
import 'package:flutter_reactive_ble/src/debug_logger.dart';
import 'package:flutter_reactive_ble/src/model/uuid.dart';
import 'package:flutter_reactive_ble/src/model/write_characteristic_info.dart';
import 'package:meta/meta.dart';

import 'converter/protobuf_converter.dart';
import 'model/characteristic_value.dart';
import 'model/clear_gatt_cache_error.dart';
import 'model/connection_state_update.dart';
import 'model/discovered_service.dart';
import 'model/qualified_characteristic.dart';
import 'model/unit.dart';

abstract class DeviceOperationController {
  Stream<CharacteristicValue> get charValueUpdateStream;

  Future<List<DiscoveredService>> discoverServices(String deviceId);

  Stream<void> readCharacteristic(QualifiedCharacteristic characteristic);

  Future<WriteCharacteristicInfo> writeCharacteristicWithResponse(
    QualifiedCharacteristic characteristic,
    List<int> value,
  );

  Future<WriteCharacteristicInfo> writeCharacteristicWithoutResponse(
    QualifiedCharacteristic characteristic,
    List<int> value,
  );

  Stream<void> subscribeToNotifications(
    QualifiedCharacteristic characteristic,
  );

  Future<void> stopSubscribingToNotifications(
    QualifiedCharacteristic characteristic,
  );

  Future<int> requestMtuSize(String deviceId, int? mtu);

  Future<ConnectionPriorityInfo> requestConnectionPriority(
      String deviceId, ConnectionPriority priority);
}

abstract class ScanOperationController {
  Stream<ScanResult> get scanStream;

  Stream<void> scanForDevices({
    required List<Uuid> withServices,
    required ScanMode? scanMode,
    required bool? requireLocationServicesEnabled,
  });
}

abstract class DeviceConnectionController {
  Stream<ConnectionStateUpdate> get connectionUpdateStream;

  Stream<void> connectToDevice(
    String id,
    Map<Uuid, List<Uuid>>? servicesWithCharacteristicsToDiscover,
    Duration? connectionTimeout,
  );

  Future<void> disconnectDevice(String deviceId);
}

abstract class BleOperationController {
  Stream<BleStatus> get bleStatusStream;

  Future<void> initialize();

  Future<void> deinitialize();

  Future<Result<Unit, GenericFailure<ClearGattCacheError>?>> clearGattCache(
      String deviceId);
}

class PluginController
    implements
        DeviceOperationController,
        ScanOperationController,
        DeviceConnectionController,
        BleOperationController {
  PluginController({
    required ArgsToProtobufConverter argsToProtobufConverter,
    required ProtobufConverter protobufConverter,
    required MethodChannel bleMethodChannel,
    required Stream<List<int>> connectedDeviceChannel,
    required Stream<List<int>> charUpdateChannel,
    required Stream<List<int>> bleDeviceScanChannel,
    required Stream<List<int>> bleStatusChannel,
    required Logger debugLogger,
  })  : assert(argsToProtobufConverter != null),
        assert(protobufConverter != null),
        assert(bleMethodChannel != null),
        assert(connectedDeviceChannel != null),
        assert(bleDeviceScanChannel != null),
        assert(bleStatusChannel != null),
        assert(charUpdateChannel != null),
        assert(debugLogger != null),
        _argsToProtobufConverter = argsToProtobufConverter,
        _protobufConverter = protobufConverter,
        _bleMethodChannel = bleMethodChannel,
        _connectedDeviceRawStream = connectedDeviceChannel,
        _charUpdateRawStream = charUpdateChannel,
        _bleStatusRawChannel = bleStatusChannel,
        _bleDeviceScanRawStream = bleDeviceScanChannel,
        _debugLogger = debugLogger;

  final ArgsToProtobufConverter _argsToProtobufConverter;
  final ProtobufConverter _protobufConverter;
  final MethodChannel _bleMethodChannel;
  final Stream<List<int>> _connectedDeviceRawStream;
  final Stream<List<int>> _charUpdateRawStream;
  final Stream<List<int>> _bleDeviceScanRawStream;
  final Stream<List<int>> _bleStatusRawChannel;
  final Logger _debugLogger;

  Stream<ConnectionStateUpdate>? _connectionUpdateStream;
  Stream<CharacteristicValue>? _charValueStream;
  Stream<ScanResult>? _scanResultStream;
  Stream<BleStatus>? _bleStatusStream;

  @override
  Stream<ConnectionStateUpdate> get connectionUpdateStream =>
      _connectionUpdateStream ??= _connectedDeviceRawStream
          .map(_protobufConverter.connectionStateUpdateFrom)
          .map(
        (update) {
          _debugLogger.log(
            'Received $ConnectionStateUpdate(deviceId: ${update.deviceId}, connectionState: ${update.connectionState}, failure: ${update.failure})',
          );
          return update;
        },
      );

  @override
  Stream<CharacteristicValue> get charValueUpdateStream =>
      _charValueStream ??= _charUpdateRawStream
          .map(_protobufConverter.characteristicValueFrom)
          .map(
        (update) {
          _debugLogger.log(
              'Received $CharacteristicValue(characteristic: ${update.characteristic}, result: ${update.runtimeType})');
          return update;
        },
      );

  @override
  Stream<ScanResult> get scanStream => _scanResultStream ??=
          _bleDeviceScanRawStream.map(_protobufConverter.scanResultFrom).map(
        (scanResult) {
          _debugLogger
              .log('Received $ScanResult(result: ${scanResult.result})');
          return scanResult;
        },
      );

  @override
  Stream<BleStatus> get bleStatusStream =>
      _bleStatusStream ??= _bleStatusRawChannel
          .map(_protobufConverter.bleStatusFrom)
          .map((status) {
        _debugLogger.log('Received ble status update: $status');
        return status;
      });

  @override
  Future<void> initialize() {
    _debugLogger.log('Initialize ble client');
    return _bleMethodChannel.invokeMethod("initialize");
  }

  @override
  Future<void> deinitialize() {
    _debugLogger.log('DeIititialize ble client');
    return _bleMethodChannel.invokeMethod<void>("deinitialize");
  }

  @override
  Stream<void> scanForDevices({
    required List<Uuid> withServices,
    required ScanMode? scanMode,
    required bool? requireLocationServicesEnabled,
  }) {
    _debugLogger.log(
      'Start scanning for devices with arguments (withServices:$withServices, scanMode: $scanMode, locationServiceEnabled: $requireLocationServicesEnabled)',
    );
    return _bleMethodChannel
        .invokeMethod<void>(
          "scanForDevices",
          _argsToProtobufConverter
              .createScanForDevicesRequest(
                withServices: withServices,
                scanMode: scanMode,
                requireLocationServicesEnabled: requireLocationServicesEnabled,
              )
              .writeToBuffer(),
        )
        .asStream();
  }

  @override
  Stream<void> connectToDevice(
    String id,
    Map<Uuid, List<Uuid>>? servicesWithCharacteristicsToDiscover,
    Duration? connectionTimeout,
  ) {
    _debugLogger.log(
      'Start connecting to device with arguments (deviceId: $id, servicesWithCharacteristicsToDiscover: $servicesWithCharacteristicsToDiscover, timeout: $connectionTimeout)',
    );
    return _bleMethodChannel
        .invokeMethod<void>(
          "connectToDevice",
          _argsToProtobufConverter
              .createConnectToDeviceArgs(
                id,
                servicesWithCharacteristicsToDiscover,
                connectionTimeout,
              )
              .writeToBuffer(),
        )
        .asStream();
  }

  @override
  Future<void> disconnectDevice(String deviceId) {
    _debugLogger.log('Disconnect from device $deviceId');
    return _bleMethodChannel.invokeMethod<void>(
      "disconnectFromDevice",
      _argsToProtobufConverter
          .createDisconnectDeviceArgs(deviceId)
          .writeToBuffer(),
    );
  }

  @override
  Stream<void> readCharacteristic(QualifiedCharacteristic characteristic) {
    _debugLogger.log('Read characteristic $characteristic');
    return _bleMethodChannel
        .invokeMethod<void>(
          "readCharacteristic",
          _argsToProtobufConverter
              .createReadCharacteristicRequest(characteristic)
              .writeToBuffer(),
        )
        .asStream();
  }

  @override
  Future<WriteCharacteristicInfo> writeCharacteristicWithResponse(
    QualifiedCharacteristic characteristic,
    List<int> value,
  ) async {
    _debugLogger.log('Write with response to $characteristic, value: $value');
    return _bleMethodChannel
        .invokeMethod<List<int>>(
            "writeCharacteristicWithResponse",
            _argsToProtobufConverter
                .createWriteChacracteristicRequest(characteristic, value)
                .writeToBuffer())
        .then(_protobufConverter.writeCharacteristicInfoFrom as FutureOr<WriteCharacteristicInfo> Function(List<int>?));
  }

  @override
  Future<WriteCharacteristicInfo> writeCharacteristicWithoutResponse(
    QualifiedCharacteristic characteristic,
    List<int> value,
  ) async {
    _debugLogger
        .log('Write without response to $characteristic, value: $value');
    return _bleMethodChannel
        .invokeMethod<List<int>>(
          "writeCharacteristicWithoutResponse",
          _argsToProtobufConverter
              .createWriteChacracteristicRequest(characteristic, value)
              .writeToBuffer(),
        )
        .then(_protobufConverter.writeCharacteristicInfoFrom as FutureOr<WriteCharacteristicInfo> Function(List<int>?));
  }

  @override
  Stream<void> subscribeToNotifications(
    QualifiedCharacteristic characteristic,
  ) {
    _debugLogger.log('Start subscribing to notifications for $characteristic');
    return _bleMethodChannel
        .invokeMethod<void>(
          "readNotifications",
          _argsToProtobufConverter
              .createNotifyCharacteristicRequest(characteristic)
              .writeToBuffer(),
        )
        .asStream();
  }

  @override
  Future<void> stopSubscribingToNotifications(
    QualifiedCharacteristic characteristic,
  ) {
    _debugLogger.log('Stop subscribing to notifications for $characteristic');

    return _bleMethodChannel
        .invokeMethod<void>(
          "stopNotifications",
          _argsToProtobufConverter
              .createNotifyNoMoreCharacteristicRequest(characteristic)
              .writeToBuffer(),
        )
        .catchError(
          (Object e) => print("Error unsubscribing from notifications: $e"),
        );
  }

  @override
  Future<int> requestMtuSize(String deviceId, int? mtu) async {
    _debugLogger
        .log('Request mtu size for device: $deviceId with mtuSize: $mtu');
    return _bleMethodChannel
        .invokeMethod<List<int>>(
          "negotiateMtuSize",
          _argsToProtobufConverter
              .createNegotiateMtuRequest(deviceId, mtu!)
              .writeToBuffer(),
        )
        .then(_protobufConverter.mtuSizeFrom);
  }

  @override
  Future<ConnectionPriorityInfo> requestConnectionPriority(
      String deviceId, ConnectionPriority priority) {
    _debugLogger.log(
        'Request connection priority for device: $deviceId, priority: $priority');
    return _bleMethodChannel
        .invokeMethod<List<int>>(
          "requestConnectionPriority",
          _argsToProtobufConverter
              .createChangeConnectionPrioRequest(deviceId, priority)
              .writeToBuffer(),
        )
        .then(_protobufConverter.connectionPriorityInfoFrom as FutureOr<ConnectionPriorityInfo> Function(List<int>?));
  }

  @override
  Future<Result<Unit, GenericFailure<ClearGattCacheError>?>> clearGattCache(
      String deviceId) {
    _debugLogger.log('Clear gatt cache for device: $deviceId');
    return _bleMethodChannel
        .invokeMethod<List<int>>(
          "clearGattCache",
          _argsToProtobufConverter
              .createClearGattCacheRequest(deviceId)
              .writeToBuffer(),
        )
        .then(_protobufConverter.clearGattCacheResultFrom as FutureOr<Result<Unit, GenericFailure<ClearGattCacheError>?>> Function(List<int>?));
  }

  @override
  Future<List<DiscoveredService>> discoverServices(String deviceId) async =>
      _bleMethodChannel
          .invokeMethod<List<int>>(
            'discoverServices',
            _argsToProtobufConverter
                .createDiscoverServicesRequest(deviceId)
                .writeToBuffer(),
          )
          .then(_protobufConverter.discoveredServicesFrom as FutureOr<List<DiscoveredService>> Function(List<int>?));
}

class PluginControllerFactory {
  const PluginControllerFactory();

  PluginController create(Logger logger) {
    const _bleMethodChannel = MethodChannel("flutter_reactive_ble_method");

    const connectedDeviceChannel =
        EventChannel("flutter_reactive_ble_connected_device");
    const charEventChannel = EventChannel("flutter_reactive_ble_char_update");
    const scanEventChannel = EventChannel("flutter_reactive_ble_scan");
    const bleStatusChannel = EventChannel("flutter_reactive_ble_status");

    return PluginController(
      protobufConverter: const ProtobufConverterImpl(),
      argsToProtobufConverter: const ArgsToProtobufConverterImpl(),
      bleMethodChannel: _bleMethodChannel,
      connectedDeviceChannel:
          connectedDeviceChannel.receiveBroadcastStream().cast<List<int>>(),
      charUpdateChannel:
          charEventChannel.receiveBroadcastStream().cast<List<int>>(),
      bleDeviceScanChannel:
          scanEventChannel.receiveBroadcastStream().cast<List<int>>(),
      bleStatusChannel:
          bleStatusChannel.receiveBroadcastStream().cast<List<int>>(),
      debugLogger: logger,
    );
  }
}
