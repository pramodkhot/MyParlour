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
import '../../core/widgets/buttons.dart';
import '../../core/widgets/empty_state.dart';
import 'billing_controller.dart';
import 'invoice_status_chip.dart';
import 'payment_method_ui.dart';
import 'widgets/receipt_buttons.dart';

/// S11 — Payment recorded, with receipt actions.
class PaymentSuccessScreen extends ConsumerWidget {
  const PaymentSuccessScreen({
    super.key,
    required this.billId,
    required this.paymentId,
  });

  final String billId;
  final String paymentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(billDetailProvider(billId));
    final payment = detail.value?.payments
        .where((p) => p.id == paymentId)
        .firstOrNull;
    if (detail.isLoading && !detail.hasValue) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (detail.value == null || payment == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: EmptyState(
            icon: Icons.receipt_long_outlined,
            message: 'This payment could not be found.',
          ),
        ),
      );
    }
    final d = detail.value!;
    final bill = d.invoice;
    final sender = ReceiptSender(ref, context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Close',
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.go(Routes.bill(bill.id)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Space.xl,
          Space.lg,
          Space.xl,
          Space.xxl,
        ),
        children: [
          Center(
            child: Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                color: AppColors.successBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: AppColors.success,
                size: 52,
              ),
            ),
          ),
          Gap.h16,
          const Text(
            'Payment recorded',
            textAlign: TextAlign.center,
            style: AppText.screenTitle,
          ),
          Gap.h8,
          Text(
            '${Money.format(payment.amountPaise)} by ${payment.method.label}'
            ' · ${Dates.dayMonthTime(payment.receivedAt)}',
            textAlign: TextAlign.center,
            style: AppText.body.copyWith(color: AppColors.textMuted),
          ),
          Gap.h24,
          AppCard(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        bill.invoiceNo ?? 'Bill',
                        style: AppText.bodyStrong,
                      ),
                    ),
                    InvoiceStatusChip(bill.status),
                  ],
                ),
                Gap.h8,
                Row(
                  children: [
                    Expanded(child: Text(d.clientName, style: AppText.caption)),
                    Text(
                      'Total ${Money.format(bill.totalPaise)}',
                      style: AppText.caption,
                    ),
                  ],
                ),
                const Divider(height: Space.xl),
                Row(
                  children: [
                    const Expanded(
                      child: Text('Balance', style: AppText.bodyStrong),
                    ),
                    Text(
                      Money.format(bill.balancePaise),
                      style: AppText.bodyStrong.copyWith(
                        color: bill.balancePaise > 0
                            ? AppColors.warning
                            : AppColors.success,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Gap.h24,
          PrimaryButton(
            label: 'Share receipt on WhatsApp',
            icon: Icons.share_outlined,
            onPressed: () => sender.share(d.receipt),
          ),
          Gap.h12,
          SecondaryButton(
            label: 'Print receipt',
            icon: Icons.print_outlined,
            onPressed: () => sender.print(d.receipt),
          ),
          Gap.h12,
          SecondaryButton(
            label: 'Download PDF',
            icon: Icons.download_outlined,
            onPressed: () => sender.download(d.receipt),
          ),
          Gap.h16,
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              if (bill.customerId != null)
                TextButton(
                  onPressed: () => context.go(
                    Routes.newAppointment(customerId: bill.customerId),
                  ),
                  child: const Text('Book next visit'),
                ),
              TextButton(
                onPressed: () => context.go(Routes.dashboard),
                child: const Text('Back to dashboard'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
