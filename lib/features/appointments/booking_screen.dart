import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/avatar_initials.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/choice_chips.dart';
import '../../core/widgets/discard_changes_scope.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/field_label.dart';
import '../../core/widgets/picker_field.dart';
import '../../data/providers.dart';
import '../../domain/errors.dart';
import '../../domain/models/appointment.dart';
import '../../domain/models/customer.dart';
import '../../domain/models/date_range.dart';
import '../../domain/models/staff.dart';
import '../../domain/services/appointment_rules.dart';
import '../../domain/services/booking_planner.dart';
import 'appointments_controller.dart';
import 'widgets/customer_picker.dart';
import 'widgets/overlap_sheet.dart';
import 'widgets/service_picker.dart';

/// S5 — New appointment, or reschedule when [appointmentId] is set.
class BookingScreen extends ConsumerWidget {
  const BookingScreen({
    super.key,
    this.appointmentId,
    this.customerId,
    this.date,
  });

  final String? appointmentId;
  final String? customerId;
  final DateTime? date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(bookingDataProvider(appointmentId))) {
      AsyncValue(:final value?)
          when appointmentId != null && value.existing == null =>
        _Message(context.l10n.apptNoLongerExists),
      AsyncValue(:final value?)
          when value.existing != null &&
              value.existing!.status != AppointmentStatus.booked =>
        _Message(context.l10n.bookingOnlyUpcoming),
      AsyncValue(:final value?) => _BookingForm(
        data: value,
        presetCustomerId: customerId,
        presetDate: date,
      ),
      AsyncValue(:final error?) => _Message(
        context.l10n.bookingLoadFailed('$error'),
      ),
      _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
    };
  }
}

class _BookingForm extends ConsumerStatefulWidget {
  const _BookingForm({
    required this.data,
    this.presetCustomerId,
    this.presetDate,
  });

  final BookingData data;
  final String? presetCustomerId;
  final DateTime? presetDate;

  @override
  ConsumerState<_BookingForm> createState() => _BookingFormState();
}

class _BookingFormState extends ConsumerState<_BookingForm> {
  final _formKey = GlobalKey<FormState>();
  late final Appointment? _existing = widget.data.existing;
  late Customer? _customer =
      widget.data.existingCustomer ??
      widget.data.customers
          .where((c) => c.id == widget.presetCustomerId)
          .firstOrNull;
  late bool _walkIn = _existing?.isWalkIn ?? false;
  late final _walkInName = TextEditingController(
    text: _existing?.walkInName ?? '',
  );
  late final _walkInPhone = TextEditingController(
    text: _existing?.walkInPhone ?? '',
  );
  late final _notes = TextEditingController(text: _existing?.notes ?? '');
  late List<AppointmentService> _services = [...?_existing?.services];
  late DateTime _date = DateRange.startOfDay(
    _existing?.startsAt ?? widget.presetDate ?? ref.read(clockProvider)(),
  );
  late DateTime? _time = _existing?.startsAt.toLocal();
  late String? _staffId = _existing?.staffId;
  late bool _timeTouched = _existing != null;
  late bool _staffTouched = _existing != null;
  bool _saving = false;
  bool _submitted = false;

  bool get _isReschedule => _existing != null;

  int get _durationMin => _services.fold(0, (sum, s) => sum + s.durationMin);

  bool get _isDirty {
    final e = _existing;
    if (e == null) {
      return _customer != null && widget.presetCustomerId == null ||
          _walkInName.text.trim().isNotEmpty ||
          _services.isNotEmpty ||
          _notes.text.trim().isNotEmpty ||
          _timeTouched ||
          _staffTouched;
    }
    return _time != e.startsAt.toLocal() ||
        _staffId != e.staffId ||
        _notes.text.trim() != (e.notes ?? '') ||
        _services.map((s) => s.serviceId).join() !=
            e.services.map((s) => s.serviceId).join();
  }

