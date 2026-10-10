import '../../domain/models/appointment.dart';
import '../../domain/models/customer.dart';
import '../../domain/models/expense.dart';
import '../../domain/models/invoice.dart';
import '../../domain/models/parlour.dart';
import '../../domain/models/payment.dart';
import '../../domain/models/product.dart';
import '../../domain/models/service_item.dart';
import '../../domain/models/staff.dart';
import '../../domain/models/stock_movement.dart';
import '../../domain/models/value_types.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/services/bill_builder.dart';
import '../../domain/services/invoice_calculator.dart';
import '../../domain/services/invoice_rules.dart';
import '../local/store_data.dart';

/// Builds the "Beauty Bliss Parlour" sample data (spec Section 7).
///
/// Every date is relative to [now], so today's appointments are always
/// today. The content is fixed (no randomness); only ids differ per reset.
class DemoSeed {
  DemoSeed({required this.now, required this.newId});

  final DateTime now;
  final String Function() newId;

  static StoreData build(DateTime now, String Function() newId) =>
      DemoSeed(now: now, newId: newId)._build();

  late final String _parlourId = newId();
  late final DateTime _today = DateTime(now.year, now.month, now.day);

  DateTime _day(int offset) =>
      DateTime(_today.year, _today.month, _today.day + offset);

  DateTime _at(int dayOffset, int hour, [int minute = 0]) {
    final d = _day(dayOffset);
    return DateTime(d.year, d.month, d.day, hour, minute);
  }

  StoreData _build() {
    final parlour = _parlour();
    final services = _services();
    final staff = _staff(services);
    final customers = _customers();
    final products = _products();
    final store = StoreData(
      parlour: parlour,
      services: services,
      staff: staff,
      customers: customers,
      products: products,
      expenses: _expenses(),
    );
    _appointmentsAndBills(store);
    _openingStock(store);
    return store;
  }

  // ---------------------------------------------------------------- parlour

  Parlour _parlour() => Parlour(
    id: _parlourId,
    name: 'Beauty Bliss Parlour',
    ownerName: 'Kavita',
    phone: '+91 98765 00000',
    area: 'MG Road, Pune',
    openDays: const [1, 2, 3, 4, 5, 6],
    openTime: const ClockTime(10, 0),
    closeTime: const ClockTime(20, 0),
    slotMinutes: 30,
    invoicePrefix: 'BBP',
    taxEnabled: false,
    defaultTaxRateBp: 1800,
  );

  // --------------------------------------------------------------- services

  static const _serviceSpecs = [
    ('Haircut', 'Hair', 500, 30),
    ('Hair Spa', 'Hair', 800, 60),
    ('Smoothening', 'Hair', 2500, 90),
    ('Hair Colour', 'Hair', 1500, 90),
    ('Facial', 'Skin', 1200, 60),
    ('Cleanup', 'Skin', 600, 30),
    ('Threading', 'Skin', 50, 10),
    ('Waxing (full arms)', 'Waxing', 400, 30),
    ('Manicure', 'Nails', 600, 45),
    ('Pedicure', 'Nails', 700, 45),
  ];

  final _serviceByName = <String, ServiceItem>{};

  List<ServiceItem> _services() => [
    for (final (name, category, rupees, minutes) in _serviceSpecs)
      _serviceByName[name] = ServiceItem(
        id: newId(),
        parlourId: _parlourId,
        name: name,
        category: category,
        pricePaise: rupees * 100,
        durationMin: minutes,
        taxRateBp: 1800,
      ),
  ];

  // ------------------------------------------------------------------ staff

  final _staffByName = <String, Staff>{};

  List<Staff> _staff(List<ServiceItem> services) {
    List<String> ids(List<String> names) => [
      for (final n in names) _serviceByName[n]!.id,
    ];
    final specs = [
      (
        'Anita',
        'Senior Beautician',
        '98765 11111',
        [for (final s in services) s.name],
        true,
      ),
      (
        'Riya',
        'Beautician',
        '98765 22222',
        [
          'Haircut',
          'Hair Spa',
          'Hair Colour',
          'Facial',
          'Cleanup',
          'Threading',
          'Waxing (full arms)',
        ],
        true,
      ),
      (
        'Meena',
        'Beautician',
        '98765 33333',
        [
          'Facial',
          'Cleanup',
          'Threading',
          'Waxing (full arms)',
          'Manicure',
          'Pedicure',
        ],
        true,
      ),
      (
        'Pooja',
        'Junior',
        '98765 44444',
        ['Threading', 'Waxing (full arms)', 'Cleanup'],
        false,
      ),
    ];
    return [
      for (final (name, role, phone, serviceNames, active) in specs)
        _staffByName[name] = Staff(
          id: newId(),
          parlourId: _parlourId,
          name: name,
          phone: phone,
          roleTitle: role,
          serviceIds: ids(serviceNames),
          workingDays: const [1, 2, 3, 4, 5, 6],
          startTime: const ClockTime(10, 0),
          endTime: const ClockTime(20, 0),
          isActive: active,
        ),
    ];
  }

