import 'package:ashokgold_scheme_app/features/auth/providers/customer_provider.dart';
import 'package:ashokgold_scheme_app/features/notifications/models/notification_model.dart';
import 'package:ashokgold_scheme_app/features/notifications/repository/notification_inbox_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Public providers ─────────────────────────────────────────────────────────

/// Standalone unread-count provider — used by the bell-icon badge in
/// HomeView/BottomNav. Fetched once on bottom-nav mount via [fetchCount()].
/// Updated whenever the inbox marks notifications as read.
final notificationUnreadCountProvider =
    NotifierProvider<NotificationUnreadCountNotifier, int>(
      NotificationUnreadCountNotifier.new,
    );

/// Full inbox state — used ONLY by [NotificationInboxView].
/// [initialLoad()] is called when that screen mounts, not before.
final notificationInboxProvider =
    NotifierProvider<NotificationInboxNotifier, NotificationInboxState>(
      NotificationInboxNotifier.new,
    );

// ── Unread-count notifier ─────────────────────────────────────────────────────

class NotificationUnreadCountNotifier extends Notifier<int> {
  @override
  int build() => 0;

  NotificationInboxRepository get _repo =>
      ref.read(notificationInboxRepositoryProvider);

  String? get _customerId => ref.read(customerProvider)?.customerId;

  /// Fetch only the unread count from the API.
  /// Called from BottomNav so the badge is visible without loading the full list.
  Future<void> fetchCount() async {
    final customerId = _customerId;
    if (customerId == null) return;

    final result = await _repo.getUnreadCount(customerId: customerId);
    result.fold((_) {}, (count) => state = count);
  }

  /// Sync count from an external source (e.g. after inbox initial load).
  void sync(int count) => state = count;

  void decrement(int by) =>
      state = (state - by).clamp(0, double.maxFinite.toInt());

  void reset() => state = 0;
}

// ── Notifier ─────────────────────────────────────────────────────────────────

class NotificationInboxNotifier extends Notifier<NotificationInboxState> {
  static const int _pageSize = 10;

  @override
  NotificationInboxState build() {
    return const NotificationInboxState();
  }

  NotificationInboxRepository get _repo =>
      ref.read(notificationInboxRepositoryProvider);

  String? get _customerId => ref.read(customerProvider)?.customerId;

  // ── Initialise (called when inbox screen mounts) ──────────────────────────

  Future<void> initialLoad() async {
    final customerId = _customerId;
    if (customerId == null) return;

    state = state.copyWith(isInitialLoading: true, clearError: true);

    // Fetch unread count and first page in parallel.
    final results = await Future.wait([
      _repo.getUnreadCount(customerId: customerId),
      _repo.getNotifications(customerId: customerId, page: 1, limit: _pageSize),
    ]);

    final countResult = results[0]; // Either<Failure, int>
    final pageResult = results[1]; // Either<Failure, NotificationPage>

    int unreadCount = state.unreadCount;
    // ignore: avoid_type_to_string — pattern match on Either
    countResult.fold(
      (_) {}, // silently keep old count on error
      (count) {
        unreadCount = count as int;
        ref.read(notificationUnreadCountProvider.notifier).sync(unreadCount);
      },
    );

    pageResult.fold(
      (failure) => state = state.copyWith(
        isInitialLoading: false,
        errorMessage: failure.errMSg,
        unreadCount: unreadCount,
      ),
      (page) {
        final p = page as NotificationPage;
        state = state.copyWith(
          notifications: p.items,
          currentPage: p.meta.currentPage,
          totalPages: p.meta.totalPages,
          isInitialLoading: false,
          unreadCount: unreadCount,
          clearError: true,
        );
      },
    );
  }

  // ── Load next page (infinite scroll) ─────────────────────────────────────

  Future<void> loadNextPage() async {
    if (!state.hasMore || state.isLoadingMore) return;
    final customerId = _customerId;
    if (customerId == null) return;

    state = state.copyWith(isLoadingMore: true);

    final result = await _repo.getNotifications(
      customerId: customerId,
      page: state.currentPage + 1,
      limit: _pageSize,
    );

    result.fold(
      (failure) => state = state.copyWith(
        isLoadingMore: false,
        errorMessage: failure.errMSg,
      ),
      (page) {
        state = state.copyWith(
          notifications: [...state.notifications, ...page.items],
          currentPage: page.meta.currentPage,
          totalPages: page.meta.totalPages,
          isLoadingMore: false,
          clearError: true,
        );
      },
    );
  }

  // ── Mark single notification as read ────────────────────────────────────

  Future<void> markAsRead(String notificationId) async {
    final customerId = _customerId;
    if (customerId == null) return;

    // Optimistic local update first.
    final now = DateTime.now().toIso8601String();
    state = state.copyWith(
      notifications: state.notifications.map((n) {
        if (n.notificationId == notificationId && !n.isRead) {
          return n.copyWith(isRead: true, readAt: now);
        }
        return n;
      }).toList(),
      unreadCount: state.unreadCount > 0 ? state.unreadCount - 1 : 0,
    );
    ref.read(notificationUnreadCountProvider.notifier).decrement(1);

    // Fire & forget — revert on failure.
    final result = await _repo.markAsRead(
      customerId: customerId,
      notificationId: notificationId,
    );

    result.fold(
      (failure) {
        // Revert optimistic update.
        final revertedCount = state.unreadCount + 1;
        state = state.copyWith(
          notifications: state.notifications.map((n) {
            if (n.notificationId == notificationId) {
              return n.copyWith(isRead: false, readAt: null);
            }
            return n;
          }).toList(),
          unreadCount: revertedCount,
          errorMessage: failure.errMSg,
        );
        ref.read(notificationUnreadCountProvider.notifier).sync(revertedCount);
      },
      (_) {}, // success — optimistic update already applied
    );
  }

  // ── Mark all as read ──────────────────────────────────────────────────────

  Future<void> markAllAsRead() async {
    final customerId = _customerId;
    if (customerId == null) return;

    final now = DateTime.now().toIso8601String();

    // Optimistic local update first.
    final previousNotifications = state.notifications;
    final previousUnreadCount = state.unreadCount;

    state = state.copyWith(
      notifications: state.notifications
          .map((n) => n.isRead ? n : n.copyWith(isRead: true, readAt: now))
          .toList(),
      unreadCount: 0,
    );
    ref.read(notificationUnreadCountProvider.notifier).reset();

    final result = await _repo.markAllAsRead(customerId: customerId);

    result.fold(
      (failure) {
        // Revert optimistic update.
        state = state.copyWith(
          notifications: previousNotifications,
          unreadCount: previousUnreadCount,
          errorMessage: failure.errMSg,
        );
        ref
            .read(notificationUnreadCountProvider.notifier)
            .sync(previousUnreadCount);
      },
      (_) {}, // success
    );
  }

  // ── Pull-to-refresh ───────────────────────────────────────────────────────

  Future<void> refresh() async {
    state = state.copyWith(notifications: [], currentPage: 0, totalPages: 1);
    await initialLoad();
  }
}
