import 'package:fpdart/fpdart.dart';

/// Extension methods for [Either].
extension EitherExtension<L, R> on Either<L, R> {
  /// Returns the value of the [Either] if it is a [Left], or throws an
  /// [ArgumentError] if it is a [Right].
  L getLeftOrThrow() => fold(
        (left) => left,
        (right) => throw ArgumentError.value(
          right,
          'right',
          'Either contains a right value: $right',
        ),
      );

  /// Returns the value of the [Either] if it is a [Right], or throws an
  /// [ArgumentError] if it is a [Left].
  R getRightOrThrow() => fold(
        (left) => throw ArgumentError.value(
          left,
          'left',
          'Either contains a left value: $left',
        ),
        (right) => right,
      );
}
