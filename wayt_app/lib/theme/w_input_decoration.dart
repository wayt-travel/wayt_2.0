import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';

import '../core/context/context.dart';

/// {@template w_input_decoration}
/// A custom input decoration for Wayt text fields.
/// {@endtemplate}
class WInputDecoration extends InputDecoration {
  /// {@macro w_input_decoration}
  WInputDecoration(
    BuildContext context, {
    super.labelText,
    int errorMaxLines = 4,
  }) : super(
          errorMaxLines: errorMaxLines,
          filled: true,
          fillColor: context.col.surfaceContainer,
          border: OutlineInputBorder(
            borderRadius: $corners.card.asBorderRadius,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          alignLabelWithHint: true,
        );
}
