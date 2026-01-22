import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  /// 🔹 Initialize notifications + timezone + channel
  static Future<void> init() async {
    // Initialize timezone database
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
    InitializationSettings(android: androidSettings);

    await _notifications.initialize(settings);

    // 🔔 Create notification channel (REQUIRED on Android 8+)
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'medicine_channel',
      'Medicine Reminder',
      description: 'Medicine reminder notifications',
      importance: Importance.max,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// 🔹 Schedule medicine reminder notification
  static Future<void> scheduleNotification({
    required int id,
    required String medicineName,
    required DateTime time,
  }) async {
    // Convert DateTime to timezone-aware time
    tz.TZDateTime scheduledDate =
    tz.TZDateTime.from(time, tz.local);

    // 🔴 If selected time already passed, schedule for next day
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notifications.zonedSchedule(
      id,
      'Medicine Reminder',
      'Time to take $medicineName',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'medicine_channel',
          'Medicine Reminder',
          channelDescription: 'Medicine reminder notifications',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'medicine_reminder',
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> showInstantNotification({
    required String medicineName,
  }) async {
    await _notifications.show(
      0,
      'Medicine Reminder',
      'Time to take $medicineName',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'medicine_channel',
          'Medicine Reminder',
          channelDescription: 'Medicine reminder notifications',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          fullScreenIntent: true,
        ),
      ),
    );
  }

}
