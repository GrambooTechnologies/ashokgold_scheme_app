import 'package:ashokgold_scheme_app/core/error_handling/handleErrors.dart';
import 'package:ashokgold_scheme_app/core/error_handling/type_defs.dart';
import 'package:ashokgold_scheme_app/core/providers/dio_provider.dart';
import 'package:ashokgold_scheme_app/core/utilities/handle_api_response.dart';
import 'package:ashokgold_scheme_app/core/utilities/status_code_constants.dart';
import 'package:ashokgold_scheme_app/features/auth/models/customer_model.dart';
import 'package:ashokgold_scheme_app/core/api_constants/profile_apis.dart';
import 'package:ashokgold_scheme_app/features/profile/models/update_customer_input.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(dio: ref.watch(dioProvider));
});

class ProfileRepository {
  final Dio dio;
  ProfileRepository({required this.dio});

  FutureEither<CustomerModel> updateCustomer({
    required String customerId,
    required UpdateCustomerInput input,
  }) async {
    try {
      final response = await dio.put(
        ProfileApis.updateCustomer(customerId),
        data: input.toJson(),
      );

      if (response.statusCode == SuccessStatusCode.ok) {
        final res = handleApiResponse(response);
        final customer = CustomerModel.fromJson(res['data']);
        return right(customer);
      }

      throw Exception('Failed to update customer');
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }
}
