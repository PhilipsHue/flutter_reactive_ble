## 2.1.0
* Improve documentation of public API
* Fix for write without response on iOS

## 2.0.0+1
* Remove unused dependencies from pubspec.yaml
* Fix static analysis warning in example app
* Fix test in prescan_connector_test  

## 2.0.0
This version is introducing the following breaking changes:
* Add parameter requireLocationServicesEnabled to Ble scan that can toggle requirement of location services to be running
* Make filter on advertising services optional and add possibility to filter on more services
* Add manufacturer specific data to scanresults
* Remove global set error handler java

Other improvements:
* Improvements for example app
* Add support for Flutter hot reload on iOS

## 1.1.0
* Add RSSI value to discovered device results
* Improve parsing of UUIDs
* Migrate to latest Android plugin binding
* Small improvements 

## 1.0.2
* Fix crash on clear Gattcache

## 1.0.1

* Fixes #5 Undeliverable exception.

* Small fixes for example app.

## 1.0.0+1

* Update homepage

## 1.0.0

* Initial Open Source release.