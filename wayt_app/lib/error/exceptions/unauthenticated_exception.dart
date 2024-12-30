import '../error.dart';

class UnauthenticatedException extends WException {
  UnauthenticatedException([WError? error])
      : super(error ?? $errors.auth.unauthenticated);
}
