import 'package:flutter_riverpod/flutter_riverpod.dart';

final paymentGatewayControllerProvider =
    NotifierProvider<PaymentGatewayController, bool>(
  () => PaymentGatewayController(),
);

class PaymentGatewayController extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }
}
