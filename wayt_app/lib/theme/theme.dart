// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';

import '../core/core.dart';

export 'random_color.dart';

const kFontFamilySans = 'Noto Sans';
const kFontFamilySerif = 'Noto Serif';

/// Returns the padding to add at the bottom of a scrollable widget to make sure
/// the last item is not hidden by the bottom navigation bar and the FAB
double getScrollableBottomPadding(BuildContext context, {bool hasFab = true}) =>
    context.mq.padding.bottom + (hasFab ? 68 : 0) + 12;

final kThemeInitial = ThemeData.from(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xff182B57),
    brightness: Brightness.dark,
  ),
);

/// Wrapper for the Wayt theme.
///
/// This wrapper applies the Wayt theme to the child widget.
///
/// Changes to theme must be done here and not in the [kThemeInitial] because
/// here the theme has been enhanced with context specific information.
class WaytThemeWrapper extends StatelessWidget {
  final Widget child;
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
<<<<<<< Updated upstream
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
=======
>>>>>>> Stashed changes
      ),
      child: child,
    );
  }
}
