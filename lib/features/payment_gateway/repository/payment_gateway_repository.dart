import 'package:ashokgold_scheme_app/core/api_constants/scheme_payment_entry_apis.dart';
import 'package:ashokgold_scheme_app/core/error_handling/handleErrors.dart';
import 'package:ashokgold_scheme_app/core/error_handling/type_defs.dart';
import 'package:ashokgold_scheme_app/core/providers/dio_provider.dart';
import 'package:ashokgold_scheme_app/core/utilities/handle_api_response.dart';
import 'package:ashokgold_scheme_app/core/utilities/status_code_constants.dart';
import 'package:ashokgold_scheme_app/features/payment_gateway/models/payment_status_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final paymentGatewayRepositoryProvider = Provider<PaymentGatewayRepository>((
  ref,
) {
  return PaymentGatewayRepository(dio: ref.watch(dioProvider));
});

class PaymentGatewayRepository {
  final Dio dio;

  PaymentGatewayRepository({required this.dio});

  FutureEither<PaymentStatusModel> verifyPaymentStatus({
    required String orderId,
  }) async {
    try {
      final response = await dio.get(
        SchemePaymentEntryApis.verifyPaymentStatus(orderId),
      );

      if (response.statusCode == SuccessStatusCode.ok) {
        final res = handleApiResponse(response);
        final paymentStatus = PaymentStatusModel.fromJson(res['data']);
        return right(paymentStatus);
      }

      throw Exception('Failed to verify payment status');
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }
}
