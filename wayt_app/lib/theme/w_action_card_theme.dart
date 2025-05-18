import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';

import '../core/core.dart';

/// {@template w_action_card_theme}
/// A widget to apply a custom theme card theme to its child.
///
/// To be used to display a card that has an action on tap.
/// {@endtemplate}
class WActionCardTheme extends StatelessWidget {
  /// The child widget to apply the theme to.
  final Widget child;

  /// {@macro w_action_card_theme}
  const WActionCardTheme({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        cardTheme: theme.cardTheme.copyWith(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: $corners.card.asBorderRadius,
            side: BorderSide(
              width: 1,
              color: context.col.primary,
            ),
          ),
        ),
      ),
      child: child,
    );
  }
}
