import 'package:ashokgold_scheme_app/core/custom_widgets/custom_snackBar.dart';
import 'package:ashokgold_scheme_app/features/scheme_payment_entry/models/input_models/installment_payment_input.dart';
import 'package:ashokgold_scheme_app/features/scheme_payment_entry/models/installment_payment_response.dart';
import 'package:ashokgold_scheme_app/features/scheme_payment_entry/repository/scheme_payment_entry_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final schemePaymentEntryControllerProvider =
    NotifierProvider<SchemePaymentEntryController, bool>(
      () => SchemePaymentEntryController(),
    );

class SchemePaymentEntryController extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  Future<InstallmentPaymentResponse?> initiateInstallmentPayment({
    required String joinId,
    required double amount,
    required BuildContext context,
    String? description,
  }) async {
    state = true;
    final repository = ref.read(schemePaymentEntryRepositoryProvider);
    final result = await repository.initiateInstallmentPayment(
      joinId: joinId,
      amount: amount,
      description: description,
    );

    state = false;

    return result.fold((failure) {
      context.showErrorSnackBar(failure.errMSg);
      return null;
    }, (paymentResponse) => paymentResponse);
  }

  Future<bool> createInstallmentPayment(InstallmentPaymentInput input) async {
    state = true;
    final repository = ref.read(schemePaymentEntryRepositoryProvider);
    final result = await repository.createInstallmentPayment(input);

    state = false;
    return result.fold((failure) => false, (_) => true);
  }
}
