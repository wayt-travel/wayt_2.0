import 'error.dart';

export 'exceptions/exceptions.dart';
export 'w_error.dart';

final $errors = (
  generic: WError(
    code: 'GENERIC_ERROR',
    defaultMessage: 'A generic error occurred.',
    // FIXME: l10n
    userIntlMessage: (context) => 'Something went wrong.',
  ),
  auth: (
    unauthenticated: WError(
      code: 'UNAUTHENTICATED',
      defaultMessage: 'The user is not authenticated.',
      // FIXME: l10n
      userIntlMessage: (context) => 'The user is not authenticated.',
    )
  ),
  server: (
    auth: (
      signIn: (
        generic: WError(
          code: 'SIGN_IN_FAILED',
          defaultMessage: 'An error occurred while signing-in.',
          // FIXME: l10n
          userIntlMessage: (context) => 'An error occurred while signing-in.',
        ),
        invalidCredentials: WError(
          code: 'SIGN_IN_INVALID_CREDENTIALS',
          defaultMessage: 'Invalid credentials',
          // FIXME: l10n
          userIntlMessage: (context) => 'Invalid credentials.',
        ),
      ),
    ),
  ),
);
