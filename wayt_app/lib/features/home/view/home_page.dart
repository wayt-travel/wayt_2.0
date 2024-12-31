import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../theme/theme.dart';

class HomePage extends StatelessWidget {
  const HomePage._();

  static const String path = '/home';
  static const String routeName = 'home';

  static GoRoute get route => GoRoute(
        path: path,
        name: routeName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: HomePage._(),
        ),
      );

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

class HomeView extends StatelessWidget {
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
