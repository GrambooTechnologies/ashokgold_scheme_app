class ValidateInitialInstallmentAmountInput {
  final String schemeId;
  final double installmentAmount;
  final int branchId;

  ValidateInitialInstallmentAmountInput({
    required this.schemeId,
    required this.installmentAmount,
    required this.branchId,
  });

  Map<String, dynamic> toJson() {
    return {
      'schemeId': schemeId,
      'installmentAmount': installmentAmount,
      'branchId': branchId,
    };
  }
}
