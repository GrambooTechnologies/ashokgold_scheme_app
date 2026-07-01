import 'package:ashokgold_scheme_app/core/api_constants/banner_apis.dart';
import 'package:ashokgold_scheme_app/core/error_handling/handleErrors.dart';
import 'package:ashokgold_scheme_app/core/error_handling/type_defs.dart';
import 'package:ashokgold_scheme_app/core/providers/dio_provider.dart';
import 'package:ashokgold_scheme_app/core/utilities/handle_api_response.dart';
import 'package:ashokgold_scheme_app/core/utilities/status_code_constants.dart';
import 'package:ashokgold_scheme_app/features/home/models/banner_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final bannerRepositoryProvider = Provider<BannerRepository>((ref) {
  return BannerRepository(dio: ref.watch(dioProvider));
});

class BannerRepository {
  final Dio dio;

  BannerRepository({required this.dio});

  FutureEither<List<BannerModel>> fetchBannersApp() async {
    try {
      final response = await dio.get(BannerApis.fetchBannersApp);

      if (response.statusCode == SuccessStatusCode.ok) {
        final res = handleApiResponse(response);
        final bannerList = (res['data'] as List)
            .map(
              (banner) => BannerModel.fromJson(banner as Map<String, dynamic>),
            )
            .toList();
        return right(bannerList);
      }

      throw Exception('Failed to fetch banners');
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }
}
