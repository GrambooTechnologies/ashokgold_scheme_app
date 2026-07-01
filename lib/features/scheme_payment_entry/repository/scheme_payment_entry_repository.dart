import 'package:ashokgold_scheme_app/core/api_constants/scheme_payment_entry_apis.dart';
import 'package:ashokgold_scheme_app/core/error_handling/handleErrors.dart';
import 'package:ashokgold_scheme_app/core/error_handling/type_defs.dart';
import 'package:ashokgold_scheme_app/core/providers/dio_provider.dart';
import 'package:ashokgold_scheme_app/core/utilities/handle_api_response.dart';
import 'package:ashokgold_scheme_app/core/utilities/status_code_constants.dart';
import 'package:ashokgold_scheme_app/features/scheme_payment_entry/models/input_models/installment_payment_input.dart';
import 'package:ashokgold_scheme_app/features/scheme_payment_entry/models/installment_payment_response.dart';
import 'package:ashokgold_scheme_app/features/scheme_payment_entry/models/next_installment_details_response.dart';
import 'package:ashokgold_scheme_app/features/scheme_payment_entry/models/installment_history_model.dart';
import 'package:ashokgold_scheme_app/features/scheme_payment_entry/models/payment_tries_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final schemePaymentEntryRepositoryProvider = Provider((ref) {
  return SchemePaymentEntryRepository(dio: ref.watch(dioProvider));
});

class SchemePaymentEntryRepository {
  final Dio dio;

  SchemePaymentEntryRepository({required this.dio});

  FutureEither<InstallmentPaymentResponse> initiateInstallmentPayment({
    required String joinId,
    required double amount,
    String? description,
  }) async {
    try {
      final response = await dio.post(
        SchemePaymentEntryApis.createInstallmentPayment,
        data: {
          'joinId': joinId,
          'installmentAmount': amount,
          'paymentMethod': 'PAYMENT_GATEWAY',
          'description': ?description,
        },
      );

      if (response.statusCode == SuccessStatusCode.ok ||
          response.statusCode == SuccessStatusCode.created) {
        final res = handleApiResponse(response);
        final paymentResponse = InstallmentPaymentResponse.fromJson(
          res['data'],
        );
        return right(paymentResponse);
      }

      throw Exception('Failed to initiate installment payment');
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }

  FutureEither<void> createInstallmentPayment(
    InstallmentPaymentInput input,
  ) async {
    try {
      final response = await dio.post(
        SchemePaymentEntryApis.createInstallmentPayment,
        data: input.toJson(),
      );
      handleApiResponse(response);
      return right(null);
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }

  FutureEither<List<InstallmentGroupModel>> getInstallmentHistory({
    required String joinId,
  }) async {
    try {
      final response = await dio.get(
        SchemePaymentEntryApis.getInstallmentHistory(joinId),
      );

      if (response.statusCode == SuccessStatusCode.ok) {
        final res = handleApiResponse(response);
        final List<dynamic> paymentsJson = res['data'] as List<dynamic>;
        final payments = paymentsJson.map((json) {
          return InstallmentGroupModel.fromJson(json as Map<String, dynamic>);
        }).toList();
        return right(payments);
      }

      throw Exception('Failed to fetch installment history');
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }

  FutureEither<NextInstallmentDetailsResponse> getNextInstallmentDetails({
    required String joinId,
  }) async {
    try {
      final response = await dio.get(
        SchemePaymentEntryApis.getNextInstallmentDetails(joinId),
      );

      if (response.statusCode == SuccessStatusCode.ok) {
        final res = handleApiResponse(response);
        final details = NextInstallmentDetailsResponse.fromJson(res['data']);
        return right(details);
      }

      throw Exception('Failed to fetch next installment details');
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }

  FutureEither<List<PaymentTriesItemModel>> getPaymentTries({
    required String joinId,
  }) async {
    try {
      final response = await dio.get(
        SchemePaymentEntryApis.getPaymentTries(joinId),
      );

      if (response.statusCode == SuccessStatusCode.ok) {
        final res = handleApiResponse(response);
        final List<dynamic> triesJson = res['data'] as List<dynamic>;
        final tries = triesJson
            .map(
              (json) =>
                  PaymentTriesItemModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
        return right(tries);
      }

      throw Exception('Failed to fetch payment tries');
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }
}
