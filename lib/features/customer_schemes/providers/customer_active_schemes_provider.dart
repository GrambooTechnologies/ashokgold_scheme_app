import 'package:ashokgold_scheme_app/features/customer_schemes/models/customer_joined_active_scheme_response.dart';
import 'package:ashokgold_scheme_app/features/customer_schemes/repository/customer_schemes_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final customerJoinedActiveSchemesProvider =
    AutoDisposeAsyncNotifierProvider<
      CustomerJoinedActiveSchemesNotifier,
      List<CustomerJoinedActiveSchemeResponse>
    >(() => CustomerJoinedActiveSchemesNotifier());

class CustomerJoinedActiveSchemesNotifier
    extends AutoDisposeAsyncNotifier<List<CustomerJoinedActiveSchemeResponse>> {
  @override
  Future<List<CustomerJoinedActiveSchemeResponse>> build() async {
    return fetchCustomerJoinedActiveSchemes();
  }

  Future<List<CustomerJoinedActiveSchemeResponse>>
  fetchCustomerJoinedActiveSchemes() async {
    final repository = ref.read(customerSchemesRepositoryProvider);
    final result = await repository.getCustomerJoinedActiveSchemes();

    return result.fold(
      (failure) => throw Exception(failure.errMSg),
      (schemes) => schemes,
    );
  }
}
