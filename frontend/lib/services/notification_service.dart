import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(initSettings);
  }

  static Future<void> showRainAlert(String message) async {
    const androidDetails = AndroidNotificationDetails(
      'rain_alert_channel',
      'Rain Alerts',
      channelDescription: 'Notifications for rain alerts',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const details = NotificationDetails(android: androidDetails);
    await _plugin.show(1, '🌧️ Rain Alert', message, details);
  }

  static Future<void> showHeatwaveAlert(String message) async {
    const androidDetails = AndroidNotificationDetails(
      'heatwave_channel',
      'Heatwave Alerts',
      channelDescription: 'Notifications for extreme heat',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const details = NotificationDetails(android: androidDetails);
    await _plugin.show(2, '🔥 Heatwave Warning', message, details);
  }

  static Future<void> showHydrationReminder() async {
    const androidDetails = AndroidNotificationDetails(
      'hydration_channel',
      'Hydration Reminders',
      channelDescription: 'Remind to drink water',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: '@mipmap/ic_launcher',
    );
    const details = NotificationDetails(android: androidDetails);
    await _plugin.show(3, '💧 Hydration Reminder',
        'Time to drink some water! Stay hydrated.', details);
  }
}