  // -------------------------------------------------------------- customers

  final _customerByName = <String, Customer>{};

  List<Customer> _customers() {
    // Birthdays this month: one today, two later this month (or earlier,
    // near month end).
    DayMonth thisMonth(int offsetDays) {
      final lastDay = DateTime(_today.year, _today.month + 1, 0).day;
      var day = _today.day + offsetDays;
      if (day > lastDay) day = _today.day - offsetDays;
      if (day < 1) day = 1;
      return DayMonth(day, _today.month);
    }

    final specs = <(String, String, String?, DayMonth?, String?, int)>[
      (
        'Priya Sharma',
        '98765 43210',
        'priya.sharma@example.com',
        null,
        'Prefers less heat in smoothening.',
        420,
      ),
      ('Neha Verma', '91234 56789', null, null, null, 380),
      ('Sneha Patil', '99887 66554', null, const DayMonth(12, 3), null, 300),
      ('Ritika Kapoor', '88776 55433', 'ritika.k@example.com', null, null, 260),
      (
        'Anjali Singh',
        '77665 44322',
        null,
        null,
        'Likes Riya for hair colour.',
        240,
      ),
      ('Pooja Mehta', '90040 11223', null, thisMonth(0), null, 210),
      ('Kavya Nair', '98200 33445', null, null, null, 200),
      (
        'Shruti Deshpande',
        '97300 55667',
        null,
        null,
        'Sensitive skin: patch test before facial.',
        180,
      ),
      ('Aishwarya Kulkarni', '96650 77889', null, thisMonth(6), null, 150),
      ('Meghna Joshi', '93220 99001', null, const DayMonth(27, 8), null, 120),
      ('Tanvi Bhosale', '95180 22334', null, thisMonth(11), null, 100),
      (
        'Divya Iyer',
        '94420 44556',
        null,
        null,
        'Allergic to strong fragrance.',
        80,
      ),
      ('Sakshi Gupta', '92010 66778', null, null, null, 60),
      ('Rashmi Pawar', '90960 88990', null, null, null, 45),
    ];
    return [
      for (final (name, phone, email, birthday, notes, sinceDays) in specs)
        _customerByName[name] = Customer(
          id: newId(),
          parlourId: _parlourId,
          name: name,
          phone: phone,
          email: email,
          birthday: birthday,
          notes: notes,
          createdAt: _at(-sinceDays, 11),
        ),
    ];
  }

  // --------------------------------------------------------------- products

  final _productByName = <String, Product>{};

  /// (name, category, unit, price ₹, cost ₹, final stock, alert at)
  static const _productSpecs = [
    ('Hair Serum', 'Hair care', ProductUnit.pcs, 450, 280, 2, 3),
    ('Face Cream', 'Skin care', ProductUnit.pcs, 350, 210, 3, 5),
    ('Shampoo', 'Hair care', ProductUnit.pcs, 250, 150, 15, 5),
    ('Conditioner', 'Hair care', ProductUnit.pcs, 280, 170, 8, 5),
    ('Hair Colour', 'Hair care', ProductUnit.pcs, 500, 320, 0, 2),
    ('Wax Strips', 'Waxing', ProductUnit.pcs, 15, 8, 40, 10),
    ('Nail Polish', 'Nails', ProductUnit.pcs, 180, 90, 12, 3),
    ('Face Wash', 'Skin care', ProductUnit.pcs, 220, 130, 6, 3),
  ];

  List<Product> _products() => [
    for (final (name, category, unit, price, cost, stock, alert)
        in _productSpecs)
      _productByName[name] = Product(
        id: newId(),
        parlourId: _parlourId,
        name: name,
        category: category,
        unit: unit,
        sellingPricePaise: price * 100,
        costPricePaise: cost * 100,
        stockQty: stock,
        lowStockAt: alert,
      ),
  ];

