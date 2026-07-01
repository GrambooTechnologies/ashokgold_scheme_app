class PaymentSuccessExtras {
  final String orderId;
  final String joinId;
  final bool isSchemeJoining;
  final String schemeName;
  final String amount;

  const PaymentSuccessExtras({
    required this.orderId,
    this.joinId = '',
    this.isSchemeJoining = false,
    this.schemeName = 'Scheme',
    this.amount = '0',
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'joinId': joinId,
      'isSchemeJoining': isSchemeJoining,
      'schemeName': schemeName,
      'amount': amount,
    };
  }
}

class PaymentFailureExtras {
  final String orderId;
  final String message;

  const PaymentFailureExtras({
    required this.orderId,
    required this.message,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'message': message,
    };
  }
}
