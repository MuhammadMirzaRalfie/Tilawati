import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Notifikasi lokal: pengingat latihan harian pukul 18:00.
class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const int _dailyReminderId = 100;
  static const int _reminderHour = 18;

  static Future<void> init() async {
    tzdata.initializeTimeZones();
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _plugin.initialize(settings);
  }

  /// Minta izin notifikasi (Android 13+). Di versi lebih lama otomatis true.
  static Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? true;
    }
    return true;
  }

  /// Jadwalkan pengingat harian pukul 18:00 waktu lokal device.
  /// Pakai inexact alarm agar tidak butuh permission SCHEDULE_EXACT_ALARM.
  static Future<void> scheduleDailyReminder() async {
    // Anchor ke UTC dari jam lokal device — valid karena Indonesia tanpa DST,
    // sehingga tidak perlu package tambahan untuk resolve nama timezone.
    final now = DateTime.now();
    var next = DateTime(now.year, now.month, now.day, _reminderHour);
    if (!next.isAfter(now)) next = next.add(const Duration(days: 1));
    final scheduled = tz.TZDateTime.from(next.toUtc(), tz.UTC);

    await _plugin.zonedSchedule(
      _dailyReminderId,
      'Waktunya Latihan Tilawati 📖',
      'Yuk lanjutkan latihan bacaan Al-Qur\'an hari ini!',
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder',
          'Pengingat Harian',
          channelDescription: 'Pengingat latihan harian Tilawati',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> cancelReminder() async {
    await _plugin.cancel(_dailyReminderId);
  }
}
