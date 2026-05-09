import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.protoCream,
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
        backgroundColor: AppColors.protoSurface,
        indicatorColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black12,
        elevation: 0,
        height: 72,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: AppColors.protoTabIdle),
            selectedIcon: Icon(Icons.home, color: AppColors.protoBrand),
            label: l10n.navHome,
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined, color: AppColors.protoTabIdle),
            selectedIcon: Icon(Icons.explore, color: AppColors.protoBrand),
            label: l10n.navExplore,
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: AppColors.protoTabIdle),
            selectedIcon: Icon(Icons.person, color: AppColors.protoBrand),
            label: l10n.navProfile,
          ),
        ],
      ),
    );
  }
}
