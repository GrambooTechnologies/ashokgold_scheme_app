class InstallmentPaymentInput {
  final String joinId;
  final String paymentMethod;
  final double installmentAmount;

  InstallmentPaymentInput({
    required this.joinId,
    required this.paymentMethod,
    required this.installmentAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      'joinId': joinId,
      'paymentMethod': paymentMethod,
      'installmentAmount': installmentAmount,
    };
  }
}
