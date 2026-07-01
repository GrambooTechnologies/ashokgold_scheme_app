import 'package:ashokgold_scheme_app/core/api_constants/dropdown_apis.dart';
import 'package:ashokgold_scheme_app/core/error_handling/handleErrors.dart';
import 'package:ashokgold_scheme_app/core/error_handling/type_defs.dart';
import 'package:ashokgold_scheme_app/core/providers/dio_provider.dart';
import 'package:ashokgold_scheme_app/core/utilities/handle_api_response.dart';
import 'package:ashokgold_scheme_app/core/utilities/status_code_constants.dart';
import 'package:ashokgold_scheme_app/features/common/models/dropdown_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final dropdownRepositoryProvider = Provider<DropdownRepository>((ref) {
  return DropdownRepository(dio: ref.watch(dioProvider));
});

class DropdownRepository {
  final Dio dio;

  DropdownRepository({required this.dio});

  FutureEither<List<DropdownItemModel>> fetchNomineeRelations() async {
    try {
      final response = await dio.get(DropdownApis.getNomineeRelations);

      if (response.statusCode == SuccessStatusCode.ok) {
        final res = handleApiResponse(response);
        final List<dynamic> relationsJson = res['data'] as List<dynamic>;
        final relations = relationsJson
            .map(
              (json) =>
                  DropdownItemModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
        return right(relations);
      }

      throw Exception('Failed to fetch nominee relations');
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }
}
