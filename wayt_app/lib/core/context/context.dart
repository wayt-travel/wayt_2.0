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
    AuthRepository auth,
    PlanRepository plan,
    PlanRepository user,
    PlanRepository widget
  }) get repo => (
        auth: GetIt.I.get<AuthRepository>(),
        user: GetIt.I.get<PlanRepository>(),
        plan: GetIt.I.get<PlanRepository>(),
        widget: GetIt.I.get<PlanRepository>(),
      );
}
