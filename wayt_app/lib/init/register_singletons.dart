import 'package:get_it/get_it.dart';

import '../app/app.dart';
import '../core/context/context.dart';
import '../repositories/repositories.dart';
import 'init.dart';

/// Registers the singletons of the application.
void registerSingletons() {
  late final RepositoryPack repositories;
  if ($.env.useInMemoryRepositories) {
    repositories = inMemoryRepositories();
  } else {
    throw UnimplementedError(
      'Not in-memory repositories are not supported yet.',
    );
  }

  GetIt.I.registerSingleton<InitializationCubit>(InitializationCubit());

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
  GetIt.I.registerSingleton<SummaryHelperRepository>(
    repositories.summaryHelperRepo,
  );
  GetIt.I.registerSingleton<TravelDocumentRepository>(
    repositories.travelDocument,
  );
  GetIt.I.registerSingleton<TravelItemRepository>(repositories.travelItemRepo);
  GetIt.I.registerSingleton<TravelDocumentLocalMediaDataSource>(
    TravelDocumentLocalMediaDataSource(
      appContext: AppContext.I,
      authRepository: repositories.authRepo,
    ),
  );
}
