import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/appointments/appointment_detail_screen.dart';
import '../features/appointments/appointments_screen.dart';
import '../features/appointments/booking_screen.dart';
import '../features/customers/customer_detail_screen.dart';
import '../features/customers/customer_form_screen.dart';
import '../features/customers/customers_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/more/more_screen.dart';
import '../features/services/service_form_screen.dart';
import '../features/services/services_screen.dart';
import '../features/staff/staff_detail_screen.dart';
import '../features/staff/staff_form_screen.dart';
import '../features/staff/staff_screen.dart';
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
                builder: (_, _) => const AppointmentsScreen(),
                routes: [
                  GoRoute(
                    path: 'new',
                    builder: (_, state) => BookingScreen(
                      customerId: state.uri.queryParameters['customerId'],
                      date: DateTime.tryParse(
                        state.uri.queryParameters['date'] ?? '',
                      ),
                    ),
                  ),
                  GoRoute(
                    path: ':id',
                    builder: (_, state) => AppointmentDetailScreen(
                      appointmentId: state.pathParameters['id']!,
                    ),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        builder: (_, state) => BookingScreen(
                          appointmentId: state.pathParameters['id'],
                        ),
                      ),
                    ],
                  ),
                ],
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
                  GoRoute(
                    path: 'customers',
                    builder: (_, _) => const CustomersScreen(),
                    routes: [
                      GoRoute(
                        path: 'new',
                        builder: (_, _) => const CustomerFormScreen(),
                      ),
                      GoRoute(
                        path: ':id',
                        builder: (_, state) => CustomerDetailScreen(
                          customerId: state.pathParameters['id']!,
                        ),
                        routes: [
                          GoRoute(
                            path: 'edit',
                            builder: (_, state) => CustomerFormScreen(
                              customerId: state.pathParameters['id'],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'staff',
                    builder: (_, _) => const StaffScreen(),
                    routes: [
                      GoRoute(
                        path: 'new',
                        builder: (_, _) => const StaffFormScreen(),
                      ),
                      GoRoute(
                        path: ':id',
                        builder: (_, state) => StaffDetailScreen(
                          staffId: state.pathParameters['id']!,
                        ),
                        routes: [
                          GoRoute(
                            path: 'edit',
                            builder: (_, state) => StaffFormScreen(
                              staffId: state.pathParameters['id'],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'services',
                    builder: (_, _) => const ServicesScreen(),
                    routes: [
                      GoRoute(
                        path: 'new',
                        builder: (_, _) => const ServiceFormScreen(),
                      ),
                      GoRoute(
                        path: ':id/edit',
                        builder: (_, state) => ServiceFormScreen(
                          serviceId: state.pathParameters['id'],
                        ),
                      ),
                    ],
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
