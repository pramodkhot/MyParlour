import '../../domain/models/date_range.dart';
import '../../domain/models/payment.dart';
import '../../domain/repositories/repositories.dart';
import 'local_store.dart';

/// Read-only view of payments. Payments are recorded through
/// `InvoiceRepository.recordPayment` so the bill updates in the same save.
class LocalPaymentRepository implements PaymentRepository {
  LocalPaymentRepository(this._store);

  final LocalStore _store;

  @override
  Future<List<Payment>> listInRange(DateRange range) async =>
      _sorted(_store.data.payments.where((p) => range.contains(p.receivedAt)));

  @override
  Future<List<Payment>> listForInvoice(String invoiceId) async =>
      _sorted(_store.data.payments.where((p) => p.invoiceId == invoiceId));

  List<Payment> _sorted(Iterable<Payment> items) =>
      items.toList()..sort((a, b) => a.receivedAt.compareTo(b.receivedAt));
}
