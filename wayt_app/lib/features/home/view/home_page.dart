import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../theme/theme.dart';

/// The home page.
class HomePage extends StatelessWidget {
  const HomePage._();

  /// The path of the home page.
  static const String path = '/home';

  /// The route name of the home page.
  static const String routeName = 'home';

  /// The route of the home page.
  static GoRoute get route => GoRoute(
        path: path,
        name: routeName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: HomePage._(),
        ),
      );

  /// Navigates to the home page.
  static void go(BuildContext context) {
    context.router.goNamed(
      routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}

/// The view of the home page.
class HomeView extends StatelessWidget {
  /// Creates a new instance of [HomeView].
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          title: Text(
            'Home',
            style: const TextStyle().copyWith(
              fontWeight: FontWeight.bold,
              fontFamily: kFontFamilySerif,
            ),
          ),
        ),
        const Placeholder().asSliver,
      ],
    );
  }
}
