import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:get_it/get_it.dart';

import '../../error/error.dart';
import '../../repositories/repositories.dart';
import 'context.dart';

export '../../env/env.dart';
export 'app_context.dart';

/// Shortcut to access the style insets.
final $insets = $.style.insets;

/// Shortcut to access the style corners.
final $corners = $.style.corners;

/// Shortcut object to access all app singleton instances.
final class $ {
  /// The app style.
  static final style = $style;

  /// The app errors.
  static final errors = $errors;

  /// The app context.
  static final context = AppContext.I;

  /// The app environment.
  static WEnv get env => WEnv.I;

  /// Gets all app repositories.
  static ({
    AuthRepository Function() auth,
    TravelDocumentRepository Function() travelDocument,
    UserRepository Function() user,
    TravelItemRepository Function() travelItem,
    SummaryHelperRepository Function() summaryHelper,
  }) get repo => (
        auth: GetIt.I.get<AuthRepository>,
        user: GetIt.I.get<UserRepository>,
        travelDocument: GetIt.I.get<TravelDocumentRepository>,
        travelItem: GetIt.I.get<TravelItemRepository>,
        summaryHelper: GetIt.I.get<SummaryHelperRepository>,
      );
}
