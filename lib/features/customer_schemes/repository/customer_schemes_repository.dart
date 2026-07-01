import 'package:ashokgold_scheme_app/core/api_constants/customer_schemes_apis.dart';
import 'package:ashokgold_scheme_app/core/error_handling/handleErrors.dart';
import 'package:ashokgold_scheme_app/core/error_handling/type_defs.dart';
import 'package:ashokgold_scheme_app/core/providers/dio_provider.dart';
import 'package:ashokgold_scheme_app/core/utilities/handle_api_response.dart';
import 'package:ashokgold_scheme_app/features/customer_schemes/models/customer_closed_scheme_detail_response.dart';
import 'package:ashokgold_scheme_app/features/customer_schemes/models/customer_closed_scheme_response.dart';
import 'package:ashokgold_scheme_app/features/customer_schemes/models/customer_joined_active_scheme_detail_response.dart';
import 'package:ashokgold_scheme_app/features/customer_schemes/models/customer_joined_active_scheme_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final customerSchemesRepositoryProvider = Provider((ref) {
  return CustomerSchemesRepository(dio: ref.watch(dioProvider));
});

class CustomerSchemesRepository {
  final Dio dio;

  CustomerSchemesRepository({required this.dio});

  FutureEither<List<CustomerJoinedActiveSchemeResponse>>
  getCustomerJoinedActiveSchemes() async {
    try {
      final response = await dio.get(
        CustomerSchemesApis.getCustomerJoinedActiveSchemes,
      );
      final res = handleApiResponse(response);
      final List<dynamic> dataList = res['data'] as List<dynamic>;
      final schemes = dataList.map((json) {
        return CustomerJoinedActiveSchemeResponse.fromJson(
          json as Map<String, dynamic>,
        );
      }).toList();
      return right(schemes);
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }

  FutureEither<CustomerJoinedActiveSchemeDetailResponse>
  getCustomerJoinedActiveSchemeDetail(String joinId) async {
    try {
      final response = await dio.get(
        CustomerSchemesApis.getCustomerJoinedActiveSchemeDetail(joinId),
      );
      final res = handleApiResponse(response);
      final schemeDetail = CustomerJoinedActiveSchemeDetailResponse.fromJson(
        res['data'] as Map<String, dynamic>,
      );
      return right(schemeDetail);
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }

  FutureEither<List<CustomerClosedSchemeResponse>>
  getCustomerClosedSchemes() async {
    try {
      final response = await dio.get(
        CustomerSchemesApis.getCustomerClosedSchemes,
      );
      final res = handleApiResponse(response);
      final List<dynamic> dataList = res['data'] as List<dynamic>;
      final schemes = dataList.map((json) {
        return CustomerClosedSchemeResponse.fromJson(
          json as Map<String, dynamic>,
        );
      }).toList();
      return right(schemes);
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }

  FutureEither<CustomerClosedSchemeDetailResponse>
  getCustomerClosedSchemeDetail(String closingId) async {
    try {
      final response = await dio.get(
        CustomerSchemesApis.getCustomerClosedSchemeDetailByClosingId(closingId),
      );
      final res = handleApiResponse(response);
      final schemeDetail = CustomerClosedSchemeDetailResponse.fromJson(
        res['data'] as Map<String, dynamic>,
      );
      return right(schemeDetail);
    } catch (e, s) {
      return left(handleErrors(e, s));
    }
  }
}
