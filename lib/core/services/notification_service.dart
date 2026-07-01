import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Must be a top-level function — called by Firebase when app is terminated or background.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Firebase is already initialized in main(); nothing else needed here.
  debugPrint('📩 Background FCM message: ${message.messageId}');
}

/// Android notification channel used for all FCM messages.
const AndroidNotificationChannel fcmNotificationChannel =
    AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'Used for important app notifications.',
  importance: Importance.high,
);

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Call once during app startup (after Firebase.initializeApp).
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    await _requestPermissions();
    await _setupLocalNotifications();

    // Foreground messages — show a local notification manually (Android only).
    FirebaseMessaging.onMessage.listen(_showLocalNotification);

    // App opened from background notification tap.
    FirebaseMessaging.onMessageOpenedApp.listen(_onNotificationTapped);

    // App opened from terminated state via notification tap.
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _onNotificationTapped(initialMessage);
    }
  }

  // ---------------------------------------------------------------------------
  // Permissions
  // ---------------------------------------------------------------------------

  Future<void> _requestPermissions() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );

    // iOS: show notifications even when app is in foreground.
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // ---------------------------------------------------------------------------
  // Local Notifications (Android foreground display)
  // ---------------------------------------------------------------------------

  Future<void> _setupLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    await _localNotifications.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );

    // Create the high-importance channel on Android.
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(fcmNotificationChannel);
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          fcmNotificationChannel.id,
          fcmNotificationChannel.name,
          channelDescription: fcmNotificationChannel.description,
          icon: '@mipmap/ic_launcher',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: message.data.toString(),
    );
  }

  void _onNotificationTapped(RemoteMessage message) {
    debugPrint('🔔 Notification tapped — data: ${message.data}');
    // Add navigation logic here if needed, e.g. using a GlobalKey<NavigatorState>.
  }

  // ---------------------------------------------------------------------------
  // FCM Token
  // ---------------------------------------------------------------------------

  /// Returns the current FCM token. May be null if permission is denied.
  Future<String?> getToken() async {
    return _messaging.getToken();
  }

  /// Listen for token refresh events (e.g. re-send to backend when token changes).
  void listenToTokenRefresh(void Function(String token) onNewToken) {
    _messaging.onTokenRefresh.listen(onNewToken);
  }
}
