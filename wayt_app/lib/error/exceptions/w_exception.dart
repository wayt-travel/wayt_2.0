import '../errors.dart';

abstract class WException implements Exception {
  final WError error;

  WException(this.error);

  @override
  String toString() => '$WException{error: $error}';
}

extension WErrorFromException on Object {
  WError? get maybeError =>
      this is WException ? (this as WException).error : null;

  WError get errorOrGeneric =>
      this is WException ? (this as WException).error : $errors.generic;

  WError errorOr(WError error) =>
      this is WException ? (this as WException).error : error;
}
