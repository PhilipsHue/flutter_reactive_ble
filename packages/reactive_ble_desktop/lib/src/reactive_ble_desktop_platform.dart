import 'dart:async';
import 'dart:typed_data';
import 'package:quick_blue/quick_blue.dart';
import 'package:reactive_ble_platform_interface/reactive_ble_platform_interface.dart';
import 'package:rxdart/rxdart.dart';

class ReactiveBleDesktopPlatform extends ReactiveBlePlatform {
  ReactiveBleDesktopPlatform();

  ///`Streams`
  StreamController<ConnectionStateUpdate> connectionStreamController =
      StreamController.broadcast();
  StreamController<CharacteristicValue> charValueUpdateStreamController =
      StreamController.broadcast();

  ///[Implemented Methods]
  @override
  Future<void> initialize() async {
    ///add connection
    QuickBlue.setConnectionHandler((deviceId, state) {
      connectionStreamController.add(ConnectionStateUpdate(
          deviceId: deviceId,
          connectionState: state == BlueConnectionState.connected
              ? DeviceConnectionState.connected
              : DeviceConnectionState.disconnected,
          failure: null));
    });

    ///Service Id not Available with Characteristic response
    QuickBlue.setValueHandler(
        (String deviceId, String characteristicId, Uint8List value) {
      charValueUpdateStreamController.add(CharacteristicValue(
          characteristic: QualifiedCharacteristic(
              characteristicId: Uuid.parse(characteristicId),
              serviceId: Uuid.parse(''),
              deviceId: deviceId),
          result: Result.success(value)));
    });
  }

  @override
  Future<void> deinitialize() async {
    QuickBlue.setConnectionHandler(null);
  }

  @override
  Stream<BleStatus> get bleStatusStream => QuickBlue.isBluetoothAvailable()
      .asStream()
      .map((event) => event ? BleStatus.ready : BleStatus.unsupported);

  @override
  Stream<ScanResult> get scanStream => QuickBlue.scanResultStream
      .doOnCancel(QuickBlue.stopScan)
      .map((BlueScanResult device) => ScanResult(
              result: Result.success(DiscoveredDevice(
            id: device.deviceId,
            name: device.name,
            serviceData: const {},
            manufacturerData: device.manufacturerData,
            rssi: device.rssi,
            serviceUuids: const [],
          ))));

  @override
  Stream<void> scanForDevices({
    required List<Uuid> withServices,
    required ScanMode scanMode,
    required bool requireLocationServicesEnabled,
  }) =>
      Future<void>.delayed(const Duration(microseconds: 10))
          .then((value) => QuickBlue.startScan())
          .asStream();

  @override
  Stream<ConnectionStateUpdate> get connectionUpdateStream =>
      connectionStreamController.stream;

  @override
  Future<void> disconnectDevice(String deviceId) async {
    QuickBlue.disconnect(deviceId);
  }

  @override
  Stream<void> connectToDevice(
    String id,
    Map<Uuid, List<Uuid>>? servicesWithCharacteristicsToDiscover,
    Duration? connectionTimeout,
  ) =>
      Future<void>.delayed(const Duration(microseconds: 10))
          .then((value) => QuickBlue.connect(id))
          .asStream();

  @override
  Future<List<DiscoveredService>> discoverServices(String deviceId) async {
    QuickBlue.discoverServices(deviceId);
    //not available for windows , but we can perform all tasks related to services
    // ignore: prefer_final_locals
    var discoveredServices = <DiscoveredService>[];
    QuickBlue.setServiceHandler((String device, String serviceId) {
      print('serviceId: $serviceId');
      if (device == deviceId) {
        discoveredServices.add(DiscoveredService(
            serviceId: Uuid.parse(serviceId),
            characteristicIds: [],
            characteristics: []));
      }
    });
    await Future<void>.delayed(const Duration(seconds: 1));
    QuickBlue.setServiceHandler(null);
    return discoveredServices;
  }

  @override
  Future<WriteCharacteristicInfo> writeCharacteristicWithResponse(
    QualifiedCharacteristic characteristic,
    List<int> value,
  ) async {
    await QuickBlue.writeValue(
        characteristic.deviceId,
        characteristic.serviceId.toString(),
        characteristic.characteristicId.toString(),
        Uint8List.fromList(value),
        BleOutputProperty.withResponse);
    return WriteCharacteristicInfo(
        characteristic: characteristic, result: const Result.success(Unit()));
  }

  @override
  Future<WriteCharacteristicInfo> writeCharacteristicWithoutResponse(
    QualifiedCharacteristic characteristic,
    List<int> value,
  ) async {
    await QuickBlue.writeValue(
        characteristic.deviceId,
        characteristic.serviceId.toString(),
        characteristic.characteristicId.toString(),
        Uint8List.fromList(value),
        BleOutputProperty.withoutResponse);
    return WriteCharacteristicInfo(
        characteristic: characteristic, result: const Result.success(Unit()));
  }

  @override
  Stream<CharacteristicValue> get charValueUpdateStream =>
      charValueUpdateStreamController.stream;

  @override
  Stream<void> readCharacteristic(QualifiedCharacteristic characteristic) =>
      QuickBlue.readValue(
              characteristic.deviceId,
              characteristic.serviceId.toString(),
              characteristic.characteristicId.toString())
          .asStream();

  @override
  Stream<void> subscribeToNotifications(
    QualifiedCharacteristic characteristic,
  ) =>
      QuickBlue.setNotifiable(
              characteristic.deviceId,
              characteristic.serviceId.toString(),
              characteristic.characteristicId.toString(),
              BleInputProperty.notification)
          .asStream();

  @override
  Future<void> stopSubscribingToNotifications(
    QualifiedCharacteristic characteristic,
  ) =>
      QuickBlue.setNotifiable(
          characteristic.deviceId,
          characteristic.serviceId.toString(),
          characteristic.characteristicId.toString(),
          BleInputProperty.disabled);

  @override
  Future<int> requestMtuSize(String deviceId, int? mtu) =>
      QuickBlue.requestMtu(deviceId, mtu ?? 242);

  ///`UnSupported Methods`
  @override
  Future<Result<Unit, GenericFailure<ClearGattCacheError>?>> clearGattCache(
      String deviceId) {
    throw UnimplementedError('clearGattCache() has not been implemented.');
  }

  @override
  Future<ConnectionPriorityInfo> requestConnectionPriority(
      String deviceId, ConnectionPriority priority) {
    throw UnimplementedError(
        'requesConnectionPriority has not been implemented.');
  }
}

class ReactiveBleDesktopPlatformFactory {
  const ReactiveBleDesktopPlatformFactory();
  ReactiveBleDesktopPlatform create() => ReactiveBleDesktopPlatform();
}
