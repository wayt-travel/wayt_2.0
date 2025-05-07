import 'package:flutter/services.dart';

/// {@template double_text_input_formatter}
/// A [TextInputFormatter] that allows only double values.
///
/// It allows the use of comma or dot as decimal separator.
/// {@endtemplate}
class DoubleTextInputFormatter extends FilteringTextInputFormatter {
  static const _unsignedDoubleRegex = r'^((0|([1-9][0-9]*))([\.,][0-9]*)?)?';
  static const _signedDoubleRegex = r'^-?((0|([1-9][0-9]*))([\.,][0-9]*)?)?';

  /// {@macro double_text_input_formatter}
  ///
  /// [allowNegative] indicates whether negative values are allowed.
  DoubleTextInputFormatter({
    bool allowNegative = false,
  }) : super(
          RegExp(allowNegative ? _signedDoubleRegex : _unsignedDoubleRegex),
          allow: true,
        );
}
