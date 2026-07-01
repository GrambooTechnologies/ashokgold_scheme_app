import 'package:ashokgold_scheme_app/core/api_constants/branch_apis.dart';
import 'package:ashokgold_scheme_app/core/error_handling/handleErrors.dart';
import 'package:ashokgold_scheme_app/core/error_handling/type_defs.dart';
import 'package:ashokgold_scheme_app/core/providers/dio_provider.dart';
import 'package:ashokgold_scheme_app/core/utilities/handle_api_response.dart';
import 'package:ashokgold_scheme_app/core/utilities/status_code_constants.dart';
import 'package:ashokgold_scheme_app/features/common/models/branch_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final branchRepositoryProvider = Provider<BranchRepository>((ref) {
  return BranchRepository(dio: ref.watch(dioProvider));
});

class BranchRepository {
  final Dio dio;

  BranchRepository({required this.dio});

  FutureEither<List<BranchModel>> fetchAllBranches() async {
    try {
      final response = await dio.get(BranchApis.allBranches);

      if (response.statusCode == SuccessStatusCode.ok) {
        final res = handleApiResponse(response);
        final branches = (res['data'] as List)
            .map((branch) => BranchModel.fromJson(branch))
            .toList();
        return right(branches);
      }

      throw Exception('Failed to fetch branches');
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }
}
