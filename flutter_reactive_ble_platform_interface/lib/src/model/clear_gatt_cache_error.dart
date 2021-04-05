/// Error type of Clear Gatt cache operation.
enum ClearGattCacheError {
  /// Reason of failure is unknown.
  unknown,

  /// Clear gatt cache is not supported on this OS.
  operationNotSupported
}
