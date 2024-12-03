import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../features/features.dart';
import '../widgets/widgets.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>();
final _profileNavigatorKey = GlobalKey<NavigatorState>();

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

      // initial routes with no app bar, e.g. login and sign up routes
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNestedNavigation(
            navigationShell: navigationShell,
          );
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              HomePage.route,
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _profileNavigatorKey,
            routes: [
              ProfilePage.route,
            ],
          ),
        ],
      ),
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
    });
