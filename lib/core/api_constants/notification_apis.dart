class NotificationApis {
  /// POST — register / refresh FCM token.
  static String updateFcmToken(String customerId) =>
      '/notifications/$customerId/fcm-token';

  /// GET — paginated notification inbox.
  ///
  /// Query params: page, limit, sortBy, sortOrder, isRead
  static String getNotifications(String customerId) =>
      '/notifications/$customerId';

  /// GET — unread notification count (for badge).
  static String getUnreadCount(String customerId) =>
      '/notifications/$customerId/unread-count';

  /// PATCH — mark a single notification as read.
  static String markAsRead(String customerId, String notificationId) =>
      '/notifications/$customerId/$notificationId/read';

  /// PATCH — mark ALL notifications as read.
  static String markAllAsRead(String customerId) =>
      '/notifications/$customerId/read-all';
}
