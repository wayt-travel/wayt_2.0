import 'package:flext/flext.dart';
import 'package:flutter/material.dart';

/// Scale property for the FeatureTextStyle feature.
enum TypographyFeatureScale {
  /// Display large scale.
  h1,

  /// Headline medium scale.
  h2,

  /// Title large scale.
  h3,

  /// Body medium scale.
  body;

  /// Factory constructor that creates a [TypographyFeatureScale] from its
  /// string name.
  factory TypographyFeatureScale.fromName(String name) => values.firstWhere(
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

  /// Returns the [TextStyle] for the scale.
  TextStyle? getFlutterTextStyle(BuildContext context) => switch (this) {
        h1 => context.tt.displayMedium,
        h2 => context.tt.headlineMedium,
        h3 => context.tt.titleLarge,
        body => context.tt.bodyMedium,
      };
}
