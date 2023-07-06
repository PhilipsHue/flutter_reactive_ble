# Flutter reactive BLE library

[![flutter_reactive_ble version](https://img.shields.io/pub/v/flutter_reactive_ble?label=flutter_reactive_ble)](https://pub.dev/packages/flutter_reactive_ble)

Flutter library that handles BLE operations for multiple devices.

## Contributing
Feel free to open an new issue or a pull request to make this project better

## Setup

This project uses melos to manage all the packages inside this repo.

Install melos: `dart pub global activate melos`
Setup melos to point to the dependencies in your local folder: `melos bootstrap`

### Android

Library requires kotlin version `1.5.31`.

### Update kotlin version

To update the kotlin version open Android studio and go to `Tools > Kotlin > Configure Kotlin plugin updates` and update `Update channel` to `1.5.x`.

## Features

The reactive BLE lib supports the following:

- BLE device discovery
- Observe host device BLE status
- Establishing a BLE connection
- Maintaining connection status of multiple BLE devices 
- Discover services(will be implicit)
- Read / write a characteristic
- Subscribe to a characteristic
- Clear GATT cache
- Negotiate MTU size

## Getting Started
### Android

You need to add the following permissions to your AndroidManifest.xml file:

```xml
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" android:usesPermissionFlags="neverForLocation" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" android:maxSdkVersion="30" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" android:maxSdkVersion="30" />
```

If you use `BLUETOOTH_SCAN` to determine location, modify your AndroidManfiest.xml file to include the following entry:

```xml
 <uses-permission android:name="android.permission.BLUETOOTH_SCAN" 
                     tools:remove="android:usesPermissionFlags"
                     tools:targetApi="s" />
```

If you use location services in your app, remove `android:maxSdkVersion="30"` from the location permission tags

### Android ProGuard rules
In case you are using ProGuard add the following snippet to your `proguard-rules.pro` file:

```
-keep class com.signify.hue.** { *; }
```

This will prevent issues like [#131](https://github.com/PhilipsHue/flutter_reactive_ble/issues/131).

### iOS

For iOS it is required you add the following entries to the `Info.plist` file of your app. It is not allowed to access Core BLuetooth without this. See [our example app](https://github.com/PhilipsHue/flutter_reactive_ble/blob/master/example/ios/Runner/Info.plist) on how to implement this. For more indepth details: [Blog post on iOS bluetooth permissions](https://medium.com/flawless-app-stories/handling-ios-13-bluetooth-permissions-26c6a8cbb816)

iOS13 and higher
* NSBluetoothAlwaysUsageDescription

iOS12 and lower
* NSBluetoothPeripheralUsageDescription

## Usage
### Initialization

Initializing the library should be done the following:

```dart
final flutterReactiveBle = FlutterReactiveBle();
```

### Device discovery

Discovering BLE devices should be done like this:

```dart
flutterReactiveBle.scanForDevices(withServices: [serviceId], scanMode: ScanMode.lowLatency).listen((device) {
      //code for handling results
    }, onError: () {
      //code for handling error
    });
  
```

The `withServices` parameter specifies the advertised service IDs to look for. If an empty list is passed, all the advertising devices will be reported. The parameter `scanMode` is only used on Android and follows the conventions described on [ScanSettings](https://developer.android.com/reference/android/bluetooth/le/ScanSettings#SCAN_MODE_BALANCED) Android reference page. If `scanMode` is omitted the balanced scan mode will be used.


### Observe host device BLE status

Use `statusStream` to retrieve updates about the BLE status of the host device (the device running the app) . This stream can be used in order to determine if the BLE is turned on, on the device or if the required permissions are granted. Example usage:

``` dart
_ble.statusStream.listen((status) {
  //code for handling status update
});
```

Use ` _ble.status` to get the current status of the host device.

See [BleStatus](https://github.com/PhilipsHue/flutter_reactive_ble/blob/master/packages/reactive_ble_platform_interface/lib/src/model/ble_status.dart) for
more info about the meaning of the different statuses.

### Establishing connection

To interact with a device you first need to establish a connection:

```dart
flutterReactiveBle.connectToDevice(
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
flutterReactiveBle.connectToAdvertisingDevice(
    id: foundDeviceId,
    withServices: [serviceUuid],
    prescanDuration: const Duration(seconds: 5),
    servicesWithCharacteristicsToDiscover: {serviceId: [char1, char2]},
    connectionTimeout: const Duration(seconds:  2),
  ).listen((connectionState) {
    // Handle connection state updates
  }, onError: (dynamic error) {
    // Handle a possible error
  });
```

Besides the normal connection parameters that are described above this function also has 2 additional required parameters: `withServices` and  `prescanDuration`. PreScanDuration is the amount of time the ble stack will scan for the device before it attempts to connect (if the device is found)

### Read / write characteristics

#### Read characteristic

```dart
final characteristic = QualifiedCharacteristic(serviceId: serviceUuid, characteristicId: characteristicUuid, deviceId: foundDeviceId);
final response = await flutterReactiveBle.readCharacteristic(characteristic);
```

#### Write with response

Write a value to characteristic and await the response. The "response" in "write characteristic with response" means "an acknowledgement of reception". The write can either be acknowledged (success) or failed (an exception is thrown), thus the return type is `void` and there is nothing to print (though you can `print("Write successful")` and in a catch-clause `print("Write failed: $e")`).

BLE does not provide a request-response mechanism like you may know from HTTP out of the box. If you need to perform request-response calls, you will need to implement a custom mechanism on top of the basic BLE functionality. A typical approach is to implement a "control point": a characteristic that is writable and delivers [notifications or indications](https://duckduckgo.com/?q=BLE+"indications"+vs+"notifications"), so that a request is written to it and a response is delivered back as a notification or an indication.

```dart
final characteristic = QualifiedCharacteristic(serviceId: serviceUuid, characteristicId: characteristicUuid, deviceId: foundDeviceId); 
await flutterReactiveBle.writeCharacteristicWithResponse(characteristic, value: [0x00]);
```

#### Write without response

Use this operation if you want to execute multiple consecutive write operations in a small timeframe (e.g uploading firmware to device) or if the device does not provide a response. This is performance wise the fastest way of writing a value but there's a chance that the BLE device cannot handle that many consecutive writes in a row, so do a `writeWithResponse` once in a while.

```dart
final characteristic = QualifiedCharacteristic(serviceId: serviceUuid, characteristicId: characteristicUuid, deviceId: foundDeviceId);
flutterReactiveBle.writeCharacteristicWithoutResponse(characteristic, value: [0x00]);
```

### Subscribe to characteristic

Instead of periodically reading the characteristic you can also listen to the notifications (in case the specific service supports it) in case the value changes. 

```dart
final characteristic = QualifiedCharacteristic(serviceId: serviceUuid, characteristicId: characteristicUuid, deviceId: foundDeviceId);
   flutterReactiveBle.subscribeToCharacteristic(characteristic).listen((data) {
      // code to handle incoming data
    }, onError: (dynamic error) {
      // code to handle errors
    });
```

### Negotiate MTU size

You can increase or decrease the MTU size to reach a higher throughput. This operation will return the actual negotiated MTU size, but it is no guarantee that the requested size will be successfully negotiated. iOS has a default MTU size which cannot be negotiated, however you can still use this operation to get the current MTU.

```dart
final mtu = await flutterReactiveBle.requestMtu(deviceId: foundDeviceId, mtu: 250);
```

### Android specific operations

The following operations will only have effect for Android and are not supported by iOS. When using these operations on iOS the library will throw an UnSupportedOperationException.

#### Request connection priority

On Android you can send a connection priority update to the BLE device. The parameter `priority` is an enum that uses the same spec
 as the [BluetoothGatt Android spec](https://developer.android.com/reference/android/bluetooth/BluetoothGatt#requestConnectionPriority(int)).
 Using `highPerformance` will increase battery usage but will speed up GATT operations. Be cautious when setting the priority when communicating with multiple devices because if you set highperformance for all devices the effect of increasing the priority will be lower.

```dart
await flutterReactiveBle.requestConnectionPriority(deviceId: foundDeviceId, priority:  ConnectionPriority.highPerformance);
```

#### Clear GATT cache

The Android OS maintains a table per device of the discovered service in cache. Sometimes it happens that after a firmware update a new service is introduced but the cache is not updated. To invalidate the cache you can use the cleargattCache operation. 

**This is a hidden BLE operation and should be used with extreme caution since this operation is on the [greylist](https://developer.android.com/distribute/best-practices/develop/restrictions-non-sdk-interfaces).**  

```dart
await flutterReactiveBle.clearGattCache(foundDeviceId);
```

### FAQ

#### How to handle the BLE undeliverable exception

On Android side we use the [RxAndroidBle](https://github.com/Polidea/RxAndroidBle) library of Polidea. After migration towards RxJava 2 some of the errors are not routed properly to their listeners and thus this will result in a BLE Undeliverable Exception. The root cause lies in the threading of the Android OS. As workaround RxJava has a hook where you can set the global errorhandler. For more info see [RxJava docs](https://github.com/ReactiveX/RxJava/wiki/What's-different-in-2.0#error-handling) .


A default workaround implementation in the Flutter app (needs to be in the Java / Kotlin part e.g. mainactivity) is shown below. For an example (in Java) see Polidea RxAndroidBle [sample](https://github.com/Polidea/RxAndroidBle/tree/master/sample/src/main/java/com/polidea/rxandroidble2/sample).

BleException is coming from Polidea RxAndroidBle, so make sure your application declares the following depedency: `implementation "com.polidea.rxandroidble2:rxandroidble:1.11.1"`

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

#### Why doesn't the BLE stack directly connect to my peripheral

Before you are able to execute BLE operations the BLE-stack of the device makes sure everything is setup correctly and then reports ready for operation. For some devices this takes a bit longer than for others. When starting the app make sure that the BLE-stack is properly initialized before you execute BLE operations. The safest way to do this is by listening to the `statusStream` and wait for `BleStatus.ready`.

This will prevent issues like [#147](https://github.com/PhilipsHue/flutter_reactive_ble/issues/147).

#### Unofficial example apps

- Example implementation UART over BLE:[link](https://github.com/wolfc01/flutter_reactive_ble_uart_example)
- Example implementation subscription to characteristic using StreamProvider: [link](https://github.com/ubiqueIoT/flutter-reactive-ble-example)
