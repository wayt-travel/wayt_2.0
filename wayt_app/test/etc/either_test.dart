import 'package:flutter_test/flutter_test.dart';
import 'package:the_umpteenth_logger/the_umpteenth_logger.dart';
import 'package:wayt_app/error/error.dart';

void main() {
  const logger = NthLogger('either_test');
  group('TaskEither', () {
    test('flatMap should not execute tasks if one fails', () async {
      var count = 0;
      final task1 = WTaskEither<int>.tryCatch(
        () async => count = 1,
        taskEitherOnError(logger),
      );
      final task2 = WTaskEither<int>.tryCatch(
        () async => throw Exception('Task 2 failed'),
        taskEitherOnError(logger),
      );
      final task3 = WTaskEither<int>.tryCatch(
        () async => count = 2,
        taskEitherOnError(logger),
      );

      final result =
          await task1.flatMap((_) => task2).flatMap((_) => task3).run();

      expect(result.isLeft(), true);
      expect(count, 1);
    });
  });
}
