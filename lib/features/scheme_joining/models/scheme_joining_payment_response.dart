import 'package:ashokgold_scheme_app/core/utilities/global_util_functions.dart';

class SchemeJoiningPaymentResponse {
  final String paymentUrl;
  final String orderId;
  final double amount;

  SchemeJoiningPaymentResponse({
    required this.paymentUrl,
    required this.orderId,
    required this.amount,
  });

  factory SchemeJoiningPaymentResponse.fromJson(Map<String, dynamic> json) {
    return SchemeJoiningPaymentResponse(
      paymentUrl: json['paymentUrl'] as String,
      orderId: json['orderId'] as String,
      amount: toDouble(json['amount']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'paymentUrl': paymentUrl, 'orderId': orderId, 'amount': amount};
  }

  SchemeJoiningPaymentResponse copyWith({
    String? paymentUrl,
    String? orderId,
    double? amount,
  }) {
    return SchemeJoiningPaymentResponse(
      paymentUrl: paymentUrl ?? this.paymentUrl,
      orderId: orderId ?? this.orderId,
      amount: amount ?? this.amount,
    );
  }
}
