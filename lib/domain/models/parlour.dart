import 'json.dart';
import 'value_types.dart';

class Parlour {
  const Parlour({
    required this.id,
    required this.name,
    required this.ownerName,
    required this.phone,
    required this.area,
    this.address,
    this.logoPath,
    this.currency = 'INR',
    required this.openDays,
    required this.openTime,
    required this.closeTime,
    required this.slotMinutes,
    required this.invoicePrefix,
    required this.taxEnabled,
    required this.defaultTaxRateBp,
    this.pricesIncludeTax = false,
    this.gstin,
    this.receiptFooter = 'Thank you! Visit again.',
  });

  factory Parlour.fromJson(Json json) => Parlour(
    id: json['id']! as String,
    name: json['name']! as String,
    ownerName: json['ownerName']! as String,
    phone: json['phone']! as String,
    area: json['area']! as String,
    address: json['address'] as String?,
    logoPath: json['logoPath'] as String?,
    currency: json['currency'] as String? ?? 'INR',
    openDays: intList(json['openDays']),
    openTime: ClockTime.parse(json['openTime']! as String),
    closeTime: ClockTime.parse(json['closeTime']! as String),
    slotMinutes: json['slotMinutes']! as int,
    invoicePrefix: json['invoicePrefix']! as String,
    taxEnabled: json['taxEnabled']! as bool,
    defaultTaxRateBp: json['defaultTaxRateBp']! as int,
    pricesIncludeTax: json['pricesIncludeTax'] as bool? ?? false,
    gstin: json['gstin'] as String?,
    receiptFooter:
        json['receiptFooter'] as String? ?? 'Thank you! Visit again.',
  );

  final String id;
  final String name;
  final String ownerName;
  final String phone;
  final String area;
  final String? address;
  final String? logoPath;
  final String currency;

  /// Open weekdays, using [DateTime.weekday] numbers (1 = Monday).
  final List<int> openDays;
  final ClockTime openTime;
  final ClockTime closeTime;
  final int slotMinutes;
  final String invoicePrefix;
  final bool taxEnabled;

  /// GST rate in basis points (1800 = 18%).
  final int defaultTaxRateBp;
  final bool pricesIncludeTax;
  final String? gstin;
  final String receiptFooter;

  bool isOpenOn(DateTime day) => openDays.contains(day.weekday);

  Parlour copyWith({
    String? name,
    String? ownerName,
    String? phone,
    String? area,
    String? address,
    String? logoPath,
    List<int>? openDays,
    ClockTime? openTime,
    ClockTime? closeTime,
    int? slotMinutes,
    String? invoicePrefix,
    bool? taxEnabled,
    int? defaultTaxRateBp,
    bool? pricesIncludeTax,
    String? gstin,
    String? receiptFooter,
  }) => Parlour(
    id: id,
    name: name ?? this.name,
    ownerName: ownerName ?? this.ownerName,
    phone: phone ?? this.phone,
    area: area ?? this.area,
    address: address ?? this.address,
    logoPath: logoPath ?? this.logoPath,
    currency: currency,
    openDays: openDays ?? this.openDays,
    openTime: openTime ?? this.openTime,
    closeTime: closeTime ?? this.closeTime,
    slotMinutes: slotMinutes ?? this.slotMinutes,
    invoicePrefix: invoicePrefix ?? this.invoicePrefix,
    taxEnabled: taxEnabled ?? this.taxEnabled,
    defaultTaxRateBp: defaultTaxRateBp ?? this.defaultTaxRateBp,
    pricesIncludeTax: pricesIncludeTax ?? this.pricesIncludeTax,
    gstin: gstin ?? this.gstin,
    receiptFooter: receiptFooter ?? this.receiptFooter,
  );

  Json toJson() => compact({
    'id': id,
    'name': name,
    'ownerName': ownerName,
    'phone': phone,
    'area': area,
    'address': address,
    'logoPath': logoPath,
    'currency': currency,
    'openDays': openDays,
    'openTime': openTime.toJson(),
    'closeTime': closeTime.toJson(),
    'slotMinutes': slotMinutes,
    'invoicePrefix': invoicePrefix,
    'taxEnabled': taxEnabled,
    'defaultTaxRateBp': defaultTaxRateBp,
    'pricesIncludeTax': pricesIncludeTax,
    'gstin': gstin,
    'receiptFooter': receiptFooter,
  });
}
