import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/design/colors.dart';
import '../../core/design/spacing.dart';
import '../../core/design/typography.dart';
import '../../core/format/phone.dart';
import '../../core/l10n/l10n.dart';
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
      AsyncValue(hasValue: true) => _Message(context.l10n.custNotFound),
      AsyncValue(:final error?) => _Message(
        context.l10n.custLoadOneError('$error'),
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
      showMessage(context, context.l10n.commonNoAppFor(what));
    }
  }

  Future<void> _more(BuildContext context, WidgetRef ref) async {
    final contacts = ref.read(contactActionsProvider);
    final actions = ref.read(customerActionsProvider);
    final l10n = context.l10n;
    final choice = await showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: Text(l10n.custShareContact),
              onTap: () => Navigator.of(context).pop('share'),
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(l10n.custEdit),
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
                c.isActive ? l10n.custDeactivate : l10n.custReactivate,
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
          l10n.commonAppSharing,
        );
      case 'edit':
        await context.push(Routes.editCustomer(c.id));
      case 'active':
        if (c.isActive) {
          final ok = await ConfirmDialog.show(
            context,
            title: l10n.custDeactivateTitle(c.name),
            message: l10n.custDeactivateMessage,
            confirmLabel: l10n.commonDeactivate,
            destructive: true,
          );
          if (!ok) return;
        }
        await actions.setActive(c.id, isActive: !c.isActive);
        if (context.mounted) {
          showMessage(
            context,
            c.isActive ? l10n.custDeactivated : l10n.custReactivated,
          );
        }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.read(contactActionsProvider);
    final l10n = context.l10n;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppTopBar(
          title: l10n.commonCustomer,
          actions: [
            IconButton(
              tooltip: l10n.custEdit,
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
                      StatusChip(
                        label: l10n.commonInactive,
                        tone: ChipTone.neutral,
                      ),
                    ],
                    Gap.h16,
                    Row(
                      children: [
                        for (final action in [
                          RoundAction(
                            icon: Icons.call_outlined,
                            label: l10n.commonCall,
                            onTap: () => _contact(
                              context,
                              () => contacts.call(c.phone),
                              l10n.commonAppCalls,
                            ),
                          ),
                          RoundAction(
                            icon: Icons.chat_outlined,
                            label: l10n.commonWhatsApp,
                            onTap: () => _contact(
                              context,
                              () => contacts.whatsApp(c.phone),
                              l10n.commonAppWhatsApp,
                            ),
                          ),
                          RoundAction(
                            icon: Icons.sms_outlined,
                            label: l10n.commonSms,
                            onTap: () => _contact(
                              context,
                              () => contacts.sms(c.phone),
                              l10n.commonAppMessages,
                            ),
                          ),
                          RoundAction(
                            icon: Icons.more_horiz_rounded,
                            label: l10n.custActionMore,
                            onTap: () => _more(context, ref),
                          ),
                        ])
                          // Equal shares, so the row always fits.
                          Expanded(child: action),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: TabBar(
                tabs: [
                  Tab(text: l10n.custTabHistory),
                  Tab(text: l10n.custTabDetails),
                  Tab(text: l10n.custNotes),
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
                    label: l10n.custNewAppointment,
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
      appBar: AppTopBar(title: context.l10n.commonCustomer),
      body: Center(
        child: EmptyState(icon: Icons.person_off_outlined, message: message),
      ),
    );
  }
}
