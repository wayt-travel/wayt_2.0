import 'package:flext/flext.dart';
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
    return BlocProvider.value(
      // the AppBloc is provided and injected also in the bloc provider so
      // it is possible to watch the app state.
      value: GetIt.I.get<AppBloc>()..init(),
      child: const WaytView(),
    );
  }
}

class WaytView extends StatelessWidget {
  const WaytView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff182B57),
          brightness: Brightness.dark,
        ),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routeInformationParser: $router.routeInformationParser,
      routerDelegate: $router.routerDelegate,
      routeInformationProvider: $router.routeInformationProvider,
      builder: (context, child) {
        // Provide the theme below the MaterialApp in the tree so that it has
        // been enhanced with context specific information. E.g., the size of
        // the fonts based on the device size.
        final theme = context.theme;
        return Theme(
          data: theme.copyWith(
            textTheme: theme.textTheme
                .apply(
                  fontFamily: 'Noto Sans',
                )
                .let(
                  (t) => t.copyWith(
                    displayLarge: t.displayLarge?.apply(
                      fontFamily: 'Noto Serif',
                    ),
                    displayMedium: t.displayMedium?.apply(
                      fontFamily: 'Noto Serif',
                    ),
                    displaySmall: t.displaySmall?.apply(
                      fontFamily: 'Noto Serif',
                    ),
                  ),
                ),
            appBarTheme: theme.appBarTheme.copyWith(
              titleTextStyle: theme.textTheme.titleLarge?.copyWith(
                fontFamily: 'Noto Serif',
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
