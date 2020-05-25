import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/src/converter/args_to_protubuf_converter.dart';
import 'package:flutter_reactive_ble/src/converter/protobuf_converter.dart';
import 'package:flutter_reactive_ble/src/device_connector.dart';
import 'package:flutter_reactive_ble/src/discovered_devices_registry.dart';
import 'package:flutter_reactive_ble/src/generated/bledata.pb.dart' as pb;
import 'package:flutter_reactive_ble/src/model/ble_status.dart';
import 'package:flutter_reactive_ble/src/model/characteristic_value.dart';
import 'package:flutter_reactive_ble/src/model/connection_priority.dart';
import 'package:flutter_reactive_ble/src/model/connection_state_update.dart';
import 'package:flutter_reactive_ble/src/model/discovered_device.dart';
import 'package:flutter_reactive_ble/src/model/qualified_characteristic.dart';
import 'package:flutter_reactive_ble/src/model/scan_mode.dart';
import 'package:flutter_reactive_ble/src/model/scan_session.dart';
import 'package:flutter_reactive_ble/src/model/uuid.dart';
import 'package:flutter_reactive_ble/src/plugin_controller.dart';
import 'package:flutter_reactive_ble/src/prescan_connector.dart';
import 'package:flutter_reactive_ble/src/rx_ext/repeater.dart';
import 'package:flutter_reactive_ble/src/rx_ext/serial_disposable.dart';
import 'package:meta/meta.dart';

/// [FlutterReactiveBle] is the facade of the library. Its interface allows to
/// perform all the supported BLE operations.
class FlutterReactiveBle {
  static final FlutterReactiveBle _sharedInstance = FlutterReactiveBle._();

  factory FlutterReactiveBle() => _sharedInstance;

  FlutterReactiveBle._() {
    _trackStatus();
  }

  /// Registry that keeps track of all BLE devices found during a BLE scan.
  final scanRegistry = DiscoveredDevicesRegistry.standard();

  /// A stream providing the host device BLE subsystem status updates.
  ///
  /// Also see [status].
  Stream<BleStatus> get statusStream => Repeater(onListenEmitFrom: () async* {
        await initialize();
        yield _status;
        yield* _statusStream;
      }).stream;

  /// Returns the current status of the BLE subsystem of the host device.
  ///
  /// Also see [statusStream].
  BleStatus get status => _status;

  /// A stream providing connection updates for all the connected BLE devices.
  final Stream<ConnectionStateUpdate> connectedDeviceStream =
      const EventChannel("flutter_reactive_ble_connected_device")
          .receiveBroadcastStream()
          .cast<List<int>>()
          .map((data) => pb.DeviceInfo.fromBuffer(data))
          .map(const ProtobufConverter().connectionStateUpdateFrom)
            ..listen((_) {});

  /// A stream providing value updates for all the connected BLE devices.
  ///
  /// The updates include read responses as well as notifications.
  final Stream<CharacteristicValue> characteristicValueStream =
      const EventChannel("flutter_reactive_ble_char_update")
          .receiveBroadcastStream()
          .cast<List<int>>()
          .map((data) => pb.CharacteristicValueInfo.fromBuffer(data))
          .map(const ProtobufConverter().characteristicValueFrom)
            ..listen((_) {});

  final _methodChannel = const MethodChannel("flutter_reactive_ble_method");

  PluginController _pluginController;

  BleStatus _status = BleStatus.unknown;

  final Stream<BleStatus> _statusStream =
      const EventChannel("flutter_reactive_ble_status")
          .receiveBroadcastStream()
          .cast<List<int>>()
          .map((data) => pb.BleStatusInfo.fromBuffer(data))
          .map(const ProtobufConverter().bleStatusFrom);

  PrescanConnector _prescanConnector;

  Future<void> _trackStatus() async {
    await initialize();
    _statusStream.listen((status) => _status = status);
  }

  final Stream<ScanResult> _scanStream =
      const EventChannel("flutter_reactive_ble_scan")
          .receiveBroadcastStream()
          .cast<List<int>>()
          .map((data) => pb.DeviceScanInfo.fromBuffer(data))
          .map(const ProtobufConverter().scanResultFrom);

  final SerialDisposable<Repeater<DiscoveredDevice>> _scanStreamDisposable =
      SerialDisposable((repeater) => repeater.dispose());

  Future<void> _initialization;

  ScanSession _currentScan;
  DeviceConnector _deviceConnector;