  @override
  void initState() {
    super.initState();
    for (final c in [_walkInName, _walkInPhone, _notes]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (final c in [_walkInName, _walkInPhone, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  // ------------------------------------------------------------- pickers

  Future<void> _chooseCustomer() async {
    final picked = await showCustomerPicker(
      context,
      customers: widget.data.customers,
    );
    if (picked != null) setState(() => _customer = picked);
  }

  Future<void> _newCustomer() async {
    final created = await showNewCustomerSheet(context);
    if (created != null) setState(() => _customer = created);
  }

  Future<void> _chooseServices() async {
    final picked = await showServicePicker(
      context,
      services: widget.data.services,
      selected: {for (final s in _services) s.serviceId},
    );
    if (picked == null) return;
    setState(() {
      // Keep existing snapshots (and their order), add new ones from the menu.
      _services = [
        for (final s in _services)
          if (picked.contains(s.serviceId)) s,
        for (final item in widget.data.services)
          if (picked.contains(item.id) &&
              !_services.any((s) => s.serviceId == item.id))
            AppointmentService(
              serviceId: item.id,
              name: item.name,
              pricePaise: item.pricePaise,
              durationMin: item.durationMin,
            ),
      ];
    });
  }

  Future<void> _chooseDate() async {
    final today = DateRange.startOfDay(ref.read(clockProvider)());
    final picked = await showDatePicker(
      context: context,
      initialDate: _date.isBefore(today) ? today : _date,
      firstDate: today,
      lastDate: DateTime(today.year + 1, today.month, today.day),
    );
    if (picked == null) return;
    setState(() {
      _date = DateRange.startOfDay(picked);
      // Move the chosen time to the new day, keeping the clock time.
      if (_time != null) {
        _time = DateTime(
          _date.year,
          _date.month,
          _date.day,
          _time!.hour,
          _time!.minute,
        );
      }
    });
  }

  // -------------------------------------------------------- calculations

  List<DateTime> _slots(DateTime now) {
    final p = widget.data.parlour;
    final all = AppointmentRules.slots(
      day: _date,
      open: p.openTime,
      close: p.closeTime,
      slotMinutes: p.slotMinutes,
    );
    final upcoming = all.where((s) => !s.isBefore(now)).toList();
    // Keep the current time visible when rescheduling.
    if (_time != null && !upcoming.contains(_time)) {
      upcoming
        ..add(_time!)
        ..sort();
    }
    return upcoming;
  }

  // ---------------------------------------------------------------- save

  Future<void> _book({
    required DateTime? time,
    required Staff? stylist,
    required List<Appointment> dayList,
    required PeopleNames? names,
  }) async {
    if (_saving) return;
    final l10n = context.l10n;
    setState(() => _submitted = true);
    final fieldsOk = _formKey.currentState?.validate() ?? false;
    final hasClient = _isReschedule || _walkIn || _customer != null;
    if (!fieldsOk ||
        !hasClient ||
        _services.isEmpty ||
        time == null ||
        stylist == null) {
      showMessage(context, l10n.commonFillRequired);
      return;
    }

    final end = time.add(Duration(minutes: _durationMin));
    final clashes = AppointmentRules.clashes(
      staffId: stylist.id,
      start: time,
      end: end,
      existing: dayList,
      excludeId: _existing?.id,
    );
    if (clashes.isNotEmpty) {
      final bookAnyway = await showOverlapSheet(
        context,
        stylistName: stylist.name,
        clashes: clashes,
        clientName: (a) => names?.client(a, l10n) ?? l10n.commonCustomer,
      );
      if (!bookAnyway) return;
    }

    setState(() => _saving = true);
    final actions = ref.read(appointmentActionsProvider);
    final e = _existing;
    final phone = _walkInPhone.text.trim();
    final notes = _notes.text.trim();
    try {
      final saved = await actions.save(
        Appointment(
          id: e?.id ?? actions.newId(),
          parlourId: e?.parlourId ?? '',
          customerId: e != null
              ? e.customerId
              : (_walkIn ? null : _customer!.id),
          walkInName: e != null
              ? e.walkInName
              : (_walkIn ? _walkInName.text.trim() : null),
          walkInPhone: e != null
              ? e.walkInPhone
              : (_walkIn && phone.isNotEmpty
                    ? PhoneNumber.display(phone)
                    : null),
          staffId: stylist.id,
          startsAt: time,
          endsAt: end,
          status: AppointmentStatus.booked,
          notes: notes.isEmpty ? null : notes,
          services: _services,
        ),
      );
      if (!mounted) return;
      if (e != null) {
        showMessage(context, l10n.bookingRescheduled);
        Navigator.of(context).pop();
      } else {
        showMessage(context, l10n.bookingBooked);
        context.pushReplacement(Routes.appointment(saved.id));
      }
    } on DomainException catch (err) {
      if (mounted) showMessage(context, context.errorText(err));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  // ------------------------------------------------------------------ UI

  @override
  Widget build(BuildContext context) {
    final now = ref.watch(clockProvider)();
    final dayList = ref.watch(dayAppointmentsProvider(_date)).value ?? const [];
    final names = ref.watch(peopleNamesProvider).value;

    final serviceIds = {for (final s in _services) s.serviceId};
    final eligible = BookingPlanner.eligibleStaff(
      staff: widget.data.staff,
      serviceIds: serviceIds,
      day: _date,
    );
    final duration = _durationMin == 0 ? 30 : _durationMin;
    final slots = _slots(now);

    // Next free slot is preselected until the user picks a time.
    final time = _timeTouched
        ? _time
        : BookingPlanner.nextFreeSlot(
                slots: slots,
                notBefore: now,
                durationMin: duration,
                candidates: eligible,
                appointments: dayList,
                excludeId: _existing?.id,
              ) ??
              (slots.isEmpty ? null : slots.first);
    final end = time?.add(Duration(minutes: duration));

    // First free stylist is preselected until the user picks one.
    Staff? stylist;
    if (_staffTouched) {
      stylist = widget.data.staff.where((s) => s.id == _staffId).firstOrNull;
    }
    if (stylist == null && time != null) {
      stylist =
          BookingPlanner.firstFreeStylist(
            candidates: eligible,
            start: time,
            end: end!,
            appointments: dayList,
            excludeId: _existing?.id,
          ) ??
          eligible.firstOrNull;
    }

    final isClosed = !widget.data.parlour.isOpenOn(_date);
    final l10n = context.l10n;

    return DiscardChangesScope(
      isDirty: _isDirty && !_saving,
      child: Scaffold(
        appBar: AppTopBar(
          title: _isReschedule ? l10n.apptReschedule : l10n.bookingNewTitle,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              Space.xl,
              Space.sm,
              Space.xl,
              Space.xxl,
            ),
            children: [
              ..._customerSection(),
              Gap.h20,
              ..._servicesSection(),
              Gap.h20,
              PickerField(
                label: l10n.bookingDate,
                isRequired: true,
                icon: Icons.calendar_today_outlined,
                hint: l10n.bookingChooseDate,
                value: Dates.weekdayDayMonth(_date),
                onTap: _chooseDate,
              ),
              if (isClosed) ...[
                Gap.h8,
                Text(
                  l10n.bookingClosedOn(Dates.weekday(_date)),
                  style: AppText.caption.copyWith(color: AppColors.warning),
                ),
              ],
              Gap.h20,
              FieldLabel(l10n.bookingTime, required: true),
              Gap.h8,
              if (slots.isEmpty)
                Text(
                  l10n.bookingNoTimesLeft,
                  style: AppText.body.copyWith(color: AppColors.textMuted),
                )
              else
                ChoiceChips<DateTime>(
                  options: [
                    for (final s in slots) ChoiceOption(s, Dates.time(s)),
                  ],
                  selected: time,
                  onSelected: (s) => setState(() {
                    _time = s;
                    _timeTouched = true;
                  }),
                ),
              Gap.h20,
              FieldLabel(l10n.commonStylist, required: true),
              Gap.h8,
              if (eligible.isEmpty)
                Text(
                  l10n.bookingNoStylist,
                  style: AppText.body.copyWith(color: AppColors.textMuted),
                )
              else
                for (final s in eligible)
                  _StylistTile(
                    staff: s,
                    selected: s.id == stylist?.id,
                    availability: time == null
                        ? null
                        : BookingPlanner.availability(
                            staffId: s.id,
                            start: time,
                            end: end!,
                            appointments: dayList,
                            excludeId: _existing?.id,
                          ),
                    onTap: () => setState(() {
                      _staffId = s.id;
                      _staffTouched = true;
                    }),
                  ),
              if (_services.isNotEmpty && time != null) ...[
                Gap.h16,
                _Summary(
                  durationMin: _durationMin,
                  end: end!,
                  estimatePaise: _services.fold(
                    0,
                    (sum, s) => sum + s.pricePaise,
                  ),
                ),
              ],
              Gap.h20,
              AppTextField(
                label: l10n.apptNotes,
                controller: _notes,
                maxLines: 3,
                hint: l10n.bookingNotesHint,
                textCapitalization: TextCapitalization.sentences,
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              Space.xl,
              Space.sm,
              Space.xl,
              Space.lg,
            ),
            child: PrimaryButton(
              label: _isReschedule ? l10n.commonSaveChanges : l10n.apptBook,
              loading: _saving,
              onPressed: () => _book(
                time: time,
                stylist: stylist,
                dayList: dayList,
                names: names,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _customerSection() {
    final l10n = context.l10n;
    final error = _submitted && !_walkIn && _customer == null;
    if (_isReschedule) {
      final name = _customer?.name ?? _existing!.walkInName ?? l10n.commonGuest;
      return [
        FieldLabel(l10n.commonCustomer, required: true),
        Gap.h8,
        _CustomerTile(
          name: _existing!.isWalkIn ? l10n.commonWalkInNamed(name) : name,
          phone: _customer?.phone ?? _existing.walkInPhone,
        ),
      ];
    }
    if (_walkIn) {
      return [
        AppTextField(
          label: l10n.bookingWalkInName,
          isRequired: true,
          controller: _walkInName,
          icon: Icons.person_outline_rounded,
          textCapitalization: TextCapitalization.words,
          autofocus: true,
          validator: (v) => (v == null || v.trim().isEmpty)
              ? l10n.bookingWalkInNameRequired
              : null,
        ),
        Gap.h16,
        AppTextField(
          label: l10n.bookingMobileNumber,
          controller: _walkInPhone,
          icon: Icons.phone_outlined,
          prefixText: '+91 ',
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
            LengthLimitingTextInputFormatter(11),
          ],
          validator: (v) {
            final t = v?.trim() ?? '';
            if (t.isEmpty) return null;
            return PhoneNumber.isValidMobile(t)
                ? null
                : l10n.bookingPhoneInvalid;
          },
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => setState(() => _walkIn = false),
            icon: const Icon(Icons.people_alt_outlined, size: 20),
            label: Text(l10n.bookingChooseSavedCustomer),
          ),
        ),
      ];
    }
    return [
      PickerField(
        label: l10n.commonCustomer,
        isRequired: true,
        icon: Icons.search_rounded,
        hint: l10n.apptSearchCustomer,
        value: _customer == null
            ? null
            : '${_customer!.name} · ${PhoneNumber.display(_customer!.phone)}',
        onTap: _chooseCustomer,
      ),
      if (error)
        Padding(
          padding: const EdgeInsets.only(top: Space.xs, left: Space.md),
          child: Text(
            l10n.bookingCustomerRequired,
            style: AppText.caption.copyWith(color: AppColors.error),
          ),
        ),
      Row(
        children: [
          TextButton.icon(
            onPressed: _newCustomer,
            icon: const Icon(Icons.add_rounded, size: 20),
            label: Text(l10n.apptNewCustomerShort),
          ),
          TextButton.icon(
            onPressed: () => setState(() {
              _walkIn = true;
              _customer = null;
            }),
            icon: const Icon(Icons.directions_walk_rounded, size: 20),
            label: Text(l10n.commonWalkIn),
          ),
        ],
      ),
    ];
  }

  List<Widget> _servicesSection() {
    final l10n = context.l10n;
    return [
      FieldLabel(l10n.apptServices, required: true),
      Gap.h8,
      Wrap(
        spacing: Space.sm,
        runSpacing: Space.sm,
        children: [
          for (final s in _services)
            InputChip(
              label: Text('${s.name} · ${Money.format(s.pricePaise)}'),
              labelStyle: AppText.chip.copyWith(color: AppColors.info),
              backgroundColor: AppColors.chipSelected,
              shape: const StadiumBorder(
                side: BorderSide(color: AppColors.rose, width: 0.8),
              ),
              deleteIconColor: AppColors.info,
              deleteButtonTooltipMessage: l10n.bookingRemoveService(s.name),
              onDeleted: () => setState(
                () => _services = [
                  for (final x in _services)
                    if (x.serviceId != s.serviceId) x,
                ],
              ),
            ),
          ActionChip(
            avatar: const Icon(
              Icons.add_rounded,
              size: 18,
              color: AppColors.primary,
            ),
            label: Text(
              _services.isEmpty ? l10n.bookingAddServices : l10n.bookingAddMore,
            ),
            labelStyle: AppText.chip.copyWith(color: AppColors.primary),
            backgroundColor: AppColors.surface,
            shape: const StadiumBorder(
              side: BorderSide(color: AppColors.border),
            ),
            onPressed: _chooseServices,
          ),
        ],
      ),
      if (_submitted && _services.isEmpty)
        Padding(
          padding: const EdgeInsets.only(top: Space.xs, left: Space.md),
          child: Text(
            l10n.errAppointmentNoServices,
            style: AppText.caption.copyWith(color: AppColors.error),
          ),
        ),
    ];
  }
}

class _CustomerTile extends StatelessWidget {
  const _CustomerTile({required this.name, this.phone});

  final String name;
  final String? phone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Space.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: Radii.controlAll,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          AvatarInitials(name: name, size: 40),
          Gap.w12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppText.bodyStrong),
                if (phone != null)
                  Text(PhoneNumber.display(phone!), style: AppText.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StylistTile extends StatelessWidget {
  const _StylistTile({
    required this.staff,
    required this.selected,
    required this.availability,
    required this.onTap,
  });

  final Staff staff;
  final bool selected;
  final StylistAvailability? availability;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final a = availability;
    final (String text, Color color) = a == null
        ? (l10n.bookingChooseTimeFirst, AppColors.textMuted)
        : a.isFree
        ? (l10n.bookingFree, AppColors.success)
        : a.busyUntil != null
        ? (l10n.bookingBusyUntil(Dates.time(a.busyUntil!)), AppColors.warning)
        : (l10n.bookingBusyFrom(Dates.time(a.busyFrom!)), AppColors.warning);
    return Padding(
      padding: const EdgeInsets.only(bottom: Space.sm),
      child: Material(
        color: selected ? AppColors.chipSelected : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: Radii.controlAll,
          side: BorderSide(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          customBorder: const RoundedRectangleBorder(
            borderRadius: Radii.controlAll,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Space.md,
              vertical: 10,
            ),
            child: Row(
              children: [
                AvatarInitials(name: staff.name, size: 36),
                Gap.w12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(staff.name, style: AppText.bodyStrong),
                      // Availability under the name, so it never pushes
                      // the row wider than a small screen.
                      Text.rich(
                        TextSpan(
                          text: '${l10n.builtIn(staff.roleTitle)} · ',
                          children: [
                            TextSpan(
                              text: text,
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        style: AppText.caption,
                      ),
                    ],
                  ),
                ),
                Gap.w8,
                Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  color: selected ? AppColors.primary : AppColors.textMuted,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({
    required this.durationMin,
    required this.end,
    required this.estimatePaise,
  });

  final int durationMin;
  final DateTime end;
  final int estimatePaise;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final h = durationMin ~/ 60;
    final m = durationMin % 60;
    final duration = [
      if (h > 0) l10n.commonHours(h),
      if (m > 0) l10n.commonMinutes(m),
    ].join(' ');
    return Container(
      padding: const EdgeInsets.all(Space.lg),
      decoration: const BoxDecoration(
        color: AppColors.chipSelected,
        borderRadius: Radii.cardAll,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                size: 18,
                color: AppColors.primary,
              ),
              Gap.w8,
              Expanded(
                child: Text(
                  l10n.bookingDurationEnds(duration, Dates.time(end)),
                  style: AppText.body.copyWith(color: AppColors.info),
                ),
              ),
            ],
          ),
          Gap.h8,
          Row(
            children: [
              const Icon(
                Icons.payments_outlined,
                size: 18,
                color: AppColors.primary,
              ),
              Gap.w8,
              Text(
                l10n.bookingEstimate(Money.format(estimatePaise)),
                style: AppText.bodyStrong.copyWith(color: AppColors.info),
              ),
            ],
          ),
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
