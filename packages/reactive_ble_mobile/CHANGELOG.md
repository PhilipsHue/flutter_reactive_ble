## 5.3.1

*  Use proper platform_interface dependency version #837

## 5.3.0

* Readd accidentally removed version constraint #789
* Add a placeholder implementation for non-mobile platforms #688
* Add Github actions and Migrate to latest Android SDK, AGP and protobuf plugin  #830
* Include packages lock-files #797
* Update Kotlin version in README #831
* Migrate away from deprecated strong mode analysis options #832
* Read RSSI #796

## 5.2.0

* Bump the minimum requirement to Dart 2.17 and upgrade melos to 3.1.0 in #762
* swiftlint config and inital formatting pass in #765
* Cancel subscription when a disconnect event has been thrown in #769
* Fix typos in #778
* Update CI config to use Xcode 14 in #786
* Support multiple services or characteristics with the same id in #776
* Breaking change: If a device has multiple characteristics with the same ID, `readCharacteristic`, `writeCharacteristic` and `subscribeToCharacteristic` used to select the first of those characteristics. Now they will fail in this case. Use `resolve` or `getDiscoveredServices` instead.

## 5.1.1

* Make Connectable backwards compatible #757, #750

## 5.1.0

* Add IsConnectable to discovery data. #750
* Upgraded build_runner. #750

## 5.0.3

* Enable extended advertising on android. Fix #571
* Add additional null checks to scanRecord. Fix #521
* Restore support for Xcode 12
* Add verbose debug logging Fix #583 

## 5.0.2

 * Revert Queue up messages on iOS until event channel is ready. Fix #439

## 5.0.1

* Bump protobuf so it includes binaries for Mac M1 #396.

## 5.0.0

* `DiscoveredService` has now a new required property called `DiscoveredCharacteristic` which provides properties of the BLE characteristic.
* Android 12 support.
* Queue up messages on iOS until event channel is ready. Fixes #137, #251, #307, #385, #387.

## 4.1.0

* Add support Android 12

## 4.0.1

* Add support for iOS 15

## 4.0.0

* Initial Open Source release.

