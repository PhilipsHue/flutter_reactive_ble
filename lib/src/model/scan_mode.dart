enum ScanMode { opportunistic, lowPower, balanced, lowLatency }

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
  assert(false);
  return -1000;
}
