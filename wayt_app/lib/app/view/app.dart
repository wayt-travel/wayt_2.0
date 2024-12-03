import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../l10n/l10n.dart';
import '../../router/router.dart';
import '../app.dart';

class WaytApp extends StatelessWidget {
  const WaytApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // the AppBloc is created and injected also in the bloc provider so
      // it is possible to watch the app state.
      create: (ctx) => GetIt.I.get<AppBloc>(),
      child: const WaytView(),
    );
  }
}

class WaytView extends StatelessWidget {
  const WaytView({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routeInformationParser: $router.routeInformationParser,
        routerDelegate: $router.routerDelegate,
        routeInformationProvider: $router.routeInformationProvider,
      );
}
