import 'package:ashokgold_scheme_app/features/customer_schemes/models/customer_closed_scheme_response.dart';
import 'package:ashokgold_scheme_app/features/customer_schemes/repository/customer_schemes_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final customerClosedSchemesProvider =
    AutoDisposeAsyncNotifierProvider<
      CustomerClosedSchemesNotifier,
      List<CustomerClosedSchemeResponse>
    >(() => CustomerClosedSchemesNotifier());

class CustomerClosedSchemesNotifier
    extends AutoDisposeAsyncNotifier<List<CustomerClosedSchemeResponse>> {
  @override
  Future<List<CustomerClosedSchemeResponse>> build() async {
    return fetchCustomerClosedSchemes();
  }

  Future<List<CustomerClosedSchemeResponse>>
  fetchCustomerClosedSchemes() async {
    final repository = ref.read(customerSchemesRepositoryProvider);
    final result = await repository.getCustomerClosedSchemes();

    return result.fold(
      (failure) => throw Exception(failure.errMSg),
      (schemes) => schemes,
    );
  }
}
