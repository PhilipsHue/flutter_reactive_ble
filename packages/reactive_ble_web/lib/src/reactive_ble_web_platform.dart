import 'dart:async';
import 'dart:typed_data';
import 'package:collection/collection.dart';
import 'package:flutter_web_bluetooth/flutter_web_bluetooth.dart';
import 'package:reactive_ble_platform_interface/reactive_ble_platform_interface.dart';
import 'package:reactive_ble_web/src/model/connectedDeviceStreams.dart';
import 'package:reactive_ble_web/src/model/notifyingCharacteristicStream.dart';
import 'package:rxdart/rxdart.dart';

class ReactiveBleWebPlatform extends ReactiveBlePlatform {

  ReactiveBleWebPlatform();

  ///Initialise `FlutterWebBluetooth`
  late FlutterWebBluetoothInterface flutterWeb;

  ///LocalData of list of `BluetoothPairedDevices`
  List<BluetoothDevice> bluetoothDeviceList = [];
  List<ConnectedDeviceStreams> connectedDeviceStreams = [];
  List<NotifyingCharacteristicStream> notifyingCharaceristicStreams = [];

  ///`Streams`
  StreamController<ConnectionStateUpdate> connectionStreamController =
      StreamController.broadcast();
  StreamController<CharacteristicValue> charValueUpdateStreamController =
      StreamController.broadcast();

  ///[Implemented Methods]
  @override
  Future<void> initialize() async {
    flutterWeb = FlutterWebBluetooth.instance;
    bluetoothDeviceList.clear();
  }

  @override
  Future<void> deinitialize() async {
    bluetoothDeviceList.clear();
  }

  @override
  Stream<BleStatus> get bleStatusStream => flutterWeb.isAvailable
      .map((event) => event ? BleStatus.ready : BleStatus.unsupported);

  @override
  Stream<ScanResult> get scanStream {
    try {
      return flutterWeb.devices.where((event) => event.isNotEmpty).map((event) {
        event.forEach((element) {
          if (!bluetoothDeviceList.any((device) => device.id == element.id)) {
            bluetoothDeviceList.add(element);
          }
        });
        return event.map(setBluetoothToDiscoverdDevice);
      }).transform(SwitchMapStreamTransformer((i) => Stream.fromIterable(i)
          .map((d) => ScanResult(result: Result.success(d)))));
    } on Exception catch (e) {
      print(e);

      ///Few Browsers Does not Support `flutterweb.device` , so send them localList
      return Stream.fromIterable(
        bluetoothDeviceList.map((e) => ScanResult(
            result: Result.success(setBluetoothToDiscoverdDevice(e)))),
      );
    }
  }

  @override
  Stream<void> scanForDevices({
    required List<Uuid> withServices,
    required ScanMode scanMode,
    required bool requireLocationServicesEnabled,
  }) =>
      flutterWeb
          .requestDevice(RequestOptionsBuilder.acceptAllDevices(
              //optionalServices: getServicesList(serviceList: withServices)
              //add More Services here , maybe by an optionalServices parameter
              optionalServices: [
                BluetoothDefaultServiceUUIDS.GENERIC_ACCESS.uuid,
                BluetoothDefaultServiceUUIDS.deviceInformation.uuid,
                '0000180A-0000-1000-8000-00805f9b34fb',
                '0000180F-0000-1000-8000-00805f9b34fb',
                '0000FE59-0000-1000-8000-00805f9b34fb',
                '81F12000-59C5-4255-BAD2-7685CC587FD3',
              ]))
          .asStream();

  @override
  Stream<ConnectionStateUpdate> get connectionUpdateStream =>
      connectionStreamController.stream;

  @override
  Future<void> disconnectDevice(String deviceId) async {
    final device = bluetoothDeviceList
        .firstWhereOrNull((element) => element.id == deviceId);
    if (device != null) {
      device.disconnect();
      removeConnectionStream(device);
    }
  }

  @override
  Stream<void> connectToDevice(
    String id,
    Map<Uuid, List<Uuid>>? servicesWithCharacteristicsToDiscover,
    Duration? connectionTimeout,
  ) async* {
    final device =
        bluetoothDeviceList.firstWhereOrNull((element) => element.id == id);
    if (device == null) throw Exception('Device not found');
    yield* device
        .connect(timeout: connectionTimeout)
        .then((value) => addNewConnectionStream(device))
        .asStream();
  }

