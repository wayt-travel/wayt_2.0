import 'dart:math';

import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';

import '../../../../../core/context/context.dart';
import '../../../../../repositories/repositories.dart';
import '../../../../../theme/theme.dart';

/// {@template text_widget_scale_icon}
/// An icon that represents a [TypographyFeatureScale], i.e., H1, H2, etc.,
/// used to distinguish between different text scales.
/// {@endtemplate}
class TextWidgetScaleIcon extends StatelessWidget {
  /// The [TypographyFeatureScale] to display.
  final TypographyFeatureScale scale;

  /// The size of the icon.
  final double? size;

  /// The border radius of the icon.
  final BorderRadius? borderRadius;

  /// {@macro text_widget_scale_icon}
  const TextWidgetScaleIcon({
    required this.scale,
    this.size,
    this.borderRadius,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.col.onPrimary,
        borderRadius: borderRadius ?? $.style.corners.md.asBorderRadius,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final h = constraints.maxHeight;
          return Center(
            child: SizedBox.square(
              dimension: switch (scale) {
                TypographyFeatureScale.h1 => max(h * 0.9, 40),
                TypographyFeatureScale.h2 => max(h * 0.7, 32),
                TypographyFeatureScale.h3 => max(h * 0.6, 26),
                TypographyFeatureScale.body => max(h * 0.4, 18),
              }
                  .let((dimension) => min(dimension.toDouble(), h)),
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  scale.getLocalizedAcronym(context).toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: kFontFamilySerif,
                    color: context.col.primary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
