import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

export 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Extension on [BuildContext] to access the [AppLocalizations] instance
extension AppLocalizationsX on BuildContext {
  /// Returns the [AppLocalizations] instance for the current [BuildContext].
  AppLocalizations get l10n => AppLocalizations.of(this);
}