  @override
  Future<List<DiscoveredService>> discoverServices(String deviceId) async {
    final device = getDeviceById(deviceId);
    final services = await device.discoverServices();

    // ignore: prefer_final_locals
    var discoveredServices = <DiscoveredService>[];

    services.forEach((service) async {
      final characteristics = await service.getCharacteristics();

      final characteristicIds =
          characteristics.map((e) => Uuid.parse(e.uuid)).toList();

      final characteristicsList = characteristics
          .map((e) => DiscoveredCharacteristic(
              characteristicId: Uuid.parse(e.uuid),
              serviceId: Uuid.parse(service.uuid),
              isReadable: e.properties.read,
              isWritableWithResponse: e.properties.write,
              isWritableWithoutResponse: e.properties.writeWithoutResponse,
              isNotifiable: e.properties.notify,
              isIndicatable: e.properties.indicate))
          .toList();

      discoveredServices.add(DiscoveredService(
          serviceId: Uuid.parse(service.uuid),
          characteristicIds: characteristicIds,
          characteristics: characteristicsList));
    });

    return discoveredServices;
  }

  @override
  Future<WriteCharacteristicInfo> writeCharacteristicWithResponse(
    QualifiedCharacteristic characteristic,
    List<int> value,
  ) async {
    try {
      final bleCharacteristic = await getBleCharacteristics(characteristic);
      await bleCharacteristic.writeValueWithResponse(Uint8List.fromList(value));
      return WriteCharacteristicInfo(
          characteristic: characteristic, result: const Result.success(Unit()));
    } on Exception catch (e) {
      return WriteCharacteristicInfo(
          characteristic: characteristic,
          result: Result.failure(GenericFailure(
              code: WriteCharacteristicFailure.unknown,
              message: e.toString())));
    }
  }

  @override
  Future<WriteCharacteristicInfo> writeCharacteristicWithoutResponse(
    QualifiedCharacteristic characteristic,
    List<int> value,
  ) async {
    try {
      final bleCharacteristic = await getBleCharacteristics(characteristic);
      await bleCharacteristic
          .writeValueWithoutResponse(Uint8List.fromList(value));
      return WriteCharacteristicInfo(
          characteristic: characteristic, result: const Result.success(Unit()));
    } on Exception catch (e) {
      return WriteCharacteristicInfo(
          characteristic: characteristic,
          result: Result.failure(GenericFailure(
              code: WriteCharacteristicFailure.unknown,
              message: e.toString())));
    }
  }

  @override
  Stream<CharacteristicValue> get charValueUpdateStream =>
      charValueUpdateStreamController.stream;

  @override
  Stream<void> readCharacteristic(
      QualifiedCharacteristic characteristic) async* {
    final bleCharacteristic = await getBleCharacteristics(characteristic);
    final data = await bleCharacteristic.readValue();

    final list = List<int>.from(data.buffer.asUint8List());
    print(list);
    charValueUpdateStreamController.add(CharacteristicValue(
        characteristic: characteristic,
        result: Result.success(data.buffer.asUint8List())));
    yield* bleCharacteristic.readValue().asStream();
  }

  @override
  Stream<void> subscribeToNotifications(
    QualifiedCharacteristic characteristic,
  ) async* {
    final bleCharacteristic = await getBleCharacteristics(characteristic);
    addNewNotificationStream(bleCharacteristic, characteristic);
    yield* bleCharacteristic.startNotifications().asStream();
  }

  @override
  Future<void> stopSubscribingToNotifications(
    QualifiedCharacteristic characteristic,
  ) async {
    final bleCharacteristic = await getBleCharacteristics(characteristic);
    if (bleCharacteristic.isNotifying) {
      await bleCharacteristic.stopNotifications();
      removeNotificationStream(bleCharacteristic);
    }
  }

  ///`UnSupported Methods`
  @override
  Future<Result<Unit, GenericFailure<ClearGattCacheError>?>> clearGattCache(
      String deviceId) {
    throw UnimplementedError('clearGattCache() has not been implemented.');
  }

  @override
  Future<int> requestMtuSize(String deviceId, int? mtu) {
    throw UnimplementedError('requestMtuSize has not been implemented.');
  }

  @override
  Future<ConnectionPriorityInfo> requestConnectionPriority(
      String deviceId, ConnectionPriority priority) {
    throw UnimplementedError(
        'requesConnectionPriority has not been implemented.');
  }

  ///`Helper Methods`

