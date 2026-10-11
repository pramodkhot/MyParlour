import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/appointments/appointment_detail_screen.dart';
import '../features/appointments/appointments_screen.dart';
import '../features/appointments/booking_screen.dart';
import '../features/billing/bill_editor_screen.dart';
import '../features/billing/bill_screen.dart';
import '../features/billing/billing_controller.dart';
import '../features/billing/billing_screen.dart';
import '../features/billing/payment_screen.dart';
import '../features/billing/payment_success_screen.dart';
import '../features/customers/customer_detail_screen.dart';
import '../features/customers/customer_form_screen.dart';
import '../features/customers/customers_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../domain/services/report_service.dart';
import '../features/expenses/expense_form_screen.dart';
import '../features/expenses/expenses_screen.dart';
import '../features/inventory/inventory_controller.dart';
import '../features/inventory/inventory_screen.dart';
import '../features/inventory/product_detail_screen.dart';
import '../features/inventory/product_form_screen.dart';
import '../features/more/more_screen.dart';
import '../features/reports/reports_screen.dart';
import '../features/settings/settings_forms.dart';
import '../features/settings/settings_screen.dart';
import '../features/services/service_form_screen.dart';
import '../features/services/services_screen.dart';
import '../features/staff/staff_detail_screen.dart';
import '../features/staff/staff_form_screen.dart';
import '../features/staff/staff_screen.dart';
import '../features/welcome/welcome_screen.dart';
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
                builder: (_, state) => BillingScreen(
                  initialFilter: state.uri.queryParameters['filter'] == 'all'
                      ? BillFilter.all
                      : BillFilter.open,
                ),
                routes: [
                  GoRoute(
                    path: 'new',
                    builder: (_, state) => BillEditorScreen(
                      args: (
                        draftId: null,
                        appointmentId:
                            state.uri.queryParameters['appointmentId'],
                        customerId: state.uri.queryParameters['customerId'],
                      ),
                    ),
                  ),
                  GoRoute(
                    path: ':id',
                    builder: (_, state) =>
                        BillScreen(billId: state.pathParameters['id']!),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        builder: (_, state) => BillEditorScreen(
                          args: (
                            draftId: state.pathParameters['id'],
                            appointmentId: null,
                            customerId: null,
                          ),
                        ),
                      ),
                      GoRoute(
                        path: 'pay',
                        builder: (_, state) =>
                            PaymentScreen(billId: state.pathParameters['id']!),
                      ),
                      GoRoute(
                        path: 'paid/:paymentId',
                        builder: (_, state) => PaymentSuccessScreen(
                          billId: state.pathParameters['id']!,
                          paymentId: state.pathParameters['paymentId']!,
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
                  GoRoute(
                    path: 'inventory',
                    builder: (_, state) => InventoryScreen(
                      initialTab: InventoryTab.fromQuery(
                        state.uri.queryParameters['tab'],
                      ),
                    ),
                    routes: [
                      GoRoute(
                        path: 'new',
                        builder: (_, _) => const ProductFormScreen(),
                      ),
                      GoRoute(
                        path: ':id',
                        builder: (_, state) => ProductDetailScreen(
                          productId: state.pathParameters['id']!,
                        ),
                        routes: [
                          GoRoute(
                            path: 'edit',
                            builder: (_, state) => ProductFormScreen(
                              productId: state.pathParameters['id'],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'expenses',
                    builder: (_, _) => const ExpensesScreen(),
                    routes: [
                      GoRoute(
                        path: 'new',
                        builder: (_, _) => const ExpenseFormScreen(),
                      ),
                      GoRoute(
                        path: ':id/edit',
                        builder: (_, state) => ExpenseFormScreen(
                          expenseId: state.pathParameters['id'],
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'reports',
                    builder: (_, state) => ReportsScreen(
                      initialPeriod:
                          state.uri.queryParameters['period'] == 'today'
                          ? ReportPeriod.today
                          : ReportPeriod.thisMonth,
                    ),
                  ),
                  GoRoute(
                    path: 'settings',
                    builder: (_, _) => const SettingsScreen(),
                    routes: [
                      for (final (path, section) in const [
                        ('profile', SettingsSection.profile),
                        ('hours', SettingsSection.hours),
                        ('billing', SettingsSection.billing),
                      ])
                        GoRoute(
                          path: path,
                          builder: (_, _) =>
                              SettingsFormScreen(section: section),
                        ),
                    ],
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
