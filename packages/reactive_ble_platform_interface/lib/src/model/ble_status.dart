/// The status of the BLE subsystem as reported by the platform API.
enum BleStatus {
  /// Status is not (yet) determined.
  unknown,

  /// BLE is not supported on this device.
  unsupported,

  /// BLE usage is not authorized for this app.
  unauthorized,

  /// BLE is turned off.
  poweredOff,

  /// Android only: Location services are disabled.
  locationServicesDisabled,

  /// BLE is fully operating for this app.
  ready
}
