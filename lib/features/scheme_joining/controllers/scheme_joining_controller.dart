import 'package:ashokgold_scheme_app/core/custom_widgets/custom_snackBar.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/models/input_models/join_scheme_input.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/models/input_models/validate_amount_input.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/models/scheme_joining_payment_response.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/repository/scheme_joining_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final schemeJoiningControllerProvider =
    NotifierProvider<SchemeJoiningController, bool>(
      () => SchemeJoiningController(),
    );

class SchemeJoiningController extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  Future<bool> validateInitialInstallmentAmount({
    required String schemeId,
    required double installmentAmount,
    required int branchId,
    required BuildContext context,
  }) async {
    state = true;

    final input = ValidateInitialInstallmentAmountInput(
      schemeId: schemeId,
      installmentAmount: installmentAmount,
      branchId: branchId,
    );

    final res = await ref
        .read(schemeJoiningRepositoryProvider)
        .validateInitialInstallmentAmount(input);

    state = false;

    return res.fold(
      (failure) {
        context.showErrorSnackBar(failure.errMSg);
        return false;
      },
      (response) {
        context.showSuccessSnackBar('Amount validated successfully!');
        return true;
      },
    );
  }

  Future<SchemeJoiningPaymentResponse?> joinScheme({
    required JoinSchemeInput input,
    required BuildContext context,
  }) async {
    state = true;

    final res = await ref
        .read(schemeJoiningRepositoryProvider)
        .joinScheme(input);

    state = false;

    return res.fold(
      (failure) {
        context.showErrorSnackBar(failure.errMSg);
        return null;
      },
      (paymentResponse) {
        // Don't invalidate here - will invalidate after successful payment
        // ref.invalidate(customerJoinedSchemesProvider);
        return paymentResponse;
      },
    );
  }
}
