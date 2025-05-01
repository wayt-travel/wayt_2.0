import 'package:fpdart/fpdart.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

import 'error.dart';

/// Gets the predicate to pass as second argument to [TaskEither.tryCatch].
///
/// The error reported by the [TaskEither] will be a [WError] determined in this
/// way:
/// - if the caught exception is not an [Exception] but it is an [Error] (fatal
///   error) a `$errors.core.badState` error will be reported
/// - if the caught exception is a managed [WException], the error will be the
///  [WError] wrapped in the exception: we want to maintain the original error.
/// - if [fallbackError] is not null, it will be used as the error reported by
///  the [TaskEither] failure
/// - otherwise, a `$errors.core.generic` error will be reported
///
/// If you're confident that the task will fail only due to a [WException],
/// i.e., with a [WError] already wrapped in the exception, there is no need to
/// pass a [fallbackError] to this function.
///
/// Example usage:
///
/// ```dart
/// final task = TaskEither.tryCatch(
///   () async => await someAsyncFunction(),
///   taskEitherOnError(logger, message: 'Failed to execute task'),
/// );
/// ```
WError Function(Object error, StackTrace stackTrace) taskEitherOnError(
  NthLogger logger, {
  WError? fallbackError,
  String message = 'The following error occurred',
}) =>
    (e, s) {
      fallbackError = e.errorOr(
        fallbackError ??
            (e is Error ? $errors.core.badState : $errors.core.generic),
      );
      logger.e('$message $fallbackError', e, s);
      return fallbackError!;
    };
