import 'errors.dart';

export 'exceptions/exceptions.dart';
export 'w_error.dart';

const _somethingWentWrongMessage = 'Oops, Something went wrong.';

final $errors = (
  generic: WError(
    code: 'GENERIC_ERROR',
    defaultMessage: 'A generic error occurred.',
    // FIXME: l10n
    userIntlMessage: (context) => _somethingWentWrongMessage,
  ),
  auth: (
    unauthenticated: WError(
      code: 'UNAUTHENTICATED',
      defaultMessage: 'The user is not authenticated.',
      // FIXME: l10n
      userIntlMessage: (context) => 'The user is not authenticated.',
    )
  ),
  validation: (
    invalidCubitState: WError(
      code: 'INVALID_CUBIT_STATE',
      defaultMessage: 'The cubit state is invalid. It should have been '
          'validated before reaching this point.',
      // FIXME: l10n
      userIntlMessage: (context) => _somethingWentWrongMessage,
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