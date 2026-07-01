import 'package:ashokgold_scheme_app/features/nominee/models/nominee_model.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/models/preferred_branch_model.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/models/scheme_joining_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final schemeJoiningFormProvider =
    NotifierProvider.autoDispose<SchemeJoiningFormNotifier, SchemeJoiningState>(
      SchemeJoiningFormNotifier.new,
    );

class SchemeJoiningFormNotifier
    extends AutoDisposeNotifier<SchemeJoiningState> {
  @override
  SchemeJoiningState build() {
    // Keep the provider alive during the entire form flow to prevent premature disposal
    ref.keepAlive();
    return SchemeJoiningState(installmentAmount: 0.0);
  }

  void initialize({required double initialAmount}) {
    state = SchemeJoiningState(installmentAmount: initialAmount);
  }

  void nextPage() {
    if (state.currentPage < 3) {
      state = state.copyWith(currentPage: state.currentPage + 1);
    }
  }

  void previousPage() {
    if (state.currentPage > 0) {
      state = state.copyWith(currentPage: state.currentPage - 1);
    }
  }

  void setNominee(CustomerNomineeModel? nominee) {
    state = state.copyWith(selectedNominee: nominee);
  }

  void setBranch(PreferredBranchModel? branch) {
    state = state.copyWith(selectedBranch: branch);
  }

  void setInstallmentAmount(double amount) {
    state = state.copyWith(installmentAmount: amount);
  }

  void setPaymentMethod(String method) {
    state = state.copyWith(paymentMethod: method);
  }

  void updateBillingAddress({
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? postalCode,
    String? country,
  }) {
    this.state = this.state.copyWith(
      addressLine1: addressLine1,
      addressLine2: addressLine2,
      city: city,
      state: state,
      postalCode: postalCode,
      country: country,
    );
  }

  void reset() {
    state = SchemeJoiningState(installmentAmount: 0.0);
  }
}
