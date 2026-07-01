import 'package:ashokgold_scheme_app/features/nominee/models/nominee_model.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/models/input_models/join_scheme_input.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/models/preferred_branch_model.dart';

class SchemeJoiningState {
  final int currentPage;
  final CustomerNomineeModel? selectedNominee;
  final PreferredBranchModel? selectedBranch;
  final double installmentAmount;
  final String paymentMethod;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  SchemeJoiningState({
    this.currentPage = 0,
    this.selectedNominee,
    this.selectedBranch,
    required this.installmentAmount,
    this.paymentMethod = 'CASH',
    this.addressLine1 = '',
    this.addressLine2,
    this.city = '',
    this.state = '',
    this.postalCode = '',
    this.country = 'India',
  });

  SchemeJoiningState copyWith({
    int? currentPage,
    CustomerNomineeModel? selectedNominee,
    PreferredBranchModel? selectedBranch,
    double? installmentAmount,
    String? paymentMethod,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? postalCode,
    String? country,
  }) {
    return SchemeJoiningState(
      currentPage: currentPage ?? this.currentPage,
      // For nullable fields, use the provided value if not null, otherwise keep existing
      selectedNominee: selectedNominee ?? this.selectedNominee,
      selectedBranch: selectedBranch ?? this.selectedBranch,
      installmentAmount: installmentAmount ?? this.installmentAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      addressLine1: addressLine1 ?? this.addressLine1,
      // addressLine2 can be explicitly set to null via an empty string check in the caller
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
    );
  }

  JoinSchemeInput toJoinSchemeInput(String schemeId) {
    if (selectedNominee == null) {
      throw Exception('Nominee must be selected');
    }
    if (selectedBranch == null) {
      throw Exception('Branch must be selected');
    }

    return JoinSchemeInput(
      schemeId: schemeId,
      installmentAmount: installmentAmount,
      paymentMethod: paymentMethod,
      preferredBranchId: selectedBranch!.branchId,
      nomineeId: selectedNominee!.nomineeId,
      billingAddress: Address(
        addressLine1: addressLine1,
        addressLine2: addressLine2?.isEmpty == true ? null : addressLine2,
        city: city,
        state: state,
        postalCode: postalCode,
        country: country,
      ),
    );
  }
}
