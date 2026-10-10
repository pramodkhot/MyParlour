import 'json.dart';

enum InvoiceStatus {
  draft,
  finalised,
  partiallyPaid,
  paid,
  void_;

  /// Stored as "void" (a reserved word in Dart, hence `void_`).
  String toJson() => this == void_ ? 'void' : name;

  static InvoiceStatus fromJson(String value) =>
      value == 'void' ? void_ : InvoiceStatus.values.byName(value);
}

enum InvoiceItemType { service, product }

/// How the bill-level discount was entered.
enum DiscountType { none, amount, percent }

/// One line on a bill. Money in paise, tax rate in basis points.
class InvoiceItem {
  const InvoiceItem({
    required this.id,
    required this.type,
    required this.refId,
    required this.name,
    required this.unitPricePaise,
    required this.qty,
    this.itemDiscountPaise = 0,
    this.allocatedDiscountPaise = 0,
    required this.taxRateBp,
    this.taxPaise = 0,
    this.lineTotalPaise = 0,
    this.staffId,
  });

  factory InvoiceItem.fromJson(Json json) => InvoiceItem(
    id: json['id']! as String,
    type: enumFromJson(InvoiceItemType.values, json['type']),
    refId: json['refId']! as String,
    name: json['name']! as String,
    unitPricePaise: json['unitPricePaise']! as int,
    qty: json['qty']! as int,
    itemDiscountPaise: json['itemDiscountPaise'] as int? ?? 0,
    allocatedDiscountPaise: json['allocatedDiscountPaise'] as int? ?? 0,
    taxRateBp: json['taxRateBp']! as int,
    taxPaise: json['taxPaise'] as int? ?? 0,
    lineTotalPaise: json['lineTotalPaise'] as int? ?? 0,
    staffId: json['staffId'] as String?,
  );

  final String id;
  final InvoiceItemType type;

  /// The service or product id this line was made from.
  final String refId;
  final String name;
  final int unitPricePaise;
  final int qty;
  final int itemDiscountPaise;

  /// This line's share of the bill-level discount (set by the calculator).
  final int allocatedDiscountPaise;
  final int taxRateBp;
  final int taxPaise;

  /// Taxable amount plus tax (set by the calculator).
  final int lineTotalPaise;
  final String? staffId;

  InvoiceItem copyWith({
    int? qty,
    int? itemDiscountPaise,
    int? allocatedDiscountPaise,
    int? taxRateBp,
    int? taxPaise,
    int? lineTotalPaise,
    String? staffId,
  }) => InvoiceItem(
    id: id,
    type: type,
    refId: refId,
    name: name,
    unitPricePaise: unitPricePaise,
    qty: qty ?? this.qty,
    itemDiscountPaise: itemDiscountPaise ?? this.itemDiscountPaise,
    allocatedDiscountPaise:
        allocatedDiscountPaise ?? this.allocatedDiscountPaise,
    taxRateBp: taxRateBp ?? this.taxRateBp,
    taxPaise: taxPaise ?? this.taxPaise,
    lineTotalPaise: lineTotalPaise ?? this.lineTotalPaise,
    staffId: staffId ?? this.staffId,
  );

  Json toJson() => compact({
    'id': id,
    'type': type.name,
    'refId': refId,
    'name': name,
    'unitPricePaise': unitPricePaise,
    'qty': qty,
    'itemDiscountPaise': itemDiscountPaise,
    'allocatedDiscountPaise': allocatedDiscountPaise,
    'taxRateBp': taxRateBp,
    'taxPaise': taxPaise,
    'lineTotalPaise': lineTotalPaise,
    'staffId': staffId,
  });
}

class Invoice {
  const Invoice({
    required this.id,
    required this.parlourId,
    this.invoiceNo,
    this.customerId,
    this.walkInName,
    this.appointmentId,
    required this.status,
    required this.items,
    this.discountType = DiscountType.none,
    this.discountValue = 0,
    required this.subtotalPaise,
    required this.discountPaise,
    required this.taxablePaise,
    required this.taxPaise,
    required this.totalPaise,
    required this.paidPaise,
    required this.balancePaise,
    this.taxEnabled = false,
    this.pricesIncludeTax = false,
    required this.createdAt,
    this.finalisedAt,
    this.voidedAt,
  });