  /// One purchase 31 days ago per product, sized so that after the sales
  /// on seeded bills the stock ends at the spec's figures.
  void _openingStock(StoreData store) {
    for (final product in store.products) {
      final sold = store.stockMovements
          .where((m) => m.productId == product.id)
          .fold(0, (sum, m) => sum - m.qtyChange);
      final opening = product.stockQty + sold;
      if (opening <= 0) continue;
      store.stockMovements.insert(
        0,
        StockMovement(
          id: newId(),
          parlourId: _parlourId,
          productId: product.id,
          qtyChange: opening,
          reason: StockReason.purchase,
          note: 'Opening stock',
          createdAt: _at(-31, 10),
        ),
      );
    }
  }

  // --------------------------------------------------------------- expenses

  List<Expense> _expenses() {
    Expense e(
      int dayOffset,
      String category,
      int rupees,
      PaymentMethod method,
      String? note,
    ) => Expense(
      id: newId(),
      parlourId: _parlourId,
      category: category,
      amountPaise: rupees * 100,
      spentOn: _day(dayOffset),
      method: method,
      note: note,
    );
    return [
      e(-25, 'Rent', 15000, PaymentMethod.upi, 'Shop rent'),
      e(-24, 'Salary', 12000, PaymentMethod.upi, 'Anita'),
      e(-24, 'Salary', 9000, PaymentMethod.upi, 'Riya'),
      e(-24, 'Salary', 9000, PaymentMethod.cash, 'Meena'),
      e(-18, 'Electricity', 2400, PaymentMethod.upi, 'MSEB bill'),
      e(-20, 'Products', 4500, PaymentMethod.cash, 'Monthly product purchase'),
      e(-2, 'Tea/Snacks', 180, PaymentMethod.cash, null),
      e(-6, 'Tea/Snacks', 150, PaymentMethod.cash, null),
      e(-10, 'Tea/Snacks', 220, PaymentMethod.cash, null),
      e(-14, 'Tea/Snacks', 120, PaymentMethod.cash, null),
      e(-20, 'Tea/Snacks', 260, PaymentMethod.cash, null),
      e(-27, 'Tea/Snacks', 200, PaymentMethod.cash, null),
    ];
  }

  // ------------------------------------------------- appointments and bills

  /// Service combos used for past visits, with the stylist who does them.
  static const _combos = [
    (['Haircut'], 'Riya'),
    (['Haircut', 'Hair Spa'], 'Anita'),
    (['Facial', 'Threading'], 'Meena'),
    (['Manicure', 'Pedicure'], 'Meena'),
    (['Smoothening'], 'Anita'),
    (['Hair Colour'], 'Riya'),
    (['Threading'], 'Meena'),
    (['Waxing (full arms)', 'Threading'], 'Riya'),
    (['Cleanup', 'Threading'], 'Meena'),
    (['Hair Spa'], 'Riya'),
    (['Facial'], 'Anita'),
    (['Pedicure'], 'Meena'),
  ];

  /// Start times for past days; 90 min apart so one stylist never clashes.
  static const _pastSlots = [(10, 30), (12, 0), (13, 30), (15, 0), (16, 30)];

