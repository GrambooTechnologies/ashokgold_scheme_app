class PaymentTriesItemModel {
  final String paymentOrderId;
  final String orderId;
  final double amount;
  final String orderStatus;
  final String? gatewayType;
  final String? transactionId;
  final String? responseCode;
  final String? responseMessage;
  final String createdAt;
  final String? updatedAt;
  final String? schemePaymentId;
  final String? vchNo;
  final String? vchDate;
  final String? paymentStatus;

  PaymentTriesItemModel({
    required this.paymentOrderId,
    required this.orderId,
    required this.amount,
    required this.orderStatus,
    required this.gatewayType,
    required this.transactionId,
    required this.responseCode,
    required this.responseMessage,
    required this.createdAt,
    required this.updatedAt,
    required this.schemePaymentId,
    required this.vchNo,
    required this.vchDate,
    required this.paymentStatus,
  });

  factory PaymentTriesItemModel.fromJson(Map<String, dynamic> json) {
    return PaymentTriesItemModel(
      paymentOrderId: json['paymentOrderId'] as String,
      orderId: json['orderId'] as String,
      amount: _parseDouble(json['amount']),
      orderStatus: json['orderStatus'] as String,
      gatewayType: json['gatewayType'] as String?,
      transactionId: json['transactionId'] as String?,
      responseCode: json['responseCode'] as String?,
      responseMessage: json['responseMessage'] as String?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String?,
      schemePaymentId: json['schemePaymentId'] as String?,
      vchNo: json['vchNo'] as String?,
      vchDate: json['vchDate'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentOrderId': paymentOrderId,
      'orderId': orderId,
      'amount': amount,
      'orderStatus': orderStatus,
      'gatewayType': gatewayType,
      'transactionId': transactionId,
      'responseCode': responseCode,
      'responseMessage': responseMessage,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'schemePaymentId': schemePaymentId,
      'vchNo': vchNo,
      'vchDate': vchDate,
      'paymentStatus': paymentStatus,
    };
  }
}
