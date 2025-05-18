import 'package:fpdart/fpdart.dart';

import '../util.dart';

/// Extension methods for [Either].
@SdkCandidate()
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

/// Extension methods for [Option].
extension OptionExtension<T> on Option<T> {
  /// Returns the value of the [Option] if it is a [Some], or returns
  /// [other] if it is a [None].
  T getOr(T other) => getOrElse(() => other);

  /// Returns the value of the [Option] if it is a [Some], or returns
  /// `null` if it is a [None].
  T? getOrNull() => map((t) => t as T?).getOrElse(() => null);
}
