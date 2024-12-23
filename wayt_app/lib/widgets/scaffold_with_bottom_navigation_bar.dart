import 'package:flutter/material.dart';

class ScaffoldWithBottomNavigationBar extends StatelessWidget {
  const ScaffoldWithBottomNavigationBar({
    required this.body,
    required this.currentIndex,
    required this.onDestinationSelected,
    super.key,
  });
  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        destinations: const [
          // products
          NavigationDestination(
              icon: Icon(Icons.home_rounded),
              //selectedIcon:  Icon(Icons.home_rounded),
              // FIXME: l10n
              label: 'Home'),
          // NavigationDestination(
          //   icon:  Icon(Icons.scanner_rounded),
          //   //selectedIcon:  Icon(Icons.scanner_rounded),
          //   label: 'Scanner',
          // ),
          NavigationDestination(
            icon: Icon(Icons.person_rounded),
            //selectedIcon:  Icon(Icons.shop_rounded),
            // FIXME: l10n
            label: 'Profilo',
          ),
        ],
        onDestinationSelected: onDestinationSelected,
      ),
      body: body,
    );
  }
}
