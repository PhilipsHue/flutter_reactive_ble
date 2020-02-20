# Flutter reactive BLE library

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
reactivebleclient.scanForDevices(withService: uuid, scanMode: ScanMode.lowLatency).listen((device) {
      //code for handling results
    }, onError: () {
      //code for handling error
    });
  
```

The `withservice` parameter is required.  The parameter `scanmode` is only used in Android and follows the conventions 
described in [Android scansettings reference](https://developer.android.com/reference/android/bluetooth/le/ScanSettings). 
If no scanmode is specified the library will use the balanced scanmode as reference.

### Establishing connection

To interact with a device you first need to establish a connection:

```dart
reactiveBleClient.connectToDevice(
      id: 'AA:BB:CC:DD:EE:FF', 
      servicesWithCharacteristicsToDiscover: {serviceUuid: [char1, char2]},
      connectionTimeout: const Duration(seconds:  2),
    ).listen((connectionUpdate) {
      //code to handle connection update
    }, onError: (dynamic error) {
      //code to handle error
    });
```
Use for the required id parameter the device id retrieved from device discovery. For iOS this should be a UUID and for Android thisis a MAC address.  When first writing or reading a BLE characteristic after establishing a connection it can take a while because the BLE stack needs to discover all services. When supplying a map with services and characteristic UUIDs you want to discover, you can speedup the usage of those services because they will be discovered when establishing a connection. This functionality is only supported by iOS. You can specify a `connectionTimeout` when the client will provide an error in case the connection cannot be established within the specified time. However this does not mean that the client has cancelled the connection request on the level of the BLE stack. 

There are numerous issues on the Android BLE stack that leave it hanging when you try to connect to a device that is not in range. To work around this
issue use the method `connectToAdvertisingDevice` to first scan for the device and when it is found connect to it.

```dart
  reactiveBleClient.connectToAdvertisingDevice(
      id: 'AA:BB:CC:DD:EE:FF', 
      withService: serviceUuid,
      prescanDuration: const Duration(seconds: 5), 
      servicesWithCharacteristicsToDiscover: {serviceUuid: [char1, char2]},
      connectionTimeout: const Duration(seconds:  2),
    ).listen((connectionUpdate) {
      //code to handle connection update
    }, onError: (dynamic error) {
      //code to handle error
    });
```
Besides the normal connection parameters that are described at above this function also has 2 additional required parameters: `withService` and  `prescanDuration`. PreScanDuration is the amount of time the ble stack will scan for the device before it attempts to connect (if the device is found)

### Read / write characteristics

#### Read characteristic
```dart
final characteristic = QualifiedCharacteristic(serviceId: serviceUuid, characteristicId: characteristicUuid, deviceId: 'AA:BB:CC:DD:EE:FF');
final response = await reactiveBleClient.readCharacteristic(characteristic);
```

#### Write with response
Write a value to characteristic and await the reaponse. The return value is a `List<Int>`.

```dart
final characteristic = QualifiedCharacteristic(serviceId: serviceUuid, characteristicId: characteristicUuid, deviceId: 'AA:BB:CC:DD:EE:FF');
final response = await reactiveBleClient.writeCharacteristicWithResponse(characteristic, value: [0x00]);
```

#### Write without response
Use this operation if you want to execute multiple consecutive write operations in a small timeframe (e.g uploading firmware to device) or if the device does not provide a response. This is performance wise the fastest way of writing a value but there's a chance that the BLE device cannot handle that many consecutive writes in a row so it is recommended to do a `writeWithResponse` each x times.

```dart
final characteristic = QualifiedCharacteristic(serviceId: serviceUuid, characteristicId: characteristicUuid, deviceId: 'AA:BB:CC:DD:EE:FF');
reactiveBleClient.writeCharacteristicWithoutResponse(characteristic, value: [0x00]);
```

### Subscribe to characteristic
Instead of periodically reading the characteristic you can also listen to the notifications (in case the specific service supports it) in case the value changes. 

```dart
final characteristic = QualifiedCharacteristic(serviceId: serviceUuid, characteristicId: characteristicUuid, deviceId: 'AA:BB:CC:DD:EE:FF');
   reactiveBleClient.subscribeToCharacteristic(characteristic).listen((data) {
      // code to handle incoming data
    }, onError: (dynamic error) {
      // code to handle errors
    });
```

### Negotiate MTU size
You can increase or decrease the MTU size to reach a higher throughput. This operation will return the actual negotiated MTU size, but it is no guarantee that the requested size will be successfully negotiated. iOS has a default MTU size which cannot be negotiated, however you can still use this operation to get the current MTU.

```dart
final mtu = await reactiveBleClient.requestMtu(deviceId: 'AA:BB:CC:DD:EE:FF', mtu: 250);
```

### Android specific operations
The following operations will only have effect for Android and are not supported by iOS. When using these operations on iOS the library will throw an UnSupportedOperationException.

#### Request connection priority

On Android you can send a connection priority update to the BLE device. The parameter `priority` is an enum that uses the same spec
 as the [BluetoothGatt Android spec](https://developer.android.com/reference/android/bluetooth/BluetoothGatt#requestConnectionPriority(int)).
 Using `highPerformance` will increase battery usage but will speed up GATT operations. Be cautious when setting the priority when communicating with multiple devices because if you set highperformance for all devices the effect of increasing the priority will be lower. 
 
 ```dart
await reactiveBleClient.requestConnectionPriority(deviceId: 'AA:BB:CC:DD:EE:FF', priority:  ConnectionPriority.highPerformance);
```

#### Clear GATT cache
The Android OS maintains a table per device of the discovered service in cache. Sometimes it happens that after a firmware update a new service is introduced but the cache is not updated. To invalidate the cache you can use the cleargattCache operation. 

** This is a hidden BLE operation and should be used with extreme caution since this operation is on the [greylist](https://developer.android.com/distribute/best-practices/develop/restrictions-non-sdk-interfaces). **  

```dart
await reactiveBleClient.clearGattCache('AA:BB:CC:DD:EE:FF');
```





