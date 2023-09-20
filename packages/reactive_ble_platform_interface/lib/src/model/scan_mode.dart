/// Android only: mode in which BLE discovery is executed.
enum ScanMode {
  /// passively listen for other scan results without starting BLE scan itself.
  opportunistic,

  /// Scan mode which has the lowest battery consumption.
  lowPower,

  /// Scan mode that is a good compromise between battery consumption and latency.
  balanced,

  /// Scan mode with highest battery consumption and lowest latency.
  /// Should not be used when scanning for a long time.
  lowLatency,
}

/// Converts [ScanMode] to integer representation.
int convertScanModeToArgs(ScanMode scanMode) {
  switch (scanMode) {
    case ScanMode.opportunistic:
      return -1;
    case ScanMode.lowPower:
      return 0;
    case ScanMode.balanced:
      return 1;
    case ScanMode.lowLatency:
      return 2;
  }
}
