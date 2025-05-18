import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';

import '../../core/core.dart';

/// {@template alt_horizontal_line}
/// A horizontal line with a text in the middle.
/// {@endtemplate}
class AltHorizontalLine extends StatelessWidget {
  /// The text to display in the middle of the line.
  ///
  /// If null, the default text 'Or' will be used.
  final String? text;

  /// {@macro alt_horizontal_line}
  ///
  /// The [text] parameter is optional and defaults to 'Or'.
  const AltHorizontalLine({
    this.text,
    super.key,
  });

  Widget _getLine(BuildContext context) => Expanded(
        child: Divider(
          color: context.col.onSurface.withValues(alpha: 0.5),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: $insets.sm.asPaddingV,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _getLine(context),
          Padding(
            padding: $insets.xs.asPaddingH,
            child: Text((text ?? 'Or').toUpperCase()),
          ),
          _getLine(context),
        ],
      ),
    );
  }
}
