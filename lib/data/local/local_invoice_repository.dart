import '../../domain/errors.dart';
import '../../domain/models/invoice.dart';
import '../../domain/models/payment.dart';
import '../../domain/models/stock_movement.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/services/bill_builder.dart';
import '../../domain/services/invoice_rules.dart';
import '../../domain/services/stock_rules.dart';
import 'local_store.dart';
import 'store_data.dart';

class LocalInvoiceRepository implements InvoiceRepository {
  LocalInvoiceRepository(this._store, {required this.newId});

  final LocalStore _store;
  final String Function() newId;

  @override
  Future<List<Invoice>> list() async =>
      _store.data.invoices.toList()
        ..sort((a, b) => _sortTime(b).compareTo(_sortTime(a)));

  @override
  Future<Invoice?> getById(String id) async =>
      findById(_store.data.invoices, id, (i) => i.id);

  @override
  Future<Invoice?> findByAppointment(String appointmentId) async =>
      _billForAppointment(_store.data, appointmentId);

  @override
  Future<List<Invoice>> listForCustomer(String customerId) async =>
      (await list()).where((i) => i.customerId == customerId).toList();

  @override
  Future<Invoice> saveDraft(BillDraft draft) =>
      _store.transact((data) => _putDraft(data, draft));

  @override
  Future<Invoice> finalise(BillDraft draft) => _store.transact((data) {
    final existing = findById(data.invoices, draft.id, (i) => i.id);
    // A repeated submit of an already-finalised bill changes nothing.
    if (existing != null && !existing.isDraft) return existing;

    final invoice = _putDraft(data, draft);
    final now = _store.clock();

    // Reduce stock for products, all or nothing.
    final soldByProduct = <String, int>{};
    for (final item in invoice.items) {
      if (item.type == InvoiceItemType.product) {
        soldByProduct[item.refId] = (soldByProduct[item.refId] ?? 0) + item.qty;
      }
    }
    for (final entry in soldByProduct.entries) {
      final product = findById(data.products, entry.key, (p) => p.id);
      if (product == null) {
        throw const NotFoundException(
          'A product on this bill no longer exists.',
        );
      }
      upsertById(
        data.products,
        StockRules.apply(product, -entry.value),
        (p) => p.id,
      );
      data.stockMovements.add(
        StockMovement(
          id: newId(),
          parlourId: data.parlour.id,
          productId: entry.key,
          qtyChange: -entry.value,
          reason: StockReason.sale,
          invoiceId: invoice.id,
          createdAt: now,
        ),
      );
    }

    final fy = InvoiceRules.financialYear(now);
    final serial = (data.invoiceSerials[fy] ?? 0) + 1;
    data.invoiceSerials[fy] = serial;

    final finalised = invoice.copyWith(
      invoiceNo: InvoiceRules.invoiceNumber(
        prefix: data.parlour.invoicePrefix,
        date: now,
        serial: serial,
      ),
      status: InvoiceRules.statusFor(
        totalPaise: invoice.totalPaise,
        paidPaise: 0,
      ),
      paidPaise: 0,
      balancePaise: invoice.totalPaise,
      finalisedAt: now,
    );
    upsertById(data.invoices, finalised, (i) => i.id);
    return finalised;
  });

  @override
  Future<Invoice> recordPayment(PaymentInput input) => _store.transact((data) {
    final invoice = findById(data.invoices, input.invoiceId, (i) => i.id);
    if (invoice == null) throw const NotFoundException('Bill not found.');

    // Same payment id again (double tap): nothing extra is recorded.
    if (data.payments.any((p) => p.id == input.id)) return invoice;

    if (invoice.isDraft) {
      throw const ValidationException(
        'Finalise the bill before taking payment.',
      );
    }
    if (invoice.isVoid) {
      throw const ValidationException('This bill is void.');
    }
    final error = InvoiceRules.paymentError(
      amountPaise: input.amountPaise,
      balancePaise: invoice.balancePaise,
      method: input.method,
    );
    if (error != null) throw ValidationException(error);

    data.payments.add(
      Payment(
        id: input.id,
        parlourId: data.parlour.id,
        invoiceId: invoice.id,
        amountPaise: input.amountPaise,
        method: input.method,
        reference: _blankToNull(input.reference),
        note: _blankToNull(input.note),
        receivedAt: _store.clock(),
      ),
    );
    final updated = _withPayments(data, invoice);
    upsertById(data.invoices, updated, (i) => i.id);
    return updated;
  });

  @override
  Future<Invoice> voidInvoice(String id) => _store.transact((data) {
    final invoice = findById(data.invoices, id, (i) => i.id);
    if (invoice == null) throw const NotFoundException('Bill not found.');
    if (invoice.isVoid) return invoice;
    final now = _store.clock();

    // Put sold stock back.
    final sales = data.stockMovements
        .where((m) => m.invoiceId == id && m.reason == StockReason.sale)
        .toList();
    for (final sale in sales) {
      final product = findById(data.products, sale.productId, (p) => p.id);
      if (product == null) continue;
      upsertById(
        data.products,
        StockRules.apply(product, -sale.qtyChange),
        (p) => p.id,
      );
      data.stockMovements.add(
        StockMovement(
          id: newId(),
          parlourId: data.parlour.id,
          productId: sale.productId,
          qtyChange: -sale.qtyChange,
          reason: StockReason.voidReversal,
          invoiceId: id,
          createdAt: now,
        ),
      );
    }

    for (var i = 0; i < data.payments.length; i++) {
      final p = data.payments[i];
      if (p.invoiceId == id && !p.isVoid) {
        data.payments[i] = p.copyWith(isVoid: true);
      }
    }

    final voided = invoice.copyWith(
      status: InvoiceStatus.void_,
      paidPaise: 0,
      balancePaise: 0,
      voidedAt: now,
    );
    upsertById(data.invoices, voided, (i) => i.id);
    return voided;
  });

  Invoice _putDraft(StoreData data, BillDraft draft) {
    final previous = findById(data.invoices, draft.id, (i) => i.id);
    if (previous != null && !previous.isDraft) {
      throw const ValidationException('This bill is already finalised.');
    }
    if (draft.appointmentId != null) {
      final other = _billForAppointment(data, draft.appointmentId!);
      if (other != null && other.id != draft.id) {
        throw ValidationException(
          'This appointment already has a bill'
          '${other.invoiceNo == null ? '' : ' (${other.invoiceNo})'}.',
        );
      }
    }
    final invoice = BillBuilder.buildDraft(
      draft: draft,
      parlour: data.parlour,
      createdAt: _store.clock(),
      newId: newId,
      previous: previous,
    );
    upsertById(data.invoices, invoice, (i) => i.id);
    return invoice;
  }

  Invoice _withPayments(StoreData data, Invoice invoice) {
    final paid = InvoiceRules.paidPaise(
      data.payments.where((p) => p.invoiceId == invoice.id),
    );
    return invoice.copyWith(
      paidPaise: paid,
      balancePaise: invoice.totalPaise - paid,
      status: InvoiceRules.statusFor(
        totalPaise: invoice.totalPaise,
        paidPaise: paid,
      ),
    );
  }

  static Invoice? _billForAppointment(StoreData data, String appointmentId) {
    for (final invoice in data.invoices) {
      if (invoice.appointmentId == appointmentId && !invoice.isVoid) {
        return invoice;
      }
    }
    return null;
  }

  static DateTime _sortTime(Invoice i) => i.finalisedAt ?? i.createdAt;

  static String? _blankToNull(String? value) {
    final trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }
}
