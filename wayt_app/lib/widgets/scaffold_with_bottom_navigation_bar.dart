import 'package:flutter/material.dart';

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
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        destinations: destinations,
        onDestinationSelected: onDestinationSelected,
      ),
      body: body,
    );
  }
}
