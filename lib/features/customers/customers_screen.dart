import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/design/spacing.dart';
import '../../core/format/dates.dart';
import '../../core/format/phone.dart';
import '../../core/l10n/l10n.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/avatar_initials.dart';
import '../../core/widgets/choice_chips.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/list_row_card.dart';
import '../../core/widgets/search_field.dart';
import 'customers_controller.dart';

/// S6 — Customers list with search and sort.
class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen> {
  String _query = '';
  CustomerView _view = CustomerView.recentVisit;

  void _add() => context.push(Routes.newCustomer);

  @override
  Widget build(BuildContext context) {
    final rows = ref.watch(customerRowsProvider);
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppTopBar(
        title: l10n.custTitle,
        actions: [
          IconButton(
            tooltip: l10n.custAdd,
            onPressed: _add,
            icon: const Icon(Icons.person_add_alt_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.custAdd,
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
            child: Column(
              children: [
                SearchField(
                  hint: l10n.custSearchHint,
                  onChanged: (v) => setState(() => _query = v),
                ),
                Gap.h12,
                ChoiceChips<CustomerView>(
                  scrollable: true,
                  selected: _view,
                  onSelected: (v) => setState(() => _view = v),
                  options: [
                    ChoiceOption(
                      CustomerView.recentVisit,
                      l10n.custViewRecent,
                      icon: Icons.schedule_rounded,
                    ),
                    ChoiceOption(
                      CustomerView.az,
                      l10n.custViewAz,
                      icon: Icons.sort_by_alpha_rounded,
                    ),
                    ChoiceOption(
                      CustomerView.inactive,
                      l10n.custViewInactive(
                        rows.value?.where((r) => !r.customer.isActive).length ??
                            0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: switch (rows) {
              AsyncValue(:final value?) => _List(
                rows: filterCustomers(value, query: _query, view: _view),
                view: _view,
                hasQuery: _query.trim().isNotEmpty,
                onAdd: _add,
              ),
              AsyncValue(:final error?) => Center(
                child: EmptyState(
                  icon: Icons.error_outline_rounded,
                  message: l10n.custLoadError('$error'),
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
    required this.rows,
    required this.view,
    required this.hasQuery,
    required this.onAdd,
  });

  final List<CustomerRow> rows;
  final CustomerView view;
  final bool hasQuery;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (rows.isEmpty) {
      return SingleChildScrollView(
        child: hasQuery
            ? EmptyState(
                icon: Icons.person_search_outlined,
                message: l10n.custNoMatch,
                actionLabel: l10n.custAdd,
                onAction: onAdd,
              )
            : view == CustomerView.inactive
            ? EmptyState(
                icon: Icons.people_alt_outlined,
                message: l10n.custNoInactive,
              )
            : EmptyState(
                icon: Icons.people_alt_outlined,
                message: l10n.custEmpty,
                actionLabel: l10n.custAdd,
                onAction: onAdd,
              ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        Space.screen,
        0,
        Space.screen,
        96, // room for the FAB
      ),
      itemCount: rows.length,
      separatorBuilder: (_, _) => Gap.h8,
      itemBuilder: (context, index) {
        final row = rows[index];
        final c = row.customer;
        final last = c.lastVisitAt == null
            ? l10n.custNoVisitsYet
            : l10n.custLastVisit(Dates.dayMonth(c.lastVisitAt!));
        return ListRowCard(
          title: c.name,
          subtitle: PhoneNumber.display(c.phone),
          caption: l10n.custRowCaption(row.visits, last),
          leading: AvatarInitials(name: c.name),
          trailing: const RowChevron(),
          dimmed: !c.isActive,
          onTap: () => context.push(Routes.customer(c.id)),
        );
      },
    );
  }
}
