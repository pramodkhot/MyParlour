import 'json.dart';
import 'value_types.dart';

class Staff {
  const Staff({
    required this.id,
    required this.parlourId,
    required this.name,
    required this.phone,
    required this.roleTitle,
    required this.serviceIds,
    required this.workingDays,
    required this.startTime,
    required this.endTime,
    this.isActive = true,
  });

  factory Staff.fromJson(Json json) => Staff(
    id: json['id']! as String,
    parlourId: json['parlourId']! as String,
    name: json['name']! as String,
    phone: json['phone']! as String,
    roleTitle: json['roleTitle']! as String,
    serviceIds: stringList(json['serviceIds']),
    workingDays: intList(json['workingDays']),
    startTime: ClockTime.parse(json['startTime']! as String),
    endTime: ClockTime.parse(json['endTime']! as String),
    isActive: json['isActive'] as bool? ?? true,
  );

  final String id;
  final String parlourId;
  final String name;
  final String phone;
  final String roleTitle;
  final List<String> serviceIds;

  /// Weekdays using [DateTime.weekday] numbers (1 = Monday).
  final List<int> workingDays;
  final ClockTime startTime;
  final ClockTime endTime;
  final bool isActive;

  bool doesService(String serviceId) => serviceIds.contains(serviceId);

  Staff copyWith({String? parlourId, bool? isActive}) => Staff(
    id: id,
    parlourId: parlourId ?? this.parlourId,
    name: name,
    phone: phone,
    roleTitle: roleTitle,
    serviceIds: serviceIds,
    workingDays: workingDays,
    startTime: startTime,
    endTime: endTime,
    isActive: isActive ?? this.isActive,
  );

  Json toJson() => {
    'id': id,
    'parlourId': parlourId,
    'name': name,
    'phone': phone,
    'roleTitle': roleTitle,
    'serviceIds': serviceIds,
    'workingDays': workingDays,
    'startTime': startTime.toJson(),
    'endTime': endTime.toJson(),
    'isActive': isActive,
  };
}
