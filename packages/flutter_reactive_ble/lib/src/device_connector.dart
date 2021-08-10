import 'package:collection/collection.dart';
import 'package:flutter_reactive_ble/src/device_scanner.dart';
import 'package:flutter_reactive_ble/src/rx_ext/repeater.dart';
import 'package:reactive_ble_platform_interface/reactive_ble_platform_interface.dart';

abstract class DeviceConnector {
  Stream<ConnectionStateUpdate> get deviceConnectionStateUpdateStream;

  Stream<ConnectionStateUpdate> connect({
    required String id,
    Map<Uuid, List<Uuid>>? servicesWithCharacteristicsToDiscover,
    Duration? connectionTimeout,
  });

  Stream<ConnectionStateUpdate> connectToAdvertisingDevice({
    required String id,
    required List<Uuid> withServices,
    required Duration prescanDuration,
    Map<Uuid, List<Uuid>>? servicesWithCharacteristicsToDiscover,
    Duration? connectionTimeout,
  });
}

class DeviceConnectorImpl implements DeviceConnector {
  const DeviceConnectorImpl({
    required ReactiveBlePlatform blePlatform,
    required bool Function(
            {required String deviceId, required Duration cacheValidity})
        deviceIsDiscoveredRecently,
    required DeviceScanner deviceScanner,
    required Duration delayAfterScanFailure,
  })  : _deviceIsDiscoveredRecently = deviceIsDiscoveredRecently,
        _deviceScanner = deviceScanner,
        _blePlatform = blePlatform,
        _delayAfterScanFailure = delayAfterScanFailure;

  final ReactiveBlePlatform _blePlatform;
  final bool Function({
    required String deviceId,
    required Duration cacheValidity,
  }) _deviceIsDiscoveredRecently;
  final DeviceScanner _deviceScanner;
  final Duration _delayAfterScanFailure;

  static const _scanRegistryCacheValidityPeriod = Duration(seconds: 25);

  @override
  Stream<ConnectionStateUpdate> get deviceConnectionStateUpdateStream =>
      _blePlatform.connectionUpdateStream;

  @override
  Stream<ConnectionStateUpdate> connect({
    required String id,
    Map<Uuid, List<Uuid>>? servicesWithCharacteristicsToDiscover,
    Duration? connectionTimeout,
  }) {
    final specificConnectedDeviceStream = deviceConnectionStateUpdateStream
        .where((update) => update.deviceId == id)
        .expand((update) =>
            update.connectionState != DeviceConnectionState.disconnected
                ? [update]
                : [update, null])
        .takeWhile((update) => update != null)
        .cast<ConnectionStateUpdate>();

    final autoconnectingRepeater = Repeater.broadcast(
      onListenEmitFrom: () => _blePlatform
          .connectToDevice(
            id,
            servicesWithCharacteristicsToDiscover,
            connectionTimeout,
          )
          .asyncExpand((_) => specificConnectedDeviceStream),
      onCancel: () => _blePlatform.disconnectDevice(id),
    );

    return autoconnectingRepeater.stream;
  }

  @override
  Stream<ConnectionStateUpdate> connectToAdvertisingDevice({
    required String id,
    required List<Uuid> withServices,
    required Duration prescanDuration,
    Map<Uuid, List<Uuid>>? servicesWithCharacteristicsToDiscover,
    Duration? connectionTimeout,
  }) {
    if (_deviceScanner.currentScan != null) {
      return _awaitCurrentScanAndConnect(
        withServices,
        prescanDuration,
        id,
        servicesWithCharacteristicsToDiscover,
        connectionTimeout,
      );
    } else {
      return _prescanAndConnect(
        id,
        servicesWithCharacteristicsToDiscover,
        connectionTimeout,
        withServices,
        prescanDuration,
      );
    }
  }

  Stream<ConnectionStateUpdate> _prescanAndConnect(
    String id,
    Map<Uuid, List<Uuid>>? servicesWithCharacteristicsToDiscover,
    Duration? connectionTimeout,
    List<Uuid> withServices,
    Duration prescanDuration,
  ) {
    if (_deviceIsDiscoveredRecently(
        deviceId: id, cacheValidity: _scanRegistryCacheValidityPeriod)) {
      return connect(
        id: id,
        servicesWithCharacteristicsToDiscover:
            servicesWithCharacteristicsToDiscover,
        connectionTimeout: connectionTimeout,
      );
    } else {
      final scanSubscription = _deviceScanner
          .scanForDevices(
              withServices: withServices, scanMode: ScanMode.lowLatency)
          .listen((DiscoveredDevice scanData) {}, onError: (Object _) {});
      Future<void>.delayed(prescanDuration).then<void>((_) {
        scanSubscription.cancel();
      });

      return _deviceScanner.currentScan!.future
          .then((_) => true)
          .catchError((Object _) => false)
          .asStream()
          .asyncExpand(
        (succeeded) {
          if (succeeded) {
            return _connectIfRecentlyDiscovered(
                id, servicesWithCharacteristicsToDiscover, connectionTimeout);
          } else {
            // When the scan fails 99% of the times it is due to violation of the scan threshold:
            // https://blog.classycode.com/undocumented-android-7-ble-behavior-changes-d1a9bd87d983
            //
            // Previously we used "autoconnect" but that gives slow connection times (up to 2 min) on a lot of devices.
            return Future<void>.delayed(_delayAfterScanFailure)
                .asStream()
                .asyncExpand((_) => _connectIfRecentlyDiscovered(
                      id,
                      servicesWithCharacteristicsToDiscover,
                      connectionTimeout,
                    ));
          }
        },
      );
    }
  }

  Stream<ConnectionStateUpdate> _awaitCurrentScanAndConnect(
    List<Uuid> withServices,
    Duration prescanDuration,
    String id,
    Map<Uuid, List<Uuid>>? servicesWithCharacteristicsToDiscover,
    Duration? connectionTimeout,
  ) {
    if (const DeepCollectionEquality()
        .equals(_deviceScanner.currentScan!.withServices, withServices)) {
      return _deviceScanner.currentScan!.future
          .timeout(prescanDuration + const Duration(seconds: 1))
          .asStream()
          .asyncExpand(
            (_) => _connectIfRecentlyDiscovered(
              id,
              servicesWithCharacteristicsToDiscover,
              connectionTimeout,
            ),
          );
    } else {
      return Stream.fromIterable(
        [
          ConnectionStateUpdate(
            deviceId: id,
            connectionState: DeviceConnectionState.disconnected,
            failure: const GenericFailure(
              code: ConnectionError.failedToConnect,
              message: "A scan for a different service is running",
            ),
          ),
        ],
      );
    }
  }

  Stream<ConnectionStateUpdate> _connectIfRecentlyDiscovered(
    String id,
    Map<Uuid, List<Uuid>>? servicesWithCharacteristicsToDiscover,
    Duration? connectionTimeout,
  ) {
    if (_deviceIsDiscoveredRecently(
      deviceId: id,
      cacheValidity: _scanRegistryCacheValidityPeriod,
    )) {
      return connect(
        id: id,
        servicesWithCharacteristicsToDiscover:
            servicesWithCharacteristicsToDiscover,
        connectionTimeout: connectionTimeout,
      );
    } else {
      return Stream.fromIterable(
        [
          ConnectionStateUpdate(
            deviceId: id,
            connectionState: DeviceConnectionState.disconnected,
            failure: const GenericFailure(
                code: ConnectionError.failedToConnect,
                message: "Device is not advertising"),
          ),
        ],
      );
    }
  }
}
