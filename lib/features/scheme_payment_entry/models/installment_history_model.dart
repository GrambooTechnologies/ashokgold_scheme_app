class InstallmentEntryItemModel {
  final String paymentId;
  final String vchNo;
  final String vchDate;
  final String paymentMode;
  final String paymentStatus;
  final double paymentAmount;
  final double receivedAmount;
  final double? goldRate;
  final double? goldWeight;
  final double cashPaid;
  final double cardPaid;
  final double upiPaid;
  final double rtgsPaid;
  final double? gst;

  InstallmentEntryItemModel({
    required this.paymentId,
    required this.vchNo,
    required this.vchDate,
    required this.paymentMode,
    required this.paymentStatus,
    required this.paymentAmount,
    required this.receivedAmount,
    required this.goldRate,
    required this.goldWeight,
    required this.cashPaid,
    required this.cardPaid,
    required this.upiPaid,
    required this.rtgsPaid,
    required this.gst,
  });

  factory InstallmentEntryItemModel.fromJson(Map<String, dynamic> json) {
    return InstallmentEntryItemModel(
      paymentId: json['paymentId'] as String,
      vchNo: json['vchNo'] as String,
      vchDate: json['vchDate'] as String,
      paymentMode: json['paymentMode'] as String,
      paymentStatus: json['paymentStatus'] as String,
      paymentAmount: _parseDouble(json['paymentAmount']),
      receivedAmount: _parseDouble(json['receivedAmount']),
      goldRate: _parseNullableDouble(json['goldRate']),
      goldWeight: _parseNullableDouble(json['goldWeight']),
      cashPaid: _parseDouble(json['cashPaid']),
      cardPaid: _parseDouble(json['cardPaid']),
      upiPaid: _parseDouble(json['upiPaid']),
      rtgsPaid: _parseDouble(json['rtgsPaid']),
      gst: _parseNullableDouble(json['gst']),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static double? _parseNullableDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentId': paymentId,
      'vchNo': vchNo,
      'vchDate': vchDate,
      'paymentMode': paymentMode,
      'paymentStatus': paymentStatus,
      'paymentAmount': paymentAmount,
      'receivedAmount': receivedAmount,
      'goldRate': goldRate,
      'goldWeight': goldWeight,
      'cashPaid': cashPaid,
      'cardPaid': cardPaid,
      'upiPaid': upiPaid,
      'rtgsPaid': rtgsPaid,
      'gst': gst,
    };
  }
}

class InstallmentGroupModel {
  final int installmentNumber;
  final double totalAmount;
  final double totalGoldWeight;
  final List<InstallmentEntryItemModel> paymentEntries;

  InstallmentGroupModel({
    required this.installmentNumber,
    required this.totalAmount,
    required this.totalGoldWeight,
    required this.paymentEntries,
  });

  factory InstallmentGroupModel.fromJson(Map<String, dynamic> json) {
    return InstallmentGroupModel(
      installmentNumber: json['installmentNumber'] is int
          ? json['installmentNumber'] as int
          : int.parse(json['installmentNumber'].toString()),
      totalAmount: _parseDouble(json['totalAmount']),
      totalGoldWeight: _parseDouble(json['totalGoldWeight']),
      paymentEntries: (json['paymentEntries'] as List<dynamic>)
          .map((e) =>
              InstallmentEntryItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'installmentNumber': installmentNumber,
      'totalAmount': totalAmount,
      'totalGoldWeight': totalGoldWeight,
      'paymentEntries': paymentEntries.map((e) => e.toJson()).toList(),
    };
  }
}
