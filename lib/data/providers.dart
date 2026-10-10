import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../domain/repositories/repositories.dart';
import 'local/local_appointment_repository.dart';
import 'local/local_customer_repository.dart';
import 'local/local_demo_data_repository.dart';
import 'local/local_expense_repository.dart';
import 'local/local_invoice_repository.dart';
import 'local/local_parlour_repository.dart';
import 'local/local_payment_repository.dart';
import 'local/local_product_repository.dart';
import 'local/local_service_repository.dart';
import 'local/local_staff_repository.dart';
import 'local/local_store.dart';

/// One provider per repository. Moving to Supabase later means changing
/// only the providers in this file.

/// Overridden in `main` with a loaded store (and in tests with a temp one).
final localStoreProvider = Provider<LocalStore>(
  (ref) => throw UnimplementedError('localStoreProvider must be overridden'),
);

/// True on the first launch after install (the demo data was just created).
final isFirstLaunchProvider = Provider<bool>(
  (ref) => ref.watch(localStoreProvider).seededOnLoad,
);

/// Current time; overridable in tests.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// New record ids (UUID v4).
final idGeneratorProvider = Provider<String Function()>((ref) {
  const uuid = Uuid();
  return uuid.v4;
});

/// Counts data changes. Screen providers watch it so they reload after any
/// save. (A counter rather than `void`, so each change is a new value.)
final dataVersionProvider = StreamProvider<int>((ref) {
  var version = 0;
  return ref.watch(localStoreProvider).changes.map((_) => ++version);
});

final parlourRepositoryProvider = Provider<ParlourRepository>(
  (ref) => LocalParlourRepository(ref.watch(localStoreProvider)),
);

final customerRepositoryProvider = Provider<CustomerRepository>(
  (ref) => LocalCustomerRepository(ref.watch(localStoreProvider)),
);

final serviceRepositoryProvider = Provider<ServiceRepository>(
  (ref) => LocalServiceRepository(ref.watch(localStoreProvider)),
);

final staffRepositoryProvider = Provider<StaffRepository>(
  (ref) => LocalStaffRepository(ref.watch(localStoreProvider)),
);

final appointmentRepositoryProvider = Provider<AppointmentRepository>(
  (ref) => LocalAppointmentRepository(ref.watch(localStoreProvider)),
);

final invoiceRepositoryProvider = Provider<InvoiceRepository>(
  (ref) => LocalInvoiceRepository(
    ref.watch(localStoreProvider),
    newId: ref.watch(idGeneratorProvider),
  ),
);

final paymentRepositoryProvider = Provider<PaymentRepository>(
  (ref) => LocalPaymentRepository(ref.watch(localStoreProvider)),
);

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => LocalProductRepository(
    ref.watch(localStoreProvider),
    newId: ref.watch(idGeneratorProvider),
  ),
);

final expenseRepositoryProvider = Provider<ExpenseRepository>(
  (ref) => LocalExpenseRepository(ref.watch(localStoreProvider)),
);

final demoDataRepositoryProvider = Provider<DemoDataRepository>(
  (ref) => LocalDemoDataRepository(ref.watch(localStoreProvider)),
);
