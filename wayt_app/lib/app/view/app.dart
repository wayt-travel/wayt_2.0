import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../core/core.dart';
import '../../features/features.dart';
import '../../l10n/l10n.dart';
import '../../router/router.dart';
import '../../theme/theme.dart';
import '../app.dart';

/// The main application widget.
class WaytApp extends StatelessWidget {
  /// Creates a new instance of [WaytApp].
  const WaytApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // the InitializationCubit is provided and injected also into the
        // context
        BlocProvider.value(
          value: GetIt.I.get<InitializationCubit>()..onSetup(),
        ),
        BlocProvider.value(
          // the AppBloc is provided and injected also in the bloc provider so
          // it is possible to watch the app state.
          value: GetIt.I.get<AppBloc>(),
        ),
        // the PlanListCubit is provided here because it must be visible from
        // the scaffold to render the FAB.
        BlocProvider(
          create: (context) => PlanListCubit(
            travelDocumentRepository: $.repo.travelDocument(),
            authRepository: $.repo.auth(),
          ),
        ),
      ],
      child: const WaytView(),
    );
  }
}

/// The main application view for the [WaytApp].
class WaytView extends StatelessWidget {
  /// Creates a new instance of [WaytView].
  const WaytView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: kThemeInitial,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routeInformationParser: $router.routeInformationParser,
      routerDelegate: $router.routerDelegate,
      routeInformationProvider: $router.routeInformationProvider,
      builder: (context, child) {
        // Provide the theme below the MaterialApp in the tree so that it has
        // been enhanced with context specific information. E.g., the size of
        // the fonts based on the device size.
        return WaytThemeWrapper(child: AppFacade(child: child!));
      },
    );
  }
}
