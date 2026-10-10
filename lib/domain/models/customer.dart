import 'json.dart';
import 'value_types.dart';

class Customer {
  const Customer({
    required this.id,
    required this.parlourId,
    required this.name,
    required this.phone,
    this.email,
    this.birthday,
    this.anniversary,
    this.notes,
    this.isActive = true,
    required this.createdAt,
    this.lastVisitAt,
  });

  factory Customer.fromJson(Json json) => Customer(
    id: json['id']! as String,
    parlourId: json['parlourId']! as String,
    name: json['name']! as String,
    phone: json['phone']! as String,
    email: json['email'] as String?,
    birthday: json['birthday'] == null
        ? null
        : DayMonth.fromJson(json['birthday']),
    anniversary: json['anniversary'] == null
        ? null
        : DayMonth.fromJson(json['anniversary']),
    notes: json['notes'] as String?,
    isActive: json['isActive'] as bool? ?? true,
    createdAt: instantFromJson(json['createdAt']),
    lastVisitAt: optionalInstant(json['lastVisitAt']),
  );

  final String id;
  final String parlourId;
  final String name;

  /// Stored as the user typed it; see `PhoneNumber.normalise` for matching.
  final String phone;
  final String? email;
  final DayMonth? birthday;
  final DayMonth? anniversary;
  final String? notes;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastVisitAt;

  Customer copyWith({
    String? parlourId,
    String? name,
    String? phone,
    String? notes,
    bool? isActive,
    DateTime? lastVisitAt,
  }) => Customer(
    id: id,
    parlourId: parlourId ?? this.parlourId,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    email: email,
    birthday: birthday,
    anniversary: anniversary,
    notes: notes ?? this.notes,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt,
    lastVisitAt: lastVisitAt ?? this.lastVisitAt,
  );

  Json toJson() => compact({
    'id': id,
    'parlourId': parlourId,
    'name': name,
    'phone': phone,
    'email': email,
    'birthday': birthday?.toJson(),
    'anniversary': anniversary?.toJson(),
    'notes': notes,
    'isActive': isActive,
    'createdAt': instantToJson(createdAt),
    'lastVisitAt': lastVisitAt == null ? null : instantToJson(lastVisitAt!),
  });
}
