import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_noti/models/alarm_model.dart';
import 'package:flutter_noti/services/notification_service.dart';
import 'package:flutter_noti/services/database_service.dart';

class HomeController extends GetxController {
  final NotiService notiService;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  final RxList<Alarm> alarms = <Alarm>[].obs;

  HomeController({required this.notiService});

  @override
  void onInit() async {
    super.onInit();

    if (!notiService.isInitialized) {
      notiService.initNotification();
    }

    await loadAlarms();
  }

  Future<void> loadAlarms() async {
    try {
      final loadedAlarms = await _dbHelper.getAlarms();
      alarms.assignAll(loadedAlarms);

      for (var alarm in alarms) {
        if (alarm.isActive.value && alarm.dateTime.isAfter(DateTime.now())) {
          await scheduleAlarmNotification(alarm);
        }
      }
    } catch (e) {
      print('Error loading alarms: $e');
    }
  }

  Future<void> showNotification() async {
    await notiService.showNotification(
      title: 'Test Notification',
      body: 'This is a test notification body',
      payload: 'notification.test',
    );
  }

  Future<void> scheduleNotificationInOneMinute() async {
    final now = DateTime.now();
    final scheduledTime = now.add(const Duration(minutes: 1));

    await notiService.schdulanoti(
      title: 'Scheduled Notification',
      body:
          'This notification was scheduled to appear 1 minute after button press',
      scheduledDateTime: scheduledTime,
    );

    Get.snackbar(
      'Notification Scheduled',
      'Notification scheduled for ${formatTime(scheduledTime)}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> addAlarm(DateTime dateTime) async {
    try {
      final newAlarm = Alarm(
        dateTime: dateTime,
      );

      final id = await _dbHelper.insertAlarm(newAlarm);

      final alarmWithId = Alarm(
        id: id,
        dateTime: dateTime,
      );
      alarms.add(alarmWithId);

      await scheduleAlarmNotification(alarmWithId);

      Get.snackbar(
        'Alarm Added',
        'Alarm set for ${formatTime(dateTime)} on ${formatDate(dateTime)}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error adding alarm: $e');
      Get.snackbar(
        'Error',
        'Failed to add alarm',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> toggleAlarm(Alarm alarm) async {
    try {
      final newState = !alarm.isActive.value;
      alarm.isActive.value = newState;

      if (alarm.id != null) {
        await _dbHelper.updateAlarm(alarm);
      }

      if (newState) {
        await scheduleAlarmNotification(alarm);
        Get.snackbar('Alarm Activated', 'Alarm has been turned on',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        if (alarm.id != null) {
          await notiService.cancelNotification(alarm.id!);
        }
        Get.snackbar('Alarm Deactivated', 'Alarm has been turned off',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print('Error toggling alarm: $e');
    }
  }

  Future<void> scheduleAlarmNotification(Alarm alarm) async {
    if (alarm.id != null) {
      await notiService.schdulanoti(
        id: alarm.id!,
        title: 'Alarm',
        body: 'Your scheduled alarm for ${formatTime(alarm.dateTime)}',
        scheduledDateTime: alarm.dateTime,
      );
    }
  }

  String formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final hourDisplay = hour == 0 ? 12 : hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';

    return '$hourDisplay:$minute $period';
  }

  String formatDate(DateTime dateTime) {
    final dayOfWeek = _getDayOfWeek(dateTime.weekday);

    final monthName = _getMonthName(dateTime.month);

    return '$dayOfWeek ${dateTime.day} $monthName ${dateTime.year}';
  }

  String _getDayOfWeek(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }
}
