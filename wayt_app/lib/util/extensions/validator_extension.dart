import 'package:flext/flext.dart';
import 'package:luthor/luthor.dart';

/// Extension methods for [Validator].
extension ValidatorExtension on Validator {
  /// Returns a function to be used as form field validator.
  String? Function(dynamic value) get formFieldValidator =>
      (dynamic value) => validateValue(value)
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

/// Extension methods for [SchemaValidationErrorExtension].
extension SchemaValidationErrorExtension<T> on SchemaValidationError<T> {
  /// Returns the first error message from the errors map.
  String? get firstError {
    final errors = this.errors.values.firstOrNull;
    if (errors == null) {
      return null;
    }
    if (errors is List) {
      final first = errors.firstOrNull;
      if (first is String) {
        return first;
      }
    }
    if (errors is String) {
      return errors;
    }
    return null;
  }
}

/// Extension methods for [SingleValidationResult].
extension SingleValidationResultExtension<T> on SingleValidationResult<T> {
  /// Cast this result to [SingleValidationSuccess].
  SingleValidationSuccess<T> get asSuccess =>
      this as SingleValidationSuccess<T>;

  /// Cast this result to [SingleValidationError].
  SingleValidationError<T> get asError => this as SingleValidationError<T>;
}

/// Extension methods for [SingleValidationErrorExtension].
extension SingleValidationErrorExtension<T> on SingleValidationError<T> {
  /// Returns the first error message from the errors list.
  String? get firstError =>
      errors.firstOrNull is String ? errors.firstOrNull : null;
}
