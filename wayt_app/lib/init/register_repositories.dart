import 'package:get_it/get_it.dart';

import '../app/app.dart';
import '../core/context/context.dart';
import '../repositories/repositories.dart';
import 'init.dart';

void registerRepositories() {
  late final RepositoryPack repositories;
  if ($.env.useInMemoryRepositories) {
    repositories = inMemoryRepositories();
  } else {
    throw UnimplementedError(
      'Not in-memory repositories are not supported yet.',
    );
  }

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
  GetIt.I.registerSingleton<WidgetRepository>(repositories.widgetRepo);
}