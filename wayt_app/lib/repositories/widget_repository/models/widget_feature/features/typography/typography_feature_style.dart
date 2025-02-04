import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../features.dart';

/// Style for the typography feature.
final class TypographyFeatureStyle extends Equatable {
  /// Scale property for the typography style.
  ///
  /// It defines how big the text should be.
  final TypographyFeatureScale scale;

  /// Color property for the typography style.
  ///
  /// If not provided, normally, the text should be rendered in the theme
  /// default color for text.
  final FeatureColor? color;

  /// Font weight property for the typography style.
  ///
  /// If not provided, normally, the text should be rendered with the `normal`
  /// font weight.
  final FontWeight? fontWeight;

  /// Decoration property for the typography style.
  final TextDecoration? decoration;

  /// Creates a new instance of the [TypographyFeatureStyle].
  const TypographyFeatureStyle({
    required this.scale,
    this.color,
    this.fontWeight,
    this.decoration,
  });

  /// Creates a typography style with the display large scale.
  const TypographyFeatureStyle.h1({
    this.color,
    this.fontWeight,
    this.decoration,
  }) : scale = TypographyFeatureScale.h1;

  /// Creates a typography style with the default body scale.
  const TypographyFeatureStyle.body({
    this.color,
    this.fontWeight,
    this.decoration,
  }) : scale = TypographyFeatureScale.body;

  @override
  List<Object?> get props => [
        scale,
        color,
        fontWeight,
        decoration,
      ];

  /// Creates a copy of the [TypographyFeatureStyle] with the provided
  /// properties.
  TypographyFeatureStyle copyWith({
    TypographyFeatureScale? scale,
    FeatureColor? color,
    FontWeight? fontWeight,
    TextDecoration? decoration,
  }) =>
      TypographyFeatureStyle(
        scale: scale ?? this.scale,
        color: color ?? this.color,
        fontWeight: fontWeight ?? this.fontWeight,
        decoration: decoration ?? this.decoration,
      );

  /// Converts the [TypographyFeatureStyle] to a Flutter native [TextStyle].
  ///
  /// The [context] is required to access the theme text styles.
  TextStyle toFlutterTextStyle(BuildContext context) {
    final materialStyle = scale.getFlutterTextStyle(context);
    return (materialStyle ?? const TextStyle()).copyWith(
      color: color?.toFlutterColor(context),
      fontWeight: fontWeight,
      decoration: decoration,
    );
  }
}
