# Reactive_ble_web

UnOfficial Web implementation for the flutter_reactive_ble plugin.

# Addition Changes

If Implemented Web support, don't use prescan connect option

For web , we have to Pass Services in the ScanMethod itself , only then we can access them after connection
so modify your code like this , also try to avoid adding services in short like `Uuid.parse('180a')` , use like below accordingly

```dart
      flutterReactiveBle
          .scanForDevices(
              withServices: kIsWeb
                  ? [
                      //Add All services which you want to work with after connection
                      Uuid.parse('0000180a-0000-1000-8000-00805f9b34fb'),
                      Uuid.parse('00001800-0000-1000-8000-00805f9b34fb'),
                    ]
                   : [
                       Uuid.parse(deviceUUID)
                    ]
              scanMode: kIsWeb ? ScanMode.opportunistic : ScanMode.lowLatency)
          .listen((device) {}
```

if want to filter devices of specific service like what `withServices` do in Mobile
use `ScanMode` = > `ScanMode.opportunistic` and pass first service which we want to filter with , Like this

```dart
      flutterReactiveBle
          .scanForDevices(
              withServices: kIsWeb
                  ? [
                      //Add All services which you want to work with after connection , and first service , which we want to set filter for devices
                      Uuid.parse(deviceUUID)
                      Uuid.parse('0000180a-0000-1000-8000-00805f9b34fb'),
                      Uuid.parse('00001800-0000-1000-8000-00805f9b34fb'),
                    ]
                   : [
                       Uuid.parse(deviceUUID)
                    ]
                    //make sure change Scanmode to opportunistic if First service is for filtering ( just a temporary workaround for now)
              scanMode: kIsWeb ? ScanMode.opportunistic : ScanMode.lowLatency)
          .listen((device) {}
```
