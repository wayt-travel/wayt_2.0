import 'package:flutter/material.dart';

/// Generic error class to handle errors in the app.
final class WError {
  final String code;
  final String message;
  final String Function(BuildContext context) userIntlMessage;

  const WError({
    required this.code,
    required String defaultMessage,
    required this.userIntlMessage,
  }) : message = defaultMessage;

  @override
  String toString() => 'WError{code: $code, message: $message}';

  WError copyWithMessage(String message) => WError(
        code: code,
        defaultMessage: message,
        userIntlMessage: userIntlMessage,
      );
}
