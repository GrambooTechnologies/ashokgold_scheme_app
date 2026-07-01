import 'package:ashokgold_scheme_app/core/utilities/global_util_functions.dart';

class InstallmentPaymentResponse {
  final String paymentUrl;
  final String orderId;
  final double amount;

  InstallmentPaymentResponse({
    required this.paymentUrl,
    required this.orderId,
    required this.amount,
  });

  factory InstallmentPaymentResponse.fromJson(Map<String, dynamic> json) {
    return InstallmentPaymentResponse(
      paymentUrl: json['paymentUrl'] as String,
      orderId: json['orderId'] as String,
      amount: toDouble(json['amount']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'paymentUrl': paymentUrl, 'orderId': orderId, 'amount': amount};
  }

  InstallmentPaymentResponse copyWith({
    String? paymentUrl,
    String? orderId,
    double? amount,
  }) {
    return InstallmentPaymentResponse(
      paymentUrl: paymentUrl ?? this.paymentUrl,
      orderId: orderId ?? this.orderId,
      amount: amount ?? this.amount,
    );
  }
}
