import 'json.dart';

enum AppointmentStatus { booked, checkedIn, completed, cancelled, noShow }

/// Snapshot of a service at booking time, so later price changes do not
/// alter past appointments.
class AppointmentService {
  const AppointmentService({
    required this.serviceId,
    required this.name,
    required this.pricePaise,
    required this.durationMin,
  });

  factory AppointmentService.fromJson(Json json) => AppointmentService(
    serviceId: json['serviceId']! as String,
    name: json['name']! as String,
    pricePaise: json['pricePaise']! as int,
    durationMin: json['durationMin']! as int,
  );

  final String serviceId;
  final String name;
  final int pricePaise;
  final int durationMin;

  Json toJson() => {
    'serviceId': serviceId,
    'name': name,
    'pricePaise': pricePaise,
    'durationMin': durationMin,
  };
}

class Appointment {
  const Appointment({
    required this.id,
    required this.parlourId,
    this.customerId,
    this.walkInName,
    this.walkInPhone,
    required this.staffId,
    required this.startsAt,
    required this.endsAt,
    required this.status,
    this.notes,
    this.cancelReason,
    required this.services,
  });

  factory Appointment.fromJson(Json json) => Appointment(
    id: json['id']! as String,
    parlourId: json['parlourId']! as String,
    customerId: json['customerId'] as String?,
    walkInName: json['walkInName'] as String?,
    walkInPhone: json['walkInPhone'] as String?,
    staffId: json['staffId']! as String,
    startsAt: instantFromJson(json['startsAt']),
    endsAt: instantFromJson(json['endsAt']),
    status: enumFromJson(AppointmentStatus.values, json['status']),
    notes: json['notes'] as String?,
    cancelReason: json['cancelReason'] as String?,
    services: jsonList(
      json['services'],
    ).map(AppointmentService.fromJson).toList(),
  );

  final String id;
  final String parlourId;

  /// Null for walk-ins, who have [walkInName] instead.
  final String? customerId;
  final String? walkInName;
  final String? walkInPhone;
  final String staffId;
  final DateTime startsAt;
  final DateTime endsAt;
  final AppointmentStatus status;
  final String? notes;
  final String? cancelReason;
  final List<AppointmentService> services;

  bool get isWalkIn => customerId == null;

  int get totalPricePaise =>
      services.fold(0, (sum, service) => sum + service.pricePaise);

  int get totalDurationMin =>
      services.fold(0, (sum, service) => sum + service.durationMin);

  Appointment copyWith({
    String? parlourId,
    String? staffId,
    DateTime? startsAt,
    DateTime? endsAt,
    AppointmentStatus? status,
    String? notes,
    String? cancelReason,
    List<AppointmentService>? services,
  }) => Appointment(
    id: id,
    parlourId: parlourId ?? this.parlourId,
    customerId: customerId,
    walkInName: walkInName,
    walkInPhone: walkInPhone,
    staffId: staffId ?? this.staffId,
    startsAt: startsAt ?? this.startsAt,
    endsAt: endsAt ?? this.endsAt,
    status: status ?? this.status,
    notes: notes ?? this.notes,
    cancelReason: cancelReason ?? this.cancelReason,
    services: services ?? this.services,
  );

  Json toJson() => compact({
    'id': id,
    'parlourId': parlourId,
    'customerId': customerId,
    'walkInName': walkInName,
    'walkInPhone': walkInPhone,
    'staffId': staffId,
    'startsAt': instantToJson(startsAt),
    'endsAt': instantToJson(endsAt),
    'status': status.name,
    'notes': notes,
    'cancelReason': cancelReason,
    'services': services.map((s) => s.toJson()).toList(),
  });
}
