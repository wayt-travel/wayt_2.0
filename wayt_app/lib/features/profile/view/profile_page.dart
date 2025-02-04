import 'package:a2f_sdk/a2f_sdk.dart';
import 'package:flext/flext.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Page displaying the user profile.
class ProfilePage extends StatelessWidget {
  const ProfilePage._();

  /// Path to the profile page.
  static const String path = '/profile';

  /// Route name of the profile page.
  static const String routeName = 'profile';

  /// Route of the profile page.
  static GoRoute get route => GoRoute(
        path: path,
        name: routeName,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: ProfilePage._(),
        ),
      );

  /// Navigates to the profile page.
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

/// View displaying the user profile.
class ProfileView extends StatelessWidget {
  /// Creates a profile view.
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar.large(
          title: Text('Profile'),
        ),
        const Placeholder().asSliver,
      ],
    );
  }
}
