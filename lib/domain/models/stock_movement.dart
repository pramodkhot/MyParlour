import 'json.dart';

enum StockReason {
  purchase,
  sale,
  usedInService,
  damaged,
  correction,
  voidReversal,
}

class StockMovement {
  const StockMovement({
    required this.id,
    required this.parlourId,
    required this.productId,
    required this.qtyChange,
    required this.reason,
    this.invoiceId,
    this.note,
    required this.createdAt,
  });

  factory StockMovement.fromJson(Json json) => StockMovement(
    id: json['id']! as String,
    parlourId: json['parlourId']! as String,
    productId: json['productId']! as String,
    qtyChange: json['qtyChange']! as int,
    reason: enumFromJson(StockReason.values, json['reason']),
    invoiceId: json['invoiceId'] as String?,
    note: json['note'] as String?,
    createdAt: instantFromJson(json['createdAt']),
  );

  final String id;
  final String parlourId;
  final String productId;

  /// Positive adds stock, negative removes it.
  final int qtyChange;
  final StockReason reason;
  final String? invoiceId;
  final String? note;
  final DateTime createdAt;

  Json toJson() => compact({
    'id': id,
    'parlourId': parlourId,
    'productId': productId,
    'qtyChange': qtyChange,
    'reason': reason.name,
    'invoiceId': invoiceId,
    'note': note,
    'createdAt': instantToJson(createdAt),
  });
}
