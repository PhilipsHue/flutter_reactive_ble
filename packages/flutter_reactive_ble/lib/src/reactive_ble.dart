import 'dart:async';
import 'dart:io';

import 'package:flutter_reactive_ble/src/connected_device_operation.dart';
import 'package:flutter_reactive_ble/src/debug_logger.dart';
import 'package:flutter_reactive_ble/src/device_connector.dart';
import 'package:flutter_reactive_ble/src/device_scanner.dart';
import 'package:flutter_reactive_ble/src/discovered_devices_registry.dart';
import 'package:flutter_reactive_ble/src/rx_ext/repeater.dart';
import 'package:meta/meta.dart';
import 'package:reactive_ble_mobile/reactive_ble_mobile.dart';
import 'package:reactive_ble_platform_interface/reactive_ble_platform_interface.dart';

/// [FlutterReactiveBle] is the facade of the library. Its interface allows to
/// perform all the supported BLE operations.
class FlutterReactiveBle {
  static final FlutterReactiveBle _sharedInstance = FlutterReactiveBle._();

  factory FlutterReactiveBle() => _sharedInstance;

  ///Create a new instance where injected depedencies are used.
  @visibleForTesting
  FlutterReactiveBle.witDependencies({
    required DeviceScanner deviceScanner,
    required DeviceConnector deviceConnector,
    required ConnectedDeviceOperation connectedDeviceOperation,
    required Logger debugLogger,
    required Future<void> initialization,
    required ReactiveBlePlatform reactiveBlePlatform,
  }) {
    _deviceScanner = deviceScanner;
    _deviceConnector = deviceConnector;
    _connectedDeviceOperator = connectedDeviceOperation;
    _debugLogger = debugLogger;
    _initialization = initialization;
    _blePlatform = reactiveBlePlatform;
    _trackStatus();
  }

  FlutterReactiveBle._() {
    _trackStatus();
  }

  /// Registry that keeps track of all BLE devices found during a BLE scan.
  final scanRegistry = DiscoveredDevicesRegistryImpl.standard();

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
  Stream<ConnectionStateUpdate> get connectedDeviceStream =>
      Repeater(onListenEmitFrom: () async* {
        await initialize();
        yield* _deviceConnector.deviceConnectionStateUpdateStream;
      }).stream.asBroadcastStream()
        ..listen((_) {});

  /// A stream providing value updates for all the connected BLE devices.
  ///
  /// The updates include read responses as well as notifications.
  Stream<CharacteristicValue> get characteristicValueStream async* {
    await initialize();
    yield* _connectedDeviceOperator.characteristicValueStream;
  }

  late ReactiveBlePlatform _blePlatform;

  BleStatus _status = BleStatus.unknown;

  Stream<BleStatus> get _statusStream => _blePlatform.bleStatusStream;

  Future<void> _trackStatus() async {
    await initialize();
    _statusStream.listen((status) => _status = status);
  }

  Future<void>? _initialization;

  late DeviceConnector _deviceConnector;
  late ConnectedDeviceOperation _connectedDeviceOperator;
  late DeviceScanner _deviceScanner;
  late Logger _debugLogger;

  /// Initializes this [FlutterReactiveBle] instance and its platform-specific
  /// counterparts.
  ///
  /// The initialization is performed automatically the first time any BLE
  /// operation is triggered.
  Future<void> initialize() async {
    if (_initialization == null) {
      _debugLogger = DebugLogger(
        'REACTIVE_BLE',
        print,
      );

      ReactiveBlePlatform.instance =
          const ReactiveBleMobilePlatformFactory().create(
        logger: _debugLogger,
      );

      _blePlatform = ReactiveBlePlatform.instance;

      _initialization ??= _blePlatform.initialize();

      _connectedDeviceOperator = ConnectedDeviceOperationImpl(
        blePlatform: _blePlatform,
      );
      _deviceScanner = DeviceScannerImpl(
        blePlatform: _blePlatform,
        platformIsAndroid: () => Platform.isAndroid,
        delayAfterScanCompletion: Future<void>.delayed(
          const Duration(milliseconds: 300),
        ),
        addToScanRegistry: scanRegistry.add,
      );

      _deviceConnector = DeviceConnectorImpl(
        blePlatform: _blePlatform,
        deviceIsDiscoveredRecently: scanRegistry.deviceIsDiscoveredRecently,
        deviceScanner: _deviceScanner,
        delayAfterScanFailure: const Duration(seconds: 10),
      );

      await _initialization;
    }
  }

  /// Deinitializes this [FlutterReactiveBle] instance and its platform-specific
  /// counterparts.
  ///
  /// The deinitialization is automatically performed on Flutter Hot Restart.
  Future<void> deinitialize() async {
    if (_initialization != null) {
      _initialization = null;
      await _blePlatform.deinitialize();
    }
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
    return _connectedDeviceOperator.readCharacteristic(characteristic);
  }

