import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/design/colors.dart';
import '../../core/design/spacing.dart';
import '../../core/design/typography.dart';
import '../../core/format/phone.dart';
import '../../core/platform/contact_actions.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/avatar_initials.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/round_action.dart';
import '../../core/widgets/status_chip.dart';
import '../../domain/models/customer.dart';
import 'customers_controller.dart';
import 'widgets/customer_details_tab.dart';
import 'widgets/customer_history_tab.dart';
import 'widgets/customer_notes_tab.dart';

/// S7 — Customer details.
class CustomerDetailScreen extends ConsumerWidget {
  const CustomerDetailScreen({super.key, required this.customerId});

  final String customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(customerDetailProvider(customerId))) {
      AsyncValue(:final value?) => _Detail(detail: value),
      AsyncValue(hasValue: true) => const _Message(
        'This customer no longer exists.',
      ),
      AsyncValue(:final error?) => _Message(
        'Could not load this customer. $error',
      ),
      _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
    };
  }
}

class _Detail extends ConsumerWidget {
  const _Detail({required this.detail});

  final CustomerDetail detail;

  Customer get c => detail.customer;

  Future<void> _contact(
    BuildContext context,
    Future<bool> Function() action,
    String what,
  ) async {
    final ok = await action();
    if (!ok && context.mounted) {
      showMessage(context, 'No app on this phone can open $what.');
    }
  }

  Future<void> _more(BuildContext context, WidgetRef ref) async {
    final contacts = ref.read(contactActionsProvider);
    final actions = ref.read(customerActionsProvider);
    final choice = await showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: const Text('Share contact'),
              onTap: () => Navigator.of(context).pop('share'),
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit customer'),
              onTap: () => Navigator.of(context).pop('edit'),
            ),
            ListTile(
              leading: Icon(
                c.isActive
                    ? Icons.person_off_outlined
                    : Icons.person_add_alt_outlined,
                color: c.isActive ? AppColors.error : AppColors.primary,
              ),
              title: Text(
                c.isActive ? 'Deactivate customer' : 'Reactivate customer',
                style: TextStyle(
                  color: c.isActive ? AppColors.error : AppColors.text,
                ),
              ),
              onTap: () => Navigator.of(context).pop('active'),
            ),
            Gap.h8,
          ],
        ),
      ),
    );
    if (!context.mounted || choice == null) return;
    switch (choice) {
      case 'share':
        await _contact(
          context,
          () => contacts.shareText(
            '${c.name}\n+91 ${PhoneNumber.display(c.phone)}',
            subject: c.name,
          ),
          'sharing',
        );
      case 'edit':
        await context.push(Routes.editCustomer(c.id));
      case 'active':
        if (c.isActive) {
          final ok = await ConfirmDialog.show(
            context,
            title: 'Deactivate ${c.name}?',
            message:
                'They will be hidden from the customer list and booking. '
                'Their history is kept, and you can reactivate them later.',
            confirmLabel: 'Deactivate',
            destructive: true,
          );
          if (!ok) return;
        }
        await actions.setActive(c.id, isActive: !c.isActive);
        if (context.mounted) {
          showMessage(
            context,
            c.isActive ? 'Customer deactivated' : 'Customer reactivated',
          );
        }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.read(contactActionsProvider);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppTopBar(
          title: 'Customer',
          actions: [
            IconButton(
              tooltip: 'Edit customer',
              onPressed: () => context.push(Routes.editCustomer(c.id)),
              icon: const Icon(Icons.edit_outlined),
            ),
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, _) => [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  Space.xl,
                  Space.sm,
                  Space.xl,
                  Space.lg,
                ),
                child: Column(
                  children: [
                    AvatarInitials(name: c.name, size: 76),
                    Gap.h12,
                    Text(
                      c.name,
                      textAlign: TextAlign.center,
                      style: AppText.barTitle,
                    ),
                    Gap.h4,
                    Text(
                      '+91 ${PhoneNumber.display(c.phone)}',
                      style: AppText.body.copyWith(color: AppColors.textMuted),
                    ),
                    if (!c.isActive) ...[
                      Gap.h8,
                      const StatusChip(
                        label: 'Inactive',
                        tone: ChipTone.neutral,
                      ),
                    ],
                    Gap.h16,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RoundAction(
                          icon: Icons.call_outlined,
                          label: 'Call',
                          onTap: () => _contact(
                            context,
                            () => contacts.call(c.phone),
                            'calls',
                          ),
                        ),
                        RoundAction(
                          icon: Icons.chat_outlined,
                          label: 'WhatsApp',
                          onTap: () => _contact(
                            context,
                            () => contacts.whatsApp(c.phone),
                            'WhatsApp links',
                          ),
                        ),
                        RoundAction(
                          icon: Icons.sms_outlined,
                          label: 'SMS',
                          onTap: () => _contact(
                            context,
                            () => contacts.sms(c.phone),
                            'messages',
                          ),
                        ),
                        RoundAction(
                          icon: Icons.more_horiz_rounded,
                          label: 'More',
                          onTap: () => _more(context, ref),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: TabBar(
                tabs: [
                  Tab(text: 'History'),
                  Tab(text: 'Details'),
                  Tab(text: 'Notes'),
                ],
              ),
            ),
          ],
          body: TabBarView(
            children: [
              CustomerHistoryTab(entries: detail.history),
              CustomerDetailsTab(detail: detail),
              CustomerNotesTab(customer: c),
            ],
          ),
        ),
        bottomNavigationBar: c.isActive
            ? SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    Space.xl,
                    Space.sm,
                    Space.xl,
                    Space.lg,
                  ),
                  child: PrimaryButton(
                    label: 'New appointment',
                    icon: Icons.add_rounded,
                    onPressed: () =>
                        context.go(Routes.newAppointment(customerId: c.id)),
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Customer'),
      body: Center(
        child: EmptyState(icon: Icons.person_off_outlined, message: message),
      ),
    );
  }
}
