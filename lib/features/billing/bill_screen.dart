import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/design/colors.dart';
import '../../core/design/spacing.dart';
import '../../core/design/typography.dart';
import '../../core/format/dates.dart';
import '../../core/format/money.dart';
import '../../core/l10n/l10n.dart';
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
      AsyncValue(hasValue: true) => _Message(context.l10n.billingBillGone),
      AsyncValue(:final error?) => _Message(
        context.l10n.billingLoadBillError('$error'),
      ),
      _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
    };
  }
}

class _Bill extends ConsumerWidget {
  const _Bill({required this.detail});

  final BillDetail detail;

  Future<void> _void(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final ok = await ConfirmDialog.show(
      context,
      title: l10n.billingVoidTitle,
      message: l10n.billingVoidMessage,
      confirmLabel: l10n.billingVoidBill,
      destructive: true,
    );
    if (!ok) return;
    try {
      await ref.read(billingActionsProvider).voidBill(detail.invoice.id);
      if (context.mounted) showMessage(context, l10n.billingVoided);
    } on DomainException catch (e) {
      if (context.mounted) showMessage(context, context.errorText(e));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final bill = detail.invoice;
    final sender = ReceiptSender(ref, context);
    final receipt = detail.receipt(l10n);

    return Scaffold(
      appBar: AppTopBar(
        title: bill.invoiceNo ?? l10n.billingDraftBill,
        actions: [
          if (!bill.isVoid && !bill.isDraft)
            PopupMenuButton<String>(
              tooltip: l10n.billingMoreActions,
              icon: const Icon(Icons.more_horiz_rounded),
              onSelected: (v) => switch (v) {
                'print' => sender.print(receipt),
                'download' => sender.download(receipt),
                _ => _void(context, ref),
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'print',
                  child: Text(l10n.billingPrintReceipt),
                ),
                PopupMenuItem(
                  value: 'download',
                  child: Text(l10n.billingDownloadPdf),
                ),
                PopupMenuItem(value: 'void', child: Text(l10n.billingVoidBill)),
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
                l10n.billingVoidBanner,
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
                      Text(detail.clientName(l10n), style: AppText.bodyStrong),
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
              (l10n.billingPaidAmount, bill.paidPaise, false),
              (l10n.billingBalanceDue, bill.balancePaise, true),
            ],
          ),
          if (detail.payments.isNotEmpty) ...[
            Gap.h20,
            Text(l10n.billingPayments, style: AppText.sectionTitle),
            Gap.h8,
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (final pay in detail.payments)
                    ListTile(
                      leading: Icon(pay.method.icon, color: AppColors.primary),
                      title: Text(
                        '${l10n.paymentMethod(pay.method)}'
                        '${pay.reference == null ? '' : ' · ${pay.reference}'}',
                        style: pay.isVoid
                            ? const TextStyle(
                                decoration: TextDecoration.lineThrough,
                              )
                            : null,
                      ),
                      subtitle: Text(
                        Dates.dayMonthTime(pay.receivedAt) +
                            (pay.isVoid ? ' · ${l10n.billingVoidTag}' : ''),
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
                              label: l10n.billingShare,
                              icon: Icons.share_outlined,
                              onPressed: () => sender.share(receipt),
                            ),
                          ),
                          Gap.w12,
                          Expanded(
                            flex: 2,
                            child: PrimaryButton(
                              label: l10n.billingRecordPayment,
                              onPressed: () =>
                                  context.push(Routes.payBill(bill.id)),
                            ),
                          ),
                        ],
                      )
                    : PrimaryButton(
                        label: l10n.billingShareReceiptWhatsApp,
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
      appBar: AppTopBar(title: context.l10n.billingBill),
      body: Center(
        child: EmptyState(icon: Icons.receipt_long_outlined, message: message),
      ),
    );
  }
}
