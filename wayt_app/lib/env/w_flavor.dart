import 'package:flext/flext.dart';

/// Represents the different flavors to launch the app.
enum WFlavor {
  /// The flavor used for local testing (unit tests).
  localTest,

  /// The flavor used for local development.
  ///
  /// It connects to the local environment.
  local,

  /// The flavor used for development.
  ///
  /// It connects to the dev environment.
  dev,

  /// The flavor used for production.
  prod;

  /// Returns a flavor based on the given name. Throws if not found.
  ///
  /// The name can be in any case and can be in snake case or not, e.g.
  /// 'local_test' or 'localTest'.
  factory WFlavor.fromName(String input) {
    final match = maybeFromName(input);
    if (match == null) {
      throw ArgumentError.value(input, 'input', 'Invalid flavor name');
    }
    return match;
  }

  /// Returns a flavor based on the given name. Null if not found.
  static WFlavor? maybeFromName(String input) => values.firstWhereOrNull(
        (match) => [
          match.name.toLowerCase(),
          match.name.toSnakeCase().toLowerCase(),
        ].contains(input.toLowerCase()),
      );
}
