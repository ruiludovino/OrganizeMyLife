import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Ponto único para lembretes locais (flutter_local_notifications) e para
/// autorização de push remoto (firebase_messaging). Push remoto de verdade
/// (enviado por um backend/Cloud Function) fica como extensão futura — por
/// ora só pedimos a permissão e deixamos o token disponível.
///
/// `flutter_local_notifications` não tem implementação web, então tudo
/// aqui vira no-op em `kIsWeb` (o app roda normal no navegador, só sem
/// notificações — mobile é a plataforma alvo desse recurso).
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _localNotifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized || kIsWeb) return;
    tz_data.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    await _localNotifications.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    await _localNotifications
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    await FirebaseMessaging.instance.requestPermission();

    _initialized = true;
  }

  /// Token do dispositivo para push remoto (FCM). `null` na web (sem
  /// configuração de VAPID key) ou se a permissão não foi concedida.
  Future<String?> getToken() async {
    if (kIsWeb) return null;
    return FirebaseMessaging.instance.getToken();
  }

  /// Dispara sempre que o FCM gera um token novo (reinstalação, troca de
  /// dispositivo, etc.) — quem escuta decide o que fazer com ele.
  Stream<String> get onTokenRefresh => FirebaseMessaging.instance.onTokenRefresh;

  /// Agenda um lembrete local. `id` é o id do documento no Firestore —
  /// usamos o hash dele como id numérico da notificação, para poder
  /// cancelar depois sem guardar um id separado.
  Future<void> scheduleReminder({
    required String id,
    required String title,
    required DateTime dateTime,
  }) async {
    if (kIsWeb || dateTime.isBefore(DateTime.now())) return;

    await _localNotifications.zonedSchedule(
      id.hashCode,
      title,
      null,
      tz.TZDateTime.from(dateTime, tz.UTC),
      const NotificationDetails(
        android: AndroidNotificationDetails('reminders', 'Lembretes'),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelReminder(String id) async {
    if (kIsWeb) return;
    await _localNotifications.cancel(id.hashCode);
  }
}
