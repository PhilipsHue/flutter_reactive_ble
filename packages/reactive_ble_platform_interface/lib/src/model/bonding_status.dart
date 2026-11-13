/// The bonding state of a peripheral.
///
/// Bonding is an Android-only feature. The bonding state is reported as the
/// result of `ReactiveBlePlatform.establishBonding`.
enum BondingStatus {
  /// The device is not bonded.
  none,

  /// Bonding is in progress.
  bonding,

  /// Bonding is complete.
  bonded,
}
