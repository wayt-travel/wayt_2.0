import 'package:flutter/material.dart';

import '../util.dart';

/// Extension for [TextStyle] to add some useful methods.
@SdkCandidate()
extension TextStyleExtension on TextStyle {
  /// Copies the current [TextStyle] and applies the italic font style.
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);

  /// Copies the current [TextStyle] and applies the bold font weight.
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);

  /// Copies the current [TextStyle] and applies the underline text decoration.
  TextStyle get underline => copyWith(decoration: TextDecoration.underline);
}
