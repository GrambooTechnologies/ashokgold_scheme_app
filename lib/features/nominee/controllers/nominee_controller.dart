import 'package:ashokgold_scheme_app/core/custom_widgets/custom_snackBar.dart';
import 'package:ashokgold_scheme_app/features/auth/providers/customer_provider.dart';
import 'package:ashokgold_scheme_app/features/nominee/models/create_nominee_input.dart';
import 'package:ashokgold_scheme_app/features/nominee/models/update_nominee_input.dart';
import 'package:ashokgold_scheme_app/features/nominee/providers/nominee_provider.dart';
import 'package:ashokgold_scheme_app/features/nominee/repository/nominee_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final nomineeControllerProvider = NotifierProvider<NomineeController, bool>(
  () => NomineeController(),
);

class NomineeController extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  Future<void> createNominee({
    required String nomineeName,
    required String nomineeRelationId,
    String? nomineeMobile,
    required BuildContext context,
  }) async {
    state = true;

    final customer = ref.read(customerProvider);
    if (customer == null) {
      state = false;
      context.showErrorSnackBar('Customer not found');
      return;
    }

    final input = CreateNomineeInput(
      customerId: customer.customerId,
      nomineeName: nomineeName,
      nomineeRelationId: nomineeRelationId,
      nomineeMobile: nomineeMobile,
    );

    final res = await ref.read(nomineeRepositoryProvider).createNominee(input);

    state = false;
    res.fold(
      (failure) {
        context.showErrorSnackBar(failure.errMSg);
      },
      (nominee) {
        ref.invalidate(nomineeListProvider);
        context.showSuccessSnackBar('Nominee added successfully!');
        context.pop();
      },
    );
  }

  Future<void> updateNominee({
    required String nomineeId,
    required String nomineeName,
    required String nomineeRelationId,
    String? nomineeMobile,
    required BuildContext context,
  }) async {
    state = true;

    final input = UpdateNomineeInput(
      nomineeId: nomineeId,
      nomineeName: nomineeName,
      nomineeRelationId: nomineeRelationId,
      nomineeMobile: nomineeMobile,
    );

    final res = await ref.read(nomineeRepositoryProvider).updateNominee(input);

    state = false;
    res.fold(
      (failure) {
        context.showErrorSnackBar(failure.errMSg);
      },
      (updatedNominee) {
        ref.invalidate(nomineeListProvider);
        context.showSuccessSnackBar('Nominee updated successfully!');
        context.pop();
      },
    );
  }

  Future<void> deleteNominee({
    required String nomineeId,
    required BuildContext context,
  }) async {
    state = true;

    final res = await ref
        .read(nomineeRepositoryProvider)
        .deleteNominee(nomineeId: nomineeId);

    state = false;
    res.fold(
      (failure) {
        context.showErrorSnackBar(failure.errMSg);
      },
      (message) {
        ref.invalidate(nomineeListProvider);
        context.showSuccessSnackBar('Nominee deleted successfully!');
      },
    );
  }
}
