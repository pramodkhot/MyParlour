import '../errors.dart';
import '../models/invoice.dart';
import '../models/parlour.dart';
import '../repositories/repositories.dart';
import 'invoice_calculator.dart';

/// Turns what the user entered ([BillDraft]) into a calculated draft
/// [Invoice] using the parlour's tax settings.
abstract final class BillBuilder {
  static Invoice buildDraft({
    required BillDraft draft,
    required Parlour parlour,
    required DateTime createdAt,
    required String Function() newId,
    Invoice? previous,
  }) {
    if (draft.lines.isEmpty) {
      throw const ValidationException(ErrorCode.billNoLines);
    }
    for (final line in draft.lines) {
      if (line.qty <= 0) {
        throw ValidationException(ErrorCode.lineQtyInvalid, {
          'name': line.name,
        });
      }
      if (line.unitPricePaise < 0 || line.itemDiscountPaise < 0) {
        throw ValidationException(ErrorCode.linePriceInvalid, {
          'name': line.name,
        });
      }
    }

    // Reuse line ids when the same draft is saved again.
    final oldIds = [
      for (final item in previous?.items ?? <InvoiceItem>[]) item.id,
    ];
    final items = [
      for (var i = 0; i < draft.lines.length; i++)
        InvoiceItem(
          id: i < oldIds.length ? oldIds[i] : newId(),
          type: draft.lines[i].type,
          refId: draft.lines[i].refId,
          name: draft.lines[i].name,
          unitPricePaise: draft.lines[i].unitPricePaise,
          qty: draft.lines[i].qty,
          itemDiscountPaise: draft.lines[i].itemDiscountPaise,
          taxRateBp: draft.lines[i].taxRateBp,
          staffId: draft.lines[i].staffId,
        ),
    ];

    final subtotal = items.fold(
      0,
      (sum, item) => sum + InvoiceCalculator.lineNet(item),
    );
    final discountError = InvoiceCalculator.discountError(
      draft.discount,
      subtotal,
    );
    if (discountError != null) {
      throw ValidationException(discountError.code, discountError.args);
    }

    final totals = InvoiceCalculator.calculate(
      items: items,
      discount: draft.discount,
      taxEnabled: parlour.taxEnabled,
      pricesIncludeTax: parlour.pricesIncludeTax,
    );

    final walkIn = draft.walkInName?.trim();
    return Invoice(
      id: draft.id,
      parlourId: parlour.id,
      customerId: draft.customerId,
      walkInName: draft.customerId == null
          ? ((walkIn == null || walkIn.isEmpty) ? 'Walk-in' : walkIn)
          : null,
      appointmentId: draft.appointmentId,
      status: InvoiceStatus.draft,
      items: totals.items,
      discountType: draft.discount.type,
      discountValue: draft.discount.value,
      subtotalPaise: totals.subtotalPaise,
      discountPaise: totals.discountPaise,
      taxablePaise: totals.taxablePaise,
      taxPaise: totals.taxPaise,
      totalPaise: totals.totalPaise,
      paidPaise: 0,
      balancePaise: totals.totalPaise,
      taxEnabled: parlour.taxEnabled,
      pricesIncludeTax: parlour.pricesIncludeTax,
      createdAt: previous?.createdAt ?? createdAt,
    );
  }
}
