import 'package:equatable/equatable.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';

import '../features.dart';

/// Scale property for the [FeatureTextStyle] feature.
enum FeatureTextStyleScale {
  h1,
  h2,
  h3,
  body;

  /// Factory constructor that creates a [FeatureTextStyleScale] from its string
  /// name.
  factory FeatureTextStyleScale.fromName(String name) => values.firstWhere(
        (e) => e.name.toLowerCase() == name.toLowerCase(),
        orElse: () => throw ArgumentError.value(name, 'name', 'Invalid name'),
      );

  /// Returns the localized 1-2 letter acronym of the enum to be displayed in
  /// the UI.
  // FIXME: l10n
  String getLocalizedAcronym(BuildContext context) => switch (this) {
        h1 => 'H1',
        h2 => 'H2',
        h3 => 'H3',
        body => 'P',
      };

  /// Returns the localized name of the enum to be displayed in the UI.
  // FIXME: l10n
  String getLocalizedName(BuildContext context) => switch (this) {
        h1 => 'Display',
        h2 => 'Headline',
        h3 => 'Title',
        body => 'Paragraph',
      };

  TextStyle? getFlutterTextStyle(BuildContext context) => switch (this) {
        h1 => context.tt.displayMedium,
        h2 => context.tt.headlineMedium,
        h3 => context.tt.titleLarge,
        body => context.tt.bodyMedium,
      };
}

/// Text style feature for the widget.
final class FeatureTextStyle extends Equatable {
  /// Scale property for the text style.
  ///
  /// It defines how big the text should be.
  final FeatureTextStyleScale scale;

  /// Color property for the text style.
  ///
  /// If not provided, normally, the text should be rendered in the theme
  /// default color for text.
  final FeatureColor? color;

  /// Font weight property for the text style.
  ///
  /// If not provided, normally, the text should be rendered with the `normal`
  /// font weight.
  final FontWeight? fontWeight;

  /// Decoration property for the text style.
  final TextDecoration? decoration;

  const FeatureTextStyle({
    required this.scale,
    this.color,
    this.fontWeight,
    this.decoration,
  });

  /// Creates a text style with the display large scale.
  const FeatureTextStyle.h1({
    this.color,
    this.fontWeight,
    this.decoration,
  }) : scale = FeatureTextStyleScale.h1;

  /// Creates a text style with the default body scale.
  const FeatureTextStyle.body({
    this.color,
    this.fontWeight,
    this.decoration,
  }) : scale = FeatureTextStyleScale.body;

  @override
  List<Object?> get props => [
        scale,
        color,
        fontWeight,
        decoration,
      ];

  /// Creates a copy of the [FeatureTextStyle] with the provided properties.
  FeatureTextStyle copyWith({
    FeatureTextStyleScale? scale,
    FeatureColor? color,
    FontWeight? fontWeight,
    TextDecoration? decoration,
  }) =>
      FeatureTextStyle(
        scale: scale ?? this.scale,
        color: color ?? this.color,
        fontWeight: fontWeight ?? this.fontWeight,
        decoration: decoration ?? this.decoration,
      );

  /// Converts the [FeatureTextStyle] to a Flutter native [TextStyle].
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
