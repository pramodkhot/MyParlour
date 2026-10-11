import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/routes.dart';
import '../../core/design/colors.dart';
import '../../core/design/spacing.dart';
import '../../core/design/typography.dart';
import '../../core/format/dates.dart';
import '../../core/format/phone.dart';
import '../../core/platform/contact_actions.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/avatar_initials.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/money_text.dart';
import '../../domain/errors.dart';
import '../../domain/models/appointment.dart';
import 'appointment_status_chip.dart';
import 'appointments_controller.dart';
import 'widgets/cancel_appointment_dialog.dart';

/// S4 — Appointment details and status actions.
class AppointmentDetailScreen extends ConsumerWidget {
  const AppointmentDetailScreen({super.key, required this.appointmentId});

  final String appointmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(appointmentDetailProvider(appointmentId))) {
      AsyncValue(:final value?) => _Detail(detail: value),
      AsyncValue(hasValue: true) => const _Message(
        'This appointment no longer exists.',
      ),
      AsyncValue(:final error?) => _Message(
        'Could not load this appointment. $error',
      ),
      _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
    };
  }
}

enum _MenuAction { cancel, noShow, openCustomer }

class _Detail extends ConsumerStatefulWidget {
  const _Detail({required this.detail});

  final AppointmentDetail detail;

  @override
  ConsumerState<_Detail> createState() => _DetailState();
}

class _DetailState extends ConsumerState<_Detail> {
  bool _busy = false;

  Appointment get a => widget.detail.appointment;

