import 'dart:async';
import 'dart:typed_data';

import 'package:bluez/bluez.dart';
import 'package:reactive_ble_platform_interface/reactive_ble_platform_interface.dart';

class ReactiveBleLinuxPlatform extends ReactiveBlePlatform {
  final _client = BlueZClient();
  StreamSubscription<BlueZAdapter>? _adapterAddedSubscription;
  StreamSubscription<BlueZAdapter>? _adapterRemovedSubscription;
  StreamSubscription<BlueZDevice>? _deviceAddedSubscription;
  StreamSubscription<BlueZDevice>? _deviceRemovedSubscription;
  final _scanController = StreamController<ScanResult>.broadcast();
  final _bleStatusController = StreamController<BleStatus>.broadcast();
  final _connectionUpdateController =
      StreamController<ConnectionStateUpdate>.broadcast();
  final _charValueUpdateController =
      StreamController<CharacteristicValue>.broadcast();
  BleStatus? _lastStatus;

  ReactiveBleLinuxPlatform() {
    _adapterAddedSubscription = _client.adapterAdded.listen(_adapterAdded);
    _adapterRemovedSubscription =
        _client.adapterRemoved.listen(_adapterRemoved);
    _deviceAddedSubscription = _client.deviceAdded.listen(_deviceAdded);
    _deviceRemovedSubscription = _client.deviceRemoved.listen(_deviceRemoved);

    // Ensure a new listener always gets the current status.
    _scanController.onListen = () {
      _client.devices.forEach(_sendDeviceState);
    };
    _bleStatusController.onListen = () {
      _lastStatus = null;
      _checkStatus();
    };
    _connectionUpdateController.onListen = () {
      _client.devices.forEach(_checkDeviceConnectionState);
    };
  }

  @override
  Stream<ScanResult> get scanStream => _scanController.stream;

  @override
  Stream<BleStatus> get bleStatusStream => _bleStatusController.stream;

  @override
  Stream<ConnectionStateUpdate> get connectionUpdateStream =>
      _connectionUpdateController.stream;

  @override
  Stream<CharacteristicValue> get charValueUpdateStream =>
      _charValueUpdateController.stream;

  @override
  Future<void> initialize() async {
    await _client.connect();
  }

  @override
  Future<void> deinitialize() async {
    await _adapterAddedSubscription?.cancel();
    await _adapterRemovedSubscription?.cancel();
    await _deviceAddedSubscription?.cancel();
    await _deviceRemovedSubscription?.cancel();
    await _client.close();
  }

  @override
  Stream<void> scanForDevices({
    required List<Uuid> withServices,
    required ScanMode scanMode,
    required bool requireLocationServicesEnabled,
  }) {
    final controller = StreamController<void>()
      ..onCancel = () {
        for (final adapter in _client.adapters) {
          adapter.stopDiscovery();
        }
      };

    for (final adapter in _client.adapters) {
      adapter
        ..setDiscoveryFilter(
            uuids: withServices.map((uuid) => uuid.toString()).toList())
        ..startDiscovery();
    }

    // Indicate have received request.
    controller
      ..add(null)
      ..close();

    return controller.stream;
  }

  @override
  Stream<void> connectToDevice(
    String id,
    Map<Uuid, List<Uuid>>? servicesWithCharacteristicsToDiscover,
    Duration? connectionTimeout,
  ) {
    final controller = StreamController<void>();

    controller.onListen = () {
      final device = _getDeviceWithId(id);
      if (device == null) {
        controller.addError('No such device $id');
      } else {
        device.connect();
        controller
          ..add(null)
          ..close();
      }
    };

    return controller.stream;
  }

  @override
  Future<void> disconnectDevice(String deviceId) async {
    final device = _getDeviceWithId(deviceId);
    if (device == null) {
      throw Exception('No such device $deviceId');
    }
    await device.disconnect();
  }

  @override
  Stream<void> readCharacteristic(QualifiedCharacteristic characteristic) {
    final controller = StreamController<void>();

    controller.onListen = () {
      final c = _getCharacteristic(characteristic);
      if (c == null) {
        controller.addError('No such characteristic');
      } else {
        c.readValue().then((value) {
          _charValueUpdateController.add(CharacteristicValue(
              characteristic: characteristic, result: Result.success(value)));
        }).catchError((Object error) {
          _charValueUpdateController.add(CharacteristicValue(
              characteristic: characteristic,
              result: Result.failure(GenericFailure(
                  code: CharacteristicValueUpdateError.unknown,
                  message: error.toString()))));
        });

        // Indicate have received request.
        controller
          ..add(null)
          ..close();
      }
    };

    return controller.stream;
  }

