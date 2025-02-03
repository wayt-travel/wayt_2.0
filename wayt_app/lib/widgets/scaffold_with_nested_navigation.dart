// Stateful navigation based on
// https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../util/util.dart';
import 'scaffold_with_bottom_navigation_bar.dart';

/// Scaffold with nested navigation.
@SdkCandidate()
class ScaffoldWithNestedNavigation extends StatelessWidget {
  /// Creates a scaffold with nested navigation.
  const ScaffoldWithNestedNavigation({
    required this.navigationShell,
    required this.destinations,
    Key? key,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));

  /// The destinations of the navigation bar.
  final List<NavigationDestination> destinations;

  /// The navigation shell.
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // Supports navigating to the initial location when tapping the item
      // that is already selected.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithBottomNavigationBar(
      body: navigationShell,
      currentIndex: navigationShell.currentIndex,
      destinations: destinations,
      onDestinationSelected: _goBranch,
    );
  }
}
