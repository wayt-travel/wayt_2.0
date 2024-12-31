import 'package:flutter/material.dart';
import 'package:luthor/luthor.dart';

/// Common validators with localization.
abstract interface class L10nValidators {
  static Validator text1To144([BuildContext? context]) => l
      .string()
      // FIXME: l10n
      .min(1, message: 'It cannot be empty')
      // FIXME: l10n
      .max(144, message: 'It should be at most 144 characters long');

  static Validator text1ToInf([BuildContext? context]) => l.string().min(1);

  static Validator coordinates([BuildContext? context]) => l.custom(
        (coords) {
          if (coords is! (double, double)) return false;
          final (lat, lon) = coords;
          return l.double().min(-90).max(90).validateValue(lat).isValid &&
              l.double().min(-180).max(180).validateValue(lon).isValid;
        },
        // FIXME: l10n
        message: 'Invalid coordinates',
      );
}
