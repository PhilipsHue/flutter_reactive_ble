import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_reactive_ble/src/discovered_devices_registry.dart';
import 'package:flutter_reactive_ble/src/model/connection_state_update.dart';
import 'package:flutter_reactive_ble/src/model/discovered_device.dart';
import 'package:flutter_reactive_ble/src/model/generic_failure.dart';
import 'package:flutter_reactive_ble/src/model/scan_mode.dart';
import 'package:flutter_reactive_ble/src/model/scan_session.dart';
import 'package:flutter_reactive_ble/src/model/uuid.dart';

class PrescanConnector {
  const PrescanConnector({
    @required this.scanRegistry,
    @required this.connectDevice,
    @required this.scanDevices,
    @required this.getCurrentScan,
    @required this.delayAfterScanFailure,
  });

  static const scanRegistryCacheValidityPeriod = Duration(seconds: 25);

  final DiscoveredDevicesRegistry scanRegistry;
  final Stream<ConnectionStateUpdate> Function({
    String id,
    Map<Uuid, List<Uuid>> servicesWithCharacteristicsToDiscover,
    Duration connectionTimeout,
  }) connectDevice;

  final Stream<DiscoveredDevice> Function(
      {List<Uuid> withServices, ScanMode scanMode}) scanDevices;

  final ScanSession Function() getCurrentScan;
  final Duration delayAfterScanFailure;

  Stream<ConnectionStateUpdate> connectToAdvertisingDevice({
    @required String id,
    @required List<Uuid> withServices,
    @required Duration prescanDuration,
    Map<Uuid, List<Uuid>> servicesWithCharacteristicsToDiscover,
    Duration connectionTimeout,
  }) {
    if (getCurrentScan() != null) {
      return awaitCurrentScanAndConnect(
        withServices,
        prescanDuration,
        id,
        servicesWithCharacteristicsToDiscover,
        connectionTimeout,
      );
    } else {
      return prescanAndConnect(
        id,
        servicesWithCharacteristicsToDiscover,
        connectionTimeout,
        withServices,
        prescanDuration,
      );
    }
  }

  @visibleForTesting
  Stream<ConnectionStateUpdate> prescanAndConnect(
    String id,
    Map<Uuid, List<Uuid>> servicesWithCharacteristicsToDiscover,
    Duration connectionTimeout,
    List<Uuid> withServices,
    Duration prescanDuration,
  ) {
    if (scanRegistry.deviceIsDiscoveredRecently(
        deviceId: id, cacheValidity: scanRegistryCacheValidityPeriod)) {
      return connectDevice(
        id: id,
        servicesWithCharacteristicsToDiscover:
            servicesWithCharacteristicsToDiscover,
        connectionTimeout: connectionTimeout,
      );
    } else {
      final scanSubscription =
          scanDevices(withServices: withServices, scanMode: ScanMode.lowLatency)
              .listen((DiscoveredDevice scanData) {}, onError: (Object _) {});
      Future<void>.delayed(prescanDuration).then<void>((_) {
        scanSubscription.cancel();
      });

      return getCurrentScan()
          .future
          .then((_) => true)
          .catchError((Object _) => false)
          .asStream()
          .asyncExpand(
        (succeeded) {
          if (succeeded) {
            return connectIfRecentlyDiscovered(
                id, servicesWithCharacteristicsToDiscover, connectionTimeout);
          } else {
            /*When the scan fails 99% of the times it is due to violation of the scan threshold:
            https://blog.classycode.com/undocumented-android-7-ble-behavior-changes-d1a9bd87d983 . Previously we did
            autoconnect but that gives slow connection times (up to 2 min) on a lot of devices.
             */
            return Future<void>.delayed(delayAfterScanFailure)
                .asStream()
                .asyncExpand((_) => connectIfRecentlyDiscovered(id,
                    servicesWithCharacteristicsToDiscover, connectionTimeout));
          }
        },
      );
    }
  }

  @visibleForTesting
  Stream<ConnectionStateUpdate> awaitCurrentScanAndConnect(
    List<Uuid> withServices,
    Duration prescanDuration,
    String id,
    Map<Uuid, List<Uuid>> servicesWithCharacteristicsToDiscover,
    Duration connectionTimeout,
  ) {
    if (const DeepCollectionEquality()
        .equals(getCurrentScan().withServices, withServices)) {
      return getCurrentScan()
          .future
          .timeout(prescanDuration + const Duration(seconds: 1))
          .asStream()
          .asyncExpand((_) => connectIfRecentlyDiscovered(
                id,
                servicesWithCharacteristicsToDiscover,
                connectionTimeout,
              ));
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

  @visibleForTesting
  Stream<ConnectionStateUpdate> connectIfRecentlyDiscovered(
    String id,
    Map<Uuid, List<Uuid>> servicesWithCharacteristicsToDiscover,
    Duration connectionTimeout,
  ) {
    if (scanRegistry.deviceIsDiscoveredRecently(
        deviceId: id, cacheValidity: scanRegistryCacheValidityPeriod)) {
      return connectDevice(
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
