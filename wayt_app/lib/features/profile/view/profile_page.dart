import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage._();

  static const String path = '/profile';
  static const String routeName = 'profile';

  static GoRoute get route => GoRoute(
        path: path,
        name: routeName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: ProfilePage._(),
        ),
      );

  static void go(BuildContext context) {
    context.router.goNamed(
      routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const ProfileView();
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          title: Text(
            'Profile',
            style: const TextStyle().copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Placeholder().asSliver,
      ],
    );
  }
}
