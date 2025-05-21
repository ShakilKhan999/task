import 'package:get/get.dart';

class Alarm {
  final int id;
  final DateTime dateTime;
  RxBool isActive;

  Alarm({
    required this.id,
    required this.dateTime,
    bool active = true,
  }) : isActive = active.obs;
}