  void _appointmentsAndBills(StoreData store) {
    final customerNames = _customerByName.keys.toList();
    var visit = 0;

    // Past 30 days: 40 completed (billed), 2 cancelled, 1 no-show.
    final completedPast = <Appointment>[];
    final perDayPattern = [2, 1, 2, 2, 1];
    var dayOffset = -1;
    var patternIndex = 0;
    while (completedPast.length < 40 && dayOffset >= -30) {
      final day = _day(dayOffset);
      if (day.weekday != DateTime.sunday) {
        final count = perDayPattern[patternIndex++ % perDayPattern.length];
        for (var k = 0; k < count && completedPast.length < 40; k++) {
          final (services, stylist) = _combos[visit % _combos.length];
          final (h, m) = _pastSlots[k];
          final customer =
              customerNames[(visit * 5 + 3) % customerNames.length];
          completedPast.add(
            _appointment(
              customer: customer,
              stylist: stylist,
              start: _at(dayOffset, h, m),
              services: services,
              status: AppointmentStatus.completed,
            ),
          );
          visit++;
        }
      }
      dayOffset--;
    }
    store.appointments.addAll(completedPast);

    store.appointments.addAll([
      _appointment(
        customer: 'Kavya Nair',
        stylist: 'Anita',
        start: _at(-3, 17, 30),
        services: ['Facial'],
        status: AppointmentStatus.cancelled,
        cancelReason: 'Customer was unwell',
      ),
      _appointment(
        customer: 'Sakshi Gupta',
        stylist: 'Riya',
        start: _at(-9, 18),
        services: ['Haircut'],
        status: AppointmentStatus.cancelled,
        cancelReason: 'Rescheduled by customer',
      ),
      _appointment(
        customer: 'Rashmi Pawar',
        stylist: 'Meena',
        start: _at(-5, 18),
        services: ['Manicure'],
        status: AppointmentStatus.noShow,
      ),
    ]);

    // Today: 2 completed and billed, 1 checked in, 3 booked.
    final todayDone = [
      _appointment(
        customer: 'Priya Sharma',
        stylist: 'Anita',
        start: _at(0, 10),
        services: ['Haircut', 'Smoothening'],
        status: AppointmentStatus.completed,
        notes: 'Prefers less heat in smoothening.',
      ),
      _appointment(
        customer: 'Neha Verma',
        stylist: 'Meena',
        start: _at(0, 10, 30),
        services: ['Facial', 'Threading'],
        status: AppointmentStatus.completed,
      ),
    ];
    store.appointments.addAll(todayDone);
    store.appointments.addAll([
      _appointment(
        customer: 'Sneha Patil',
        stylist: 'Meena',
        start: _at(0, 12, 30),
        services: ['Manicure', 'Pedicure'],
        status: AppointmentStatus.checkedIn,
      ),
      _appointment(
        walkIn: 'Kiran',
        stylist: 'Riya',
        start: _at(0, 14),
        services: ['Threading'],
        status: AppointmentStatus.booked,
      ),
      _appointment(
        customer: 'Ritika Kapoor',
        stylist: 'Anita',
        start: _at(0, 15, 30),
        services: ['Hair Colour'],
        status: AppointmentStatus.booked,
      ),
      _appointment(
        customer: 'Anjali Singh',
        stylist: 'Riya',
        start: _at(0, 17, 30),
        services: ['Hair Spa'],
        status: AppointmentStatus.booked,
      ),
    ]);

    // Next 7 days: 8 booked, on open days only.
    final future = <(String, String, List<String>, int, int)>[
      ('Divya Iyer', 'Anita', ['Facial'], 11, 0),
      ('Tanvi Bhosale', 'Riya', ['Haircut'], 16, 0),
      ('Shruti Deshpande', 'Meena', ['Cleanup', 'Threading'], 12, 0),
      ('Meghna Joshi', 'Anita', ['Smoothening'], 11, 30),
      ('Aishwarya Kulkarni', 'Meena', ['Manicure', 'Pedicure'], 15, 0),
      ('Pooja Mehta', 'Riya', ['Hair Colour'], 14, 0),
      ('Priya Sharma', 'Anita', ['Hair Spa'], 17, 0),
      ('Kavya Nair', 'Meena', ['Facial'], 12, 30),
    ];
    final futureDays = <int>[];
    for (var d = 1; futureDays.length < 6 && d <= 7; d++) {
      if (_day(d).weekday != DateTime.sunday) futureDays.add(d);
    }
    const perFutureDay = [2, 1, 2, 1, 1, 1];
    var f = 0;
    for (var i = 0; i < futureDays.length && f < future.length; i++) {
      for (var k = 0; k < perFutureDay[i] && f < future.length; k++, f++) {
        final (customer, stylist, services, h, m) = future[f];
        store.appointments.add(
          _appointment(
            customer: customer,
            stylist: stylist,
            start: _at(futureDays[i], h, m),
            services: services,
            status: AppointmentStatus.booked,
          ),
        );
      }
    }

    // Bills, oldest first so invoice numbers follow time order.
    final billed = [...completedPast.reversed, ...todayDone];
    final productsOnBill = <int, (String, int)>{
      3: ('Hair Serum', 1),
      11: ('Face Wash', 1),
      20: ('Hair Serum', 1),
      27: ('Shampoo', 1),
    };
    final invoices = <Invoice>[];
    for (var i = 0; i < billed.length; i++) {
      final discount = i % 6 == 5
          ? const BillDiscount.percent(1000)
          : const BillDiscount.none();
      invoices.add(_bill(store, billed[i], i, discount, productsOnBill[i]));
    }

    // Three recent past bills left partly paid: balances ₹1,000 + ₹700 +
    // ₹450 = ₹2,150 pending. Today's two bills are fully paid.
    final targets = [100000, 70000, 45000];
    final partial = <String, int>{};
    for (final invoice in invoices.sublist(0, invoices.length - 2).reversed) {
      if (partial.length == targets.length) break;
      final target = targets[partial.length];
      if (invoice.totalPaise >= target + 30000) partial[invoice.id] = target;
    }

    for (var i = 0; i < invoices.length; i++) {
      final invoice = invoices[i];
      final balance = partial[invoice.id] ?? 0;
      final amount = invoice.totalPaise - balance;
      final appointment = billed[i];
      store.payments.add(
        Payment(
          id: newId(),
          parlourId: _parlourId,
          invoiceId: invoice.id,
          amountPaise: amount,
          method: _methodFor(i),
          reference: _methodFor(i) == PaymentMethod.upi
              ? 'UPI${(482193 + i * 7919) % 1000000}'
              : null,
          receivedAt: appointment.endsAt,
        ),
      );
      store.invoices.add(
        invoice.copyWith(
          paidPaise: amount,
          balancePaise: balance,
          status: InvoiceRules.statusFor(
            totalPaise: invoice.totalPaise,
            paidPaise: amount,
          ),
        ),
      );
    }

    // Last visit per customer.
    for (var i = 0; i < store.customers.length; i++) {
      final c = store.customers[i];
      final visits =
          billed
              .where((a) => a.customerId == c.id)
              .map((a) => a.startsAt)
              .toList()
            ..sort();
      if (visits.isNotEmpty) {
        store.customers[i] = c.copyWith(lastVisitAt: visits.last);
      }
    }
  }

