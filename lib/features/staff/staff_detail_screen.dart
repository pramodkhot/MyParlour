import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/design/colors.dart';
import '../../core/design/spacing.dart';
import '../../core/design/typography.dart';
import '../../core/format/dates.dart';
import '../../core/format/money.dart';
import '../../core/format/phone.dart';
import '../../core/l10n/l10n.dart';
import '../../core/platform/contact_actions.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/avatar_initials.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/metric_card.dart';
import '../../core/widgets/round_action.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/status_chip.dart';
import '../appointments/appointment_status_chip.dart';
import 'staff_controller.dart';

/// S12 detail — one staff member.
class StaffDetailScreen extends ConsumerWidget {
  const StaffDetailScreen({super.key, required this.staffId});

  final String staffId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(staffDetailProvider(staffId))) {
      AsyncValue(:final value?) => _Detail(detail: value),
      AsyncValue(hasValue: true) => _Message(context.l10n.staffNotFound),
      AsyncValue(:final error?) => _Message(
        context.l10n.staffLoadError('$error'),
      ),
      _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
    };
  }
}

class _Detail extends ConsumerWidget {
  const _Detail({required this.detail});

  final StaffDetail detail;

  Future<void> _toggleActive(BuildContext context, WidgetRef ref) async {
    final s = detail.staff;
    final l10n = context.l10n;
    if (s.isActive) {
      final ok = await ConfirmDialog.show(
        context,
        title: l10n.staffDeactivateTitle(s.name),
        message: l10n.staffDeactivateMessage(s.name),
        confirmLabel: l10n.commonDeactivate,
        destructive: true,
      );
      if (!ok) return;
    }
    await ref.read(staffActionsProvider).setActive(s.id, isActive: !s.isActive);
    if (context.mounted) {
      showMessage(
        context,
        s.isActive ? l10n.staffDeactivated : l10n.staffActivated,
      );
    }
  }

  Future<void> _contact(
    BuildContext context,
    Future<bool> Function() action,
    String what,
  ) async {
    if (!await action() && context.mounted) {
      showMessage(context, context.l10n.commonNoAppFor(what));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = detail.staff;
    final contacts = ref.read(contactActionsProvider);
    final l10n = context.l10n;
    final workingDays = [
      for (final d in [1, 2, 3, 4, 5, 6, 7])
        if (s.workingDays.contains(d)) Dates.weekdayShort(DateTime(2024, 1, d)),
    ].join(', ');
    final hours = l10n.staffHoursRange(
      Dates.time(s.startTime.on(detail.now)),
      Dates.time(s.endTime.on(detail.now)),
    );

    return Scaffold(
      appBar: AppTopBar(
        title: l10n.staffTitle,
        actions: [
          IconButton(
            tooltip: l10n.staffEdit,
            onPressed: () => context.push(Routes.editStaff(s.id)),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Space.screen,
          Space.sm,
          Space.screen,
          Space.xxl,
        ),
        children: [
          Row(
            children: [
              AvatarInitials(name: s.name, size: 64),
              Gap.w16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s.name, style: AppText.barTitle),
                    Text(l10n.builtIn(s.roleTitle), style: AppText.caption),
                    Gap.h4,
                    StatusChip(
                      label: s.isActive
                          ? l10n.commonActive
                          : l10n.commonInactive,
                      tone: s.isActive ? ChipTone.success : ChipTone.neutral,
                    ),
                  ],
                ),
              ),
              RoundAction(
                icon: Icons.call_outlined,
                label: l10n.commonCall,
                onTap: () => _contact(
                  context,
                  () => contacts.call(s.phone),
                  l10n.commonAppCalls,
                ),
              ),
              RoundAction(
                icon: Icons.chat_outlined,
                label: l10n.commonWhatsApp,
                onTap: () => _contact(
                  context,
                  () => contacts.whatsApp(s.phone),
                  l10n.commonAppWhatsApp,
                ),
              ),
            ],
          ),
          Gap.h16,
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _InfoRow(
                  Icons.phone_outlined,
                  l10n.staffMobile,
                  '+91 ${PhoneNumber.display(s.phone)}',
                ),
                const Divider(indent: 52),
                _InfoRow(
                  Icons.calendar_month_outlined,
                  l10n.staffWorks,
                  workingDays,
                ),
                const Divider(indent: 52),
                _InfoRow(Icons.schedule_rounded, l10n.staffHours, hours),
                const Divider(indent: 52),
                _InfoRow(
                  Icons.content_cut_rounded,
                  l10n.staffServices,
                  s.serviceIds
                      .map((id) => detail.serviceNames[id])
                      .whereType<String>()
                      .join(', '),
                ),
              ],
            ),
          ),
          Gap.h20,
          Text(l10n.periodThisMonth, style: AppText.sectionTitle),
          Gap.h12,
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: MetricCard(
                    label: l10n.staffServicesDone,
                    value: '${detail.month.servicesDone}',
                    icon: Icons.check_circle_outline_rounded,
                  ),
                ),
                Gap.w12,
                Expanded(
                  child: MetricCard(
                    label: l10n.staffAmountBilled,
                    value: Money.format(detail.month.billedPaise),
                    icon: Icons.payments_outlined,
                  ),
                ),
              ],
            ),
          ),
          Gap.h12,
          SectionHeader(title: l10n.staffTodayAndUpcoming),
          if (detail.upcoming.isEmpty)
            AppCard(
              child: Text(
                l10n.staffNoAppointments,
                style: const TextStyle(color: AppColors.textMuted),
              ),
            )
          else
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (var i = 0; i < detail.upcoming.length; i++) ...[
                    if (i > 0)
                      const Divider(indent: Space.lg, endIndent: Space.lg),
                    _AppointmentRow(detail: detail, index: i),
                  ],
                ],
              ),
            ),
          Gap.h24,
          SecondaryButton(
            label: s.isActive ? l10n.commonDeactivate : l10n.staffActivate,
            icon: s.isActive ? Icons.block_rounded : Icons.check_rounded,
            onPressed: () => _toggleActive(context, ref),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.icon, this.label, this.value);

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          Gap.w16,
          SizedBox(width: 72, child: Text(label, style: AppText.label)),
          Expanded(
            child: Text(
              value.isEmpty ? context.l10n.commonNone : value,
              textAlign: TextAlign.end,
              style: AppText.bodyStrong,
            ),
          ),
        ],
      ),
    );
  }
}

class _AppointmentRow extends StatelessWidget {
  const _AppointmentRow({required this.detail, required this.index});

  final StaffDetail detail;
  final int index;

  @override
  Widget build(BuildContext context) {
    final a = detail.upcoming[index];
    final isToday = DateUtils.isSameDay(a.startsAt.toLocal(), detail.now);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Space.lg,
        vertical: Space.md,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 76,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isToday
                      ? context.l10n.periodToday
                      : Dates.dayMonth(a.startsAt),
                  style: AppText.caption,
                ),
                Text(
                  Dates.time(a.startsAt),
                  style: AppText.bodyStrong.copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.clientName(a, context.l10n),
                  style: AppText.bodyStrong,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  a.services.map((s) => s.name).join(', '),
                  style: AppText.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          AppointmentStatusChip(a.status),
        ],
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
      appBar: AppTopBar(title: context.l10n.staffTitle),
      body: Center(
        child: EmptyState(icon: Icons.badge_outlined, message: message),
      ),
    );
  }
}
