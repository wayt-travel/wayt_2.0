// Stateful navigation based on
// https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'scaffold_with_bottom_navigation_bar.dart';

class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    required this.navigationShell,
    required this.destinations,
    Key? key,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));

  final List<NavigationDestination> destinations;
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
