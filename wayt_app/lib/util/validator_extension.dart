import 'package:flext/flext.dart';
import 'package:luthor/luthor.dart';

extension ValidatorExtension on Validator {
  String? Function(String? value)? get formFieldValidator =>
      (String? value) => validateValue(value)
          .let((result) => result.isValid ? null : result.asError.errors.first);
}

extension SchemaValidationResultExtension<T> on SchemaValidationResult<T> {
  SchemaValidationSuccess<T> get asSuccess =>
      this as SchemaValidationSuccess<T>;

  SchemaValidationError<T> get asError => this as SchemaValidationError<T>;
}

extension SingleValidationResultExtension<T> on SingleValidationResult<T> {
  SingleValidationSuccess<T> get asSuccess =>
      this as SingleValidationSuccess<T>;

  SingleValidationError<T> get asError => this as SingleValidationError<T>;
}
