import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:iconify_flutter_plus/icons/ri.dart';

import '../../core/theme/app_colors.dart';

/// Hosts the 5-tab bottom nav. `navigationShell` is provided by
/// StatefulShellRoute.indexedStack and remembers each tab's own stack —
/// switching tabs doesn't reset scroll position or pushed screens.
class MainShellScreen extends StatelessWidget {
  const MainShellScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        onTap: (index) => navigationShell.goBranch(
          index,
          // Tapping the already-active tab pops it back to its root.
          initialLocation: index == navigationShell.currentIndex,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Iconify(Mdi.paw_outline, color: AppColors.textSecondary),
            activeIcon: const Iconify(Mdi.paw, color: AppColors.primary,),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.star_border_outlined),
            activeIcon: Icon(Icons.star),
            label: 'Features',
          ),
          BottomNavigationBarItem(
            icon: Icon(FluentIcons.people_community_24_regular, color: AppColors.textSecondary),
            activeIcon: Icon(FluentIcons.people_community_24_filled, color: AppColors.primary,),
            label: 'Community',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          const BottomNavigationBarItem(
            icon: Iconify(Ri.settings_line, color: AppColors.textSecondary),
            activeIcon: Iconify(Ri.settings_fill, color: AppColors.primary,),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
