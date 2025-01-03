/// An annotation to mark a class as a candidate for being ported to the
/// `a2f_sdk` package.
final class SdkCandidate {
  /// Whether the class requires localization (l10n).
  ///
  /// In this case either it is generalized or is cannot be ported to the sdk
  /// until the SDK has a localization solution.
  final bool requiresL10n;

  /// Whether the class is Material 3 friendly.
  ///
  /// To be material 3 friendly, the class must use the new Material 3 spec,
  /// be perfectly compatible with light and dark theme without tweaks.
  final bool isM3Friendly;

  const SdkCandidate({
    this.requiresL10n = false,
    this.isM3Friendly = true,
  });
}
