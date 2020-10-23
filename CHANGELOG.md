## 2.6.1

* Prevent incrorrect propagation of error in case observing BLE status fails.

## 2.6.0

* Fix #125 Class `DiscoveredService` isn't exported.
* Set min supported iOS version to 11.
* Replace `RaisedButton` with `ElevatedButton` in Example app.

## 2.5.3

* Fix #118 not sending disconnect update when device is disconnected on Android.
* Fix pubspec sorting.

## 2.5.2

* Update Android protobuf and depedencies to support new Android sdk.
* Fix #114 Throwing faulty error when executing hot restart during scanning on Android.

## 2.5.1

* Update Podfile to support latest Flutter version.

## 2.5.0

* Add service discovery operation
* Fix #104 problems adding library to add-to-app on iOS.
* Fix #105 handle devices changing name during scanning on Android.

## 2.4.0+1

* Fix #97 crash on notifications when device gets disconnected on Android.

## 2.4.0

* Fix device list layout in the example app.
* Prefer `CBAdvertisementDataLocalName` over `peripheral.name` on iOS.
* Add consistent debug logging for both iOS and Android.

## 2.3.0

* Increase test coverage and improved architecture.
* Fix for #73 scanForDevices stream should emit error.

## 2.2.0

* Upgrade dependencies.
* Bump min Dart sdk version to 2.7.

## 2.1.0

* Improve documentation of public API.
* Fix for write without response on iOS.
* Add support for newer Flutter versions. Remove support for FLutter lower than v1.10.

## 2.0.0+1

* Remove unused dependencies from pubspec.yaml.
* Fix static analysis warning in example app.
* Fix test in prescan_connector_test.  

## 2.0.0

This version is introducing the following breaking changes:

* Add parameter requireLocationServicesEnabled to Ble scan that can toggle requirement of location services to be running.
* Make filter on advertising services optional and add possibility to filter on more services.
* Add manufacturer specific data to scanresults.
* Remove global set error handler java.

Other improvements:

* Improvements for example app.
* Add support for Flutter hot reload on iOS.

## 1.1.0

* Add RSSI value to discovered device results.
* Improve parsing of UUIDs.
* Migrate to latest Android plugin binding.
* Small improvements. 

## 1.0.2

* Fix crash on clear Gattcache.

## 1.0.1

* Fixes #5 Undeliverable exception.

* Small fixes for example app.

## 1.0.0+1

* Update homepage.

## 1.0.0

* Initial Open Source release.
