import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/design/spacing.dart';
import '../../core/design/typography.dart';
import '../../core/format/dates.dart';
import '../../core/format/money.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/money_text.dart';
import 'billing_controller.dart';
import 'invoice_status_chip.dart';

/// S9 home — bills list with Open / All.
class BillingScreen extends ConsumerStatefulWidget {
  const BillingScreen({super.key, this.initialFilter = BillFilter.open});

  final BillFilter initialFilter;

  @override
  ConsumerState<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends ConsumerState<BillingScreen> {
  late BillFilter _filter = widget.initialFilter;

  @override
  void didUpdateWidget(BillingScreen old) {
    super.didUpdateWidget(old);
    // The Dashboard's "Pending payments" card opens the open bills.
    if (old.initialFilter != widget.initialFilter) {
      _filter = widget.initialFilter;
    }
  }

  void _newBill() => context.push(Routes.newBill());

  @override
  Widget build(BuildContext context) {
    final rows = ref.watch(billRowsProvider);
    return Scaffold(
      appBar: const AppTopBar(title: 'Billing'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _newBill,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New bill'),
        shape: const StadiumBorder(),
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
            child: SizedBox(
              width: double.infinity,
              child: SegmentedButton<BillFilter>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(
                    value: BillFilter.open,
                    label: Text('Open bills'),
                  ),
                  ButtonSegment(
                    value: BillFilter.all,
                    label: Text('All bills'),
                  ),
                ],
                selected: {_filter},
                onSelectionChanged: (s) => setState(() => _filter = s.first),
              ),
            ),
          ),
          Expanded(
            child: switch (rows) {
              AsyncValue(:final value?) => _List(
                rows: filterBills(value, _filter),
                filter: _filter,
                onNew: _newBill,
              ),
              AsyncValue(:final error?) => Center(
                child: EmptyState(
                  icon: Icons.error_outline_rounded,
                  message: 'Could not load bills. $error',
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
  const _List({required this.rows, required this.filter, required this.onNew});

  final List<BillRow> rows;
  final BillFilter filter;
  final VoidCallback onNew;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return SingleChildScrollView(
        child: EmptyState(
          icon: Icons.receipt_long_outlined,
          message: filter == BillFilter.open
              ? 'No open bills. Everything is paid.'
              : 'No bills yet.',
          actionLabel: 'New bill',
          onAction: onNew,
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(Space.screen, 0, Space.screen, 96),
      itemCount: rows.length,
      separatorBuilder: (_, _) => Gap.h8,
      itemBuilder: (context, i) {
        final bill = rows[i].invoice;
        final date = bill.finalisedAt ?? bill.createdAt;
        return AppCard(
          onTap: () => context.push(
            bill.isDraft ? Routes.editBill(bill.id) : Routes.bill(bill.id),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bill.invoiceNo ?? 'Draft bill',
                      style: AppText.caption.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      rows[i].clientName,
                      style: AppText.bodyStrong,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(Dates.dayMonthTime(date), style: AppText.caption),
                  ],
                ),
              ),
              Gap.w8,
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MoneyText(bill.totalPaise),
                  if (bill.isOpen && bill.balancePaise != bill.totalPaise)
                    Text(
                      'Due ${Money.format(bill.balancePaise)}',
                      style: AppText.caption,
                    ),
                  Gap.h4,
                  InvoiceStatusChip(bill.status),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
