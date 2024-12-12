import 'package:get_it/get_it.dart';

import '../app/app.dart';
import '../config/app_config.dart';
import '../repositories/repositories.dart';
import 'init.dart';

void registersRepositories() {
  final config = GetIt.I.get<AppConfig>();

  late final ({
    AuthRepository authRepo,
    UserRepository userRepo,
    PlanRepository planRepo,
  }) repositories;

  if (config.mode.isApi) {
    throw UnimplementedError('The Api configuration is not yet supported.');
  }
  repositories = inMemoryRepositories();

  // Injects the app bloc inside this method.
  // App Bloc must be register because router uses it.
  GetIt.I.registerSingleton<AppBloc>(
    AppBloc(
      authRepo: repositories.authRepo,
      userRepo: repositories.userRepo,
    ),
  );

  GetIt.I.registerSingleton<AuthRepository>(repositories.authRepo);
  GetIt.I.registerSingleton<UserRepository>(repositories.userRepo);
  GetIt.I.registerSingleton<PlanRepository>(repositories.planRepo);
}
