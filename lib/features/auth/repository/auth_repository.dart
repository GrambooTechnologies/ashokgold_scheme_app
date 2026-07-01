import 'package:ashokgold_scheme_app/core/api_constants/auth_apis.dart';
import 'package:ashokgold_scheme_app/core/error_handling/handleErrors.dart';
import 'package:ashokgold_scheme_app/core/error_handling/type_defs.dart';
import 'package:ashokgold_scheme_app/core/providers/dio_provider.dart';
import 'package:ashokgold_scheme_app/core/providers/global_providers.dart';
import 'package:ashokgold_scheme_app/core/utilities/handle_api_response.dart';
import 'package:ashokgold_scheme_app/core/utilities/shared_preference_constants.dart';
import 'package:ashokgold_scheme_app/core/utilities/status_code_constants.dart';
import 'package:ashokgold_scheme_app/features/auth/models/customer_model.dart';
import 'package:ashokgold_scheme_app/features/auth/models/input_models/register_customer_input.dart';
import 'package:ashokgold_scheme_app/features/auth/models/register_customer_response.dart';
import 'package:ashokgold_scheme_app/features/auth/models/input_models/send_otp_input.dart';
import 'package:ashokgold_scheme_app/features/auth/models/input_models/verify_otp_input.dart';
import 'package:ashokgold_scheme_app/features/auth/models/verify_otp_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    dio: ref.watch(dioProvider),
    sharedPreferences: ref.watch(sharedPreferencesProvider),
  );
});

class AuthRepository {
  Dio dio;
  SharedPreferences sharedPreferences;
  AuthRepository({required this.dio, required this.sharedPreferences});

  FutureEither<String> sendOtp({required String phoneNumber}) async {
    try {
      final input = SendOtpInput(mobile: phoneNumber);
      final response = await dio.post(AuthApis.sendOtp, data: input.toJson());

      if (response.statusCode == SuccessStatusCode.ok) {
        final res = handleApiResponse(response);
        return right(res['message'] as String);
      }

      throw Exception('Failed to send OTP');
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }

  FutureEither<VerifyOtpResponse> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      final input = VerifyOtpInput(mobile: phoneNumber, otp: otp);
      final response = await dio.post(AuthApis.verifyOtp, data: input.toJson());

      if (response.statusCode == SuccessStatusCode.ok) {
        final res = handleApiResponse(response);
        final verifyOtpResponse = VerifyOtpResponse.fromJson(res['data']);

        // Save phone number
        await sharedPreferences.setString(
          SharedPreferenceConstants.phoneNumber,
          verifyOtpResponse.phoneNumber,
        );

        // If user is registered, save tokens and customer data
        if (verifyOtpResponse.registered) {
          if (verifyOtpResponse.accessToken != null &&
              verifyOtpResponse.refreshToken != null) {
            await sharedPreferences.setString(
              SharedPreferenceConstants.accessToken,
              verifyOtpResponse.accessToken!,
            );
            await sharedPreferences.setString(
              SharedPreferenceConstants.refreshToken,
              verifyOtpResponse.refreshToken!,
            );
          }

          if (verifyOtpResponse.customer != null) {
            await sharedPreferences.setString(
              SharedPreferenceConstants.customerId,
              verifyOtpResponse.customer!.customerId,
            );
          }
        }

        return right(verifyOtpResponse);
      }

      throw Exception('OTP verification failed');
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }

  FutureEither<RegisterCustomerResponse> registerCustomer(
    RegisterCustomerInput input,
  ) async {
    try {
      final response = await dio.post(
        AuthApis.registerCustomer,
        data: input.toJson(),
      );

      if (response.statusCode == SuccessStatusCode.ok ||
          response.statusCode == SuccessStatusCode.created) {
        final res = handleApiResponse(response);
        final registerResponse = RegisterCustomerResponse.fromJson(res['data']);

        // Save tokens and customer data
        await sharedPreferences.setString(
          SharedPreferenceConstants.accessToken,
          registerResponse.accessToken,
        );
        await sharedPreferences.setString(
          SharedPreferenceConstants.refreshToken,
          registerResponse.refreshToken,
        );
        await sharedPreferences.setString(
          SharedPreferenceConstants.customerId,
          registerResponse.customer.customerId,
        );

        return right(registerResponse);
      }

      throw Exception('Registration failed');
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }

  FutureEither<CustomerModel> getMe() async {
    try {
      final response = await dio.get(AuthApis.getMe);

      if (response.statusCode == SuccessStatusCode.ok) {
        final res = handleApiResponse(response);
        final customer = CustomerModel.fromJson(res['data']);

        await sharedPreferences.setString(
          SharedPreferenceConstants.customerId,
          customer.customerId,
        );

        return right(customer);
      }

      throw Exception('Failed to fetch customer data');
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }

  FutureEither<String> refreshAccessToken({
    required String refreshToken,
  }) async {
    try {
      final response = await dio.post(
        AuthApis.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == SuccessStatusCode.ok) {
        final res = handleApiResponse(response);
        final accessToken = res['data']['accessToken'] as String;

        await sharedPreferences.setString(
          SharedPreferenceConstants.accessToken,
          accessToken,
        );

        return right(accessToken);
      }

      throw Exception('Failed to refresh token');
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }

  FutureVoid logout() async {
    try {
      await sharedPreferences.remove(SharedPreferenceConstants.customerId);
      await sharedPreferences.remove(SharedPreferenceConstants.accessToken);
      await sharedPreferences.remove(SharedPreferenceConstants.refreshToken);
      await sharedPreferences.remove(SharedPreferenceConstants.authCustomerId);
      await sharedPreferences.remove(SharedPreferenceConstants.phoneNumber);
      return right(null);
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }
}
