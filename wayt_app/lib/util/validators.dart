import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:luthor/luthor.dart';

export 'validator_extension.dart';

/// Common validators with localization.
final class Validators {
  static const _maxTextShortLength = 144;

  /// The context to use for localization.
  final BuildContext? context;

  /// Creates a new instance of [Validators] without context, meaning that
  /// the localization will not be used.
  const Validators() : context = null;

  /// Creates a new instance of [Validators] with the given context to use
  /// for localization.
  const Validators.l10n(this.context);

  /// Returns a validator that requires the value not to be null.
  Validator required() => l.required(
        // FIXME: l10n
        message: 'It cannot be empty',
      );

  /// Returns a validator that requires the value to be a non-empty short
  /// string.
  Validator textShortRequired() => textShortOptional()
      // FIXME: l10n
      .required(message: 'It cannot be empty')
      .let((o) => o as StringValidator)
      // FIXME: l10n
      .min(1, message: 'It cannot be empty');

  /// Returns a validator that requires the value to be a short string allowing
  /// null values.
  Validator textShortOptional() => l.string().max(
        _maxTextShortLength,
        // FIXME: l10n
        message: 'It should be at most $_maxTextShortLength characters long',
      );

  /// Returns a validator that requires the value to be a non-empty string
  /// without a maximum length constraint.
  Validator textInfiniteRequired() => l
      // FIXME: l10n
      .required(message: 'It cannot be empty')
      .string()
      .min(1);

  /// Returns a validator to validates a tuple of coordinates `(double,
  /// double)`. The first value is the latitude and the second value is the
  /// longitude. The value must not be null.
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
