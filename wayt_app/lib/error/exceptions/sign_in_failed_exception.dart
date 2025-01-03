import '../errors.dart';

class SignInFailedException extends WException {
  SignInFailedException([WError? error])
      : super(error ?? $errors.server.auth.signIn.generic);
}