  /// Initializes this [FlutterReactiveBle] instance and its platform-specific
  /// counterparts.
  ///
  /// The initialization is performed automatically the first time any BLE
  /// operation is triggered.
  Future<void> initialize() async {
    _pluginController ??=
        PluginController(ArgsToProtobufConverter(), _methodChannel);
    _initialization ??= _methodChannel.invokeMethod("initialize");
    _deviceConnector ??= DeviceConnector(
      connectionStateUpdateStream: connectedDeviceStream,
      pluginController: _pluginController,
    );
    _prescanConnector = PrescanConnector(
      scanRegistry: scanRegistry,
      connectDevice: connectToDevice,
      scanDevices: scanForDevices,
      getCurrentScan: () => _currentScan,
      delayAfterScanFailure: const Duration(seconds: 10),
    );
    await _initialization;
  }

  /// Deinitializes this [FlutterReactiveBle] instance and its platform-specific
  /// counterparts.
  ///
  /// The deinitialization is automatically performed on Flutter Hot Restart.
  Future<void> deinitialize() async {
    _initialization = null;
    await _methodChannel.invokeMethod<void>("deinitialize");
  }

  /// Reads the value of the specified characteristic.
  ///
  /// The returned future completes with an error in case of a failure during reading.
  ///
  /// Be aware that a read request could be satisfied by a notification delivered
  /// for the same characteristic via [characteristicValueStream] before the actual
  /// read response arrives (due to the design of iOS BLE API).
  Future<List<int>> readCharacteristic(
      QualifiedCharacteristic characteristic) async {
    await initialize();

    final specificCharacteristicValueStream = characteristicValueStream
        .where((update) => update.characteristic == characteristic)
        .map((update) => update.result.dematerialize());

    final args = pb.ReadCharacteristicRequest()
      ..characteristic = (pb.CharacteristicAddress()
        ..deviceId = characteristic.deviceId
        ..serviceUuid = (pb.Uuid()..data = characteristic.serviceId.data)
        ..characteristicUuid =
            (pb.Uuid()..data = characteristic.characteristicId.data));

    return _methodChannel
        .invokeMethod<void>("readCharacteristic", args.writeToBuffer())
        .asStream()
        .asyncExpand((Object _) => specificCharacteristicValueStream)
        .firstWhere((_) => true,
            orElse: () => throw _NoBleCharacteristicDataReceived());
  }

  /// Writes a value to the specified characteristic awaiting for an acknowledgement.
  ///
  /// The returned future completes with an error in case of a failure during writing.
  Future<void> writeCharacteristicWithResponse(
    QualifiedCharacteristic characteristic, {
    @required List<int> value,
  }) async {
    await initialize();

    final args = pb.WriteCharacteristicRequest()
      ..characteristic = (pb.CharacteristicAddress()
        ..deviceId = characteristic.deviceId
        ..serviceUuid = (pb.Uuid()..data = characteristic.serviceId.data)
        ..characteristicUuid =
            (pb.Uuid()..data = characteristic.characteristicId.data))
      ..value = value;

    return _methodChannel
        .invokeMethod<List<int>>(
            "writeCharacteristicWithResponse", args.writeToBuffer())
        .then((data) => pb.WriteCharacteristicInfo.fromBuffer(data))
        .then(const ProtobufConverter().writeCharacteristicInfoFrom)
        .then((info) => info.result.dematerialize());
  }

  /// Writes a value to the specified characteristic without waiting for an acknowledgement.
  ///
  /// Use this method in case the  client does not need an acknowledgement
  /// that the write was successfully performed. For subsequent write operations it is
  /// recommended to execute a [writeCharacteristicWithResponse] each n times to make sure
  /// the BLE device is still responsive.
  ///
  /// The returned future completes with an error in case of a failure during writing.
  Future<void> writeCharacteristicWithoutResponse(
    QualifiedCharacteristic characteristic, {
    @required List<int> value,
  }) async {
    await initialize();

    final args = pb.WriteCharacteristicRequest()
      ..characteristic = (pb.CharacteristicAddress()
        ..deviceId = characteristic.deviceId
        ..serviceUuid = (pb.Uuid()..data = characteristic.serviceId.data)
        ..characteristicUuid =
            (pb.Uuid()..data = characteristic.characteristicId.data))
      ..value = value;

    return _methodChannel
        .invokeMethod<List<int>>(
            "writeCharacteristicWithoutResponse", args.writeToBuffer())
        .then((data) => pb.WriteCharacteristicInfo.fromBuffer(data))
        .then(const ProtobufConverter().writeCharacteristicInfoFrom)
        .then((info) => info.result.dematerialize());
  }

