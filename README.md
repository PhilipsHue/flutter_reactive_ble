# Flutter reactive BLE library

[![flutter_reactive_ble version](https://img.shields.io/pub/v/flutter_reactive_ble?label=flutter_reactive_ble)](https://pub.dev/packages/flutter_reactive_ble)

Flutter library that handles BLE operations for multiple devices.

## Usage

The reactive BLE lib supports the following:

- BLE device discovery
- Establishing a BLE connection
- Maintaining connection status of multiple BLE devices 
- Discover services(will be implicit)
- Read / write a characteristic
- Subscribe to a characteristic
- Clear GATT cache
- Negotiate MTU size

### Device discovery

Discovering BLE devices should be done like this:

```dart
reactivebleclient.scanForDevices(withServices: [uuid], scanMode: ScanMode.lowLatency).listen((device) {
      //code for handling results
    }, onError: () {
      //code for handling error
    });
  
```

The `withServices` parameter is required if you do not want to filter on services pass an empty list.  The parameter `scanMode` is only used on Android and follows the conventions described on [ScanSettings](https://developer.android.com/reference/android/bluetooth/le/ScanSettings#SCAN_MODE_BALANCED) Android reference page. If `scanMode` is omitted the balanced scan mode will be used.

### Establishing connection

To interact with a device you first need to establish a connection:

```dart
reactiveBleClient.connectToDevice(
      id: foundDeviceId,
      servicesWithCharacteristicsToDiscover: {serviceId: [char1, char2]},
      connectionTimeout: const Duration(seconds: 2),
    ).listen((connectionState) {
      // Handle connection state updates
    }, onError: (Object error) {
      // Handle a possible error
    });
```

For the required `id` parameter use a device ID retrieved through device discovery. On iOS the device ID is a UUID and on Android it is a MAC address (which may also be randomized, depending on the Android version). Supplying a map with service and characteristic IDs you want to discover may speed up the connection on iOS (otherwise _all_ services and characteristics will be discovered). You can specify a `connectionTimeout` when the client will provide an error in case the connection cannot be established within the specified time.

There are numerous issues on the Android BLE stack that leave it hanging when you try to connect to a device that is not in range. To work around this
issue use the method `connectToAdvertisingDevice` to first scan for the device and only if it is found connect to it.

```dart
reactiveBleClient.connectToAdvertisingDevice(
    id: foundDeviceId,
    withService: serviceUuid,
    prescanDuration: const Duration(seconds: 5),
    servicesWithCharacteristicsToDiscover: {serviceId: [char1, char2]},
    connectionTimeout: const Duration(seconds:  2),
  ).listen((connectionState) {
    // Handle connection state updates
  }, onError: (dynamic error) {
    // Handle a possible error
  });
```

Besides the normal connection parameters that are described above this function also has 2 additional required parameters: `withService` and  `prescanDuration`. PreScanDuration is the amount of time the ble stack will scan for the device before it attempts to connect (if the device is found)

### Read / write characteristics

#### Read characteristic

```dart
final characteristic = QualifiedCharacteristic(serviceId: serviceUuid, characteristicId: characteristicUuid, deviceId: foundDeviceId);
final response = await reactiveBleClient.readCharacteristic(characteristic);
```

#### Write with response

Write a value to characteristic and await the response. The return value is a list of bytes (`List<int>`).

```dart
final characteristic = QualifiedCharacteristic(serviceId: serviceUuid, characteristicId: characteristicUuid, deviceId: foundDeviceId);
final response = await reactiveBleClient.writeCharacteristicWithResponse(characteristic, value: [0x00]);
```

#### Write without response

Use this operation if you want to execute multiple consecutive write operations in a small timeframe (e.g uploading firmware to device) or if the device does not provide a response. This is performance wise the fastest way of writing a value but there's a chance that the BLE device cannot handle that many consecutive writes in a row, so do a `writeWithResponse` once in a while.

```dart
final characteristic = QualifiedCharacteristic(serviceId: serviceUuid, characteristicId: characteristicUuid, deviceId: foundDeviceId);
reactiveBleClient.writeCharacteristicWithoutResponse(characteristic, value: [0x00]);
```

### Subscribe to characteristic

Instead of periodically reading the characteristic you can also listen to the notifications (in case the specific service supports it) in case the value changes. 

```dart
final characteristic = QualifiedCharacteristic(serviceId: serviceUuid, characteristicId: characteristicUuid, deviceId: foundDeviceId);
   reactiveBleClient.subscribeToCharacteristic(characteristic).listen((data) {
      // code to handle incoming data
    }, onError: (dynamic error) {
      // code to handle errors
    });
```

### Negotiate MTU size

You can increase or decrease the MTU size to reach a higher throughput. This operation will return the actual negotiated MTU size, but it is no guarantee that the requested size will be successfully negotiated. iOS has a default MTU size which cannot be negotiated, however you can still use this operation to get the current MTU.

```dart
final mtu = await reactiveBleClient.requestMtu(deviceId: foundDeviceId, mtu: 250);
```

### Android specific operations

The following operations will only have effect for Android and are not supported by iOS. When using these operations on iOS the library will throw an UnSupportedOperationException.

#### Request connection priority

On Android you can send a connection priority update to the BLE device. The parameter `priority` is an enum that uses the same spec
 as the [BluetoothGatt Android spec](https://developer.android.com/reference/android/bluetooth/BluetoothGatt#requestConnectionPriority(int)).
 Using `highPerformance` will increase battery usage but will speed up GATT operations. Be cautious when setting the priority when communicating with multiple devices because if you set highperformance for all devices the effect of increasing the priority will be lower.

```dart
await reactiveBleClient.requestConnectionPriority(deviceId: foundDeviceId, priority:  ConnectionPriority.highPerformance);
```

#### Clear GATT cache

The Android OS maintains a table per device of the discovered service in cache. Sometimes it happens that after a firmware update a new service is introduced but the cache is not updated. To invalidate the cache you can use the cleargattCache operation. 

**This is a hidden BLE operation and should be used with extreme caution since this operation is on the [greylist](https://developer.android.com/distribute/best-practices/develop/restrictions-non-sdk-interfaces).**  

```dart
await reactiveBleClient.clearGattCache(foundDeviceId);
```

### Common issues

#### BLE undeliverable exception

On Android side we use the [RxAndroidBle](https://github.com/Polidea/RxAndroidBle) library of Polidea. After migration towards RxJava 2 some of the errors are not routed properly to their listeners and thus this will result in a BLE Undeliverable Exception. The root cause lies in the threading of the Android OS. As workaround RxJava has a hook where you can set the global errorhandler. For more info see [RxJava docs](https://github.com/ReactiveX/RxJava/wiki/What's-different-in-2.0#error-handling) .

A default workaround implementation in the Flutter app (needs to be in the Java / Kotlin part e.g. mainactivity) would be:

```kotlin
RxJavaPlugins.setErrorHandler { throwable ->
  if (throwable is UndeliverableException && throwable.cause is BleException) {
    return@setErrorHandler // ignore BleExceptions since we do not have subscriber
  }
  else {
    throw throwable
  }
}
```
