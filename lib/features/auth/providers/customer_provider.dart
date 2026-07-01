import 'package:ashokgold_scheme_app/features/auth/models/customer_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final customerProvider =
    StateNotifierProvider<CustomerNotifier, CustomerModel?>((ref) {
      return CustomerNotifier();
    });

class CustomerNotifier extends StateNotifier<CustomerModel?> {
  CustomerNotifier() : super(null);

  void setCustomer(CustomerModel customer) {
    state = customer;
  }

  void clearCustomer() {
    state = null;
  }

  void updateCustomer(CustomerModel customer) {
    state = customer;
  }
}
