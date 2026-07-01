import 'package:ashokgold_scheme_app/core/custom_widgets/custom_snackBar.dart';
import 'package:ashokgold_scheme_app/features/auth/providers/customer_provider.dart';
import 'package:ashokgold_scheme_app/features/profile/models/update_customer_input.dart';
import 'package:ashokgold_scheme_app/features/profile/repository/profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final profileControllerProvider = NotifierProvider<ProfileController, bool>(
  () => ProfileController(),
);

class ProfileController extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  Future<void> updateCustomer({
    required String customerId,
    required UpdateCustomerInput input,
    required BuildContext context,
  }) async {
    state = true;

    final res = await ref
        .read(profileRepositoryProvider)
        .updateCustomer(customerId: customerId, input: input);

    state = false;
    res.fold(
      (failure) {
        context.showErrorSnackBar(failure.errMSg);
      },
      (customer) async {
        context.showSuccessSnackBar('Profile updated successfully!');
        ref.read(customerProvider.notifier).setCustomer(customer);
        context.pop();
      },
    );
  }
}