  /// Request a specific MTU for a connected device.
  ///
  /// Returns the actual MTU negotiated.
  ///
  /// For reference:
  ///
  /// * BLE 4.0–4.1 max ATT MTU is 23 bytes
  /// * BLE 4.2–5.1 max ATT MTU is 247 bytes
  Future<int> requestMtu({@required String deviceId, int mtu}) async {
    await initialize();

    final args = pb.NegotiateMtuRequest()
      ..deviceId = deviceId
      ..mtuSize = mtu;

    return _methodChannel
        .invokeMethod<List<int>>("negotiateMtuSize", args.writeToBuffer())
        .then((data) => pb.NegotiateMtuInfo.fromBuffer(data))
        .then((message) => message.mtuSize);
  }

  /// Requests for a connection parameter update on the connected device.
  ///
  /// Always completes with an error on iOS, as there is no way (and no need) to perform this operation on iOS.
  Future<void> requestConnectionPriority(
      {@required String deviceId,
      @required ConnectionPriority priority}) async {
    await initialize();

    final args = pb.ChangeConnectionPriorityRequest()
      ..deviceId = deviceId
      ..priority = convertPriorityToInt(priority);

    return _methodChannel
        .invokeMethod<List<int>>(
            "requestConnectionPriority", args.writeToBuffer())
        .then((data) => pb.ChangeConnectionPriorityInfo.fromBuffer(data))
        .then(const ProtobufConverter().connectionPriorityInfoFrom)
        .then((message) => message.result.dematerialize());
  }

  /// Scan for BLE peripherals advertising the services specified in [withServices]
  /// or for all BLE peripherals, if no services is specified. It is recommended to always specify some services.
  ///
  /// There are two Android specific parameters that are ignored on iOS:
  ///
  /// - [scanMode] allows to choose between different levels of power efficient and/or low latency scan modes.
  /// - [requireLocationServicesEnabled] specifies whether to check if location services are enabled before scanning.
  ///   When set to true and location services are disabled, an exception is thrown. Default is true.
  ///   Setting the value to false can result in not finding BLE peripherals on some Android devices.
  Stream<DiscoveredDevice> scanForDevices({
    @required List<Uuid> withServices,
    ScanMode scanMode = ScanMode.balanced,
    bool requireLocationServicesEnabled = true,
  }) {
    final completer = Completer<void>();
    _currentScan =
        ScanSession(withServices: withServices, future: completer.future);

    final scanRepeater = Repeater(
      onListenEmitFrom: () =>
          _scanStream.map((scan) => scan.result.dematerialize()).handleError(
        (Object e, StackTrace s) {
          if (!completer.isCompleted) {
            completer.completeError(e, s);
          }
        },
      ),
      onCancel: () async {
        if (Platform.isAndroid) {
          // Some devices have issues with establishing connection directly after scan is stopped so we should wait here.
          // See https://github.com/googlesamples/android-BluetoothLeGatt/issues/44
          await Future<void>.delayed(const Duration(milliseconds: 300));
        }
        _currentScan = null;
        if (!completer.isCompleted) {
          completer.complete();
        }
      },
    );

    _scanStreamDisposable.set(scanRepeater);

    final scanRequest = pb.ScanForDevicesRequest()
      ..scanMode = convertScanModeToArgs(scanMode)
      ..requireLocationServicesEnabled = requireLocationServicesEnabled;

    if (withServices != null) {
      for (final withService in withServices) {
        scanRequest.serviceUuids.add((pb.Uuid()..data = withService.data));
      }
    }

    return initialize()
        .then((_) {
          _methodChannel.invokeMethod<void>(
            "scanForDevices",
            scanRequest.writeToBuffer(),
          );
        })
        .asStream()
        .asyncExpand((Object _) => scanRepeater.stream)
        .map((d) {
          scanRegistry.add(d.id);
          return d;
        });
  }

  /// Establishes a connection to a BLE device.
  ///
  /// Disconnecting the device is achieved by cancelling the stream subscription.
  ///
  /// [id] is the unique device id of the BLE device: in iOS this is a uuid and on Android this is
  /// a Mac-Adress.
  /// Use [servicesWithCharacteristicsToDiscover] to scan only for the specific services mentioned in this map,
  /// this can improve the connection speed on iOS since no full service discovery will be executed. On Android
  /// this variable is ignored since partial discovery is not possible.
  /// The [connectionTimeout] parameter can be used to emit a failure after a certain period in case the connection
  /// is not established. The pending connection attempt will be cancelled. On Android when no timeout is specified
  /// the `autoConnect` flag is set in the [connectGatt()](https://developer.android.com/reference/android/bluetooth/BluetoothDevice#connectGatt(android.content.Context,%20boolean,%20android.bluetooth.BluetoothGattCallback)) call, otherwise it's cleared.```

