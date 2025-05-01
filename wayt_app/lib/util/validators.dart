import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:luthor/luthor.dart';

export 'validator_extension.dart';

/// Common validators with localization.
final class Validators {
  /// The maximum length for an email address.
  static const emailMaxLength = 254;

  /// The maximum length for a full name.
  static const fullNameMaxLength = 100;

  /// The maximum length for a short text.
  static const maxTextShortLength = 144;

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
        maxTextShortLength,
        // FIXME: l10n
        message: 'It should be at most $maxTextShortLength characters long',
      );

  /// Returns a validator that requires the value to be a non-empty string
  /// without a maximum length constraint.
  Validator textInfiniteRequired() => l
      // FIXME: l10n
      .required(message: 'It cannot be empty')
      .string()
      .min(1);

  /// Returns a validator to validates a double value for latitude coordinates.
  Validator latitude() => l
      // FIXME: l10n
      .required(message: 'It cannot be empty')
      .double()
      .min(-90)
      .max(90);

  /// Returns a validator to validates a double value for longitude coordinates.
  Validator longitude() => l
      // FIXME: l10n
      .required(message: 'It cannot be empty')
      .double()
      .min(-180)
      .max(180);
}
