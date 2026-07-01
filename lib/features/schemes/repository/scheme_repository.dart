import 'package:ashokgold_scheme_app/core/api_constants/scheme_apis.dart';
import 'package:ashokgold_scheme_app/core/error_handling/handleErrors.dart';
import 'package:ashokgold_scheme_app/core/error_handling/type_defs.dart';
import 'package:ashokgold_scheme_app/core/providers/dio_provider.dart';
import 'package:ashokgold_scheme_app/core/utilities/handle_api_response.dart';
import 'package:ashokgold_scheme_app/core/utilities/status_code_constants.dart';
import 'package:ashokgold_scheme_app/features/schemes/models/scheme_benefit_calculation_model.dart';
import 'package:ashokgold_scheme_app/features/schemes/models/scheme_detail_response_model.dart';
import 'package:ashokgold_scheme_app/features/schemes/models/scheme_model.dart';
import 'package:ashokgold_scheme_app/features/schemes/models/scheme_payment_rule_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final schemeRepositoryProvider = Provider<SchemeRepository>((ref) {
  return SchemeRepository(dio: ref.watch(dioProvider));
});

class SchemeRepository {
  final Dio dio;

  SchemeRepository({required this.dio});

  FutureEither<List<SchemeModel>> getAllSchemes() async {
    try {
      final response = await dio.get(SchemeApis.getAllSchemes);

      if (response.statusCode == SuccessStatusCode.ok) {
        final res = handleApiResponse(response);

        final List<dynamic> data = res['data'] as List<dynamic>;
        final schemes = data
            .map((json) => SchemeModel.fromJson(json as Map<String, dynamic>))
            .toList();

        return right(schemes);
      }

      throw Exception('Failed to fetch schemes');
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }

  FutureEither<SchemeDetailByIdResponseModel> getSchemeById(
    String schemeId,
  ) async {
    try {
      final response = await dio.get(SchemeApis.getSchemeById(schemeId));

      if (response.statusCode == SuccessStatusCode.ok) {
        final res = handleApiResponse(response);
        final scheme = SchemeDetailByIdResponseModel.fromJson(
          res['data'] as Map<String, dynamic>,
        );

        return right(scheme);
      }

      throw Exception('Failed to fetch scheme details');
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }

  FutureEither<SchemePaymentRuleModel> getPaymentRulesBySchemeId(
    String schemeId,
  ) async {
    try {
      final response = await dio.get(
        SchemeApis.getPaymentRulesBySchemeId(schemeId),
      );

      if (response.statusCode == SuccessStatusCode.ok) {
        final res = handleApiResponse(response);
        final paymentRule = SchemePaymentRuleModel.fromJson(
          res['data'] as Map<String, dynamic>,
        );

        return right(paymentRule);
      }

      throw Exception('Failed to fetch payment rules');
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }

  FutureEither<SchemeBenefitCalculationModel> calculateBenefit({
    required String schemeId,
    required double installmentAmount,
  }) async {
    try {
      final response = await dio.post(
        SchemeApis.calculateBenefit,
        data: {'schemeId': schemeId, 'installmentAmount': installmentAmount},
      );

      if (response.statusCode == SuccessStatusCode.ok) {
        final res = handleApiResponse(response);
        final benefitCalculation = SchemeBenefitCalculationModel.fromJson(
          res['data'] as Map<String, dynamic>,
        );

        return right(benefitCalculation);
      }

      throw Exception('Failed to calculate benefits');
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }
}