  @override
  Future<WriteCharacteristicInfo> writeCharacteristicWithResponse(
    QualifiedCharacteristic characteristic,
    List<int> value,
  ) async {
    final c = _getCharacteristic(characteristic);
    if (c == null) {
      throw Exception('No such characteristic');
    }

    await c.writeValue(value);

    return WriteCharacteristicInfo(
        characteristic: characteristic, result: const Result.success(Unit()));
  }

  @override
  Future<WriteCharacteristicInfo> writeCharacteristicWithoutResponse(
    QualifiedCharacteristic characteristic,
    List<int> value,
  ) async {
    final c = _getCharacteristic(characteristic);
    if (c == null) {
      throw Exception('No such characteristic');
    }

    await c.writeValue(value);

    return WriteCharacteristicInfo(
        characteristic: characteristic, result: const Result.success(Unit()));
  }

  @override
  Future<List<DiscoveredService>> discoverServices(String deviceId) async {
    final device = _getDeviceWithId(deviceId);
    if (device == null) {
      throw Exception('No such device $deviceId');
    }
    final services = <DiscoveredService>[];
    for (final service in device.gattServices) {
      services.add(DiscoveredService(
          serviceId: Uuid(service.uuid.value),
          characteristicIds:
              service.characteristics.map((c) => Uuid(c.uuid.value)).toList(),
          characteristics: service.characteristics
              .map((c) => DiscoveredCharacteristic(
                  characteristicId: Uuid(c.uuid.value),
                  serviceId: Uuid(service.uuid.value),
                  isReadable:
                      c.flags.contains(BlueZGattCharacteristicFlag.read),
                  isWritableWithResponse:
                      c.flags.contains(BlueZGattCharacteristicFlag.write),
                  isWritableWithoutResponse: c.flags.contains(
                      BlueZGattCharacteristicFlag.writeWithoutResponse),
                  isNotifiable:
                      c.flags.contains(BlueZGattCharacteristicFlag.notify),
                  isIndicatable:
                      c.flags.contains(BlueZGattCharacteristicFlag.indicate)))
              .toList()));
    }
    return services;
  }

  BlueZDevice? _getDeviceWithId(String id) {
    for (final device in _client.devices) {
      if (device.address == id) {
        return device;
      }
    }
    return null;
  }

  BlueZGattCharacteristic? _getCharacteristic(
      QualifiedCharacteristic characteristic) {
    final device = _getDeviceWithId(characteristic.deviceId);
    if (device == null) {
      return null;
    }
    for (final service in device.gattServices) {
      if (Uuid(service.uuid.value) != characteristic.serviceId) {
        continue;
      }
      for (final c in service.characteristics) {
        if (Uuid(c.uuid.value) == characteristic.characteristicId) {
          return c;
        }
      }
    }

    return null;
  }

  void _adapterAdded(BlueZAdapter adapter) {
    adapter.propertiesChanged
        .listen((List<String> properties) => _checkStatus());
    _checkStatus();
  }

  void _adapterRemoved(BlueZAdapter adapter) {
    _checkStatus();
  }

  void _deviceAdded(BlueZDevice device) {
    device.propertiesChanged
        .listen((properties) => _deviceChanged(device, properties));
    _deviceChanged(device, []);
  }

  void _deviceChanged(BlueZDevice device, List<String> properties) {
    _checkDeviceConnectionState(device);
    _sendDeviceState(device);
  }

  void _sendDeviceState(BlueZDevice device) {
    /// id: address -> path?
    final result = DiscoveredDevice(
        id: device.address,
        name: device.alias != '' ? device.alias : device.name,
        serviceData: const {},
        manufacturerData: Uint8List(0),
        rssi: device.rssi,
        serviceUuids: device.uuids.map((uuid) => Uuid(uuid.value)).toList());
    _scanController.add(ScanResult(result: Result.success(result)));
  }

  void _deviceRemoved(BlueZDevice device) {}

  // Check the status and update stream if it has changed.
  void _checkStatus() {
    final status = _getStatus();
    if (status != _lastStatus) {
      _lastStatus = status;
      _bleStatusController.add(status);
    }
  }

  // Get the current status.
  BleStatus _getStatus() {
    if (_client.adapters.isEmpty) {
      return BleStatus.unsupported;
    }

    for (final adapter in _client.adapters) {
      if (adapter.powered) {
        return BleStatus.ready;
      }
    }

    return BleStatus.poweredOff;
  }

  void _checkDeviceConnectionState(BlueZDevice device) {
    // FIXME: Only if changes?
    _connectionUpdateController.add(ConnectionStateUpdate(
        deviceId: device.address,
        connectionState: _getDeviceConnectionState(device),
        failure: null));
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

class ReactiveBleLinuxPlatformFactory {
  const ReactiveBleLinuxPlatformFactory();

  ReactiveBleLinuxPlatform create() => ReactiveBleLinuxPlatform();
}
