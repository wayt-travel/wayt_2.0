import 'package:flext/flext.dart';
import 'package:luthor/luthor.dart';

/// Extension methods for [Validator].
extension ValidatorExtension on Validator {
  /// Returns a function to be used as form field validator.
  String? Function(String? value)? get formFieldValidator =>
      (String? value) => validateValue(value)
          .let((result) => result.isValid ? null : result.asError.errors.first);
}

/// Extension methods for [SchemaValidationResult].
extension SchemaValidationResultExtension<T> on SchemaValidationResult<T> {
  /// Cast this result to [SchemaValidationSuccess].
  SchemaValidationSuccess<T> get asSuccess =>
      this as SchemaValidationSuccess<T>;

  /// Cast this result to [SchemaValidationError].
  SchemaValidationError<T> get asError => this as SchemaValidationError<T>;
}

/// Extension methods for [SingleValidationResult].
extension SingleValidationResultExtension<T> on SingleValidationResult<T> {
  /// Cast this result to [SingleValidationSuccess].
  SingleValidationSuccess<T> get asSuccess =>
      this as SingleValidationSuccess<T>;

  /// Cast this result to [SingleValidationError].
  SingleValidationError<T> get asError => this as SingleValidationError<T>;
}
