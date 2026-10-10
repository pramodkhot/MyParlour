import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/dashboard/dashboard_screen.dart';
import '../features/more/more_screen.dart';
import '../features/welcome/welcome_screen.dart';
import 'placeholder_screen.dart';
import 'routes.dart';
import 'shell_scaffold.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: Routes.welcome,
    routes: [
      GoRoute(path: Routes.welcome, builder: (_, _) => const WelcomeScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => ShellScaffold(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.dashboard,
                builder: (_, _) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.appointments,
                builder: (_, _) => const PlaceholderScreen(
                  title: 'Appointments',
                  icon: Icons.event_note_outlined,
                  phase: 5,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.billing,
                builder: (_, _) => const PlaceholderScreen(
                  title: 'Billing',
                  icon: Icons.receipt_long_outlined,
                  phase: 6,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.more,
                builder: (_, _) => const MoreScreen(),
                routes: [
                  _placeholder(
                    'customers',
                    'Customers',
                    Icons.people_alt_outlined,
                    4,
                  ),
                  _placeholder('staff', 'Staff', Icons.badge_outlined, 4),
                  _placeholder(
                    'services',
                    'Services',
                    Icons.content_cut_rounded,
                    4,
                  ),
                  _placeholder(
                    'inventory',
                    'Inventory',
                    Icons.inventory_2_outlined,
                    7,
                  ),
                  _placeholder(
                    'expenses',
                    'Expenses',
                    Icons.account_balance_wallet_outlined,
                    7,
                  ),
                  _placeholder(
                    'reports',
                    'Reports',
                    Icons.insights_outlined,
                    7,
                  ),
                  _placeholder(
                    'settings',
                    'Settings',
                    Icons.settings_outlined,
                    7,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

GoRoute _placeholder(String path, String title, IconData icon, int phase) {
  return GoRoute(
    path: path,
    builder: (_, _) =>
        PlaceholderScreen(title: title, icon: icon, phase: phase),
  );
}
