import 'package:ashokgold_scheme_app/core/api_constants/branch_apis.dart';
import 'package:ashokgold_scheme_app/core/error_handling/handleErrors.dart';
import 'package:ashokgold_scheme_app/core/error_handling/type_defs.dart';
import 'package:ashokgold_scheme_app/core/providers/dio_provider.dart';
import 'package:ashokgold_scheme_app/core/utilities/handle_api_response.dart';
import 'package:ashokgold_scheme_app/core/utilities/status_code_constants.dart';
import 'package:ashokgold_scheme_app/features/common/models/branch_social_media_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final branchSocialMediaRepositoryProvider =
    Provider<BranchSocialMediaRepository>((ref) {
      return BranchSocialMediaRepository(dio: ref.watch(dioProvider));
    });

class BranchSocialMediaRepository {
  final Dio dio;

  BranchSocialMediaRepository({required this.dio});

  FutureEither<List<BranchSocialMediaModel>>
  fetchMainBranchSocialMedia() async {
    try {
      final response = await dio.get(BranchApis.mainBranchSocialMedia);

      if (response.statusCode == SuccessStatusCode.ok) {
        final res = handleApiResponse(response);
        final socialMediaList = (res['data'] as List)
            .map((item) => BranchSocialMediaModel.fromJson(item))
            .toList();
        return right(socialMediaList);
      }

      throw Exception('Failed to fetch main branch social media list');
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }
}
