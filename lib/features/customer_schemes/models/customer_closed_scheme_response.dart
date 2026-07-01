import 'package:ashokgold_scheme_app/core/utilities/global_util_functions.dart';

class CustomerClosedSchemeResponse {
  final String closingId;
  final String closingNo;
  final String closingDate;
  final ClosedSchemeInfo scheme;
  final ClosedSchemeProgress progress;
  final ClosingDetails closingDetails;
  final ClosingPaymentDetails paymentDetails;
  final ClosedSchemeCustomerInfo customer;

  CustomerClosedSchemeResponse({
    required this.closingId,
    required this.closingNo,
    required this.closingDate,
    required this.scheme,
    required this.progress,
    required this.closingDetails,
    required this.paymentDetails,
    required this.customer,
  });

  factory CustomerClosedSchemeResponse.fromJson(Map<String, dynamic> json) {
    return CustomerClosedSchemeResponse(
      closingId: json['closingId'] as String,
      closingNo: json['closingNo'] as String,
      closingDate: json['closingDate'] as String,
      scheme: ClosedSchemeInfo.fromJson(json['scheme'] as Map<String, dynamic>),
      progress: ClosedSchemeProgress.fromJson(
        json['progress'] as Map<String, dynamic>,
      ),
      closingDetails: ClosingDetails.fromJson(
        json['closingDetails'] as Map<String, dynamic>,
      ),
      paymentDetails: ClosingPaymentDetails.fromJson(
        json['paymentDetails'] as Map<String, dynamic>,
      ),
      customer: ClosedSchemeCustomerInfo.fromJson(
        json['customer'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'closingId': closingId,
      'closingNo': closingNo,
      'closingDate': closingDate,
      'scheme': scheme.toJson(),
      'progress': progress.toJson(),
      'closingDetails': closingDetails.toJson(),
      'paymentDetails': paymentDetails.toJson(),
      'customer': customer.toJson(),
    };
  }
}

class ClosedSchemeInfo {
  final String joinId;
  final String joinNo;
  final String joinDate;
  final String schemeId;
  final String schemeName;
  final String schemeCode;
  final ClosedSchemeTypeInfo schemeType;
  final ClosedSchemeGroupInfo schemeGroup;
  final String? imageUrl;
  final bool convWt;

  ClosedSchemeInfo({
    required this.joinId,
    required this.joinNo,
    required this.joinDate,
    required this.schemeId,
    required this.schemeName,
    required this.schemeCode,
    required this.schemeType,
    required this.schemeGroup,
    this.imageUrl,
    required this.convWt,
  });

  factory ClosedSchemeInfo.fromJson(Map<String, dynamic> json) {
    return ClosedSchemeInfo(
      joinId: json['joinId'] as String,
      joinNo: json['joinNo'] as String,
      joinDate: json['joinDate'] as String,
      schemeId: json['schemeId'] as String,
      schemeName: json['schemeName'] as String,
      schemeCode: json['schemeCode'] as String,
      schemeType: ClosedSchemeTypeInfo.fromJson(
        json['schemeType'] as Map<String, dynamic>,
      ),
      schemeGroup: ClosedSchemeGroupInfo.fromJson(
        json['schemeGroup'] as Map<String, dynamic>,
      ),
      imageUrl: json['imageUrl'] as String?,
      convWt: json['conWt'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'joinId': joinId,
      'joinNo': joinNo,
      'joinDate': joinDate,
      'schemeId': schemeId,
      'schemeName': schemeName,
      'schemeCode': schemeCode,
      'schemeType': schemeType.toJson(),
      'schemeGroup': schemeGroup.toJson(),
      'imageUrl': imageUrl,
      'conWt': convWt,
    };
  }
}

class ClosingDetails {
  final String? closingType;
  final double? goldRate;
  final double? paidAmount;
  final double? benefitAmount;
  final double? paidWt;
  final double? benefitWt;
  final double? closingWt;
  final double? closingAmount;

  ClosingDetails({
    this.closingType,
    this.goldRate,
    this.paidAmount,
    this.benefitAmount,
    this.paidWt,
    this.benefitWt,
    this.closingWt,
    this.closingAmount,
  });

  factory ClosingDetails.fromJson(Map<String, dynamic> json) {
    return ClosingDetails(
      closingType: json['closingType'] as String?,
      goldRate: toDoubleOrNull(json['goldRate']),
      paidAmount: toDoubleOrNull(json['paidAmount']),
      benefitAmount: toDoubleOrNull(json['benefitAmount']),
      paidWt: toDoubleOrNull(json['paidWt']),
      benefitWt: toDoubleOrNull(json['benefitWt']),
      closingWt: toDoubleOrNull(json['closingWt']),
      closingAmount: toDoubleOrNull(json['closingAmount']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'closingType': closingType,
      'goldRate': goldRate,
      'paidAmount': paidAmount,
      'benefitAmount': benefitAmount,
      'paidWt': paidWt,
      'benefitWt': benefitWt,
      'closingWt': closingWt,
      'closingAmount': closingAmount,
    };
  }
}

class ClosingPaymentDetails {
  final double? totalDepositAmount;
  final double? totalGst;
  final double? cgst;
  final double? sgst;
  final double? igst;
  final String? transType;

  ClosingPaymentDetails({
    this.totalDepositAmount,
    this.totalGst,
    this.cgst,
    this.sgst,
    this.igst,
    this.transType,
  });

  factory ClosingPaymentDetails.fromJson(Map<String, dynamic> json) {
    return ClosingPaymentDetails(
      totalDepositAmount: toDoubleOrNull(json['totalDepositAmount']),
      totalGst: toDoubleOrNull(json['totalGst']),
      cgst: toDoubleOrNull(json['cgst']),
      sgst: toDoubleOrNull(json['sgst']),
      igst: toDoubleOrNull(json['igst']),
      transType: json['transType'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalDepositAmount': totalDepositAmount,
      'totalGst': totalGst,
      'cgst': cgst,
      'sgst': sgst,
      'igst': igst,
      'transType': transType,
    };
  }
}

class ClosedSchemeTypeInfo {
  final String schemeTypeId;
  final String schemeTypeName;

  ClosedSchemeTypeInfo({
    required this.schemeTypeId,
    required this.schemeTypeName,
  });

  factory ClosedSchemeTypeInfo.fromJson(Map<String, dynamic> json) {
    return ClosedSchemeTypeInfo(
      schemeTypeId: json['schemeTypeId'] as String,
      schemeTypeName: json['schemeTypeName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'schemeTypeId': schemeTypeId, 'schemeTypeName': schemeTypeName};
  }
}

class ClosedSchemeGroupInfo {
  final String schemeGroupId;
  final String schemeGroupName;

  ClosedSchemeGroupInfo({
    required this.schemeGroupId,
    required this.schemeGroupName,
  });

  factory ClosedSchemeGroupInfo.fromJson(Map<String, dynamic> json) {
    return ClosedSchemeGroupInfo(
      schemeGroupId: json['schemeGroupId'] as String,
      schemeGroupName: json['schemeGroupName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'schemeGroupId': schemeGroupId, 'schemeGroupName': schemeGroupName};
  }
}

class ClosedSchemeProgress {
  final int numberOfInstallmentsPaid;
  final double totalPaid;
  final double totalAccumulatedGoldWeight;

  ClosedSchemeProgress({
    required this.numberOfInstallmentsPaid,
    required this.totalPaid,
    required this.totalAccumulatedGoldWeight,
  });

  factory ClosedSchemeProgress.fromJson(Map<String, dynamic> json) {
    return ClosedSchemeProgress(
      numberOfInstallmentsPaid: toInt(json['numberOfInstallmentsPaid']),
      totalPaid: toDouble(json['totalPaid']),
      totalAccumulatedGoldWeight: toDouble(json['totalAccumulatedGoldWeight']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numberOfInstallmentsPaid': numberOfInstallmentsPaid,
      'totalPaid': totalPaid,
      'totalAccumulatedGoldWeight': totalAccumulatedGoldWeight,
    };
  }
}

class ClosedSchemeCustomerInfo {
  final String customerId;
  final String customerName;
  final String customerPhone;

  ClosedSchemeCustomerInfo({
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
  });

  factory ClosedSchemeCustomerInfo.fromJson(Map<String, dynamic> json) {
    return ClosedSchemeCustomerInfo(
      customerId: json['customerId'] as String,
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
    };
  }
}
