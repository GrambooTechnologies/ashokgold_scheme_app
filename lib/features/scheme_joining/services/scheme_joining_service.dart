import 'package:ashokgold_scheme_app/features/home/views/bottom_nav.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/controllers/scheme_joining_controller.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/providers/form_controllers_provider.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/providers/scheme_joining_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Use regular Provider (not autoDispose) since this service needs to stay alive
// while coordinating autoDispose providers during the entire flow
final schemeJoiningServiceProvider = Provider<SchemeJoiningService>(
  (ref) => SchemeJoiningService(ref),
);

class SchemeJoiningService {
  final Ref _ref;

  SchemeJoiningService(this._ref);

  /// Validates the installment amount with the backend
  Future<bool> validateInitialInstallmentAmount({
    required String schemeId,
    required BuildContext context,
  }) async {
    final controllers = _ref.read(formControllersProvider);
    final amount = controllers.installmentAmount;

    final formState = _ref.read(schemeJoiningFormProvider);
    final preferredBranchId = formState.selectedBranch?.branchId;

    _ref.read(schemeJoiningFormProvider.notifier).setInstallmentAmount(amount);

    return await _ref
        .read(schemeJoiningControllerProvider.notifier)
        .validateInitialInstallmentAmount(
          schemeId: schemeId,
          installmentAmount: amount,
          branchId: preferredBranchId!,
          context: context,
        );
  }

  /// Submits the scheme joining request
  Future<bool> submitJoinScheme({
    required String schemeId,
    required BuildContext context,
  }) async {
    final controllers = _ref.read(formControllersProvider);
    final addressData = controllers.getBillingAddressData();

    // Update billing address in form state
    _ref
        .read(schemeJoiningFormProvider.notifier)
        .updateBillingAddress(
          addressLine1: addressData.addressLine1,
          addressLine2: addressData.addressLine2,
          city: addressData.city,
          state: addressData.state,
          postalCode: addressData.postalCode,
          country: addressData.country,
        );

    final formState = _ref.read(schemeJoiningFormProvider);
    final input = formState.toJoinSchemeInput(schemeId);

    final paymentResponse = await _ref
        .read(schemeJoiningControllerProvider.notifier)
        .joinScheme(input: input, context: context);

    if (paymentResponse != null) {
      // Navigate to payment webview
      if (context.mounted) {
        context.push(
          '/payment-webview',
          extra: {
            'paymentUrl': paymentResponse.paymentUrl,
            'orderId': paymentResponse.orderId,
            'joinId': '', // Not available yet, will be created after payment
            // 'schemeName': paymentResponse.schemeName,
            'amount': paymentResponse.amount.toString(),
            'isSchemeJoining': true,
          },
        );
      }
      return true;
    }

    return false;
  }

  /// Handles navigation to home after successful submission
  void navigateToHome(BuildContext context) {
    context.go(BottomNav.routeName);
  }

  /// Advances to the next page
  void nextPage() {
    _ref.read(schemeJoiningFormProvider.notifier).nextPage();
  }

  /// Goes back to the previous page
  void previousPage() {
    _ref.read(schemeJoiningFormProvider.notifier).previousPage();
  }

  /// Gets the current page number
  int get currentPage => _ref.read(schemeJoiningFormProvider).currentPage;
}
