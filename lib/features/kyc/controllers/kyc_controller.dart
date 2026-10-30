import 'package:ashokgold_scheme_app/core/custom_widgets/custom_snackBar.dart';
import 'package:ashokgold_scheme_app/features/auth/providers/customer_provider.dart';
import 'package:ashokgold_scheme_app/features/kyc/models/customer_kyc_model.dart';
import 'package:ashokgold_scheme_app/features/kyc/models/kyc_status.dart';
import 'package:ashokgold_scheme_app/features/kyc/models/kyc_submit_input.dart';
import 'package:ashokgold_scheme_app/features/kyc/repository/kyc_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KycController extends StateNotifier<AsyncValue<CustomerKycModel?>> {
  final Ref ref;

  KycController({required this.ref}) : super(const AsyncValue.loading());

  Future<void> fetchKycStatus(String customerId) async {
    // If we already have loaded data and just fetching background update, don't flash loading
    if (!state.hasValue) {
      state = const AsyncValue.loading();
    }

    final res = await ref
        .read(kycRepositoryProvider)
        .getKycStatus(customerId: customerId);

    res.fold(
      (failure) {
        state = AsyncValue.error(failure.errMSg, StackTrace.current);
      },
      (kyc) {
        state = AsyncValue.data(kyc);
        _syncCustomerWithKyc(kyc);
      },
    );
  }

  Future<CustomerKycModel?> submitKyc({
    required KycSubmitInput input,
    required BuildContext context,
  }) async {
    state = const AsyncValue.loading();

    final res = await ref.read(kycRepositoryProvider).submitKyc(input: input);

    return res.fold(
      (failure) {
        state = AsyncValue.error(failure.errMSg, StackTrace.current);
        if (context.mounted) {
          context.showErrorSnackBar(failure.errMSg);
        }
        return null;
      },
      (kyc) {
        state = AsyncValue.data(kyc);
        _syncCustomerWithKyc(kyc);
        if (context.mounted) {
          context.showSuccessSnackBar(
            input.isResubmission
                ? 'Documents resubmitted successfully for review!'
                : 'KYC documents submitted successfully for review!',
          );
        }
        return kyc;
      },
    );
  }

  Future<bool> adminReview({
    required String customerId,
    required KycStatus status,
    String? adminNote,
    String? reviewedBy,
    required BuildContext context,
  }) async {
    state = const AsyncValue.loading();

    final res = await ref
        .read(kycRepositoryProvider)
        .adminReview(
          customerId: customerId,
          status: status,
          adminNote: adminNote,
          reviewedBy: reviewedBy,
        );

    return res.fold(
      (failure) {
        state = AsyncValue.error(failure.errMSg, StackTrace.current);
        if (context.mounted) {
          context.showErrorSnackBar(failure.errMSg);
        }
        return false;
      },
      (updated) {
        state = AsyncValue.data(updated);
        _syncCustomerWithKyc(updated);
        if (context.mounted) {
          context.showSuccessSnackBar(
            'KYC status updated to: ${status.displayName}',
          );
        }
        return true;
      },
    );
  }

  void _syncCustomerWithKyc(CustomerKycModel? kyc) {
    if (kyc == null) return;
    final customer = ref.read(customerProvider);
    if (customer != null && customer.customerId == kyc.customerId) {
      final updated = customer.copyWith(
        kycStatus: kyc.status.value,
        kycReferenceId: kyc.referenceId,
      );
      ref.read(customerProvider.notifier).setCustomer(updated);
    }
  }
}
