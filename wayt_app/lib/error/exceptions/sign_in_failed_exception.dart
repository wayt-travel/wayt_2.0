import '../errors.dart';

/// Exception thrown when the sign-in fails.
class SignInFailedException extends WException {
  /// Creates a new instance of [SignInFailedException].
  SignInFailedException([WError? error])
      : super(error ?? $errors.server.auth.signIn.generic);
}
