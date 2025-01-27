import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Generic error class to handle errors in the app.
final class WError extends Equatable {
  /// The error code.
  final String code;

  /// The error debug message. For developers.
  final String message;

  /// The internationalized message for the user.
  final String Function(BuildContext context) userIntlMessage;

  /// Creates a new instance of [WError].
  const WError({
    required this.code,
    required String defaultMessage,
    required this.userIntlMessage,
  }) : message = defaultMessage;

  @override
  String toString() => 'WError{code: $code, message: $message}';

  /// Copies this error with a new message.
  WError copyWithMessage(String message) => WError(
        code: code,
        defaultMessage: message,
        userIntlMessage: userIntlMessage,
      );

  @override
  List<Object?> get props => [code, message];
}
