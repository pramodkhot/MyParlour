import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/design/spacing.dart';
import '../../core/design/typography.dart';
import '../../core/format/phone.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/avatar_initials.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/list_row_card.dart';
import '../../core/widgets/search_field.dart';
import '../../core/widgets/status_chip.dart';
import '../../domain/models/staff.dart';
import 'staff_controller.dart';

/// S12 — Staff list. Inactive staff are grouped at the bottom.
class StaffScreen extends ConsumerStatefulWidget {
  const StaffScreen({super.key});

  @override
  ConsumerState<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends ConsumerState<StaffScreen> {
  String _query = '';

  void _add() => context.push(Routes.newStaff);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(
        title: 'Staff',
        actions: [
          IconButton(
            tooltip: 'Add staff',
            onPressed: _add,
            icon: const Icon(Icons.person_add_alt_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add staff',
        onPressed: _add,
        child: const Icon(Icons.add_rounded),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Space.screen,
              Space.xs,
              Space.screen,
              Space.md,
            ),
            child: SearchField(
              hint: 'Search name, role or phone',
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: switch (ref.watch(allStaffProvider)) {
              AsyncValue(:final value?) => _List(
                staff: filterStaff(value, _query),
                hasQuery: _query.trim().isNotEmpty,
                onAdd: _add,
              ),
              AsyncValue(:final error?) => Center(
                child: EmptyState(
                  icon: Icons.error_outline_rounded,
                  message: 'Could not load staff. $error',
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

class _List extends StatelessWidget {
  const _List({
    required this.staff,
    required this.hasQuery,
    required this.onAdd,
  });

  final List<Staff> staff;
  final bool hasQuery;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    if (staff.isEmpty) {
      return SingleChildScrollView(
        child: EmptyState(
          icon: Icons.badge_outlined,
          message: hasQuery
              ? 'No staff member matches your search.'
              : 'No staff yet.',
          actionLabel: 'Add staff',
          onAction: onAdd,
        ),
      );
    }
    final firstInactive = staff.indexWhere((s) => !s.isActive);
    return ListView(
      padding: const EdgeInsets.fromLTRB(Space.screen, 0, Space.screen, 96),
      children: [
        for (var i = 0; i < staff.length; i++) ...[
          if (i == firstInactive)
            const Padding(
              padding: EdgeInsets.fromLTRB(Space.xs, Space.md, 0, Space.sm),
              child: Text('Inactive', style: AppText.sectionTitle),
            )
          else if (i > 0)
            Gap.h8,
          _StaffRow(staff: staff[i]),
        ],
      ],
    );
  }
}

class _StaffRow extends StatelessWidget {
  const _StaffRow({required this.staff});

  final Staff staff;

  @override
  Widget build(BuildContext context) {
    return ListRowCard(
      title: staff.name,
      subtitle: staff.roleTitle,
      caption: PhoneNumber.display(staff.phone),
      leading: AvatarInitials(name: staff.name),
      trailing: StatusChip(
        label: staff.isActive ? 'Active' : 'Inactive',
        tone: staff.isActive ? ChipTone.success : ChipTone.neutral,
      ),
      dimmed: !staff.isActive,
      onTap: () => context.push(Routes.staffMember(staff.id)),
    );
  }
}
