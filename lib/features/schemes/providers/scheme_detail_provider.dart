import 'package:ashokgold_scheme_app/features/schemes/models/scheme_detail_response_model.dart';
import 'package:ashokgold_scheme_app/features/schemes/providers/selected_payment_amount_provider.dart';
import 'package:ashokgold_scheme_app/features/schemes/repository/scheme_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for fetching a single scheme by ID
final schemeDetailProvider =
    AutoDisposeAsyncNotifierProvider.family<
      SchemeDetailNotifier,
      SchemeDetailByIdResponseModel,
      String
    >(SchemeDetailNotifier.new);

class SchemeDetailNotifier
    extends
        AutoDisposeFamilyAsyncNotifier<SchemeDetailByIdResponseModel, String> {
  @override
  Future<SchemeDetailByIdResponseModel> build(String schemeId) async {
    final repository = ref.watch(schemeRepositoryProvider);
    final result = await repository.getSchemeById(schemeId);

    return result.fold((failure) => throw Exception(failure.errMSg), (scheme) {
      ref
          .read(selectedPaymentAmountProvider.notifier)
          .setAmount(scheme.paymentRules?.minAmount ?? 0.0);

      return scheme;
    });
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build(arg));
  }
}
