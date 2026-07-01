import 'package:ashokgold_scheme_app/core/api_constants/notification_apis.dart';
import 'package:ashokgold_scheme_app/core/error_handling/handleErrors.dart';
import 'package:ashokgold_scheme_app/core/error_handling/type_defs.dart';
import 'package:ashokgold_scheme_app/core/providers/dio_provider.dart';
import 'package:ashokgold_scheme_app/core/utilities/handle_api_response.dart';
import 'package:ashokgold_scheme_app/core/utilities/status_code_constants.dart';
import 'package:ashokgold_scheme_app/features/notifications/models/notification_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final notificationInboxRepositoryProvider =
    Provider<NotificationInboxRepository>((ref) {
      return NotificationInboxRepository(dio: ref.watch(dioProvider));
    });

class NotificationInboxRepository {
  final Dio dio;
  NotificationInboxRepository({required this.dio});

  // ── 1. Paginated notification list ────────────────────────────────────────

  FutureEither<NotificationPage> getNotifications({
    required String customerId,
    int page = 1,
    int limit = 10,
    String sortBy = 'cn.created_at',
    String sortOrder = 'desc',
    String? isRead, // '0' = unread, '1' = read, null = all
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        'sortBy': sortBy,
        'sortOrder': sortOrder,
        'isRead': ?isRead,
      };

      final response = await dio.get(
        NotificationApis.getNotifications(customerId),
        queryParameters: queryParams,
      );

      if (response.statusCode == SuccessStatusCode.ok) {
        final res = handleApiResponse(response);
        final dataWrapper = res['data'] as Map<String, dynamic>;

        final items = (dataWrapper['data'] as List<dynamic>)
            .map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
            .toList();

        final meta = NotificationMeta.fromJson(
          dataWrapper['meta'] as Map<String, dynamic>,
        );

        return right(NotificationPage(items: items, meta: meta));
      }

      throw Exception('Failed to fetch notifications');
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }

  // ── 2. Unread count ───────────────────────────────────────────────────────

  FutureEither<int> getUnreadCount({required String customerId}) async {
    try {
      final response = await dio.get(
        NotificationApis.getUnreadCount(customerId),
      );

      if (response.statusCode == SuccessStatusCode.ok) {
        final res = handleApiResponse(response);
        final unreadCount =
            (res['data'] as Map<String, dynamic>)['unreadCount'] as int;
        return right(unreadCount);
      }

      throw Exception('Failed to fetch unread count');
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }

  // ── 3. Mark single notification as read ───────────────────────────────────

  FutureVoid markAsRead({
    required String customerId,
    required String notificationId,
  }) async {
    try {
      final response = await dio.patch(
        NotificationApis.markAsRead(customerId, notificationId),
      );

      if (response.statusCode == SuccessStatusCode.ok) {
        handleApiResponse(response);
        return right(null);
      }

      throw Exception('Failed to mark notification as read');
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }

  // ── 4. Mark all notifications as read ────────────────────────────────────

  FutureVoid markAllAsRead({required String customerId}) async {
    try {
      final response = await dio.patch(
        NotificationApis.markAllAsRead(customerId),
      );

      if (response.statusCode == SuccessStatusCode.ok) {
        handleApiResponse(response);
        return right(null);
      }

      throw Exception('Failed to mark all notifications as read');
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }
}
