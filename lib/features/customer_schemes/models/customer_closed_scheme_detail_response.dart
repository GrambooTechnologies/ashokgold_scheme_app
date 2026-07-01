import 'package:ashokgold_scheme_app/core/utilities/global_util_functions.dart';

class CustomerClosedSchemeDetailResponse {
  final String closingId;
  final String closingNo;
  final String closingDate;
  final ClosedSchemeDetailInfo scheme;
  final ClosingDetailDetails closingDetails;
  final ClosingDetailPaymentDetails paymentDetails;
  final ClosedDetailCustomerInfo customer;

  CustomerClosedSchemeDetailResponse({
    required this.closingId,
    required this.closingNo,
    required this.closingDate,
    required this.scheme,
    required this.closingDetails,
    required this.paymentDetails,
    required this.customer,
  });

  factory CustomerClosedSchemeDetailResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return CustomerClosedSchemeDetailResponse(
      closingId: json['closingId'] as String,
      closingNo: json['closingNo'] as String,
      closingDate: json['closingDate'] as String,
      scheme: ClosedSchemeDetailInfo.fromJson(
        json['scheme'] as Map<String, dynamic>,
      ),
      closingDetails: ClosingDetailDetails.fromJson(
        json['closingDetails'] as Map<String, dynamic>,
      ),
      paymentDetails: ClosingDetailPaymentDetails.fromJson(
        json['paymentDetails'] as Map<String, dynamic>,
      ),
      customer: ClosedDetailCustomerInfo.fromJson(
        json['customer'] as Map<String, dynamic>,
      ),
    );
  }
}

class ClosedSchemeDetailInfo {
  final String joinId;
  final String joinNo;
  final String joinDate;
  final String matureDate;
  final String schemeId;
  final String schemeName;
  final String schemeCode;
  final ClosedDetailSchemeTypeInfo schemeType;
  final ClosedDetailSchemeGroupInfo schemeGroup;
  final bool convWt;
  final String? imageUrl;

  ClosedSchemeDetailInfo({
    required this.joinId,
    required this.joinNo,
    required this.joinDate,
    required this.matureDate,
    required this.schemeId,
    required this.schemeName,
    required this.schemeCode,
    required this.schemeType,
    required this.schemeGroup,
    required this.convWt,
    this.imageUrl,
  });

  factory ClosedSchemeDetailInfo.fromJson(Map<String, dynamic> json) {
    return ClosedSchemeDetailInfo(
      joinId: json['joinId'] as String,
      joinNo: json['joinNo'] as String,
      joinDate: json['joinDate'] as String,
      matureDate: json['matureDate'] as String,
      schemeId: json['schemeId'] as String,
      schemeName: json['schemeName'] as String,
      schemeCode: json['schemeCode'] as String,
      schemeType: ClosedDetailSchemeTypeInfo.fromJson(
        json['schemeType'] as Map<String, dynamic>,
      ),
      schemeGroup: ClosedDetailSchemeGroupInfo.fromJson(
        json['schemeGroup'] as Map<String, dynamic>,
      ),
      convWt: json['conWt'] as bool,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}

class ClosingDetailDetails {
  final String? closingType;
  final double? goldRate;
  final double? paidAmount;
  final double? benefitAmount;
  final double? paidWt;
  final double? benefitWt;
  final double? closingWt;
  final double? closingAmount;

  ClosingDetailDetails({
    this.closingType,
    this.goldRate,
    this.paidAmount,
    this.benefitAmount,
    this.paidWt,
    this.benefitWt,
    this.closingWt,
    this.closingAmount,
  });

  factory ClosingDetailDetails.fromJson(Map<String, dynamic> json) {
    return ClosingDetailDetails(
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
}

class ClosingDetailPaymentDetails {
  final double? totalDepositAmount;
  final double? totalGst;
  final double? cgst;
  final double? sgst;
  final double? igst;

  ClosingDetailPaymentDetails({
    this.totalDepositAmount,
    this.totalGst,
    this.cgst,
    this.sgst,
    this.igst,
  });

  factory ClosingDetailPaymentDetails.fromJson(Map<String, dynamic> json) {
    return ClosingDetailPaymentDetails(
      totalDepositAmount: toDoubleOrNull(json['totalDepositAmount']),
      totalGst: toDoubleOrNull(json['totalGst']),
      cgst: toDoubleOrNull(json['cgst']),
      sgst: toDoubleOrNull(json['sgst']),
      igst: toDoubleOrNull(json['igst']),
    );
  }
}

class ClosedDetailSchemeTypeInfo {
  final String schemeTypeId;
  final String schemeTypeName;

  ClosedDetailSchemeTypeInfo({
    required this.schemeTypeId,
    required this.schemeTypeName,
  });

  factory ClosedDetailSchemeTypeInfo.fromJson(Map<String, dynamic> json) {
    return ClosedDetailSchemeTypeInfo(
      schemeTypeId: json['schemeTypeId'] as String,
      schemeTypeName: json['schemeTypeName'] as String,
    );
  }
}

class ClosedDetailSchemeGroupInfo {
  final String schemeGroupId;
  final String schemeGroupName;

  ClosedDetailSchemeGroupInfo({
    required this.schemeGroupId,
    required this.schemeGroupName,
  });

  factory ClosedDetailSchemeGroupInfo.fromJson(Map<String, dynamic> json) {
    return ClosedDetailSchemeGroupInfo(
      schemeGroupId: json['schemeGroupId'] as String,
      schemeGroupName: json['schemeGroupName'] as String,
    );
  }
}

class ClosedDetailCustomerInfo {
  final String customerId;
  final String customerName;
  final String customerPhone;

  ClosedDetailCustomerInfo({
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
  });

  factory ClosedDetailCustomerInfo.fromJson(Map<String, dynamic> json) {
    return ClosedDetailCustomerInfo(
      customerId: json['customerId'] as String,
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String,
    );
  }
}
