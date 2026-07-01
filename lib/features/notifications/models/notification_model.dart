/// Notification type values returned by the backend.
class NotificationType {
  static const String general = 'GENERAL';
  static const String payment = 'PAYMENT';
  static const String scheme = 'SCHEME';
  static const String promotion = 'PROMOTION';
  static const String system = 'SYSTEM';
}

/// Reference type values used for deep-linking.
class NotificationReferenceType {
  static const String schemeJoining = 'SCHEME_JOINING';
  static const String schemePayment = 'SCHEME_PAYMENT';
}

/// Single notification item returned inside the paginated list.
class NotificationItem {
  final String notificationId;
  final String title;
  final String body;
  final String notificationType;
  final String? referenceId;
  final String? referenceType;
  final Map<String, String>? data;
  final bool isRead;
  final String? readAt;
  final String? createdAt;

  const NotificationItem({
    required this.notificationId,
    required this.title,
    required this.body,
    required this.notificationType,
    this.referenceId,
    this.referenceType,
    this.data,
    required this.isRead,
    this.readAt,
    this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      notificationId: json['notificationId'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      notificationType: json['notificationType'] as String,
      referenceId: json['referenceId'] as String?,
      referenceType: json['referenceType'] as String?,
      data: (json['data'] as Map<String, dynamic>?)?.cast<String, String>(),
      isRead: json['isRead'] as bool,
      readAt: json['readAt'] as String?,
      createdAt: json['createdAt'] as String?,
    );
  }

  NotificationItem copyWith({bool? isRead, String? readAt}) {
    return NotificationItem(
      notificationId: notificationId,
      title: title,
      body: body,
      notificationType: notificationType,
      referenceId: referenceId,
      referenceType: referenceType,
      data: data,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt,
    );
  }
}

/// Pagination metadata returned alongside the list.
class NotificationMeta {
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final int pageSize;

  const NotificationMeta({
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
  });

  factory NotificationMeta.fromJson(Map<String, dynamic> json) {
    return NotificationMeta(
      totalItems: json['totalItems'] as int,
      totalPages: json['totalPages'] as int,
      currentPage: json['currentPage'] as int,
      pageSize: json['pageSize'] as int,
    );
  }
}

/// Holds one page of notifications plus its metadata.
class NotificationPage {
  final List<NotificationItem> items;
  final NotificationMeta meta;

  const NotificationPage({required this.items, required this.meta});
}

/// The full UI state managed by [NotificationInboxNotifier].
class NotificationInboxState {
  final List<NotificationItem> notifications;
  final int unreadCount;
  final int currentPage;
  final int totalPages;
  final bool isLoadingMore;
  final bool isInitialLoading;
  final String? errorMessage;

  const NotificationInboxState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.currentPage = 0,
    this.totalPages = 1,
    this.isLoadingMore = false,
    this.isInitialLoading = true,
    this.errorMessage,
  });

  bool get hasMore => currentPage < totalPages;

  NotificationInboxState copyWith({
    List<NotificationItem>? notifications,
    int? unreadCount,
    int? currentPage,
    int? totalPages,
    bool? isLoadingMore,
    bool? isInitialLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotificationInboxState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
