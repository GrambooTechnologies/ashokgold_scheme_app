import 'package:ashokgold_scheme_app/features/customer_schemes/models/customer_joined_active_scheme_detail_response.dart';
import 'package:ashokgold_scheme_app/features/customer_schemes/repository/customer_schemes_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final customerJoinedActiveSchemeDetailProvider = FutureProvider.autoDispose
    .family<CustomerJoinedActiveSchemeDetailResponse, String>((
      ref,
      joinId,
    ) async {
      final repository = ref.watch(customerSchemesRepositoryProvider);
      final result = await repository.getCustomerJoinedActiveSchemeDetail(
        joinId,
      );

      return result.fold(
        (failure) => throw Exception(failure.errMSg),
        (schemeDetail) => schemeDetail,
      );
    });
