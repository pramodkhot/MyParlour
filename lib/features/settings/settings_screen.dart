import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/routes.dart';
import '../../core/design/colors.dart';
import '../../core/design/spacing.dart';
import '../../core/design/typography.dart';
import '../../core/format/dates.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../core/widgets/demo_pill.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/feedback.dart';
import '../../domain/models/parlour.dart';
import 'settings_controller.dart';

/// S18 — Settings.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parlour = ref.watch(parlourProvider);
    return Scaffold(
      appBar: const AppTopBar(title: 'Settings'),
      body: switch (parlour) {
        AsyncValue(:final value?) => _Body(parlour: value),
        AsyncValue(:final error?) => Center(
          child: EmptyState(
            icon: Icons.error_outline_rounded,
            message: 'Could not load settings. $error',
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.parlour});

  final Parlour parlour;

  Future<void> _reset(BuildContext context, WidgetRef ref) async {
    final ok = await ConfirmDialog.show(
      context,
      title: 'Reset demo data?',
      message:
          'All changes are replaced with the original sample data for Beauty '
          'Bliss Parlour, dated around today. This cannot be undone.',
      confirmLabel: 'Reset',
      destructive: true,
    );
    if (!ok) return;
    await ref.read(settingsActionsProvider).resetDemo();
    if (context.mounted) showMessage(context, 'Demo data restored');
  }

  Future<void> _startEmpty(BuildContext context, WidgetRef ref) async {
    final ok = await ConfirmDialog.show(
      context,
      title: 'Start with an empty parlour?',
      message:
          'All customers, services, staff, appointments, bills, products and '
          'expenses are removed. Your parlour profile, hours and billing '
          'settings are kept. You can bring the sample data back with '
          '"Reset demo data".',
      confirmLabel: 'Start empty',
      destructive: true,
    );
    if (!ok) return;
    await ref.read(settingsActionsProvider).startEmpty();
    if (context.mounted) showMessage(context, 'Started with an empty parlour');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = parlour;
    final day = DateTime(2024);
    final weekday = DateFormat.E('en_IN');
    final days = [
      for (var d = 1; d <= 7; d++)
        if (p.openDays.contains(d)) weekday.format(DateTime(2024, 1, d)),
    ].join(', ');
    final version = ref.watch(appVersionProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        Space.screen,
        Space.sm,
        Space.screen,
        Space.xxl,
      ),
      children: [
        _Section(
          title: 'Parlour profile',
          onEdit: () => context.push(Routes.settingsProfile),
          rows: [
            ('Name', p.name),
            ('Owner', p.ownerName),
            ('Phone', p.phone),
            ('Area', p.area),
            ('Address', p.address ?? 'Not added'),
          ],
        ),
        Gap.h12,
        _Section(
          title: 'Business hours',
          onEdit: () => context.push(Routes.settingsHours),
          rows: [
            ('Open days', days.isEmpty ? 'None' : days),
            (
              'Hours',
              '${Dates.time(p.openTime.on(day))} – ${Dates.time(p.closeTime.on(day))}',
            ),
            ('Booking slots', '${p.slotMinutes} min'),
          ],
        ),
        Gap.h12,
        _Section(
          title: 'Billing & tax',
          onEdit: () => context.push(Routes.settingsBilling),
          rows: [
            ('Invoice prefix', p.invoicePrefix),
            ('GST', p.taxEnabled ? 'On' : 'Off'),
            if (p.taxEnabled) ...[
              ('GSTIN', p.gstin ?? 'Not added'),
              ('Default rate', '${p.defaultTaxRateBp ~/ 100}%'),
              ('Prices include GST', p.pricesIncludeTax ? 'Yes' : 'No'),
            ],
            ('Receipt footer', p.receiptFooter),
          ],
        ),
        Gap.h12,
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text('Demo', style: AppText.sectionTitle),
                  Gap.w8,
                  DemoPill(),
                ],
              ),
              Gap.h8,
              Text(
                'This is a demo. Data stays on this phone only.',
                style: AppText.body.copyWith(color: AppColors.textMuted),
              ),
              Gap.h8,
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.restart_alt_rounded),
                title: const Text('Reset demo data'),
                subtitle: const Text('Restore the original sample data'),
                onTap: () => _reset(context, ref),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.cleaning_services_outlined),
                title: const Text('Start empty'),
                subtitle: const Text('Clear everything to try a blank parlour'),
                onTap: () => _startEmpty(context, ref),
              ),
            ],
          ),
        ),
        Gap.h12,
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('About', style: AppText.sectionTitle),
              Gap.h8,
              Text(
                'MyParlour ${version.value ?? ''}'.trim(),
                style: AppText.bodyStrong,
              ),
              Gap.h4,
              Text(
                'Sign-in and cloud backup arrive in the full version.',
                style: AppText.body.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.onEdit,
    required this.rows,
  });

  final String title;
  final VoidCallback onEdit;
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(
        Space.lg,
        Space.xs,
        Space.xs,
        Space.md,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: AppText.sectionTitle)),
              TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text('Edit'),
              ),
            ],
          ),
          for (final (label, value) in rows)
            Padding(
              padding: const EdgeInsets.only(
                right: Space.md,
                top: 4,
                bottom: 4,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 130,
                    child: Text(label, style: AppText.label),
                  ),
                  Expanded(
                    child: Text(
                      value,
                      textAlign: TextAlign.end,
                      style: AppText.body,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
