import 'package:ashokgold_scheme_app/features/scheme_payment_entry/models/payment_tries_model.dart';
import 'package:ashokgold_scheme_app/features/scheme_payment_entry/repository/scheme_payment_entry_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paymentTriesProvider =
    AutoDisposeAsyncNotifierProviderFamily<
      PaymentTriesNotifier,
      List<PaymentTriesItemModel>,
      String
    >(() => PaymentTriesNotifier());

class PaymentTriesNotifier
    extends
        AutoDisposeFamilyAsyncNotifier<List<PaymentTriesItemModel>, String> {
  @override
  Future<List<PaymentTriesItemModel>> build(String joinId) async {
    return _fetchPaymentTries(joinId);
  }

  Future<List<PaymentTriesItemModel>> _fetchPaymentTries(String joinId) async {
    final res = await ref
        .read(schemePaymentEntryRepositoryProvider)
        .getPaymentTries(joinId: joinId);
    return res.fold((l) => throw Exception(l.errMSg), (r) => r);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchPaymentTries(arg));
  }
}
