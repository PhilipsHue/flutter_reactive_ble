/// Specify the bonding mode for the device.
enum BondingMode {
  /// Bonding will not be attempted.
  none,

  /// Bonding will be attempted, but will not be required.
  /// If bonding fails, the connection will still be established.
  notRequired,

  /// Bonding will be attempted and will be required.
  /// If bonding fails, the connection will be terminated.
  required,
}
