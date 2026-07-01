import 'package:ashokgold_scheme_app/core/api_constants/metal_rate_apis.dart';
import 'package:ashokgold_scheme_app/core/error_handling/handleErrors.dart';
import 'package:ashokgold_scheme_app/core/error_handling/type_defs.dart';
import 'package:ashokgold_scheme_app/core/providers/dio_provider.dart';
import 'package:ashokgold_scheme_app/core/utilities/handle_api_response.dart';
import 'package:ashokgold_scheme_app/core/utilities/status_code_constants.dart';
import 'package:ashokgold_scheme_app/features/common/models/metal_rate_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final metalRateRepositoryProvider = Provider<MetalRateRepository>((ref) {
  return MetalRateRepository(dio: ref.watch(dioProvider));
});

class MetalRateRepository {
  final Dio dio;

  MetalRateRepository({required this.dio});

  FutureEither<MetalRateModel> fetchLatestMetalRate() async {
    try {
      final response = await dio.get(MetalRateApis.latestMetalRate);

      if (response.statusCode == SuccessStatusCode.ok) {
        final res = handleApiResponse(response);
        final metalRate = MetalRateModel.fromJson(res['data']);
        return right(metalRate);
      }

      throw Exception('Failed to fetch latest metal rate');
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }
}
