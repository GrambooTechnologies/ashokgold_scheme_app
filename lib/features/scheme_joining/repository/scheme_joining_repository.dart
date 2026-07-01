import 'package:ashokgold_scheme_app/core/api_constants/scheme_joining_apis.dart';
import 'package:ashokgold_scheme_app/core/error_handling/handleErrors.dart';
import 'package:ashokgold_scheme_app/core/error_handling/type_defs.dart';
import 'package:ashokgold_scheme_app/core/providers/dio_provider.dart';
import 'package:ashokgold_scheme_app/core/utilities/handle_api_response.dart';
import 'package:ashokgold_scheme_app/core/utilities/status_code_constants.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/models/input_models/join_scheme_input.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/models/input_models/validate_amount_input.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/models/preferred_branch_model.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/models/scheme_joining_payment_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final schemeJoiningRepositoryProvider = Provider<SchemeJoiningRepository>((
  ref,
) {
  return SchemeJoiningRepository(dio: ref.watch(dioProvider));
});

class SchemeJoiningRepository {
  final Dio dio;

  SchemeJoiningRepository({required this.dio});

  FutureEither<SchemeJoiningPaymentResponse> joinScheme(
    JoinSchemeInput input,
  ) async {
    try {
      final response = await dio.post(
        SchemeJoiningApis.joinScheme,
        data: input.toJson(),
      );

      if (response.statusCode == SuccessStatusCode.ok ||
          response.statusCode == SuccessStatusCode.created) {
        final res = handleApiResponse(response);
        final paymentResponse = SchemeJoiningPaymentResponse.fromJson(
          res['data'],
        );
        return right(paymentResponse);
      }

      throw Exception('Failed to join scheme');
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }

  FutureVoid validateInitialInstallmentAmount(
    ValidateInitialInstallmentAmountInput input,
  ) async {
    try {
      final response = await dio.post(
        SchemeJoiningApis.validateInitialInstallmentAmount,
        data: input.toJson(),
      );

      if (response.statusCode == SuccessStatusCode.ok) {
        //TODO use handleApiResponse function
        // final res = handleApiResponse(response);
        return right(null);
      }

      throw Exception('Failed to validate installment amount');
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }

  FutureEither<List<PreferredBranchModel>> fetchPreferredBranches(
    String schemeId,
  ) async {
    try {
      final response = await dio.get(
        SchemeJoiningApis.preferredBranches,
        queryParameters: {'schemeId': schemeId},
      );

      if (response.statusCode == SuccessStatusCode.ok) {
        final List<dynamic> branchesData = response.data['data'] ?? [];
        final branches = branchesData
            .map((json) => PreferredBranchModel.fromJson(json))
            .toList();
        return right(branches);
      }

      throw Exception('Failed to fetch preferred branches');
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }
}
