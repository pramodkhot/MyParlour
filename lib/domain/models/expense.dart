import 'json.dart';
import 'payment.dart';

class Expense {
  const Expense({
    required this.id,
    required this.parlourId,
    required this.category,
    required this.amountPaise,
    required this.spentOn,
    this.method,
    this.note,
  });

  factory Expense.fromJson(Json json) => Expense(
    id: json['id']! as String,
    parlourId: json['parlourId']! as String,
    category: json['category']! as String,
    amountPaise: json['amountPaise']! as int,
    spentOn: dateFromJson(json['spentOn']),
    method: optionalEnum(PaymentMethod.values, json['method']),
    note: json['note'] as String?,
  );

  final String id;
  final String parlourId;
  final String category;
  final int amountPaise;

  /// Calendar date (local midnight).
  final DateTime spentOn;
  final PaymentMethod? method;
  final String? note;

  Expense copyWith({String? parlourId}) => Expense(
    id: id,
    parlourId: parlourId ?? this.parlourId,
    category: category,
    amountPaise: amountPaise,
    spentOn: spentOn,
    method: method,
    note: note,
  );

  Json toJson() => compact({
    'id': id,
    'parlourId': parlourId,
    'category': category,
    'amountPaise': amountPaise,
    'spentOn': dateToJson(spentOn),
    'method': method?.name,
    'note': note,
  });
}
