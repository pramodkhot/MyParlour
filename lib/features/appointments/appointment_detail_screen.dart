import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/design/colors.dart';
import '../../core/design/spacing.dart';
import '../../core/design/typography.dart';
import '../../core/format/dates.dart';
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
      AsyncValue(hasValue: true) => _Message(context.l10n.apptNoLongerExists),
      AsyncValue(:final error?) => _Message(
        context.l10n.apptDetailLoadFailed('$error'),
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
      if (mounted) showMessage(context, context.errorText(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _menu(_MenuAction action) async {
    final l10n = context.l10n;
    switch (action) {
      case _MenuAction.cancel:
        final reason = await showCancelAppointmentDialog(context);
        if (reason == null) return;
        await _change(
          AppointmentStatus.cancelled,
          reason: reason,
          done: l10n.apptCancelledDone,
        );
      case _MenuAction.noShow:
        final ok = await ConfirmDialog.show(
          context,
          title: l10n.apptNoShowTitle,
          message: l10n.apptNoShowMessage(widget.detail.clientName(l10n)),
          confirmLabel: l10n.apptMarkNoShow,
          destructive: true,
        );
        if (ok) {
          await _change(AppointmentStatus.noShow, done: l10n.apptNoShowDone);
        }
      case _MenuAction.openCustomer:
        await context.push(Routes.customer(a.customerId!));
    }
  }

  Future<void> _contact(Future<bool> Function() action, String what) async {
    if (!await action() && mounted) {
      showMessage(context, context.l10n.commonNoAppFor(what));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final d = widget.detail;
    final clientName = d.clientName(l10n);
    final contacts = ref.read(contactActionsProvider);
    final phone = d.phone;
    final canCancel =
        a.status == AppointmentStatus.booked ||
        a.status == AppointmentStatus.checkedIn;

    return Scaffold(
      appBar: AppTopBar(
        title: l10n.apptTitle,
        actions: [
          if (canCancel || a.customerId != null)
            PopupMenuButton<_MenuAction>(
              tooltip: l10n.apptMoreActions,
              icon: const Icon(Icons.more_horiz_rounded),
              onSelected: _menu,
              itemBuilder: (_) => [
                if (canCancel)
                  PopupMenuItem(
                    value: _MenuAction.cancel,
                    child: Text(l10n.apptCancelAppointment),
                  ),
                if (a.status == AppointmentStatus.booked)
                  PopupMenuItem(
                    value: _MenuAction.noShow,
                    child: Text(l10n.apptMarkNoShow),
                  ),
                if (a.customerId != null)
                  PopupMenuItem(
                    value: _MenuAction.openCustomer,
                    child: Text(l10n.apptOpenCustomer),
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
                AvatarInitials(name: clientName, size: 56),
                Gap.w12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        a.isWalkIn
                            ? l10n.commonWalkInNamed(clientName)
                            : clientName,
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
                    tooltip: l10n.commonCall,
                    onPressed: () => _contact(
                      () => contacts.call(phone),
                      l10n.commonAppCalls,
                    ),
                    icon: const Icon(
                      Icons.call_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.commonWhatsApp,
                    onPressed: () => _contact(
                      () => contacts.whatsApp(phone),
                      l10n.commonAppWhatsApp,
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
                  Dates.dayMonthYearWeekday(a.startsAt),
                ),
                const Divider(indent: 52),
                _Row(
                  Icons.schedule_rounded,
                  '${Dates.time(a.startsAt)} – ${Dates.time(a.endsAt)}',
                ),
                const Divider(indent: 52),
                _Row(
                  Icons.person_outline_rounded,
                  d.staff?.name ?? l10n.commonStylist,
                ),
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
                Text(l10n.apptServices, style: AppText.sectionTitle),
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
                    Expanded(
                      child: Text(l10n.apptTotal, style: AppText.bodyStrong),
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
                  Text(l10n.apptNotes, style: AppText.sectionTitle),
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
    final l10n = context.l10n;
    final Widget content;
    switch (a.status) {
      case AppointmentStatus.booked:
        content = Row(
          children: [
            Expanded(
              child: SecondaryButton(
                label: l10n.apptReschedule,
                onPressed: _busy
                    ? null
                    : () => context.push(Routes.rescheduleAppointment(a.id)),
              ),
            ),
            Gap.w12,
            Expanded(
              child: PrimaryButton(
                label: l10n.apptCheckIn,
                loading: _busy,
                onPressed: () => _change(
                  AppointmentStatus.checkedIn,
                  done: l10n.apptCheckedInDone,
                ),
              ),
            ),
          ],
        );
      case AppointmentStatus.checkedIn:
        content = PrimaryButton(
          label: l10n.apptComplete,
          icon: Icons.check_rounded,
          loading: _busy,
          onPressed: () => _change(
            AppointmentStatus.completed,
            done: l10n.apptCompletedDone,
          ),
        );
      case AppointmentStatus.completed:
        final bill = widget.detail.invoice;
        content = PrimaryButton(
          label: bill == null ? l10n.apptCreateBill : l10n.apptViewBill,
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
      appBar: AppTopBar(title: context.l10n.apptTitle),
      body: Center(
        child: EmptyState(icon: Icons.event_busy_outlined, message: message),
      ),
    );
  }
}