  Stream<ConnectionStateUpdate> connectToDevice({
    @required String id,
    Map<Uuid, List<Uuid>> servicesWithCharacteristicsToDiscover,
    Duration connectionTimeout,
  }) =>
      initialize().asStream().asyncExpand(
            (_) => _deviceConnector.connect(
              id,
              servicesWithCharacteristicsToDiscover,
              connectionTimeout,
            ),
          );

  /// Scans for a specific device and connects to it in case a device containing the specified [id]
  /// is found and that is advertising the services specified in [withServices].
  ///
  /// Disconnecting the device is achieved by cancelling the stream subscription.
  ///
  /// The [prescanDuration] is the amount of time BLE disovery should run in order to find the device.
  /// Use [servicesWithCharacteristicsToDiscover] to scan only for the specific services mentioned in this map,
  /// this can improve the connection speed on iOS since no full service discovery will be executed. On Android
  /// this variable is ignored since partial discovery is not possible.
  /// The [connectionTimeout] parameter can be used to emit a failure after a certain period in case the connection
  /// is not established. The pending connection attempt will be cancelled.
  Stream<ConnectionStateUpdate> connectToAdvertisingDevice({
    @required String id,
    @required List<Uuid> withServices,
    @required Duration prescanDuration,
    Map<Uuid, List<Uuid>> servicesWithCharacteristicsToDiscover,
    Duration connectionTimeout,
  }) =>
      _prescanConnector.connectToAdvertisingDevice(
        id: id,
        withServices: withServices,
        prescanDuration: prescanDuration,
        servicesWithCharacteristicsToDiscover:
            servicesWithCharacteristicsToDiscover,
        connectionTimeout: connectionTimeout,
      );

  /// Clears GATT attribute cache on Android using undocumented API. Completes with an error in case of a failure.
  ///
  /// Always completes with an error on iOS, as there is no way (and no need) to perform this operation on iOS.
  ///
  /// The connection may need to be reestablished after successful GATT attribute cache clearing.
  Future<void> clearGattCache(String deviceId) {
    final args = pb.ClearGattCacheRequest()..deviceId = deviceId;
    return _methodChannel
        .invokeMethod<List<int>>("clearGattCache", args.writeToBuffer())
        .then((data) => pb.ClearGattCacheInfo.fromBuffer(data))
        .then(const ProtobufConverter().clearGattCacheResultFrom)
        .then((info) => info.dematerialize());
  }

  /// Subscribes to notifications for a characteristic.
  ///
  /// The current implementation unsubscribes from notifications when the returned stream is not listened to,
  /// which also affects other notification streams created for the same characteristic.
  Stream<List<int>> subscribeToCharacteristic(
      QualifiedCharacteristic characteristic) {
    final specificCharacteristicValueStream = characteristicValueStream
        .where((update) => update.characteristic == characteristic)
        .map((update) => update.result.dematerialize());

    final autosubscribingRepeater = Repeater<List<int>>.broadcast(
      onListenEmitFrom: () {
        final args = pb.NotifyCharacteristicRequest()
          ..characteristic = (pb.CharacteristicAddress()
            ..deviceId = characteristic.deviceId
            ..serviceUuid = (pb.Uuid()..data = characteristic.serviceId.data)
            ..characteristicUuid =
                (pb.Uuid()..data = characteristic.characteristicId.data));

        return _methodChannel
            .invokeMethod<void>("readNotifications", args.writeToBuffer())
            .asStream()
            .asyncExpand((Object _) => specificCharacteristicValueStream);
      },
      onCancel: () {
        final args = pb.NotifyNoMoreCharacteristicRequest()
          ..characteristic = (pb.CharacteristicAddress()
            ..deviceId = characteristic.deviceId
            ..serviceUuid = (pb.Uuid()..data = characteristic.serviceId.data)
            ..characteristicUuid =
                (pb.Uuid()..data = characteristic.characteristicId.data));
        return _methodChannel
            .invokeMethod<void>("stopNotifications", args.writeToBuffer())
            .catchError((Object e) =>
                print("Error unsubscribing from notifications: $e"));
      },
    );

    connectedDeviceStream
        .where((update) =>
            update.deviceId == characteristic.deviceId &&
            (update.connectionState == DeviceConnectionState.disconnecting ||
                update.connectionState == DeviceConnectionState.disconnected))
        .firstWhere((_) => true,
            orElse: () => throw _NoBleDeviceConnectionStateReceived())
        .then<void>((_) => autosubscribingRepeater.dispose());

    return initialize()
        .asStream()
        .asyncExpand((_) => autosubscribingRepeater.stream);
  }
}

class _NoBleCharacteristicDataReceived implements Exception {}

class _NoBleDeviceConnectionStateReceived implements Exception {}
