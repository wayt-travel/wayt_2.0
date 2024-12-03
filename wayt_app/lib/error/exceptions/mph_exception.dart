import '../error.dart';

abstract class MphException implements Exception {
  final MphError error;

  MphException(this.error);

  @override
  String toString() => 'MphException{error: $error}';
}

extension MphErrorFromException on Object {
  MphError? get maybeError =>
      this is MphException ? (this as MphException).error : null;

  MphError get errorOrGeneric =>
      this is MphException ? (this as MphException).error : $errors.generic;

  MphError errorOr(MphError error) =>
      this is MphException ? (this as MphException).error : error;
}
