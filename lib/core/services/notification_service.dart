import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminders_app/features/reminders/presentation/providers/providers.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static final _notificationTapController = StreamController<String>.broadcast();
  static Stream<String> get notificationTapStream => _notificationTapController.stream;

  String? _initialPayload;
  String? get initialPayload => _initialPayload;

  WidgetRef? _ref;
  void setRef(WidgetRef ref) => _ref = ref;

  void handleNotificationTapped(String? payload) {
    if (payload == null) return;
    debugPrint('📩 Payload recibido: $payload');

    _notificationTapController.add(payload);
    if (_ref != null) {
      _ref!.read(notificationTapProvider.notifier).setPayload(payload);
    }
  }

  Future<void> init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Santiago'));

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    final iosSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        // iOS foreground tap
        handleNotificationTapped(payload);
      },
      notificationCategories: [
        DarwinNotificationCategory(
          'reminderCategory',
          actions: [DarwinNotificationAction.plain('mark_completed', 'Completado')],
        ),
      ],
    );

    final settings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        handleNotificationTapped(response.payload);
      },
    );

    // Permisos Android
    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();

    // Permisos iOS
    await _notifications
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    // Revisar si la app fue abierta desde notificación
    final details = await _notifications.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp ?? false) {
      _initialPayload = details!.notificationResponse?.payload;
      Future.microtask(() => handleNotificationTapped(_initialPayload));
    }
  }

  /// Programar recordatorio
  Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    required String payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'reminder_channel',
      'Recordatorios',
      channelDescription: 'Notificaciones de recordatorios',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      actions: [AndroidNotificationAction('mark_completed', 'Completado')],
      // ⚠ Mostrar en foreground
      ticker: 'recordatorio',
    );

    final iosDetails = DarwinNotificationDetails(
      categoryIdentifier: 'reminderCategory',
      presentAlert: true, // ⚠ Mostrar en foreground
      presentSound: true,
      presentBadge: true,
    );

    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    final scheduledTZ = tz.TZDateTime.from(scheduledDate, tz.local);

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      scheduledTZ,
      details,
      androidAllowWhileIdle: true,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  Future<void> showNow({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'reminder_channel',
      'Recordatorios',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      ticker: 'recordatorio',
    );

    final iosDetails = DarwinNotificationDetails(
      categoryIdentifier: 'reminderCategory',
      presentAlert: true,
      presentSound: true,
      presentBadge: true,
    );

    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _notifications.show(id, title, body, details, payload: payload);
  }

  Future<void> cancelNotification(int id) async => _notifications.cancel(id);
  Future<void> cancelAllNotifications() async => _notifications.cancelAll();
}
