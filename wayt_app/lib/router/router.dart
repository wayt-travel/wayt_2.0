import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/features.dart';
import '../widgets/widgets.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

void goToDefaultRoute(BuildContext context) {
  PlanListPage.go(context);
}

StatefulShellRoute _buildStatefulShellRoute(
  List<
          ({
            Icon icon,
            String Function(BuildContext context) getL10nLabel,
            GlobalKey<NavigatorState>? navigatorKey,
            List<GoRoute> routes,
          })>
      items,
) =>
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNestedNavigation(
          navigationShell: navigationShell,
          destinations: items
              .map(
                (item) => NavigationDestination(
                  icon: item.icon,
                  label: item.getL10nLabel(context),
                ),
              )
              .toList(),
        );
      },
      branches: items
          .map(
            (item) => StatefulShellBranch(
              navigatorKey: item.navigatorKey,
              routes: item.routes,
            ),
          )
          .toList(),
    );

final _routerStatefulShellRoute = _buildStatefulShellRoute(
      [
        // (
        //   icon: const Icon(Icons.home_rounded),
        //   // FIXME: l10n
        //   getL10nLabel: (context) => 'Home',
        //   navigatorKey: _homeNavigatorKey,
        //   routes: [HomePage.route],
        // ),
        (
          icon: const Icon(Icons.architecture_rounded),
          // FIXME: l10n
          getL10nLabel: (context) => 'Plans',
          navigatorKey: GlobalKey<NavigatorState>(),
          routes: [PlanListPage.route],
        ),
        (
          icon: const Icon(Icons.person_rounded),
          // FIXME: l10n
          getL10nLabel: (context) => 'Profile',
          navigatorKey: GlobalKey<NavigatorState>(),
          routes: [ProfilePage.route],
        ),
      ],
    );

// Because child of routes doesn't have a bottom navigation bar, they use
// _rootNavigatorKey as a parentNavigationKey parameter.
final $router = GoRouter(
  initialLocation: SplashPage.path,
  navigatorKey: _rootNavigatorKey,
  
  debugLogDiagnostics: true,
  // refreshListenable: GoRouterRefreshStream(
  //   GetIt.I.get<AppBloc>().stream,
  // ),
  routes: [
    SplashPage.route,
    _routerStatefulShellRoute,
  ],
  redirect: (context, state) {
    // final appBlocState = context.read<AppBloc>().state;

    // if (appBlocState.status.isUnknown) {
    //   return null;
    // }

    // final matchedLocation = state.matchedLocation;

    // final authenticatedRoutes = <String>[];

    // final isLoggedIn = appBlocState.status.isAuthenticated;
    // final isGoingToInit = matchedLocation == '/';
    // final isGoingToLogin = matchedLocation.startsWith(HomePage.path);

    // // FIXME: only home page is rendered.
    // // if (!isLoggedIn) {
    // //   return HomePage.path;
    // // } else if (isLoggedIn && (isGoingToInit || isGoingToLogin)) {
    // //   return HomePage.path;
    // // }

    return null;
  },
);
