import '../error.dart';

/// Exception thrown when the user is not authenticated.
class UnauthenticatedException extends WException {
  /// Creates a new instance of [UnauthenticatedException].
  UnauthenticatedException([WError? error])
      : super(error ?? $errors.auth.unauthenticated);
}
