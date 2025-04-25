import '../error.dart';

class _GenericException implements WException {
  @override
  final WError error;

  _GenericException(this.error);

  @override
  String toString() => 'GenericException{error: $error}';
}

/// Exception that wraps a [WError].
abstract class WException implements Exception {
  /// The error that caused the exception.
  final WError error;

  /// Creates a new instance of [WException].
  WException(this.error);

  /// Creates a new instance of [WException] with a generic error.
  factory WException.generic(WError error) {
    return _GenericException(error);
  }

  @override
  String toString() => '$WException{error: $error}';
}

/// Extension to get a WError from a generic exception if it is a [WException].
///
/// If `this` is already a [WError], it will be returned as is.
extension WErrorFromException on Object {
  /// If `this` is a [WException] it returns the [WError] contained withing,
  /// if `this` is a [WError] it returns itself, otherwise it returns null.
  WError? get maybeError {
    if (this is WError) return this as WError;
    if (this is WException) return (this as WException).error;
    return null;
  }

  /// Return the result of [maybeError] if it is not null, otherwise returns the
  /// the generic error.
  WError get errorOrGeneric => errorOr($errors.core.generic);

  /// Return the result of [maybeError] if it is not null, otherwise returns the
  /// the input [error].
  WError errorOr(WError error) => maybeError ?? error;
}