  factory Invoice.fromJson(Json json) => Invoice(
    id: json['id']! as String,
    parlourId: json['parlourId']! as String,
    invoiceNo: json['invoiceNo'] as String?,
    customerId: json['customerId'] as String?,
    walkInName: json['walkInName'] as String?,
    appointmentId: json['appointmentId'] as String?,
    status: InvoiceStatus.fromJson(json['status']! as String),
    items: jsonList(json['items']).map(InvoiceItem.fromJson).toList(),
    discountType:
        optionalEnum(DiscountType.values, json['discountType']) ??
        DiscountType.none,
    discountValue: json['discountValue'] as int? ?? 0,
    subtotalPaise: json['subtotal']! as int,
    discountPaise: json['discount']! as int,
    taxablePaise: json['taxable']! as int,
    taxPaise: json['tax']! as int,
    totalPaise: json['total']! as int,
    paidPaise: json['paid']! as int,
    balancePaise: json['balance']! as int,
    taxEnabled: json['taxEnabled'] as bool? ?? false,
    pricesIncludeTax: json['pricesIncludeTax'] as bool? ?? false,
    createdAt: instantFromJson(json['createdAt']),
    finalisedAt: optionalInstant(json['finalisedAt']),
    voidedAt: optionalInstant(json['voidedAt']),
  );

  final String id;
  final String parlourId;

  /// Assigned when the bill is finalised; null for drafts.
  final String? invoiceNo;
  final String? customerId;
  final String? walkInName;
  final String? appointmentId;
  final InvoiceStatus status;
  final List<InvoiceItem> items;
  final DiscountType discountType;

  /// Paise for [DiscountType.amount], basis points for [DiscountType.percent].
  final int discountValue;
  final int subtotalPaise;
  final int discountPaise;
  final int taxablePaise;
  final int taxPaise;
  final int totalPaise;
  final int paidPaise;
  final int balancePaise;

  /// Tax settings captured when the bill was calculated.
  final bool taxEnabled;
  final bool pricesIncludeTax;
  final DateTime createdAt;
  final DateTime? finalisedAt;
  final DateTime? voidedAt;

  bool get isDraft => status == InvoiceStatus.draft;
  bool get isVoid => status == InvoiceStatus.void_;

  /// Finalised, not void, with money still due.
  bool get isOpen =>
      (status == InvoiceStatus.finalised ||
          status == InvoiceStatus.partiallyPaid) &&
      balancePaise > 0;

  Invoice copyWith({
    String? parlourId,
    String? invoiceNo,
    InvoiceStatus? status,
    int? paidPaise,
    int? balancePaise,
    DateTime? finalisedAt,
    DateTime? voidedAt,
  }) => Invoice(
    id: id,
    parlourId: parlourId ?? this.parlourId,
    invoiceNo: invoiceNo ?? this.invoiceNo,
    customerId: customerId,
    walkInName: walkInName,
    appointmentId: appointmentId,
    status: status ?? this.status,
    items: items,
    discountType: discountType,
    discountValue: discountValue,
    subtotalPaise: subtotalPaise,
    discountPaise: discountPaise,
    taxablePaise: taxablePaise,
    taxPaise: taxPaise,
    totalPaise: totalPaise,
    paidPaise: paidPaise ?? this.paidPaise,
    balancePaise: balancePaise ?? this.balancePaise,
    taxEnabled: taxEnabled,
    pricesIncludeTax: pricesIncludeTax,
    createdAt: createdAt,
    finalisedAt: finalisedAt ?? this.finalisedAt,
    voidedAt: voidedAt ?? this.voidedAt,
  );

  Json toJson() => compact({
    'id': id,
    'parlourId': parlourId,
    'invoiceNo': invoiceNo,
    'customerId': customerId,
    'walkInName': walkInName,
    'appointmentId': appointmentId,
    'status': status.toJson(),
    'items': items.map((i) => i.toJson()).toList(),
    'discountType': discountType.name,
    'discountValue': discountValue,
    'subtotal': subtotalPaise,
    'discount': discountPaise,
    'taxable': taxablePaise,
    'tax': taxPaise,
    'total': totalPaise,
    'paid': paidPaise,
    'balance': balancePaise,
    'taxEnabled': taxEnabled,
    'pricesIncludeTax': pricesIncludeTax,
    'createdAt': instantToJson(createdAt),
    'finalisedAt': finalisedAt == null ? null : instantToJson(finalisedAt!),
    'voidedAt': voidedAt == null ? null : instantToJson(voidedAt!),
  });
}
