import 'package:ashokgold_scheme_app/core/api_constants/nominee_apis.dart';
import 'package:ashokgold_scheme_app/core/error_handling/handleErrors.dart';
import 'package:ashokgold_scheme_app/core/error_handling/type_defs.dart';
import 'package:ashokgold_scheme_app/core/providers/dio_provider.dart';
import 'package:ashokgold_scheme_app/core/utilities/handle_api_response.dart';
import 'package:ashokgold_scheme_app/core/utilities/status_code_constants.dart';
import 'package:ashokgold_scheme_app/features/nominee/models/create_nominee_input.dart';
import 'package:ashokgold_scheme_app/features/nominee/models/nominee_model.dart';
import 'package:ashokgold_scheme_app/features/nominee/models/update_nominee_input.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final nomineeRepositoryProvider = Provider<NomineeRepository>((ref) {
  return NomineeRepository(dio: ref.watch(dioProvider));
});

class NomineeRepository {
  final Dio dio;

  NomineeRepository({required this.dio});

  FutureVoid createNominee(CreateNomineeInput input) async {
    try {
      final response = await dio.post(NomineeApis.create, data: input.toJson());

      if (response.statusCode == SuccessStatusCode.created ||
          response.statusCode == SuccessStatusCode.ok) {
        handleApiResponse(response);
        return right(null);
      }

      throw Exception('Failed to create nominee');
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }

  FutureEither<List<CustomerNomineeModel>> getNomineesByCustomerId() async {
    try {
      final response = await dio.get(NomineeApis.getByCustomerId);

      if (response.statusCode == SuccessStatusCode.ok) {
        final res = handleApiResponse(response);
        final List<dynamic> nomineesJson = res['data'] as List<dynamic>;
        final nominees = nomineesJson.map((json) {
          return CustomerNomineeModel.fromJson(json as Map<String, dynamic>);
        }).toList();
        return right(nominees);
      }

      throw Exception('Failed to fetch nominees');
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }

  FutureEither<CustomerNomineeModel> getNomineeById({
    required String nomineeId,
  }) async {
    try {
      final response = await dio.get('${NomineeApis.getById}/$nomineeId');

      if (response.statusCode == SuccessStatusCode.ok) {
        final res = handleApiResponse(response);
        final nominee = CustomerNomineeModel.fromJson(res['data']);
        return right(nominee);
      }

      throw Exception('Failed to fetch nominee');
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }

  FutureVoid updateNominee(UpdateNomineeInput input) async {
    try {
      final response = await dio.put(
        '${NomineeApis.update}/${input.nomineeId}',
        data: input.toJson(),
      );

      if (response.statusCode == SuccessStatusCode.ok) {
        handleApiResponse(response);
        return right(null);
      }

      throw Exception('Failed to update nominee');
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }

  FutureVoid deleteNominee({required String nomineeId}) async {
    try {
      final response = await dio.delete('${NomineeApis.delete}/$nomineeId');

      if (response.statusCode == SuccessStatusCode.ok ||
          response.statusCode == SuccessStatusCode.noContent) {
        handleApiResponse(response);
        return right(null);
      }

      throw Exception('Failed to delete nominee');
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }
}
