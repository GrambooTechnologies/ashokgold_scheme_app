import 'package:ashokgold_scheme_app/features/scheme_payment_entry/controllers/scheme_payment_entry_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final installmentPaymentServiceProvider = Provider<InstallmentPaymentService>(
  (ref) => InstallmentPaymentService(ref),
);

class InstallmentPaymentService {
  final Ref _ref;

  InstallmentPaymentService(this._ref);

  /// Initiates installment payment and navigates to payment webview
  Future<bool> initiatePayment({
    required String joinId,
    required double amount,
    required String schemeName,
    required BuildContext context,
  }) async {
    final paymentResponse = await _ref
        .read(schemePaymentEntryControllerProvider.notifier)
        .initiateInstallmentPayment(
          joinId: joinId,
          amount: amount,
          description: '$schemeName - Monthly Installment',
          context: context,
        );

    if (paymentResponse != null) {
      // Navigate to payment webview
      if (context.mounted) {
        context.push(
          '/payment-webview',
          extra: {
            'paymentUrl': paymentResponse.paymentUrl,
            'orderId': paymentResponse.orderId,
            'joinId': joinId,
            'amount': paymentResponse.amount.toString(),
            'isSchemeJoining': false,
          },
        );
      }
      return true;
    }

    return false;
  }
}
