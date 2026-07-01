import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedPaymentAmountProvider =
    AutoDisposeNotifierProvider<SelectedPaymentAmountNotifier, double>(
  () {
    return SelectedPaymentAmountNotifier();
  },
);

class SelectedPaymentAmountNotifier extends AutoDisposeNotifier<double> {
  @override
  double build() {
    ref.keepAlive();
    return 0.0;
  }

  void setAmount(double amount) {
    state = amount;
  }

  void clearAmount() {
    state = 0.0;
  }

  void updateAmount(double amount) {
    state = amount;
  }
}
