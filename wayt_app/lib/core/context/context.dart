import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:get_it/get_it.dart';

import '../../env/env.dart';
import '../../error/error.dart';
import '../../repositories/repositories.dart';
import 'context.dart';

export 'app_context.dart';

final class $ {
  static final style = $style;
  static final errors = $errors;
  static final context = AppContext.I;
  static WEnv get env => WEnv.I;

  static ({
    AuthRepository Function() auth,
    PlanRepository Function() plan,
    UserRepository Function() user,
    WidgetRepository Function() widget
  }) get repo => (
        auth: GetIt.I.get<AuthRepository>,
        user: GetIt.I.get<UserRepository>,
        plan: GetIt.I.get<PlanRepository>,
        widget: GetIt.I.get<WidgetRepository>,
      );
}