  /// Writes a value to the specified characteristic awaiting for an acknowledgement.
  ///
  /// The returned future completes with an error in case of a failure during writing.
  Future<void> writeCharacteristicWithResponse(
    QualifiedCharacteristic characteristic, {
    required List<int> value,
  }) async {
    await initialize();
    return _connectedDeviceOperator.writeCharacteristicWithResponse(
      characteristic,
      value: value,
    );
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
    required List<int> value,
  }) async {
    await initialize();
    return _connectedDeviceOperator.writeCharacteristicWithoutResponse(
      characteristic,
      value: value,
    );
  }

  /// Request a specific MTU for a connected device.
  ///
  /// Returns the actual MTU negotiated.
  ///
  /// For reference:
  ///
  /// * BLE 4.0–4.1 max ATT MTU is 23 bytes
  /// * BLE 4.2–5.1 max ATT MTU is 247 bytes
  Future<int> requestMtu({required String deviceId, required int mtu}) async {
    await initialize();
    return _connectedDeviceOperator.requestMtu(deviceId, mtu);
  }

  /// Requests for a connection parameter update on the connected device.
  ///
  /// Always completes with an error on iOS, as there is no way (and no need) to perform this operation on iOS.
  Future<void> requestConnectionPriority(
      {required String deviceId, required ConnectionPriority priority}) async {
    await initialize();

    return _connectedDeviceOperator.requestConnectionPriority(
        deviceId, priority);
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
    required List<Uuid> withServices,
    ScanMode scanMode = ScanMode.balanced,
    bool requireLocationServicesEnabled = true,
  }) async* {
    await initialize();

    yield* _deviceScanner.scanForDevices(
      withServices: withServices,
      scanMode: scanMode,
      requireLocationServicesEnabled: requireLocationServicesEnabled,
    );
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
  /// If [connectionTimeout] parameter is supplied and a connection is not established before [connectionTimeout] expires,
  /// the pending connection attempt will be cancelled and a [TimeoutException] error will be emitted into the returned stream.
  /// On Android when no timeout is specified the `autoConnect` flag is set in the [connectGatt()](https://developer.android.com/reference/android/bluetooth/BluetoothDevice#connectGatt(android.content.Context,%20boolean,%20android.bluetooth.BluetoothGattCallback)) call, otherwise it is cleared.
  Stream<ConnectionStateUpdate> connectToDevice({
    required String id,
    Map<Uuid, List<Uuid>>? servicesWithCharacteristicsToDiscover,
    Duration? connectionTimeout,
  }) =>
      initialize().asStream().asyncExpand(
            (_) => _deviceConnector.connect(
              id: id,
              servicesWithCharacteristicsToDiscover:
                  servicesWithCharacteristicsToDiscover,
              connectionTimeout: connectionTimeout,
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
  /// If [connectionTimeout] parameter is supplied and a connection is not established before [connectionTimeout] expires,
  /// the pending connection attempt will be cancelled and a [TimeoutException] error will be emitted into the returned stream.
  /// On Android when no timeout is specified the `autoConnect` flag is set in the [connectGatt()](https://developer.android.com/reference/android/bluetooth/BluetoothDevice#connectGatt(android.content.Context,%20boolean,%20android.bluetooth.BluetoothGattCallback)) call, otherwise it is cleared.
  Stream<ConnectionStateUpdate> connectToAdvertisingDevice({
    required String id,
    required List<Uuid> withServices,
    required Duration prescanDuration,
    Map<Uuid, List<Uuid>>? servicesWithCharacteristicsToDiscover,
    Duration? connectionTimeout,
  }) =>
      initialize().asStream().asyncExpand(
            (_) => _deviceConnector.connectToAdvertisingDevice(
              id: id,
              withServices: withServices,
              prescanDuration: prescanDuration,
              servicesWithCharacteristicsToDiscover:
                  servicesWithCharacteristicsToDiscover,
              connectionTimeout: connectionTimeout,
            ),
          );

  /// Performs service discovery on the peripheral and returns the discovered services.
  ///
  /// When discovery fails this method throws an [Exception].
  Future<List<DiscoveredService>> discoverServices(String deviceId) =>
      _connectedDeviceOperator.discoverServices(deviceId);

  /// Clears GATT attribute cache on Android using undocumented API. Completes with an error in case of a failure.
  ///
  /// Always completes with an error on iOS, as there is no way (and no need) to perform this operation on iOS.
  ///
  /// The connection may need to be reestablished after successful GATT attribute cache clearing.
  Future<void> clearGattCache(String deviceId) => _blePlatform
      .clearGattCache(deviceId)
      .then((info) => info.dematerialize());

  /// Subscribes to updates from the characteristic specified.
  ///
  /// This stream terminates automatically when the device is disconnected.
  Stream<List<int>> subscribeToCharacteristic(
    QualifiedCharacteristic characteristic,
  ) {
    final isDisconnected = connectedDeviceStream
        .where((update) =>
            update.deviceId == characteristic.deviceId &&
            (update.connectionState == DeviceConnectionState.disconnecting ||
                update.connectionState == DeviceConnectionState.disconnected))
        .cast<void>()
        .firstWhere((_) => true, orElse: () {});

    return initialize().asStream().asyncExpand(
          (_) => _connectedDeviceOperator.subscribeToCharacteristic(
            characteristic,
            isDisconnected,
          ),
        );
  }

  /// Sets the verbosity of debug output.
  ///
  /// Use [LogLevel.verbose] for full debug output. Make sure to  run this only for debugging purposes.
  /// Use [LogLevel.none] to disable logging. This is also the default.
  set logLevel(LogLevel logLevel) => _debugLogger.logLevel = logLevel;

  LogLevel get logLevel => _debugLogger.logLevel;
}
