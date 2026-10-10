import 'json.dart';

enum PaymentMethod { cash, upi, card, other }

class Payment {
  const Payment({
    required this.id,
    required this.parlourId,
    required this.invoiceId,
    required this.amountPaise,
    required this.method,
    this.reference,
    this.note,
    required this.receivedAt,
    this.isVoid = false,
  });

  factory Payment.fromJson(Json json) => Payment(
    id: json['id']! as String,
    parlourId: json['parlourId']! as String,
    invoiceId: json['invoiceId']! as String,
    amountPaise: json['amountPaise']! as int,
    method: enumFromJson(PaymentMethod.values, json['method']),
    reference: json['reference'] as String?,
    note: json['note'] as String?,
    receivedAt: instantFromJson(json['receivedAt']),
    isVoid: json['isVoid'] as bool? ?? false,
  );

  final String id;
  final String parlourId;
  final String invoiceId;
  final int amountPaise;
  final PaymentMethod method;

  /// UPI reference or last 4 card digits. Recorded, never verified.
  final String? reference;
  final String? note;
  final DateTime receivedAt;
  final bool isVoid;

  Payment copyWith({String? parlourId, bool? isVoid}) => Payment(
    id: id,
    parlourId: parlourId ?? this.parlourId,
    invoiceId: invoiceId,
    amountPaise: amountPaise,
    method: method,
    reference: reference,
    note: note,
    receivedAt: receivedAt,
    isVoid: isVoid ?? this.isVoid,
  );

  Json toJson() => compact({
    'id': id,
    'parlourId': parlourId,
    'invoiceId': invoiceId,
    'amountPaise': amountPaise,
    'method': method.name,
    'reference': reference,
    'note': note,
    'receivedAt': instantToJson(receivedAt),
    'isVoid': isVoid,
  });
}
