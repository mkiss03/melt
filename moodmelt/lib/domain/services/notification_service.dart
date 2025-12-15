import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../data/models/trigger_event.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
  }

  Future<bool> requestPermissions() async {
    final androidImplementation = _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    final granted =
        await androidImplementation?.requestNotificationsPermission();

    return granted ?? false;
  }

  void _onNotificationTap(NotificationResponse response) {
    // Navigate to practice screen
    // This will be handled via router
  }

  Future<void> sendTriggerNotification(TriggerEvent trigger) async {
    const notificationId = 1;

    final message = _getNotificationMessage(trigger);

    const androidDetails = AndroidNotificationDetails(
      'moodmelt_triggers',
      'Wellness Reminders',
      channelDescription: 'Gentle nudges when tension is detected',
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(''),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      notificationId,
      '🫧 Melt itt van',
      message,
      details,
      payload: 'quick_practice',
    );
  }

  String _getNotificationMessage(TriggerEvent trigger) {
    final messages = [
      'Úgy tűnik, most kicsit feszült a tested. Van 60 másodperced?',
      'Mini reset? 3 kör légzés, aztán mehet tovább.',
      'Most egy kicsit gyors a szív. Szeretnél egy 1 perces gyakorlatot?',
      'Érzem, hogy intenzív most. Box breathing? Segítek.',
    ];

    return messages[DateTime.now().millisecond % messages.length];
  }

  Future<void> sendDailyReminder() async {
    // TODO: Schedule daily check-in reminder
  }
}
