import '../../domain/errors.dart';
import '../../domain/models/appointment.dart';
import '../../domain/models/invoice.dart';
import '../../domain/models/payment.dart';
import '../../domain/models/product.dart';
import '../../domain/models/stock_movement.dart';
import '../../domain/services/report_service.dart';
import '../../domain/services/stock_rules.dart';
import '../../l10n/gen/app_localizations.dart';

/// Names of built-in values (statuses, methods, categories…) in the
/// current language. Values the owner typed are shown as typed.
extension Labels on AppLocalizations {
  String appointmentStatus(AppointmentStatus s) => switch (s) {
    AppointmentStatus.booked => statusUpcoming,
    AppointmentStatus.checkedIn => statusCheckedIn,
    AppointmentStatus.completed => statusCompleted,
    AppointmentStatus.cancelled => statusCancelled,
    AppointmentStatus.noShow => statusNoShow,
  };

  String invoiceStatus(InvoiceStatus s) => switch (s) {
    InvoiceStatus.draft => billStatusDraft,
    InvoiceStatus.finalised => billStatusUnpaid,
    InvoiceStatus.partiallyPaid => billStatusPartiallyPaid,
    InvoiceStatus.paid => billStatusPaid,
    InvoiceStatus.void_ => billStatusVoid,
  };

  String paymentMethod(PaymentMethod m) => switch (m) {
    PaymentMethod.cash => payCash,
    PaymentMethod.upi => payUpi,
    PaymentMethod.card => payCard,
    PaymentMethod.other => payOther,
  };

  /// Label of the optional reference field for a payment method.
  String paymentReference(PaymentMethod m) => switch (m) {
    PaymentMethod.upi => payRefUpi,
    PaymentMethod.card => payRefCard,
    _ => payRefOther,
  };

  String stockReason(StockReason r) => switch (r) {
    StockReason.purchase => reasonPurchase,
    StockReason.sale => reasonSale,
    StockReason.usedInService => reasonUsedInService,
    StockReason.damaged => reasonDamaged,
    StockReason.correction => reasonCorrection,
    StockReason.voidReversal => reasonVoidReversal,
  };

  String stockAdjustment(StockAdjustment a) => switch (a) {
    StockAdjustment.stockIn => reasonPurchase,
    StockAdjustment.usedInService => reasonUsedInService,
    StockAdjustment.damaged => reasonDamaged,
    StockAdjustment.countCorrection => reasonCorrection,
  };

  String reportPeriod(ReportPeriod p) => switch (p) {
    ReportPeriod.today => periodToday,
    ReportPeriod.thisWeek => periodThisWeek,
    ReportPeriod.thisMonth => periodThisMonth,
    ReportPeriod.custom => periodCustom,
  };

  String unit(ProductUnit u) => switch (u) {
    ProductUnit.pcs => unitPcs,
    ProductUnit.ml => unitMl,
    ProductUnit.g => unitG,
  };

  /// A stored category, expense type or role. Built-in values are kept as
  /// stable English keys in the data and shown translated; anything else
  /// is the owner's own text.
  String builtIn(String value) => switch (value) {
    'Hair' => catHair,
    'Skin' => catSkin,
    'Nails' => catNails,
    'Waxing' => catWaxing,
    'Rent' => expRent,
    'Salary' => expSalary,
    'Products' => expProducts,
    'Electricity' => expElectricity,
    'Tea/Snacks' => expTeaSnacks,
    'Other' => expOther,
    'Senior Beautician' => roleSeniorBeautician,
    'Beautician' => roleBeautician,
    'Junior' => roleJunior,
    'Receptionist' => roleReceptionist,
    'Hair care' => prodCatHairCare,
    'Skin care' => prodCatSkinCare,
    _ => value,
  };

  /// "30 min", "1 h", "1 h 30".
  String duration(int minutes) {
    if (minutes < 60) return commonMinutes(minutes);
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0
        ? commonHours(h)
        : commonHoursMinutes(h, m.toString().padLeft(2, '0'));
  }

  /// [duration] that never breaks across lines ("1 तास 30" stays together
  /// in narrow time columns).
  String durationOneLine(int minutes) =>
      duration(minutes).replaceAll(' ', _noBreakSpace);

  static final _noBreakSpace = String.fromCharCode(0xA0);

  /// A business-rule problem in this language.
  String error(DomainError e) {
    String arg(String key) => '${e.args[key] ?? ''}';
    String status(String key) => appointmentStatus(
      AppointmentStatus.values.firstWhere(
        (s) => s.name == e.args[key],
        orElse: () => AppointmentStatus.booked,
      ),
    );
    return switch (e.code) {
      ErrorCode.customerNameRequired => errCustomerNameRequired,
      ErrorCode.serviceNameRequired => errServiceNameRequired,
      ErrorCode.priceNegative => errPriceNegative,
      ErrorCode.serviceDurationRequired => errServiceDurationRequired,
      ErrorCode.staffNameRequired => errStaffNameRequired,
      ErrorCode.productNameRequired => errProductNameRequired,
      ErrorCode.lowStockNegative => errLowStockNegative,
      ErrorCode.openingStockNegative => errOpeningStockNegative,
      ErrorCode.expenseAmountZero => errAmountZero,
      ErrorCode.categoryRequired => errCategoryRequired,
      ErrorCode.appointmentNoServices => errAppointmentNoServices,
      ErrorCode.appointmentNoClient => errAppointmentNoClient,
      ErrorCode.appointmentEndBeforeStart => errAppointmentEndBeforeStart,
      ErrorCode.appointmentFinished => errAppointmentFinished,
      ErrorCode.statusChange => errStatusChange(status('from'), status('to')),
      ErrorCode.customerNotFound => errCustomerNotFound,
      ErrorCode.serviceNotFound => errServiceNotFound,
      ErrorCode.staffNotFound => errStaffNotFound,
      ErrorCode.appointmentNotFound => errAppointmentNotFound,
      ErrorCode.billNotFound => errBillNotFound,
      ErrorCode.productNotFound => errProductNotFound,
      ErrorCode.billProductMissing => errBillProductMissing,
      ErrorCode.billNoLines => errBillNoLines,
      ErrorCode.lineQtyInvalid => errLineQtyInvalid(arg('name')),
      ErrorCode.linePriceInvalid => errLinePriceInvalid(arg('name')),
      ErrorCode.discountNegative => errDiscountNegative,
      ErrorCode.discountOverSubtotal => errDiscountOverSubtotal,
      ErrorCode.discountOverHundred => errDiscountOverHundred,
      ErrorCode.billAlreadyFinalised => errBillAlreadyFinalised,
      ErrorCode.appointmentAlreadyBilled =>
        e.args['invoiceNo'] == null
            ? errAppointmentAlreadyBilled
            : errAppointmentAlreadyBilledNo(arg('invoiceNo')),
      ErrorCode.paymentNeedsFinalisedBill => errPaymentNeedsFinalisedBill,
      ErrorCode.billIsVoid => errBillIsVoid,
      ErrorCode.paymentMethodRequired => errPaymentMethodRequired,
      ErrorCode.paymentAmountZero => errAmountZero,
      ErrorCode.paymentOverBalance => errPaymentOverBalance,
      ErrorCode.outOfStock => errOutOfStock(arg('name')),
      ErrorCode.notEnoughStock => errNotEnoughStock(arg('qty'), arg('name')),
      ErrorCode.stockChangeZero => errStockChangeZero,
      ErrorCode.stockSalesViaBills => errStockSalesViaBills,
    };
  }
}
