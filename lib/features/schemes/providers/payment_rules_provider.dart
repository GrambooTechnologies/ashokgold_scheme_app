import 'package:ashokgold_scheme_app/features/schemes/models/scheme_payment_rule_model.dart';
import 'package:ashokgold_scheme_app/features/schemes/repository/scheme_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for fetching payment rules by scheme ID
final paymentRulesProvider =
    AutoDisposeAsyncNotifierProvider.family<
      PaymentRulesNotifier,
      SchemePaymentRuleModel,
      String
    >(PaymentRulesNotifier.new);

class PaymentRulesNotifier
    extends AutoDisposeFamilyAsyncNotifier<SchemePaymentRuleModel, String> {
  @override
  Future<SchemePaymentRuleModel> build(String schemeId) async {
    final repository = ref.watch(schemeRepositoryProvider);
    final result = await repository.getPaymentRulesBySchemeId(schemeId);

    return result.fold(
      (failure) => throw Exception(failure.toString()),
      (paymentRule) => paymentRule,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build(arg));
  }
}
