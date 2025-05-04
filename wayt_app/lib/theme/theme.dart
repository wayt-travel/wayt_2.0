import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';

import '../core/core.dart';

export 'random_color.dart';
export 'w_action_card_theme.dart';

/// The Sans font family to use in the app.
const kFontFamilySans = 'Noto Sans';

/// The Serif font family to use in the app.
const kFontFamilySerif = 'Noto Serif';

/// Returns the padding to add at the bottom of a scrollable widget to make sure
/// the last item is not hidden by the bottom navigation bar and the FAB
double getScrollableBottomPadding(BuildContext context, {bool hasFab = true}) =>
    context.mq.padding.bottom + (hasFab ? 68 : 0) + 12;

/// The initial theme of the app.
final kThemeInitial = ThemeData.from(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xff182B57),
    brightness: Brightness.dark,
  ),
);

/// {@template wayt_theme_wrapper}
/// Wrapper for the Wayt theme.
///
/// This wrapper applies the Wayt theme to the child widget.
///
/// Changes to theme must be done here and not in the [kThemeInitial] because
/// here the theme has been enhanced with context specific information.
/// {@endtemplate}
class WaytThemeWrapper extends StatelessWidget {
  /// The child widget to wrap with the Wayt theme.
  final Widget child;

  /// {@macro wayt_theme_wrapper}
  const WaytThemeWrapper({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Theme(
      data: theme.copyWith(
        textTheme: theme.textTheme
            .apply(
              fontFamily: kFontFamilySans,
            )
            .let(
              (t) => t.copyWith(
                displayLarge: t.displayLarge?.apply(
                  fontFamily: kFontFamilySerif,
                ),
                displayMedium: t.displayMedium?.apply(
                  fontFamily: kFontFamilySerif,
                ),
                displaySmall: t.displaySmall?.apply(
                  fontFamily: kFontFamilySerif,
                ),
                titleLarge: t.titleLarge?.apply(
                  fontFamily: kFontFamilySerif,
                ),
                headlineLarge: t.headlineLarge?.apply(
                  fontFamily: kFontFamilySerif,
                ),
                headlineMedium: t.headlineMedium?.apply(
                  fontFamily: kFontFamilySerif,
                ),
                headlineSmall: t.headlineSmall?.apply(
                  fontFamily: kFontFamilySerif,
                ),
              ),
            ),
        inputDecorationTheme: InputDecorationTheme(
          errorMaxLines: 4,
          filled: true,
          fillColor: context.col.surfaceContainer,
          border: OutlineInputBorder(
            borderRadius: $corners.card.asBorderRadius,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          alignLabelWithHint: true,
        ),
        appBarTheme: theme.appBarTheme.copyWith(
          titleTextStyle: theme.textTheme.titleLarge?.copyWith(
            fontFamily: kFontFamilySerif,
          ),
        ),
        cardTheme: theme.cardTheme.copyWith(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.hardEdge,
        ),
        listTileTheme: theme.listTileTheme.copyWith(
          // 16 horizontal: by material design spec.
          // the implementation of list tile puts 24px on the right instead.
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
      child: child,
    );
  }
}
