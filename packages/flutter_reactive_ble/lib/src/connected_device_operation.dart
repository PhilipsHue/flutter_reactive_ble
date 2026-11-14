import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:meta/meta.dart';
import 'package:reactive_ble_platform_interface/reactive_ble_platform_interface.dart';

abstract class ConnectedDeviceOperation {
  Stream<CharacteristicValue> get characteristicValueStream;

  Future<List<int>> readCharacteristic(CharacteristicInstance characteristic);

  Future<void> writeCharacteristicWithResponse(
    CharacteristicInstance characteristic, {
    required List<int> value,
  });

  Future<void> writeCharacteristicWithoutResponse(
    CharacteristicInstance characteristic, {
    required List<int> value,
  });

  Future<void> writeCharacteristicWithoutResponseBatch(
    CharacteristicInstance characteristic, {
    required List<int> value,
    int? packetSize,
  });

  Stream<List<int>> subscribeToCharacteristic(
    CharacteristicInstance characteristic,
    Future<void> isDisconnected,
  );

  Future<Stream<List<int>>> subscribeToCharacteristicAsync(
    CharacteristicInstance characteristic,
    Future<void> isDisconnected,
  );

  Future<int> requestMtu(String deviceId, int mtu);

  Future<List<DiscoveredService>> discoverServices(String deviceId);

  Future<List<DiscoveredService>> getDiscoverServices(String deviceId);

  Future<void> requestConnectionPriority(
      String deviceId, ConnectionPriority priority);
}

class ConnectedDeviceOperationImpl implements ConnectedDeviceOperation {
  ConnectedDeviceOperationImpl({required ReactiveBlePlatform blePlatform})
      : _blePlatform = blePlatform;

  final ReactiveBlePlatform _blePlatform;

  @override
  Stream<CharacteristicValue> get characteristicValueStream =>
      _blePlatform.charValueUpdateStream;

  @override
  Future<List<int>> readCharacteristic(
    CharacteristicInstance characteristic,
  ) async {
    final specificCharacteristicValueStream = characteristicValueStream
        .where((update) => update.characteristic == characteristic)
        .map((update) => update.result);

    final result = await _blePlatform
        .readCharacteristic(characteristic)
        .asyncExpand((_) => specificCharacteristicValueStream)
        .firstWhere((_) => true,
            orElse: () => throw NoBleCharacteristicDataReceived());
    return result.dematerialize();
  }

  @override
  Future<void> writeCharacteristicWithResponse(
    CharacteristicInstance characteristic, {
    required List<int> value,
  }) async =>
      _blePlatform
          .writeCharacteristicWithResponse(characteristic, value)
          .then((info) => info.result.dematerialize());

  @override
  Future<void> writeCharacteristicWithoutResponse(
    CharacteristicInstance characteristic, {
    required List<int> value,
  }) async =>
      _blePlatform
          .writeCharacteristicWithoutResponse(characteristic, value)
          .then((info) => info.result.dematerialize());

  @override
  Future<void> writeCharacteristicWithoutResponseBatch(
    CharacteristicInstance characteristic, {
    required List<int> value,
    int? packetSize,
  }) async =>
      _blePlatform
          .writeCharacteristicWithoutResponseBatch(
            characteristic,
            value,
            packetSize: packetSize,
          )
          .then((info) => info.result.dematerialize());

  @override
  Stream<List<int>> subscribeToCharacteristic(
    CharacteristicInstance characteristic,
    Future<void> isDisconnected,
  ) {
    final specificCharacteristicValueStream = characteristicValueStream
        .where((update) => update.characteristic == characteristic)
        .map((update) => update.result.dematerialize());

    final autosubscribingRepeater = Repeater<List<int>>.broadcast(
      onListenEmitFrom: () => _blePlatform
          .subscribeToNotifications(characteristic)
          .asyncExpand((_) => specificCharacteristicValueStream),
      onCancel: () => _blePlatform
          .stopSubscribingToNotifications(characteristic)
          .catchError((Object e) =>
              // ignore: avoid_print
              print("Error unsubscribing from notifications: $e")),
    );

    isDisconnected.then<void>((_) => autosubscribingRepeater.dispose());

    return autosubscribingRepeater.stream;
  }

  @override
  Future<Stream<List<int>>> subscribeToCharacteristicAsync(
    CharacteristicInstance characteristic,
    Future<void> isDisconnected,
  ) async {
    final specificCharacteristicValueStream = characteristicValueStream
        .where((update) => update.characteristic == characteristic)
        .map((update) => update.result.dematerialize());

    StreamController<List<int>>? controller;
    StreamSubscription<List<int>>? valueSubscription;
    final pendingActions = <void Function(StreamController<List<int>>)>[];

    void startListeningToValues(Stream<List<int>> source) {
      valueSubscription = source.listen(
        (data) {
          if (controller != null && controller.hasListener) {
            controller.add(data);
          } else {
            pendingActions.add((c) => c.add(data));
          }
        },
        onError: (Object error, StackTrace stackTrace) {
          if (controller != null && controller.hasListener) {
            controller.addError(error, stackTrace);
          } else {
            pendingActions.add((c) => c.addError(error, stackTrace));
          }
        },
        onDone: () {
          if (controller != null && controller.hasListener) {
            controller.close();
          } else {
            pendingActions.add((c) => c.close());
          }
        },
      );
    }

    startListeningToValues(specificCharacteristicValueStream);

    try {
      await _blePlatform
          .subscribeToNotifications(characteristic)
          .firstWhere((_) => true, orElse: () {});
    } catch (_) {
      await valueSubscription?.cancel();
      rethrow;
    }

    var isSubscribed = true;

    controller = StreamController<List<int>>.broadcast(
      onListen: () {
        if (!isSubscribed) {
          isSubscribed = true;
          startListeningToValues(
            _blePlatform
                .subscribeToNotifications(characteristic)
                .asyncExpand((_) => specificCharacteristicValueStream),
          );
          return;
        }
        if (pendingActions.isNotEmpty) {
          final actions = List.of(pendingActions);
          pendingActions.clear();
          for (final action in actions) {
            action(controller!);
          }
        }
      },
      onCancel: () async {
        isSubscribed = false;
        pendingActions.clear();
        await valueSubscription?.cancel();
        valueSubscription = null;
        await _blePlatform
            .stopSubscribingToNotifications(characteristic)
            .catchError((Object e) =>
                // ignore: avoid_print
                print("Error unsubscribing from notifications: $e"));
      },
    );

    unawaited(
      isDisconnected.then<void>((_) async {
        pendingActions.clear();
        await valueSubscription?.cancel();
        valueSubscription = null;
        await controller?.close();
      }),
    );

    return controller.stream;
  }

  @override
  Future<int> requestMtu(String deviceId, int mtu) async =>
      _blePlatform.requestMtuSize(deviceId, mtu);

  @override
  Future<List<DiscoveredService>> discoverServices(String deviceId) =>
      _blePlatform.discoverServices(deviceId);

  @override
  Future<List<DiscoveredService>> getDiscoverServices(String deviceId) =>
      _blePlatform.getDiscoverServices(deviceId);

  @override
  Future<void> requestConnectionPriority(
          String deviceId, ConnectionPriority priority) async =>
      _blePlatform
          .requestConnectionPriority(deviceId, priority)
          .then((message) => message.result.dematerialize());
}

@visibleForTesting
class NoBleCharacteristicDataReceived implements Exception {
  @override
  bool operator ==(Object other) => runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

@visibleForTesting
class NoBleDeviceConnectionStateReceived implements Exception {
  @override
  bool operator ==(Object other) => runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}
