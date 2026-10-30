import 'package:ashokgold_scheme_app/features/auth/providers/customer_provider.dart';
import 'package:ashokgold_scheme_app/features/kyc/controllers/kyc_controller.dart';
import 'package:ashokgold_scheme_app/features/kyc/models/customer_kyc_model.dart';
import 'package:ashokgold_scheme_app/features/kyc/models/kyc_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final kycControllerProvider =
    StateNotifierProvider<KycController, AsyncValue<CustomerKycModel?>>((ref) {
      final customer = ref.watch(customerProvider);
      final controller = KycController(ref: ref);
      if (customer != null) {
        controller.fetchKycStatus(customer.customerId);
      }
      return controller;
    });

final kycStatusProvider = Provider<KycStatus>((ref) {
  final kycAsync = ref.watch(kycControllerProvider);
  return kycAsync.maybeWhen(
    data: (kyc) => kyc?.status ?? KycStatus.notSubmitted,
    orElse: () => KycStatus.notSubmitted,
  );
});

final isKycApprovedProvider = Provider<bool>((ref) {
  final status = ref.watch(kycStatusProvider);
  return status == KycStatus.approved;
});
