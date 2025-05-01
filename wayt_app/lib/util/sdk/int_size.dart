import 'dart:math';
import 'dart:ui';

import 'package:equatable/equatable.dart';

import '../util.dart';

/// A class that represents a size with integer width and height.
@SdkCandidate()
class IntSize with EquatableMixin {
  /// The width of the size.
  final int width;

  /// The height of the size.
  final int height;

  /// Creates an [IntSize] with the given width and height.
  const IntSize({
    required this.width,
    required this.height,
  })  : assert(width >= 0, 'Width must be non-negative'),
        assert(height >= 0, 'Height must be non-negative');

  /// Creates an [IntSize] with zero width and height.
  const IntSize.zero()
      : width = 0,
        height = 0;

  /// Creates a square [IntSize] with the given size.
  const IntSize.square(int size)
      : width = size,
        height = size,
        assert(size >= 0, 'Size must be non-negative');

  /// Creates an [IntSize] from a named tuple with `width` and `height`
  /// properties.
  factory IntSize.fromNamedTuple(({int width, int height}) size) => IntSize(
        width: size.width,
        height: size.height,
      );

  /// Creates an [IntSize] from a tuple.
  factory IntSize.fromTuple((int width, int height) size) => IntSize(
        width: size.$1,
        height: size.$2,
      );

  /// Creates an [IntSize] from a JSON object.
  factory IntSize.fromJson(Map<String, dynamic> json) => IntSize(
        width: (json['width'] as num).toInt(),
        height: (json['height'] as num).toInt(),
      );

  /// Creates an [IntSize] from a JSON object, or returns null if the
  /// JSON object is null.
  static IntSize? maybeFromJson(Map<String, dynamic>? json) =>
      json == null ? null : IntSize.fromJson(json);

  /// Creates an [IntSize] from a JSON object, or returns null if the
  /// JSON object is null or invalid.
  static IntSize? tryFromJson(Map<String, dynamic>? json) {
    try {
      return IntSize.maybeFromJson(json);
    } catch (e) {
      return null;
    }
  }

  /// Converts the [IntSize] instance to a JSON object.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'width': width,
        'height': height,
      };

  /// Gets the aspect ratio of the size.
  double get aspectRatio {
    if (height != 0.0) {
      return width / height;
    }
    if (width > 0.0) {
      return double.infinity;
    }
    if (width < 0.0) {
      return double.negativeInfinity;
    }
    return 0;
  }

  /// Returns the area of the size.
  int get area => width * height;

  /// Returns the maximum of the width and height.
  int get longestSide => max(width, height);

  /// Returns the minimum of the width and height.
  int get shortestSide => min(width, height);

  /// Returns the size flipped, with width and height swapped.
  IntSize get flipped => IntSize(
        width: height,
        height: width,
      );

  /// Returns the size as a FlutterUI [Size] object.
  Size toSize() => Size(width.toDouble(), height.toDouble());

  /// Performs a difference operation on two [IntSize] objects.
  IntSize operator -(IntSize other) => IntSize(
        width: width - other.width,
        height: height - other.height,
      );

  /// Performs a sum operation on two [IntSize] objects.
  IntSize operator +(IntSize other) => IntSize(
        width: width + other.width,
        height: height + other.height,
      );

  /// Returns a new [IntSize] with height and width multiplied by the given
  /// [factor].
  IntSize operator *(double factor) => IntSize(
        width: (width * factor).round(),
        height: (height * factor).round(),
      );

  /// Returns a new [IntSize] with height and width divided by the given
  /// [factor].
  IntSize operator /(double factor) => IntSize(
        width: (width / factor).round(),
        height: (height / factor).round(),
      );

  /// Returns a new [IntSize] with height and width int-divided by the given
  /// [factor].
  IntSize operator ~/(double factor) => IntSize(
        width: width ~/ factor,
        height: height ~/ factor,
      );

  /// Returns a new [IntSize] with height and width modulo the given
  /// [factor].
  IntSize operator %(double factor) => IntSize(
        width: (width % factor).round(),
        height: (height % factor).round(),
      );

  @override
  List<Object?> get props => [width, height];
}
