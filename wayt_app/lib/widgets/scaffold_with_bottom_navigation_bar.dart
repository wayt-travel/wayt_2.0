import 'package:flutter/material.dart';

import '../features/features.dart';
import '../util/util.dart';

/// A scaffold with a bottom navigation bar.
@SdkCandidate()
class ScaffoldWithBottomNavigationBar extends StatelessWidget {
  /// Creates a scaffold with a bottom navigation bar.
  const ScaffoldWithBottomNavigationBar({
    required this.body,
    required this.currentIndex,
    required this.destinations,
    required this.onDestinationSelected,
    super.key,
  });

  /// The body of the scaffold.
  final Widget body;

  /// The index of the currently selected destination.
  final int currentIndex;

  /// The destinations of the navigation bar.
  final List<NavigationDestination> destinations;

  /// The callback when a destination is selected.
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final pageIndexesWithNoFAB = [1];
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        destinations: destinations,
        onDestinationSelected: onDestinationSelected,
      ),
      body: body,
      floatingActionButton: pageIndexesWithNoFAB.contains(currentIndex)
          ? null
          : _Fab(currentIndex),
    );
  }
}

class _Fab extends StatelessWidget {
  const _Fab(this.index);

  /// The index of the page
  final int index;

  @override
  Widget build(BuildContext context) {
    switch (index) {
      case 0:
        return const PlanListFab();
      default:
        throw UnimplementedError();
    }
  }
}
