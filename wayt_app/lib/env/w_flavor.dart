import 'package:flext/flext.dart';

/// Represents the different flavors to launch the app.
enum WFlavor {
  /// The TST flavor.
  ///
  /// It connects to the tst environment.
  tst,

  /// The flavor used for local development.
  ///
  /// It connects to the local deployment.
  dev,

  /// The flavor used for fast development or local testing.
  ///
  /// It does not connect to any environment. It uses in-memory data.
  mem,

  /// The flavor used for production.
  prd;

  /// Returns a flavor based on the given name. Throws if not found.
  ///
  /// The name can be in any case.
  factory WFlavor.fromName(String input) {
    final match = maybeFromName(input);
    if (match == null) {
      throw ArgumentError.value(input, 'input', 'Invalid flavor name');
    }
    return match;
  }

  /// Returns a flavor based on the given name. Null if not found.
  static WFlavor? maybeFromName(String input) => values.firstWhereOrNull(
        (match) => match.name.toLowerCase() == input.toLowerCase(),
      );
}
