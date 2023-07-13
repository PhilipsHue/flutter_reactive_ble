## 5.1.2

* Bumps to Dart 2.17 minimum and upgrades melos to 3.1.0 (#762)
* Cancel subscription when a disconnect event has been thrown (#769)

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

** Breaking change **
* DiscoveredService has now a new required property called `DiscoveredCharacteristic` which provides properties of the BLE characteristic.

Other changes
* Android 12 support.
* Queue up messages on iOS until event channel is ready. Fixes #137, #251, #307, #385, #387.

## 4.0.1

* Add support for iOS 15

## 4.0.0

* Initial Open Source release.
