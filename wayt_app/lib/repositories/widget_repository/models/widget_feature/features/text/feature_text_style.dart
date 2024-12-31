import 'package:equatable/equatable.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';

enum FeatureTextStyleScale {
  displayLarge,
  displayMedium,
  displaySmall,
  headlineLarge,
  headlineMedium,
  headlineSmall,
  titleLarge,
  titleMedium,
  titleSmall,
  bodyLarge,
  bodyMedium,
  bodySmall,
  labelLarge,
  labelMedium,
  labelSmall,
}

final class FeatureTextStyle extends Equatable {
  final FeatureTextStyleScale scale;
  final String? color;
  final FontWeight? fontWeight;
  final TextDecoration? decoration;

  const FeatureTextStyle({
    required this.scale,
    this.color,
    this.fontWeight,
    this.decoration,
  });

  const FeatureTextStyle.h1({
    this.color,
    this.fontWeight,
    this.decoration,
  }) : scale = FeatureTextStyleScale.displayLarge;

  const FeatureTextStyle.body({
    this.color,
    this.fontWeight,
    this.decoration,
  }) : scale = FeatureTextStyleScale.bodyMedium;

  @override
  List<Object?> get props => [
        scale,
        color,
        fontWeight,
        decoration,
      ];

  TextStyle toFlutterTextStyle(BuildContext context) {
    final materialStyle = switch (scale) {
      FeatureTextStyleScale.displayLarge => context.tt.displayLarge,
      FeatureTextStyleScale.displayMedium => context.tt.displayMedium,
      FeatureTextStyleScale.displaySmall => context.tt.displaySmall,
      FeatureTextStyleScale.headlineLarge => context.tt.headlineLarge,
      FeatureTextStyleScale.headlineMedium => context.tt.headlineMedium,
      FeatureTextStyleScale.headlineSmall => context.tt.headlineSmall,
      FeatureTextStyleScale.titleLarge => context.tt.titleLarge,
      FeatureTextStyleScale.titleMedium => context.tt.titleMedium,
      FeatureTextStyleScale.titleSmall => context.tt.titleSmall,
      FeatureTextStyleScale.bodyLarge => context.tt.bodyLarge,
      FeatureTextStyleScale.bodyMedium => context.tt.bodyMedium,
      FeatureTextStyleScale.bodySmall => context.tt.bodySmall,
      FeatureTextStyleScale.labelLarge => context.tt.labelLarge,
      FeatureTextStyleScale.labelMedium => context.tt.labelMedium,
      FeatureTextStyleScale.labelSmall => context.tt.labelSmall,
    };

    return (materialStyle ?? const TextStyle()).copyWith(
      color: color != null ? Color(int.parse(color!, radix: 16)) : null,
      fontWeight: fontWeight,
      decoration: decoration,
    );
  }
}
