class JoinSchemeResponse {
  final String customerSchemeId;
  final String schemeId;
  final String customerId;
  final String status;
  final double totalAmountPaid;
  final String paymentStatus;
  final String? paymentId;
  final DateTime createdAt;

  JoinSchemeResponse({
    required this.customerSchemeId,
    required this.schemeId,
    required this.customerId,
    required this.status,
    required this.totalAmountPaid,
    required this.paymentStatus,
    this.paymentId,
    required this.createdAt,
  });

  factory JoinSchemeResponse.fromJson(Map<String, dynamic> json) {
    return JoinSchemeResponse(
      customerSchemeId: json['customerSchemeId'] as String,
      schemeId: json['schemeId'] as String,
      customerId: json['customerId'] as String,
      status: json['status'] as String,
      totalAmountPaid: (json['totalAmountPaid'] as num).toDouble(),
      paymentStatus: json['paymentStatus'] as String,
      paymentId: json['paymentId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
