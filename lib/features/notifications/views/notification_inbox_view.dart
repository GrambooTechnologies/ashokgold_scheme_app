import 'package:ashokgold_scheme_app/core/custom_widgets/error_retry_widget.dart';
import 'package:ashokgold_scheme_app/core/custom_widgets/noItems_list_widget.dart';
import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/core/utilities/scale_size_utils.dart';
import 'package:ashokgold_scheme_app/features/customer_schemes/views/customer_joined_active_scheme_detail_view.dart';
import 'package:ashokgold_scheme_app/features/notifications/models/notification_model.dart';
import 'package:ashokgold_scheme_app/features/notifications/providers/notification_inbox_provider.dart';
import 'package:ashokgold_scheme_app/features/notifications/widgets/notification_tile.dart';
import 'package:ashokgold_scheme_app/features/scheme_payment_entry/views/installment_history_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NotificationInboxView extends ConsumerStatefulWidget {
  static const String routeName = '/notifications';

  const NotificationInboxView({super.key});

  @override
  ConsumerState<NotificationInboxView> createState() =>
      _NotificationInboxViewState();
}

class _NotificationInboxViewState extends ConsumerState<NotificationInboxView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Load data after the first frame so Riverpod state is ready.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationInboxProvider.notifier).initialLoad();
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    // Trigger next page when within 200px of the bottom.
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(notificationInboxProvider.notifier).loadNextPage();
    }
  }

  // ── Deep-link navigation based on referenceType ───────────────────────────

  void _navigateFromNotification(NotificationItem notification) {
    final refType = notification.referenceType;
    final refId = notification.referenceId;

    if (refType == null || refId == null) return;

    switch (refType) {
      case NotificationReferenceType.schemeJoining:
        context.push('${CustomerJoinedSchemeDetailView.routeName}/$refId');
        break;
      case NotificationReferenceType.schemePayment:
        context.push('${InstallmentHistoryView.routeName}/$refId');
        break;
      default:
        break; // no deep-link for unknown types
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationInboxProvider);
    final notifier = ref.read(notificationInboxProvider.notifier);
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      appBar: AppBar(
        backgroundColor: Palette.backgroundColor,
        centerTitle: true,
        title: Text(
          'Notifications',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.w(context, 17),
          ),
        ),
        actions: [
          if (state.unreadCount > 0)
            TextButton.icon(
              onPressed: () => notifier.markAllAsRead(),
              icon: Icon(
                Icons.done_all_rounded,
                size: SizeConfig.w(context, 18),
                color: Palette.primaryColor,
              ),
              label: Text(
                'Mark all read',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Palette.primaryColor,
                ),
              ),
            ),
          SizedBox(width: SizeConfig.w(context, 8)),
        ],
      ),
      body: RefreshIndicator(
        color: Palette.primaryColor,
        onRefresh: () => notifier.refresh(),
        child: _buildBody(state, notifier, w),
      ),
    );
  }

  Widget _buildBody(
    NotificationInboxState state,
    NotificationInboxNotifier notifier,
    double w,
  ) {
    // ── Initial loading ───────────────────────────────────────────────────
    if (state.isInitialLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Palette.primaryColor),
      );
    }

    // ── Error with empty list ─────────────────────────────────────────────
    if (state.errorMessage != null && state.notifications.isEmpty) {
      return ErrorRetryWidget(
        message: state.errorMessage!,
        onRetry: () => notifier.initialLoad(),
      );
    }

    // ── Empty state ───────────────────────────────────────────────────────
    if (state.notifications.isEmpty) {
      return const NoItemsWidget(message: 'No notifications yet');
    }

    // ── Notification list ─────────────────────────────────────────────────
    return ListView.separated(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: state.notifications.length + 1, // +1 for footer
      separatorBuilder: (_, _) =>
          Divider(height: 1, thickness: 0.5, color: Colors.grey.shade200),
      itemBuilder: (context, index) {
        if (index == state.notifications.length) {
          return _ListFooter(state: state);
        }

        final notification = state.notifications[index];
        return NotificationTile(
          notification: notification,
          onTap: () {
            // Mark as read then deep-link.
            if (!notification.isRead) {
              notifier.markAsRead(notification.notificationId);
            }
            _navigateFromNotification(notification);
          },
        );
      },
    );
  }
}

// ── Widgets ───────────────────────────────────────────────────────────────────

/// Footer shown at the bottom of the list — loading spinner or "all loaded".
class _ListFooter extends StatelessWidget {
  final NotificationInboxState state;
  const _ListFooter({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingMore) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: SizeConfig.h(context, 20)),
        child: const Center(
          child: CircularProgressIndicator(color: Palette.primaryColor),
        ),
      );
    }

    if (!state.hasMore && state.notifications.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: SizeConfig.h(context, 24)),
        child: Center(
          child: Text(
            'You\'ve reached the end',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade400),
          ),
        ),
      );
    }

    // Still has more but not loading yet — just spacer.
    return SizedBox(height: SizeConfig.h(context, 16));
  }
}