  Future<void> _change(
    AppointmentStatus to, {
    String? reason,
    required String done,
  }) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await ref
          .read(appointmentActionsProvider)
          .changeStatus(a.id, to, cancelReason: reason);
      if (mounted) showMessage(context, done);
    } on DomainException catch (e) {
      if (mounted) showMessage(context, e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _menu(_MenuAction action) async {
    switch (action) {
      case _MenuAction.cancel:
        final reason = await showCancelAppointmentDialog(context);
        if (reason == null) return;
        await _change(
          AppointmentStatus.cancelled,
          reason: reason,
          done: 'Appointment cancelled',
        );
      case _MenuAction.noShow:
        final ok = await ConfirmDialog.show(
          context,
          title: 'Mark as no-show?',
          message:
              '${widget.detail.clientName} did not come. '
              'This cannot be undone.',
          confirmLabel: 'Mark no-show',
          destructive: true,
        );
        if (ok) {
          await _change(AppointmentStatus.noShow, done: 'Marked as no-show');
        }
      case _MenuAction.openCustomer:
        await context.push(Routes.customer(a.customerId!));
    }
  }

  Future<void> _contact(Future<bool> Function() action, String what) async {
    if (!await action() && mounted) {
      showMessage(context, 'No app on this phone can open $what.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.detail;
    final contacts = ref.read(contactActionsProvider);
    final phone = d.phone;
    final canCancel =
        a.status == AppointmentStatus.booked ||
        a.status == AppointmentStatus.checkedIn;

    return Scaffold(
      appBar: AppTopBar(
        title: 'Appointment',
        actions: [
          if (canCancel || a.customerId != null)
            PopupMenuButton<_MenuAction>(
              tooltip: 'More actions',
              icon: const Icon(Icons.more_horiz_rounded),
              onSelected: _menu,
              itemBuilder: (_) => [
                if (canCancel)
                  const PopupMenuItem(
                    value: _MenuAction.cancel,
                    child: Text('Cancel appointment'),
                  ),
                if (a.status == AppointmentStatus.booked)
                  const PopupMenuItem(
                    value: _MenuAction.noShow,
                    child: Text('Mark no-show'),
                  ),
                if (a.customerId != null)
                  const PopupMenuItem(
                    value: _MenuAction.openCustomer,
                    child: Text('Open customer'),
                  ),
              ],
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
          AppCard(
            child: Row(
              children: [
                AvatarInitials(name: d.clientName, size: 56),
                Gap.w12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        a.isWalkIn ? 'Walk-in · ${d.clientName}' : d.clientName,
                        style: AppText.bodyStrong.copyWith(fontSize: 17),
                      ),
                      if (phone != null)
                        Text(
                          '+91 ${PhoneNumber.display(phone)}',
                          style: AppText.caption.copyWith(fontSize: 13),
                        ),
                    ],
                  ),
                ),
                if (phone != null) ...[
                  IconButton(
                    tooltip: 'Call',
                    onPressed: () =>
                        _contact(() => contacts.call(phone), 'calls'),
                    icon: const Icon(
                      Icons.call_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                  IconButton(
                    tooltip: 'WhatsApp',
                    onPressed: () => _contact(
                      () => contacts.whatsApp(phone),
                      'WhatsApp links',
                    ),
                    icon: const Icon(
                      Icons.chat_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Gap.h12,
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _Row(
                  Icons.calendar_today_outlined,
                  DateFormat('d MMMM y, EEEE', 'en_IN').format(a.startsAt),
                ),
                const Divider(indent: 52),
                _Row(
                  Icons.schedule_rounded,
                  '${Dates.time(a.startsAt)} – ${Dates.time(a.endsAt)}',
                ),
                const Divider(indent: 52),
                _Row(Icons.person_outline_rounded, d.staff?.name ?? 'Stylist'),
                const Divider(indent: 52),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Space.lg,
                    vertical: Space.md,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.flag_outlined,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      Gap.w16,
                      AppointmentStatusChip(a.status),
                    ],
                  ),
                ),
                if (a.cancelReason != null) ...[
                  const Divider(indent: 52),
                  _Row(Icons.info_outline_rounded, a.cancelReason!),
                ],
              ],
            ),
          ),
          Gap.h12,
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Services', style: AppText.sectionTitle),
                Gap.h8,
                for (var i = 0; i < a.services.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: Space.xs),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${i + 1}. ${a.services[i].name}',
                            style: AppText.body,
                          ),
                        ),
                        MoneyText(
                          a.services[i].pricePaise,
                          style: AppText.body,
                        ),
                      ],
                    ),
                  ),
                const Divider(height: Space.lg),
                Row(
                  children: [
                    const Expanded(
                      child: Text('Total', style: AppText.bodyStrong),
                    ),
                    MoneyText(a.totalPricePaise),
                  ],
                ),
              ],
            ),
          ),
          if (a.notes != null) ...[
            Gap.h12,
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Notes', style: AppText.sectionTitle),
                  Gap.h8,
                  Text(a.notes!, style: AppText.body),
                ],
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: _actions(context),
    );
  }

  Widget? _actions(BuildContext context) {
    final Widget content;
    switch (a.status) {
      case AppointmentStatus.booked:
        content = Row(
          children: [
            Expanded(
              child: SecondaryButton(
                label: 'Reschedule',
                onPressed: _busy
                    ? null
                    : () => context.push(Routes.rescheduleAppointment(a.id)),
              ),
            ),
            Gap.w12,
            Expanded(
              child: PrimaryButton(
                label: 'Check in',
                loading: _busy,
                onPressed: () =>
                    _change(AppointmentStatus.checkedIn, done: 'Checked in'),
              ),
            ),
          ],
        );
      case AppointmentStatus.checkedIn:
        content = PrimaryButton(
          label: 'Complete',
          icon: Icons.check_rounded,
          loading: _busy,
          onPressed: () => _change(
            AppointmentStatus.completed,
            done: 'Appointment completed',
          ),
        );
      case AppointmentStatus.completed:
        final bill = widget.detail.invoice;
        content = PrimaryButton(
          label: bill == null ? 'Create bill' : 'View bill',
          icon: Icons.receipt_long_outlined,
          onPressed: () => context.go(
            bill == null
                ? Routes.newBill(appointmentId: a.id)
                : (bill.isDraft
                      ? Routes.editBill(bill.id)
                      : Routes.bill(bill.id)),
          ),
        );
      case AppointmentStatus.cancelled || AppointmentStatus.noShow:
        return null;
    }
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Space.screen,
          Space.sm,
          Space.screen,
          Space.lg,
        ),
        child: content,
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          Gap.w16,
          Expanded(child: Text(text, style: AppText.body)),
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
      appBar: const AppTopBar(title: 'Appointment'),
      body: Center(
        child: EmptyState(icon: Icons.event_busy_outlined, message: message),
      ),
    );
  }
}
