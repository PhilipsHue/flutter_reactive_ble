import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/src/converter/protobuf_converter.dart';
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
import 'package:flutter_reactive_ble/src/prescan_connector.dart';
import 'package:flutter_reactive_ble/src/rx_ext/repeater.dart';
import 'package:flutter_reactive_ble/src/rx_ext/serial_disposable.dart';
import 'package:meta/meta.dart';

class FlutterReactiveBle {
  static final FlutterReactiveBle _sharedInstance = FlutterReactiveBle._();

  factory FlutterReactiveBle() => _sharedInstance;

  FlutterReactiveBle._() {
    _trackStatus();
  }

  final _methodChannel = const MethodChannel("flutter_reactive_ble_method");

  final scanRegistry = DiscoveredDevicesRegistry();

  BleStatus _status = BleStatus.unknown;

  final Stream<BleStatus> _statusStream =
      const EventChannel("flutter_reactive_ble_status")
          .receiveBroadcastStream()
          .cast<List<int>>()
          .map((data) => pb.BleStatusInfo.fromBuffer(data))
          .map(const ProtobufConverter().bleStatusFrom);

  PrescanConnector _prescanConnector;

  BleStatus get status => _status;

  Stream<BleStatus> get statusStream => Repeater(onListenEmitFrom: () async* {
        await initialize();
        yield _status;
        yield* _statusStream;
      }).stream;

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

  final Stream<ConnectionStateUpdate> connectedDeviceStream =
      const EventChannel("flutter_reactive_ble_connected_device")
          .receiveBroadcastStream()
          .cast<List<int>>()
          .map((data) => pb.DeviceInfo.fromBuffer(data))
          .map(const ProtobufConverter().connectionStateUpdateFrom)
            ..listen((_) {});

  final Stream<CharacteristicValue> characteristicValueStream =
      const EventChannel("flutter_reactive_ble_char_update")
          .receiveBroadcastStream()
          .cast<List<int>>()
          .map((data) => pb.CharacteristicValueInfo.fromBuffer(data))
          .map(const ProtobufConverter().characteristicValueFrom)
            ..listen((_) {});

  final SerialDisposable<Repeater<DiscoveredDevice>> _scanStreamDisposable =
      SerialDisposable((repeater) => repeater.dispose());

  Future<void> _initialization;

  ScanSession _currentScan;

  Future<void> initialize() async {
    _initialization ??= _methodChannel.invokeMethod("initialize");
    _prescanConnector = PrescanConnector(
      scanRegistry: scanRegistry,
      connectDevice: connectToDevice,
      scanDevices: scanForDevices,
      getCurrentScan: () => _currentScan,
      delayAfterScanFailure: const Duration(seconds: 10),
    );
    await _initialization;
  }

  Future<void> deinitialize() async {
    _initialization = null;
    await _methodChannel.invokeMethod<void>("deinitialize");
  }

  /// Reads the value of the specified characteristic.
  ///
  /// Be aware that a read request could be satisfied by a notification delivered for the same characteristic
  /// before the actual read response arrives (due to the design of iOS BLE API).
  ///
  /// The returned future completes with an error in case of a failure during reading.
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
              "scanForDevices", scanRequest.writeToBuffer());
        })
        .asStream()
        .asyncExpand((Object _) => scanRepeater.stream)
        .map((d) {
          scanRegistry.add(d.id);
          return d;
        });
  }

  Stream<ConnectionStateUpdate> connectToDevice({
    @required String id,
    Map<Uuid, List<Uuid>> servicesWithCharacteristicsToDiscover,
    Duration connectionTimeout,
  }) {
    final specificConnectedDeviceStream = connectedDeviceStream
        .where((update) => update.deviceId == id)
        .expand((update) =>
            update.connectionState != DeviceConnectionState.disconnected
                ? [update]
                : [update, null])
        .takeWhile((update) => update != null);

    final autoconnectingRepeater = Repeater.broadcast(
      onListenEmitFrom: () {
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
                ..characteristics.addAll(
                    characteristicIds.map((c) => pb.Uuid()..data = c.data)),
            );
          }
          args.servicesWithCharacteristicsToDiscover =
              pb.ServicesWithCharacteristics()..items.addAll(items);
        }
        return _methodChannel
            .invokeMethod<void>("connectToDevice", args.writeToBuffer())
            .asStream()
            .asyncExpand((Object _) => specificConnectedDeviceStream);
      },
      onCancel: () {
        final args = pb.DisconnectFromDeviceRequest()..deviceId = id;
        return _methodChannel.invokeMethod<void>(
            "disconnectFromDevice", args.writeToBuffer());
      },
    );

    return initialize()
        .asStream()
        .asyncExpand((_) => autoconnectingRepeater.stream);
  }

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
  /// which affects other notification streams created for the same characteristic.
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
