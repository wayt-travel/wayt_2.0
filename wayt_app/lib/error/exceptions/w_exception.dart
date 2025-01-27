import '../errors.dart';

/// Exception that wraps a [WError].
abstract class WException implements Exception {
  /// The error that caused the exception.
  final WError error;

  /// Creates a new instance of [WException].
  WException(this.error);

  @override
  String toString() => '$WException{error: $error}';
}

/// Extension to get a WError from a generic exception if it is a [WException].
extension WErrorFromException on Object {
  /// Returns the [WError] if this is a [WException], otherwise `null`.
  WError? get maybeError =>
      this is WException ? (this as WException).error : null;

  /// Returns the [WError] if this is a [WException], otherwise the generic
  /// error.
  WError get errorOrGeneric =>
      this is WException ? (this as WException).error : $errors.generic;

  /// Returns the [WError] if this is a [WException], otherwise the provided
  /// [error].
  WError errorOr(WError error) =>
      this is WException ? (this as WException).error : error;
}
