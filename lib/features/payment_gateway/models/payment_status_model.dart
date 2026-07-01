class PaymentStatusModel {
  final String orderId;
  final String? transactionId;
  final String status;
  final String amount;
  final String? responseCode;
  final String? responseMessage;
  final String updatedAt;

  PaymentStatusModel({
    required this.orderId,
    this.transactionId,
    required this.status,
    required this.amount,
    this.responseCode,
    this.responseMessage,
    required this.updatedAt,
  });

  factory PaymentStatusModel.fromJson(Map<String, dynamic> json) {
    return PaymentStatusModel(
      orderId: json['orderId'] as String,
      transactionId: json['transactionId'] as String?,
      status: json['status'] as String,
      amount: json['amount'] as String,
      responseCode: json['responseCode'] as String?,
      responseMessage: json['responseMessage'] as String?,
      updatedAt: json['updatedAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'transactionId': transactionId,
      'status': status,
      'amount': amount,
      'responseCode': responseCode,
      'responseMessage': responseMessage,
      'updatedAt': updatedAt,
    };
  }

  bool get isSuccess =>
      status.toLowerCase() == 'success' || status.toLowerCase() == 'completed';
  bool get isPending =>
      status.toLowerCase() == 'pending' || status.toLowerCase() == 'processing';
  bool get isFailed =>
      status.toLowerCase() == 'failed' || status.toLowerCase() == 'failure';

  PaymentStatusModel copyWith({
    String? orderId,
    String? transactionId,
    String? status,
    String? amount,
    String? responseCode,
    String? responseMessage,
    String? updatedAt,
  }) {
    return PaymentStatusModel(
      orderId: orderId ?? this.orderId,
      transactionId: transactionId ?? this.transactionId,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      responseCode: responseCode ?? this.responseCode,
      responseMessage: responseMessage ?? this.responseMessage,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
