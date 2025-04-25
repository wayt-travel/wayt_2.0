import 'package:fpdart/fpdart.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';

import 'error.dart';

/// Gets the predicate to pass as second argument to [TaskEither.tryCatch].
///
/// If you pass a non-null [error], it will be used as the error reported by the
/// [TaskEither] failure if an error is not already wrapped in the thrown
/// exception. In the former case, we want to maintain the original error and
/// not replace it with the [error] passed.
///
/// If you're confident that the task will fail only due to a [WException],
/// i.e., with a [WError] already wrapped in the exception, there is no need
/// to pass an [error] to this function.
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
  WError? error,
  String message = 'The following error occurred',
}) =>
    (e, s) {
      error = e.errorOr(error ?? e.errorOrGeneric);
      logger.e('$message $error', e, s);
      return error!;
    };