  /// About 60% UPI, 30% cash, 10% card.
  static PaymentMethod _methodFor(int i) => switch (i % 10) {
    0 || 1 || 3 || 4 || 6 || 8 => PaymentMethod.upi,
    2 || 5 || 7 => PaymentMethod.cash,
    _ => PaymentMethod.card,
  };

  Appointment _appointment({
    String? customer,
    String? walkIn,
    required String stylist,
    required DateTime start,
    required List<String> services,
    required AppointmentStatus status,
    String? notes,
    String? cancelReason,
  }) {
    final snapshot = [
      for (final name in services)
        AppointmentService(
          serviceId: _serviceByName[name]!.id,
          name: name,
          pricePaise: _serviceByName[name]!.pricePaise,
          durationMin: _serviceByName[name]!.durationMin,
        ),
    ];
    final minutes = snapshot.fold(0, (sum, s) => sum + s.durationMin);
    return Appointment(
      id: newId(),
      parlourId: _parlourId,
      customerId: customer == null ? null : _customerByName[customer]!.id,
      walkInName: walkIn,
      staffId: _staffByName[stylist]!.id,
      startsAt: start,
      endsAt: start.add(Duration(minutes: minutes)),
      status: status,
      notes:
          notes ?? (customer == null ? null : _customerByName[customer]!.notes),
      cancelReason: cancelReason,
      services: snapshot,
    );
  }

  Invoice _bill(
    StoreData store,
    Appointment appointment,
    int index,
    BillDiscount discount,
    (String, int)? product,
  ) {
    final lines = [
      for (final s in appointment.services)
        BillLine(
          type: InvoiceItemType.service,
          refId: s.serviceId,
          name: s.name,
          unitPricePaise: s.pricePaise,
          qty: 1,
          taxRateBp: 1800,
          staffId: appointment.staffId,
        ),
      if (product != null)
        BillLine(
          type: InvoiceItemType.product,
          refId: _productByName[product.$1]!.id,
          name: product.$1,
          unitPricePaise: _productByName[product.$1]!.sellingPricePaise!,
          qty: product.$2,
          taxRateBp: 1800,
        ),
    ];
    final id = newId();
    final at = appointment.endsAt;
    final draft = BillBuilder.buildDraft(
      draft: BillDraft(
        id: id,
        customerId: appointment.customerId,
        walkInName: appointment.walkInName,
        appointmentId: appointment.id,
        lines: lines,
        discount: discount,
      ),
      parlour: store.parlour,
      createdAt: at,
      newId: newId,
    );

    if (product != null) {
      store.stockMovements.add(
        StockMovement(
          id: newId(),
          parlourId: _parlourId,
          productId: _productByName[product.$1]!.id,
          qtyChange: -product.$2,
          reason: StockReason.sale,
          invoiceId: id,
          createdAt: at,
        ),
      );
    }

    final fy = InvoiceRules.financialYear(at);
    final serial = (store.invoiceSerials[fy] ?? 0) + 1;
    store.invoiceSerials[fy] = serial;
    return draft.copyWith(
      invoiceNo: InvoiceRules.invoiceNumber(
        prefix: store.parlour.invoicePrefix,
        date: at,
        serial: serial,
      ),
      status: InvoiceStatus.finalised,
      finalisedAt: at,
    );
  }
}
