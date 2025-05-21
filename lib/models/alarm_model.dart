import 'package:get/get.dart';

class Alarm {
  final int? id;
  final DateTime dateTime;
  RxBool isActive;

  Alarm({
    this.id,
    required this.dateTime,
    bool active = true,
  }) : isActive = active.obs;

  // Convert a Map object to an Alarm (for database operations)
  factory Alarm.fromMap(Map<String, dynamic> map) {
    return Alarm(
      id: map['id'],
      dateTime: DateTime.parse(map['dateTime']),
      active: map['isActive'] == 1,
    );
  }

  // Convert an Alarm to a Map object (for database operations)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
      'isActive': isActive.value ? 1 : 0,
    };
  }
}
