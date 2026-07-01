import 'package:ashokgold_scheme_app/core/api_constants/dropdown_apis.dart';
import 'package:ashokgold_scheme_app/core/error_handling/handleErrors.dart';
import 'package:ashokgold_scheme_app/core/error_handling/type_defs.dart';
import 'package:ashokgold_scheme_app/core/providers/dio_provider.dart';
import 'package:ashokgold_scheme_app/core/utilities/handle_api_response.dart';
import 'package:ashokgold_scheme_app/core/utilities/status_code_constants.dart';
import 'package:ashokgold_scheme_app/features/common/models/pincode_lookup_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final pincodeRepositoryProvider = Provider<PincodeRepository>((ref) {
  return PincodeRepository(dio: ref.watch(dioProvider));
});

class PincodeRepository {
  final Dio dio;

  PincodeRepository({required this.dio});

  FutureEither<PincodeLookupResponse> getPincodeDetails(String pincode) async {
    try {
      final response = await dio.get(DropdownApis.getPincodeLookup(pincode));

      if (response.statusCode == SuccessStatusCode.ok) {
        final res = handleApiResponse(response);
        final pincodeData = PincodeLookupResponse.fromJson(res['data']);
        return right(pincodeData);
      }

      throw Exception('Failed to fetch pincode details');
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }
}
