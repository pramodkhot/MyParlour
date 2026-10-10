import 'json.dart';

/// A service on the parlour's menu, e.g. "Haircut ₹500 / 30 min".
class ServiceItem {
  const ServiceItem({
    required this.id,
    required this.parlourId,
    required this.name,
    required this.category,
    required this.pricePaise,
    required this.durationMin,
    required this.taxRateBp,
    this.description,
    this.isActive = true,
  });

  factory ServiceItem.fromJson(Json json) => ServiceItem(
    id: json['id']! as String,
    parlourId: json['parlourId']! as String,
    name: json['name']! as String,
    category: json['category']! as String,
    pricePaise: json['pricePaise']! as int,
    durationMin: json['durationMin']! as int,
    taxRateBp: json['taxRateBp']! as int,
    description: json['description'] as String?,
    isActive: json['isActive'] as bool? ?? true,
  );

  final String id;
  final String parlourId;
  final String name;
  final String category;
  final int pricePaise;
  final int durationMin;
  final int taxRateBp;
  final String? description;
  final bool isActive;

  ServiceItem copyWith({String? parlourId, bool? isActive}) => ServiceItem(
    id: id,
    parlourId: parlourId ?? this.parlourId,
    name: name,
    category: category,
    pricePaise: pricePaise,
    durationMin: durationMin,
    taxRateBp: taxRateBp,
    description: description,
    isActive: isActive ?? this.isActive,
  );

  Json toJson() => compact({
    'id': id,
    'parlourId': parlourId,
    'name': name,
    'category': category,
    'pricePaise': pricePaise,
    'durationMin': durationMin,
    'taxRateBp': taxRateBp,
    'description': description,
    'isActive': isActive,
  });
}
