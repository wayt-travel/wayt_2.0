import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

void main() {
  group('fpdart TaskResult', () {
    test('should log exceptions only once', () async {
      var count = 0;
      String logException(
        Object exception,
        StackTrace stackTrace,
      ) {
        count++;
        return 'custom error';
      }

      final t1 = TaskEither<String, int>.tryCatch(
        () async => 0,
        logException,
      );

      final t2 = TaskEither<String, int>.tryCatch(
        () async => throw Exception('error'),
        logException,
      );

      final t3 = TaskEither<String, bool>.tryCatch(
        () async => false,
        logException,
      );

      final t4 = TaskEither<String, bool>.tryCatch(
        () async => throw Exception('error'),
        logException,
      );

      final either = await t1
          .flatMap((_) => t2)
          .flatMap((_) => t3)
          .flatMap((_) => t4)
          .run();

      expect(either.isLeft(), isTrue);
      expect(either.isRight(), isFalse);
      expect(count, 1);
    });
  });
}
