import 'package:ashokgold_scheme_app/features/scheme_payment_entry/models/installment_history_model.dart';
import 'package:ashokgold_scheme_app/features/scheme_payment_entry/repository/scheme_payment_entry_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final installmentHistoryProvider =
    AutoDisposeAsyncNotifierProviderFamily<
      InstallmentHistoryNotifier,
      List<InstallmentGroupModel>,
      String
    >(() => InstallmentHistoryNotifier());

class InstallmentHistoryNotifier
    extends
        AutoDisposeFamilyAsyncNotifier<List<InstallmentGroupModel>, String> {
  @override
  Future<List<InstallmentGroupModel>> build(String joinId) async {
    return fetchInstallmentHistory(joinId);
  }

  Future<List<InstallmentGroupModel>> fetchInstallmentHistory(
    String joinId,
  ) async {
    final res = await ref
        .read(schemePaymentEntryRepositoryProvider)
        .getInstallmentHistory(joinId: joinId);
    return res.fold((l) => throw Exception(l.errMSg), (r) => r);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => fetchInstallmentHistory(arg));
  }
}
