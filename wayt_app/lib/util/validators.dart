import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:luthor/luthor.dart';

export 'validator_extension.dart';

/// Common validators with localization.
final class Validators {
  static const _maxTextShortLength = 144;

  final BuildContext? context;

  const Validators() : context = null;

  const Validators.l10n(this.context);

  Validator required() => l.required(
        // FIXME: l10n
        message: 'It cannot be empty',
      );

  Validator textShortRequired() => textShortOptional()
      // FIXME: l10n
      .required(message: 'It cannot be empty')
      .let((o) => o as StringValidator)
      // FIXME: l10n
      .min(1, message: 'It cannot be empty');

  Validator textShortOptional() => l.string().max(
        _maxTextShortLength,
        message: 'It should be at most $_maxTextShortLength characters long',
      );

  Validator textInfiniteRequired() => l
      // FIXME: l10n
      .required(message: 'It cannot be empty')
      .string()
      .min(1);

  Validator coordinates() => l
          // FIXME: l10n
          .required(message: 'It cannot be empty')
          .custom(
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
