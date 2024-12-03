import 'error.dart';

export 'exceptions/mph_exception.dart';
export 'mph_error.dart';

final $errors = (
  generic: MphError(
    code: 'GENERIC_ERROR',
    defaultMessage: 'A generic error occurred.',
    // FIXME: l10n
    userIntlMessage: (context) => 'Something went wrong.',
  ),
);
