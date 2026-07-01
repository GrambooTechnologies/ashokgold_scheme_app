import 'package:ashokgold_scheme_app/core/custom_widgets/custom_snackBar.dart';
import 'package:ashokgold_scheme_app/core/providers/dio_provider.dart';
import 'package:ashokgold_scheme_app/core/providers/global_providers.dart';
import 'package:ashokgold_scheme_app/core/repositories/notification_repository.dart';
import 'package:ashokgold_scheme_app/core/services/notification_service.dart';
import 'package:ashokgold_scheme_app/features/auth/models/input_models/register_customer_input.dart';
import 'package:ashokgold_scheme_app/features/auth/providers/customer_provider.dart';
import 'package:ashokgold_scheme_app/features/auth/repository/auth_repository.dart';
import 'package:ashokgold_scheme_app/features/auth/views/phone_number_view.dart';
import 'package:ashokgold_scheme_app/features/auth/views/registration_view.dart';
import 'package:ashokgold_scheme_app/features/home/views/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authControllerProvider = NotifierProvider<AuthController, bool>(
  () => AuthController(),
);

class AuthController extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  Future<void> sendOtp({
    required String phoneNumber,
    required BuildContext context,
  }) async {
    state = true;

    final res = await ref
        .read(authRepositoryProvider)
        .sendOtp(phoneNumber: phoneNumber);

    state = false;

    res.fold(
      (failure) {
        context.showErrorSnackBar(failure.errMSg);
      },
      (message) {
        context.showSuccessSnackBar(message);
      },
    );
  }

  Future<void> verifyOtp({
    required String phoneNumber,
    required String otp,
    required BuildContext context,
  }) async {
    state = true;

    final res = await ref
        .read(authRepositoryProvider)
        .verifyOtp(phoneNumber: phoneNumber, otp: otp);

    state = false;
    res.fold(
      (failure) {
        context.showErrorSnackBar(failure.errMSg);
      },
      (verifyOtpResponse) {
        context.showSuccessSnackBar('OTP verified successfully!');

        // Check if user is registered
        if (verifyOtpResponse.registered) {
          // User is already registered, set tokens and navigate to home
          if (verifyOtpResponse.accessToken != null &&
              verifyOtpResponse.refreshToken != null) {
            ref.read(accessTokenProvider.notifier).update((state) {
              return verifyOtpResponse.accessToken;
            });
            ref.read(refreshTokenProvider.notifier).update((state) {
              return verifyOtpResponse.refreshToken;
            });
            ref.invalidate(dioProvider);
          }

          if (verifyOtpResponse.customer != null) {
            ref
                .read(customerProvider.notifier)
                .setCustomer(verifyOtpResponse.customer!);
          }

          context.showSuccessSnackBar('Login successful!');
          _uploadFcmToken(verifyOtpResponse.customer?.customerId);
          context.go(BottomNav.routeName);
        } else {
          // User is not registered, navigate to registration page
          context.showSuccessSnackBar('Please complete your registration.');
          context.push(RegistrationView.routeName);
        }
      },
    );
  }

  Future<void> registerCustomer({
    required RegisterCustomerInput input,
    required BuildContext context,
  }) async {
    state = true;

    final res = await ref.read(authRepositoryProvider).registerCustomer(input);

    state = false;
    res.fold(
      (failure) {
        context.showErrorSnackBar(failure.errMSg);
      },
      (registerResponse) {
        ref.read(accessTokenProvider.notifier).update((state) {
          return registerResponse.accessToken;
        });
        ref.read(refreshTokenProvider.notifier).update((state) {
          return registerResponse.refreshToken;
        });

        ref
            .read(customerProvider.notifier)
            .setCustomer(registerResponse.customer);

        ref.invalidate(dioProvider);
        context.showSuccessSnackBar('Registration successful!');
        _uploadFcmToken(registerResponse.customer.customerId);
        context.go(BottomNav.routeName);
      },
    );
  }

  Future<void> getMe({required BuildContext context}) async {
    state = true;
    final res = await ref.read(authRepositoryProvider).getMe();

    state = false;
    res.fold(
      (failure) {
        context.showErrorSnackBar(failure.errMSg);
        context.go(BottomNav.routeName);
      },
      (customer) {
        ref.read(customerProvider.notifier).setCustomer(customer);
        context.go(BottomNav.routeName);
      },
    );
  }

  Future<void> logout({required BuildContext context}) async {
    state = true;
    final res = await ref.read(authRepositoryProvider).logout();
    state = false;
    res.fold(
      (failure) {
        context.showErrorSnackBar(failure.errMSg);
      },
      (_) {
        ref.read(customerProvider.notifier).clearCustomer();
        ref.read(accessTokenProvider.notifier).state = null;
        ref.read(refreshTokenProvider.notifier).state = null;
        context.showSuccessSnackBar('Logout successful!');
        context.go(PhoneNumberView.routeName);
      },
    );
  }

  /// Gets the FCM token and sends it to the backend. Fire-and-forget.
  void _uploadFcmToken(String? customerId) {
    if (customerId == null) return;
    NotificationService.instance.getToken().then((token) {
      if (token == null) return;
      ref
          .read(notificationRepositoryProvider)
          .updateFcmToken(customerId: customerId, fcmToken: token);
      // Re-upload whenever the token is refreshed.
      NotificationService.instance.listenToTokenRefresh((newToken) {
        ref
            .read(notificationRepositoryProvider)
            .updateFcmToken(customerId: customerId, fcmToken: newToken);
      });
    });
  }

  // Allow users to continue without login (guest mode)
  void continueAsGuest(BuildContext context) {
    context.showSuccessSnackBar('Continuing as guest');
    context.go(BottomNav.routeName);
  }
}
