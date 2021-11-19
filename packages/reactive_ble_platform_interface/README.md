# Reactive_ble_platform_interface

A common platform interface for the [reactive ble](https://github.com/PhilipsHue/flutter_reactive_ble/) plugin. This package ensures every platform specific implementation uses the same interface.

## Usage

To implement a new platform specific implementation extend the `ReactiveBlePlatform` with an implementation that performs the platform specific behavior. 