  void addNewConnectionStream(BluetoothDevice device) {
    ///check if there is already any active subscription
    final connectedDeviceStreamsData = connectedDeviceStreams.firstWhereOrNull(
        (ConnectedDeviceStreams element) => element.deviceId == device.id);

    if (connectedDeviceStreamsData != null) {
      connectedDeviceStreamsData.stream.cancel();
      connectedDeviceStreams.remove(connectedDeviceStreamsData);
    }

    ///add new subscription
    // ignore: cancel_subscriptions
    StreamSubscription connectionSubscription;
    connectionSubscription = device.connected
        .map((bool event) => ConnectionStateUpdate(
            deviceId: device.id,
            connectionState: event
                ? DeviceConnectionState.connected
                : DeviceConnectionState.disconnected,
            failure: null))
        .listen((event) {
      connectionStreamController.add(event);
    });
    connectedDeviceStreams.add(ConnectedDeviceStreams(
        deviceId: device.id, stream: connectionSubscription));
  }

  void removeConnectionStream(BluetoothDevice device) {
    ///check if there is already any active subscription
    final connectedDeviceStreamsData = connectedDeviceStreams.firstWhereOrNull(
        (ConnectedDeviceStreams element) => element.deviceId == device.id);

    if (connectedDeviceStreamsData != null) {
      connectedDeviceStreamsData.stream.cancel();
      connectedDeviceStreams.remove(connectedDeviceStreamsData);
    }
  }

  void addNewNotificationStream(BluetoothCharacteristic characteristic,
      QualifiedCharacteristic qualifiedCharacteristic) {
    ///check if there is already any active subscription
    final notifyingCharacteristicStreamData = notifyingCharaceristicStreams
        .firstWhereOrNull((NotifyingCharacteristicStream element) =>
            element.characteristic.uuid == characteristic.uuid);

    if (notifyingCharacteristicStreamData != null) {
      notifyingCharacteristicStreamData.stream.cancel();
      notifyingCharaceristicStreams.remove(notifyingCharacteristicStreamData);
    }

    ///add new subscription
    // ignore: cancel_subscriptions
    StreamSubscription notificationSubscription;
    notificationSubscription = characteristic.value.listen((event) {
      print(event.buffer.asUint8List());
      charValueUpdateStreamController.add(CharacteristicValue(
          characteristic: qualifiedCharacteristic,
          result: Result.success(event.buffer.asUint8List())));
    });
    notifyingCharaceristicStreams.add(NotifyingCharacteristicStream(
        characteristic: characteristic, stream: notificationSubscription));
  }

  void removeNotificationStream(BluetoothCharacteristic characteristic) {
    ///check if there is already any active subscription
    final notifyingCharacteristicStreamData = notifyingCharaceristicStreams
        .firstWhereOrNull((NotifyingCharacteristicStream element) =>
            element.characteristic.uuid == characteristic.uuid);

    if (notifyingCharacteristicStreamData != null) {
      notifyingCharacteristicStreamData.stream.cancel();
      notifyingCharaceristicStreams.remove(notifyingCharacteristicStreamData);
    }
  }

  BluetoothDevice getDeviceById(String id) {
    final device =
        bluetoothDeviceList.firstWhereOrNull((element) => element.id == id);
    if (device == null) throw Exception('Device not found');
    return device;
  }

  Future<BluetoothCharacteristic> getBleCharacteristics(
      QualifiedCharacteristic characteristic) async {
    final device = getDeviceById(characteristic.deviceId);
    final services = await device.discoverServices();
    BluetoothCharacteristic? characteristicData;

    for (final service in services) {
      final characteristics = await service.getCharacteristics();
      if (characteristics.any((element) =>
          element.uuid == characteristic.characteristicId.toString())) {
        characteristicData = characteristics.firstWhereOrNull((element) =>
            element.uuid == characteristic.characteristicId.toString());
        return characteristicData!;
      }
    }

    if (characteristicData == null) throw Exception('Characteristic not found');
    return characteristicData;
  }

  List<String> getServicesList({List<Uuid> serviceList = const []}) {
    ///`Common UUID Lists`
    final commonList =
        BluetoothDefaultServiceUUIDS.VALUES.map((e) => e.uuid).toList();

    ///we need to provide list of services ,so that we can work with them later
    final providedList = serviceList.map((e) => e.toString()).toList();

    final finalList = commonList + providedList;

    return finalList;
  }

  DiscoveredDevice setBluetoothToDiscoverdDevice(BluetoothDevice device) {
    final uint8list = Uint8List(0);
    final serviceData = <Uuid, Uint8List>{};
    final uuidList = <Uuid>[];
    return DiscoveredDevice(
      id: device.id,
      name: device.name ?? '',
      serviceData: serviceData,
      manufacturerData: uint8list,
      rssi: 0,
      serviceUuids: uuidList,
    );
  }
}

class ReactiveBleWebPlatformFactory {
  const ReactiveBleWebPlatformFactory();
  ReactiveBleWebPlatform create() => ReactiveBleWebPlatform();
}
