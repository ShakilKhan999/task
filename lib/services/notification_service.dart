import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotiService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initNotification() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();

    const AndroidInitializationSettings initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initSettingsIos =
        DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true);

    const InitializationSettings initSettings = InitializationSettings(
        android: initSettingsAndroid, iOS: initSettingsIos);

    await notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('Notification clicked: ${response.payload}');
      },
    );

    await _requestPermissions();

    _isInitialized = true;
  }

  Future<void> _requestPermissions() async {
    if (await _isAndroid13OrHigher()) {
      await notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }

    final androidImplementation =
        notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      final hasExactAlarmPermission =
          await androidImplementation.canScheduleExactNotifications() ?? false;
      if (!hasExactAlarmPermission) {
        await androidImplementation.requestExactAlarmsPermission();
      }
    }
  }

  Future<bool> _isAndroid13OrHigher() async {
    try {
      final androidInfo = await notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.getNotificationAppLaunchDetails();
      return androidInfo != null;
    } catch (e) {
      return false;
    }
  }

  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
            'daily_channel_id', 'Daily notification',
            channelDescription: 'Daily notification channel',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ));
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    if (!_isInitialized) {
      print("Warning: Notification service not initialized");
      await initNotification();
    }

    await notificationsPlugin.show(
      id,
      title,
      body,
      _notificationDetails(),
      payload: payload,
    );
  }

  Future<void> schdulanoti({
    int id = 1,
    required String title,
    required String body,
    required DateTime scheduledDateTime,
  }) async {
    if (!_isInitialized) {
      print("Warning: Notification service not initialized");
      await initNotification();
    }

    final scheduledDate = tz.TZDateTime.from(scheduledDateTime, tz.local);

    print('Scheduling notification for: $scheduledDate');

    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelNotification(int id) async {
    await notificationsPlugin.cancel(id);
  }
}
