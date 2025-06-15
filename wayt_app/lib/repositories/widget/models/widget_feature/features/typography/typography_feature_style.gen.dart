import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../../repositories.dart';

part 'typography_feature_style.gen.g.dart';

/// Style for the typography feature.
@JsonSerializable()
@FontWeightJsonConverter()
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
  final bool isUnderlined;

  /// Creates a new instance of the [TypographyFeatureStyle].
  const TypographyFeatureStyle({
    required this.scale,
    this.color,
    this.fontWeight,
    this.isUnderlined = false,
  });

  /// Creates a typography style with the display large scale.
  const TypographyFeatureStyle.h1({
    FeatureColor? color,
    FontWeight? fontWeight,
    bool isUnderlined = false,
  }) : this(
          scale: TypographyFeatureScale.h1,
          color: color,
          fontWeight: fontWeight,
          isUnderlined: isUnderlined,
        );

  /// Creates a typography style with the default body scale.
  const TypographyFeatureStyle.body({
    FeatureColor? color,
    FontWeight? fontWeight,
    bool isUnderlined = false,
  }) : this(
          scale: TypographyFeatureScale.body,
          color: color,
          fontWeight: fontWeight,
          isUnderlined: isUnderlined,
        );

  /// Creates a [TypographyFeatureStyle] from a JSON map.
  factory TypographyFeatureStyle.fromJson(Map<String, dynamic> json) =>
      _$TypographyFeatureStyleFromJson(json);

  /// Converts the [TypographyFeatureStyle] to a JSON map.
  Map<String, dynamic> toJson() => _$TypographyFeatureStyleToJson(this);

  @override
  List<Object?> get props => [
        scale,
        color,
        fontWeight,
        isUnderlined,
      ];

  /// Creates a copy of the [TypographyFeatureStyle] with the provided
  /// properties.
  TypographyFeatureStyle copyWith({
    TypographyFeatureScale? scale,
    FeatureColor? color,
    FontWeight? fontWeight,
    bool? isUnderlined,
  }) =>
      TypographyFeatureStyle(
        scale: scale ?? this.scale,
        color: color ?? this.color,
        fontWeight: fontWeight ?? this.fontWeight,
        isUnderlined: isUnderlined ?? this.isUnderlined,
      );

  /// Converts the [TypographyFeatureStyle] to a Flutter native [TextStyle].
  ///
  /// The [context] is required to access the theme text styles.
  TextStyle toFlutterTextStyle(BuildContext context) {
    final materialStyle = scale.getFlutterTextStyle(context);
    return (materialStyle ?? const TextStyle()).copyWith(
      color: color?.toFlutterColor(context),
      fontWeight: fontWeight,
      decoration: isUnderlined ? TextDecoration.underline : TextDecoration.none,
    );
  }
}
