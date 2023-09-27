import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_web_bluetooth/flutter_web_bluetooth.dart';
import 'package:reactive_ble_platform_interface/reactive_ble_platform_interface.dart';
import 'package:reactive_ble_web/src/handlers/characteristics_handler.dart';
import 'package:reactive_ble_web/src/handlers/device_handler.dart';
import 'package:rxdart/rxdart.dart';

import 'handlers/connection_handler.dart';

class ReactiveBleWebPlatform extends ReactiveBlePlatform {
  ReactiveBleWebPlatform();

  ///Initialise `FlutterWebBluetooth`
  late FlutterWebBluetoothInterface flutterWeb;

  ///`Handlers`
  late DeviceHandler deviceHandler;
  late ConnectionHandler connectionHandler;
  late CharacteristicsHandler characteristicsHandler;

  ///`Streams`
  StreamController<ConnectionStateUpdate> connectionStreamController =
      StreamController.broadcast();
  BehaviorSubject<CharacteristicValue> charValueUpdateStreamController =
      BehaviorSubject<CharacteristicValue>();

  @override
  Future<void> initialize() async {
    flutterWeb = FlutterWebBluetooth.instance;
    deviceHandler = DeviceHandler();
    connectionHandler = ConnectionHandler(deviceHandler);
    characteristicsHandler = CharacteristicsHandler(deviceHandler);
  }

  @override
  Future<void> deinitialize() async {
    deviceHandler.reset();
    connectionHandler.reset();
    characteristicsHandler.reset();
  }

  @override
  Stream<BleStatus> get bleStatusStream => flutterWeb.isAvailable
      .map((event) => event ? BleStatus.ready : BleStatus.unsupported);

  @override
  Stream<ScanResult> get scanStream => deviceHandler.devices;

  @override
  Stream<void> scanForDevices({
    required List<Uuid> withServices,
    required ScanMode scanMode,
    required bool requireLocationServicesEnabled,
  }) =>
      flutterWeb
          .requestDevice(scanMode == ScanMode.opportunistic
              ? RequestOptionsBuilder([
                  RequestFilterBuilder(services: [
                    withServices.map((e) => e.toString()).toList().first
                  ])
                ],
                  optionalServices:
                      withServices.map((e) => e.toString()).toList())
              : RequestOptionsBuilder.acceptAllDevices(
                  optionalServices:
                      withServices.map((e) => e.toString()).toList()))
          .then((BluetoothDevice device) {
        print(device.name);
        deviceHandler.addDevice(device);
      }).asStream();

  @override
  Stream<ConnectionStateUpdate> get connectionUpdateStream =>
      connectionStreamController.stream;

  @override
  Future<void> disconnectDevice(String deviceId) async {
    deviceHandler.getDeviceById(deviceId).disconnect();
    await connectionHandler.removeConnectionStream(deviceId);
  }

  @override
  Stream<void> connectToDevice(
    String id,
    Map<Uuid, List<Uuid>>? servicesWithCharacteristicsToDiscover,
    Duration? connectionTimeout,
  ) =>
      connectionHandler
          .addConnectionStream(id,
              onData: (event) => connectionStreamController.add(event))
          .then((value) => deviceHandler
              .getDeviceById(id)
              .connect(timeout: connectionTimeout))
          .asStream();

  @override
  Future<List<DiscoveredService>> discoverServices(String deviceId) =>
      deviceHandler.getBleServices(deviceId);

  @override
  Future<WriteCharacteristicInfo> writeCharacteristicWithResponse(
    QualifiedCharacteristic characteristic,
    List<int> value,
  ) async {
    try {
      final bleCharacteristic =
          await deviceHandler.getBleCharacteristics(characteristic);
      await bleCharacteristic.writeValueWithResponse(Uint8List.fromList(value));
      return WriteCharacteristicInfo(
          characteristic: characteristic, result: const Result.success(Unit()));
    } on Exception catch (e) {
      print(e.toString());
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
      final bleCharacteristic =
          await deviceHandler.getBleCharacteristics(characteristic);
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
  Stream<void> readCharacteristic(QualifiedCharacteristic characteristic) =>
      deviceHandler
          .getBleCharacteristics(characteristic)
          .then((value) => value.readValue().then((data) =>
              charValueUpdateStreamController.add(CharacteristicValue(
                  characteristic: characteristic,
                  result: Result.success(data.buffer.asUint8List())))))
          .asStream();

  @override
  Stream<void> subscribeToNotifications(
    QualifiedCharacteristic characteristic,
  ) async* {
    final bleCharacteristic =
        await deviceHandler.getBleCharacteristics(characteristic);
    await characteristicsHandler.addCharacteristicStream(characteristic,
        onData: (event) => charValueUpdateStreamController.add(event));
    yield* bleCharacteristic.startNotifications().asStream();
  }

  @override
  Future<void> stopSubscribingToNotifications(
    QualifiedCharacteristic characteristic,
  ) async {
    final bleCharacteristic =
        await deviceHandler.getBleCharacteristics(characteristic);
    await bleCharacteristic.startNotifications();
    await characteristicsHandler.removeCharacteristicStream(characteristic);
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
}

class ReactiveBleWebPlatformFactory {
  const ReactiveBleWebPlatformFactory();
  ReactiveBleWebPlatform create() => ReactiveBleWebPlatform();
}
