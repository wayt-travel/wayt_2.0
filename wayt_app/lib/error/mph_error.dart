import 'package:flutter/material.dart';

/// Generic error class to handle errors in the app.
final class MphError {
  final String code;
  final String message;
  final String Function(BuildContext context) userIntlMessage;

  const MphError({
    required this.code,
    required String defaultMessage,
    required this.userIntlMessage,
  }) : message = defaultMessage;

  @override
  String toString() => 'MphError{code: $code, message: $message}';

  MphError copyWithMessage(String message) => MphError(
        code: code,
        defaultMessage: message,
        userIntlMessage: userIntlMessage,
      );
}
