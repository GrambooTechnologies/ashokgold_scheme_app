import 'package:ashokgold_scheme_app/features/customer_schemes/models/customer_closed_scheme_detail_response.dart';
import 'package:ashokgold_scheme_app/features/customer_schemes/repository/customer_schemes_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final customerClosedSchemeDetailProvider = FutureProvider.autoDispose
    .family<CustomerClosedSchemeDetailResponse, String>((ref, closingId) async {
      final repository = ref.watch(customerSchemesRepositoryProvider);
      final result = await repository.getCustomerClosedSchemeDetail(closingId);

      return result.fold(
        (failure) => throw Exception(failure.errMSg),
        (schemeDetail) => schemeDetail,
      );
    });
