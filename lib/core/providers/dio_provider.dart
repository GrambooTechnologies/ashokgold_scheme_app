import 'dart:async';

import 'package:ashokgold_scheme_app/core/api_constants/api_constants.dart';
import 'package:ashokgold_scheme_app/core/api_constants/auth_apis.dart';
import 'package:ashokgold_scheme_app/core/providers/global_providers.dart';
import 'package:ashokgold_scheme_app/core/routes/router.dart';
import 'package:ashokgold_scheme_app/core/utilities/shared_preference_constants.dart';
import 'package:ashokgold_scheme_app/features/auth/providers/customer_provider.dart';
import 'package:ashokgold_scheme_app/features/auth/views/phone_number_view.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,

      // ⏱️ Better timeouts
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),

      receiveDataWhenStatusError: true,

      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(
    QueuedInterceptorsWrapper(
      onRequest: (options, handler) {
        final token = ref.read(accessTokenProvider);

        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        return handler.next(options);
      },

      onError: (error, handler) async {
        debugPrint('❌ Dio Error: ${error.type}');
        debugPrint('URL: ${error.requestOptions.uri}');

        // 🔁 Refresh token on 401
        if (error.response?.statusCode == 401 &&
            ref.read(refreshTokenProvider) != null) {
          final newToken = await _performTokenRefresh(ref);

          if (newToken != null) {
            final requestOptions = error.requestOptions;

            requestOptions.headers['Authorization'] = 'Bearer $newToken';

            final response = await dio.fetch(requestOptions);

            return handler.resolve(response);
          } else {
            await _logoutUser(ref);
          }
        }

        return handler.next(error);
      },
    ),
  );

  return dio;
});

/// Only one refresh at a time
Completer<String?>? _refreshCompleter;

Future<String?> _performTokenRefresh(Ref ref) async {
  if (_refreshCompleter != null) {
    return _refreshCompleter!.future;
  }

  _refreshCompleter = Completer<String?>();

  try {
    final refreshToken = ref.read(refreshTokenProvider);

    if (refreshToken == null) {
      _refreshCompleter!.complete(null);
      _refreshCompleter = null;
      return null;
    }

    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    final response = await dio.post(
      AuthApis.refreshToken,
      data: {"refreshToken": refreshToken},
    );

    if (response.data['success'] == true) {
      final newToken = response.data['data']['accessToken'];

      ref.read(accessTokenProvider.notifier).state = newToken;

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(SharedPreferenceConstants.accessToken, newToken);

      _refreshCompleter!.complete(newToken);
      _refreshCompleter = null;

      return newToken;
    }

    _refreshCompleter!.complete(null);
    _refreshCompleter = null;
    return null;
  } catch (e) {
    debugPrint('Refresh Error: $e');

    _refreshCompleter!.complete(null);
    _refreshCompleter = null;
    return null;
  }
}

Future<void> _logoutUser(Ref ref) async {
  ref.read(accessTokenProvider.notifier).state = null;
  ref.read(refreshTokenProvider.notifier).state = null;

  ref.read(customerProvider.notifier).clearCustomer();

  final prefs = await SharedPreferences.getInstance();

  await prefs.remove(SharedPreferenceConstants.accessToken);
  await prefs.remove(SharedPreferenceConstants.refreshToken);
  await prefs.remove(SharedPreferenceConstants.customerId);

  router.go(PhoneNumberView.routeName);
}
