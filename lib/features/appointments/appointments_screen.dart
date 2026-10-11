import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/design/colors.dart';
import '../../core/design/spacing.dart';
import '../../core/design/typography.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/choice_chips.dart';
import '../../core/widgets/empty_state.dart';
import '../../data/providers.dart';
import '../../domain/models/date_range.dart';
import '../../domain/models/staff.dart';
import 'appointments_controller.dart';
import 'widgets/appointment_card.dart';
import 'widgets/week_strip.dart';

/// S3 — Appointments for a day, with a week strip.
class AppointmentsScreen extends ConsumerStatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  ConsumerState<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends ConsumerState<AppointmentsScreen> {
  late DateTime _today = DateRange.startOfDay(ref.read(clockProvider)());
  late DateTime _selected = _today;
  AppointmentFilter _filter = AppointmentFilter.all;
  String? _staffId;

  DateTime get _weekStart => weekStartOf(_selected);

  void _select(DateTime day) =>
      setState(() => _selected = DateRange.startOfDay(day));

  void _shiftWeek(int weeks) => _select(
    DateTime(_selected.year, _selected.month, _selected.day + 7 * weeks),
  );

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selected,
      firstDate: DateTime(_today.year - 2),
      lastDate: DateTime(_today.year + 2, 12, 31),
    );
    if (picked != null) _select(picked);
  }

  Future<void> _pickStylist(List<Staff> staff) async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: Space.lg),
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(Space.xl, 0, Space.xl, Space.sm),
              child: Text('Show appointments for', style: AppText.sectionTitle),
            ),
            _StylistOption(
              label: 'All stylists',
              selected: _staffId == null,
              onTap: () => Navigator.of(context).pop(''),
            ),
            for (final s in staff)
              _StylistOption(
                label: s.isActive ? s.name : '${s.name} (inactive)',
                selected: _staffId == s.id,
                onTap: () => Navigator.of(context).pop(s.id),
              ),
          ],
        ),
      ),
    );
    if (picked != null) {
      setState(() => _staffId = picked.isEmpty ? null : picked);
    }
  }

  void _book() => context.push(Routes.newAppointment(date: _selected));

  @override
  Widget build(BuildContext context) {
    // Keep "today" right if the app stays open past midnight.
    _today = DateRange.startOfDay(ref.watch(clockProvider)());
    final week = ref.watch(weekAppointmentsProvider(_weekStart));
    final names = ref.watch(peopleNamesProvider);

    final all = week.value ?? const [];
    final dayList = appointmentsOnDay(all, _selected, staffId: _staffId);
    final counts = filterCounts(dayList);
    final shown = dayList.where(_filter.matches).toList();
    final bookedDays = {
      for (final a in all)
        if (_staffId == null || a.staffId == _staffId)
          DateRange.startOfDay(a.startsAt),
    };
    final staffName = _staffId == null
        ? null
        : names.value?.staff[_staffId]?.name;

    return Scaffold(
      appBar: AppTopBar(
        title: 'Appointments',
        subtitle: staffName == null ? null : 'Showing $staffName',
        actions: [
          IconButton(
            tooltip: 'Pick a date',
            onPressed: _pickDate,
            icon: const Icon(Icons.calendar_month_outlined),
          ),
          IconButton(
            tooltip: 'Filter by stylist',
            onPressed: names.hasValue
                ? () => _pickStylist(names.value!.staff.values.toList())
                : null,
            icon: Badge(
              isLabelVisible: _staffId != null,
              smallSize: 8,
              backgroundColor: AppColors.rose,
              child: const Icon(Icons.filter_list_rounded),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Book appointment',
        onPressed: _book,
        child: const Icon(Icons.add_rounded),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Space.md),
            child: WeekStrip(
              weekStart: _weekStart,
              selected: _selected,
              today: _today,
              daysWithBookings: bookedDays,
              onSelect: _select,
              onPreviousWeek: () => _shiftWeek(-1),
              onNextWeek: () => _shiftWeek(1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Space.screen,
              Space.md,
              0,
              Space.md,
            ),
            child: ChoiceChips<AppointmentFilter>(
              scrollable: true,
              selected: _filter,
              onSelected: (f) => setState(() => _filter = f),
              options: [
                for (final f in AppointmentFilter.values)
                  ChoiceOption(f, '${f.label} (${counts[f]})'),
              ],
            ),
          ),
          Expanded(
            child: switch ((week, names)) {
              (AsyncValue(:final error?), _) ||
              (_, AsyncValue(:final error?)) => Center(
                child: EmptyState(
                  icon: Icons.error_outline_rounded,
                  message: 'Could not load appointments. $error',
                ),
              ),
              (AsyncValue(hasValue: true), AsyncValue(:final value?)) =>
                shown.isEmpty
                    ? SingleChildScrollView(
                        child: EmptyState(
                          icon: Icons.event_available_outlined,
                          message: dayList.isEmpty
                              ? 'No appointments on this day'
                              : 'No ${_filter.label.toLowerCase()} '
                                    'appointments on this day',
                          actionLabel: 'Book appointment',
                          onAction: _book,
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(
                          Space.screen,
                          0,
                          Space.screen,
                          96,
                        ),
                        itemCount: shown.length,
                        separatorBuilder: (_, _) => Gap.h8,
                        itemBuilder: (context, i) => AppointmentCard(
                          appointment: shown[i],
                          clientName: value.client(shown[i]),
                          stylistName: value.stylist(shown[i]),
                          onTap: () =>
                              context.push(Routes.appointment(shown[i].id)),
                        ),
                      ),
              _ => const Center(child: CircularProgressIndicator()),
            },
          ),
        ],
      ),
    );
  }
}

class _StylistOption extends StatelessWidget {
  const _StylistOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing: selected
          ? const Icon(Icons.check_rounded, color: AppColors.primary)
          : null,
      onTap: onTap,
    );
  }
}
