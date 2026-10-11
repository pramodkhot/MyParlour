import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/design/colors.dart';
import '../../core/design/spacing.dart';
import '../../core/design/typography.dart';
import '../../core/format/dates.dart';
import '../../core/format/money.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/confirm_dialog.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/feedback.dart';
import '../../core/widgets/money_text.dart';
import '../../domain/errors.dart';
import 'billing_controller.dart';
import 'invoice_status_chip.dart';
import 'payment_method_ui.dart';
import 'widgets/receipt_buttons.dart';
import 'widgets/totals_card.dart';

/// A finalised bill: items, totals, payments and actions.
class BillScreen extends ConsumerWidget {
  const BillScreen({super.key, required this.billId});

  final String billId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(billDetailProvider(billId))) {
      AsyncValue(:final value?) => _Bill(detail: value),
      AsyncValue(hasValue: true) => const _Message(
        'This bill no longer exists.',
      ),
      AsyncValue(:final error?) => _Message('Could not load this bill. $error'),
      _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
    };
  }
}

class _Bill extends ConsumerWidget {
  const _Bill({required this.detail});

  final BillDetail detail;

  Future<void> _void(BuildContext context, WidgetRef ref) async {
    final ok = await ConfirmDialog.show(
      context,
      title: 'Void this bill?',
      message:
          'The bill and its payments will be marked void and any products '
          'sold go back into stock. The bill number is not reused.',
      confirmLabel: 'Void bill',
      destructive: true,
    );
    if (!ok) return;
    try {
      await ref.read(billingActionsProvider).voidBill(detail.invoice.id);
      if (context.mounted) showMessage(context, 'Bill voided');
    } on DomainException catch (e) {
      if (context.mounted) showMessage(context, e.message);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bill = detail.invoice;
    final sender = ReceiptSender(ref, context);
    final receipt = detail.receipt;

    return Scaffold(
      appBar: AppTopBar(
        title: bill.invoiceNo ?? 'Draft bill',
        actions: [
          if (!bill.isVoid && !bill.isDraft)
            PopupMenuButton<String>(
              tooltip: 'More actions',
              icon: const Icon(Icons.more_horiz_rounded),
              onSelected: (v) => switch (v) {
                'print' => sender.print(receipt),
                'download' => sender.download(receipt),
                _ => _void(context, ref),
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'print', child: Text('Print receipt')),
                PopupMenuItem(value: 'download', child: Text('Download PDF')),
                PopupMenuItem(value: 'void', child: Text('Void bill')),
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
          if (bill.isVoid)
            Container(
              margin: const EdgeInsets.only(bottom: Space.md),
              padding: const EdgeInsets.all(Space.md),
              decoration: const BoxDecoration(
                color: AppColors.errorBg,
                borderRadius: Radii.controlAll,
              ),
              child: Text(
                'This bill is void. Its payments are not counted and its '
                'products went back into stock.',
                style: AppText.body.copyWith(color: AppColors.error),
              ),
            ),
          AppCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(detail.clientName, style: AppText.bodyStrong),
                      Text(
                        Dates.dayMonthTime(bill.finalisedAt ?? bill.createdAt),
                        style: AppText.caption,
                      ),
                    ],
                  ),
                ),
                InvoiceStatusChip(bill.status),
              ],
            ),
          ),
          Gap.h12,
          AppCard(
            child: Column(
              children: [
                for (final item in bill.items)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: Space.xs),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name, style: AppText.body),
                              Text(
                                [
                                  '${item.qty} × ${Money.format(item.unitPricePaise)}',
                                  if (item.staffId != null &&
                                      detail.staffNames[item.staffId] != null)
                                    detail.staffNames[item.staffId]!,
                                ].join(' · '),
                                style: AppText.caption,
                              ),
                            ],
                          ),
                        ),
                        MoneyText(
                          item.unitPricePaise * item.qty,
                          style: AppText.body,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Gap.h12,
          TotalsCard(
            subtotalPaise: bill.subtotalPaise,
            discountPaise: bill.discountPaise,
            taxPaise: bill.taxPaise,
            totalPaise: bill.totalPaise,
            showTax: bill.taxEnabled,
            extraRows: [
              ('Paid', bill.paidPaise, false),
              ('Balance due', bill.balancePaise, true),
            ],
          ),
          if (detail.payments.isNotEmpty) ...[
            Gap.h20,
            const Text('Payments', style: AppText.sectionTitle),
            Gap.h8,
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (final pay in detail.payments)
                    ListTile(
                      leading: Icon(pay.method.icon, color: AppColors.primary),
                      title: Text(
                        '${pay.method.label}'
                        '${pay.reference == null ? '' : ' · ${pay.reference}'}',
                        style: pay.isVoid
                            ? const TextStyle(
                                decoration: TextDecoration.lineThrough,
                              )
                            : null,
                      ),
                      subtitle: Text(
                        Dates.dayMonthTime(pay.receivedAt) +
                            (pay.isVoid ? ' · void' : ''),
                      ),
                      trailing: MoneyText(pay.amountPaise),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: bill.isVoid
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  Space.screen,
                  Space.sm,
                  Space.screen,
                  Space.lg,
                ),
                child: bill.isOpen
                    ? Row(
                        children: [
                          Expanded(
                            child: SecondaryButton(
                              label: 'Share',
                              icon: Icons.share_outlined,
                              onPressed: () => sender.share(receipt),
                            ),
                          ),
                          Gap.w12,
                          Expanded(
                            flex: 2,
                            child: PrimaryButton(
                              label: 'Record payment',
                              onPressed: () =>
                                  context.push(Routes.payBill(bill.id)),
                            ),
                          ),
                        ],
                      )
                    : PrimaryButton(
                        label: 'Share receipt on WhatsApp',
                        icon: Icons.share_outlined,
                        onPressed: () => sender.share(receipt),
                      ),
              ),
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
      appBar: const AppTopBar(title: 'Bill'),
      body: Center(
        child: EmptyState(icon: Icons.receipt_long_outlined, message: message),
      ),
    );
  }
}
