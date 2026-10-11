import 'package:flutter/material.dart';

import '../design/colors.dart';
import '../l10n/l10n.dart';

/// White bottom bar with four tabs; the active icon sits in a pink pill.
class BottomNav extends StatelessWidget {
  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onSelected;

  static List<NavigationDestination> destinations(AppLocalizations l10n) => [
    NavigationDestination(
      icon: const Icon(Icons.space_dashboard_outlined),
      selectedIcon: const Icon(Icons.space_dashboard_rounded),
      label: l10n.navDashboard,
    ),
    NavigationDestination(
      icon: const Icon(Icons.event_note_outlined),
      selectedIcon: const Icon(Icons.event_note_rounded),
      label: l10n.navAppointments,
    ),
    NavigationDestination(
      icon: const Icon(Icons.receipt_long_outlined),
      selectedIcon: const Icon(Icons.receipt_long_rounded),
      label: l10n.navBilling,
    ),
    NavigationDestination(
      icon: const Icon(Icons.menu_rounded),
      selectedIcon: const Icon(Icons.menu_open_rounded),
      label: l10n.navMore,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onSelected,
        destinations: destinations(context.l10n),
      ),
    );
  }
}
