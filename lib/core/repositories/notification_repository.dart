import 'package:ashokgold_scheme_app/core/api_constants/notification_apis.dart';
import 'package:ashokgold_scheme_app/core/error_handling/handleErrors.dart';
import 'package:ashokgold_scheme_app/core/error_handling/type_defs.dart';
import 'package:ashokgold_scheme_app/core/providers/dio_provider.dart';
import 'package:ashokgold_scheme_app/core/utilities/status_code_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(dio: ref.watch(dioProvider));
});

class NotificationRepository {
  final Dio dio;
  NotificationRepository({required this.dio});

  /// Sends the device FCM token to the backend for the given customer.
  FutureEither<void> updateFcmToken({
    required String customerId,
    required String fcmToken,
  }) async {
    try {
      final response = await dio.post(
        NotificationApis.updateFcmToken(customerId),
        data: {'fcmToken': fcmToken},
      );

      if (response.statusCode == SuccessStatusCode.ok ||
          response.statusCode == SuccessStatusCode.created) {
        return right(null);
      }

      throw Exception('Failed to update FCM token');
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }
}
