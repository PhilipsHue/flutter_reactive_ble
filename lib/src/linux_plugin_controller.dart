import 'dart:async';
import 'dart:typed_data';

import 'package:bluez/bluez.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/model/uuid.dart';
import 'package:flutter_reactive_ble/src/model/write_characteristic_info.dart';
import 'package:meta/meta.dart';

import 'model/characteristic_value.dart';
import 'model/clear_gatt_cache_error.dart';
import 'model/connection_state_update.dart';
import 'model/discovered_service.dart';
import 'model/qualified_characteristic.dart';
import 'model/unit.dart';

import 'plugin_controller.dart';

class LinuxPluginController extends PluginController {
  final client = BlueZClient();
  BlueZDevice? _connectingDevice;

  final connectionUpdateController =
      StreamController<ConnectionStateUpdate>.broadcast();
  final charValueUpdateController = StreamController<CharacteristicValue>();
  final scanController = StreamController<ScanResult>();
  final bleStatusController = StreamController<BleStatus>.broadcast();
  final notificationsController = StreamController<void>();

  @override
  Stream<ConnectionStateUpdate> get connectionUpdateStream =>
      connectionUpdateController.stream;

  @override
  Stream<CharacteristicValue> get charValueUpdateStream =>
      charValueUpdateController.stream;

  @override
  Stream<ScanResult> get scanStream => scanController.stream;

  @override
  Stream<BleStatus> get bleStatusStream => bleStatusController.stream;

  @override
  Future<void> initialize() async {
    print('initialize');
    client.deviceAddedStream.listen((device) {
      device.propertiesChangedStream.listen((name) {
        print('${device.address} ${name}');
      });
    });
    client.deviceRemovedStream.listen((device) {});
    await client.connect();

    connectionUpdateController.onListen = () {
      print('CONNECTION UPDATE');

      /// Send current state for new listeners.
      for (var device in client.devices) {
        connectionUpdateController.add(ConnectionStateUpdate(
            deviceId: device.address,
            connectionState: _getDeviceConnectionState(device),
            failure: null));
      }
    };
    scanController.onListen = () {
      print('SCAN');
      Future(() {
        /// Send current devices for new listeners.
        for (var device in client.devices) {
          /// id: address -> path?
          var result = DiscoveredDevice(
              id: device.address,
              name: device.name,
              serviceData: {},
              manufacturerData: Uint8List(0),
              rssi: device.rssi);
          scanController.add(ScanResult(result: Result.success(result)));
        }
      });
    };
    bleStatusController.onListen = () {
      Future(() {
        bleStatusController.add(_getStatus());
      });
    };
  }

  @override
  Future<void> deinitialize() async {
    print('deinitialize');
    client.close();
  }

  // FIXME async*?
  @override
  Stream<void> scanForDevices({
    required List<Uuid> withServices,
    required ScanMode? scanMode,
    required bool? requireLocationServicesEnabled,
  }) {
    print('scanForDevices ${withServices} ${scanMode}');
    var controller = StreamController<void>();
    controller.onListen = () {
      print('SCAN FOR DEVICES');
      controller.add(null);
    };
    controller.onCancel = () {
      print('CANCEL SCAN');
    };
    return controller.stream;
  }

  @override
  Stream<void> connectToDevice(
      String id,
      Map<Uuid, List<Uuid>>? servicesWithCharacteristicsToDiscover,
      Duration? connectionTimeout) {
    print('connectToDevice ${id}');
    _connectingDevice = _getDeviceWithId(id);
    var controller = StreamController<void>();
    controller.onListen = () {
      print('CONNECT TO DEVICE ${id}');
      var device = _getDeviceWithId(id);
      device.connect();
      controller.add(null);
    };
    return controller.stream;
  }

  @override
  Future<void> disconnectDevice(String deviceId) async {
    print('disconnectDevice ${deviceId}');
    var device = _getDeviceWithId(deviceId);
    await device.disconnect();
  }

  @override
  Stream<void> readCharacteristic(QualifiedCharacteristic characteristic) {
    var controller = StreamController<void>();
    return controller.stream;
  }

  @override
  Future<WriteCharacteristicInfo> writeCharacteristicWithResponse(
      QualifiedCharacteristic characteristic, List<int> value) async {
    var failure = GenericFailure<WriteCharacteristicFailure>(
      code: WriteCharacteristicFailure.unknown,
      message: 'not implemented',
    );
    return WriteCharacteristicInfo(
        characteristic: characteristic,
        result:
            Result<Unit, GenericFailure<WriteCharacteristicFailure>?>.failure(
                failure));
  }

  @override
  Future<WriteCharacteristicInfo> writeCharacteristicWithoutResponse(
    QualifiedCharacteristic characteristic,
    List<int> value,
  ) async {
    var failure = GenericFailure<WriteCharacteristicFailure>(
      code: WriteCharacteristicFailure.unknown,
      message: 'not implemented',
    );
    return WriteCharacteristicInfo(
        characteristic: characteristic,
        result:
            Result<Unit, GenericFailure<WriteCharacteristicFailure>?>.failure(
                failure));
  }

  @override
  Stream<void> subscribeToNotifications(
      QualifiedCharacteristic characteristic) {
    return notificationsController.stream;
  }

  @override
  Future<void> stopSubscribingToNotifications(
      QualifiedCharacteristic characteristic) async {}

  @override
  Future<int> requestMtuSize(String deviceId, int? mtu) async {
    return 0;
  }

  @override
  Future<ConnectionPriorityInfo> requestConnectionPriority(
      String deviceId, ConnectionPriority priority) async {
    var failure = GenericFailure<ConnectionPriorityFailure>(
      code: ConnectionPriorityFailure.unknown,
      message: 'not implemented',
    );
    return ConnectionPriorityInfo(
        result:
            Result<void, GenericFailure<ConnectionPriorityFailure>?>.failure(
                failure));
  }

  @override
  Future<Result<Unit, GenericFailure<ClearGattCacheError>?>> clearGattCache(
      String deviceId) async {
    var failure = GenericFailure<ClearGattCacheError>(
      code: ClearGattCacheError.unknown,
      message: 'not implemented',
    );
    return Result<Unit, GenericFailure<ClearGattCacheError>?>.failure(failure);
  }

  @override
  Future<List<DiscoveredService>> discoverServices(String deviceId) async {
    print('discoverServices ${deviceId}');
    var device = _getDeviceWithId(deviceId);
    var services = <DiscoveredService>[];
    for (var service in device.gattServices) {
      services.add(DiscoveredService(
          serviceId: Uuid.parse(service.uuid.id),
          characteristicIds: service.gattCharacteristics
              .map((c) => Uuid.parse(c.uuid.id))
              .toList()));
    }
    return services;
  }

  BleStatus _getStatus() {
    if (client.adapters.isEmpty) {
      return BleStatus.unsupported;
    }

    for (var adapter in client.adapters) {
      if (adapter.powered) {
        return BleStatus.ready;
      }
    }

    return BleStatus.poweredOff;
  }

  BlueZDevice _getDeviceWithId(String id) {
    return client.devices.firstWhere((d) => d.address == id);
  }

  DeviceConnectionState _getDeviceConnectionState(BlueZDevice device) {
    if (device.connected) {
      // FIXME: May be disconnecting
      return DeviceConnectionState.connected;
    } else {
      // FIXME: May be connecting
      return DeviceConnectionState.disconnected;
    }
  }
}
