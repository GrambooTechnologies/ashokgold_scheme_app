import 'package:ashokgold_scheme_app/features/scheme_payment_entry/models/next_installment_details_response.dart';
import 'package:ashokgold_scheme_app/features/scheme_payment_entry/repository/scheme_payment_entry_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final nextInstallmentDetailsProvider =
    AutoDisposeAsyncNotifierProviderFamily<
      NextInstallmentDetailsNotifier,
      NextInstallmentDetailsResponse,
      String
    >(() => NextInstallmentDetailsNotifier());

class NextInstallmentDetailsNotifier
    extends
        AutoDisposeFamilyAsyncNotifier<NextInstallmentDetailsResponse, String> {
  @override
  Future<NextInstallmentDetailsResponse> build(String joinId) async {
    return fetchNextInstallmentDetails(joinId);
  }

  Future<NextInstallmentDetailsResponse> fetchNextInstallmentDetails(
    String joinId,
  ) async {
    final res = await ref
        .read(schemePaymentEntryRepositoryProvider)
        .getNextInstallmentDetails(joinId: joinId);
    return res.fold((l) => throw Exception(l.errMSg), (r) => r);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => fetchNextInstallmentDetails(arg));
  }
}
