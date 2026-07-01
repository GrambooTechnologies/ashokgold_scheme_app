import 'package:ashokgold_scheme_app/core/utilities/global_util_functions.dart';

class CustomerJoinedActiveSchemeDetailResponse {
  final String joinId;
  final String joinNo;
  final String joinDate;
  final String? matureDate;
  final SchemeDetailInfo scheme;
  final ProgressDetailInfo progress;
  final String? nextDueDate;
  final LastPaymentDetailInfo lastPayment;
  final String? remarks;
  final bool isActive;
  final NomineeDetailInfo? nominee;
  final CustomerDetailInfo customer;

  CustomerJoinedActiveSchemeDetailResponse({
    required this.joinId,
    required this.joinNo,
    required this.joinDate,
    this.matureDate,
    required this.scheme,
    required this.progress,
    this.nextDueDate,
    required this.lastPayment,
    this.remarks,
    required this.isActive,
    this.nominee,
    required this.customer,
  });

  factory CustomerJoinedActiveSchemeDetailResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return CustomerJoinedActiveSchemeDetailResponse(
      joinId: json['joinId'] as String,
      joinNo: json['joinNo'] as String,
      joinDate: json['joinDate'] as String,
      matureDate: json['matureDate'] as String?,
      scheme: SchemeDetailInfo.fromJson(json['scheme'] as Map<String, dynamic>),
      progress: ProgressDetailInfo.fromJson(
        json['progress'] as Map<String, dynamic>,
      ),
      nextDueDate: json['nextDueDate'] as String?,
      lastPayment: LastPaymentDetailInfo.fromJson(
        json['lastPayment'] as Map<String, dynamic>,
      ),
      remarks: json['remarks'] as String?,
      isActive: json['isActive'] as bool,
      nominee: json['nominee'] != null
          ? NomineeDetailInfo.fromJson(json['nominee'] as Map<String, dynamic>)
          : null,
      customer: CustomerDetailInfo.fromJson(
        json['customer'] as Map<String, dynamic>,
      ),
    );
  }
}

class SchemeDetailInfo {
  final String schemeId;
  final String schemeName;
  final String schemeCode;
  final SchemeTypeDetailInfo schemeType;
  final SchemeGroupDetailInfo schemeGroup;
  final String? imageUrl;
  final String paymentFrequency;
  final int totalInstallments;
  final double totalSchemeAmount;
  final double benefitAmount;
  final bool convWt;

  SchemeDetailInfo({
    required this.schemeId,
    required this.schemeName,
    required this.schemeCode,
    required this.schemeType,
    required this.schemeGroup,
    this.imageUrl,
    required this.paymentFrequency,
    required this.totalInstallments,
    required this.totalSchemeAmount,
    required this.benefitAmount,
    required this.convWt,
  });

  factory SchemeDetailInfo.fromJson(Map<String, dynamic> json) {
    return SchemeDetailInfo(
      schemeId: json['schemeId'] as String,
      schemeName: json['schemeName'] as String,
      schemeCode: json['schemeCode'] as String,
      schemeType: SchemeTypeDetailInfo.fromJson(
        json['schemeType'] as Map<String, dynamic>,
      ),
      schemeGroup: SchemeGroupDetailInfo.fromJson(
        json['schemeGroup'] as Map<String, dynamic>,
      ),
      imageUrl: json['imageUrl'] as String?,
      paymentFrequency: json['paymentFrequency'] as String,
      totalInstallments: json['totalInstallments'] as int,
      totalSchemeAmount: toDouble(json['totalSchemeAmount']),
      benefitAmount: toDouble(json['benefitAmount']),
      convWt: json['convWt'] as bool,
    );
  }
}

class SchemeTypeDetailInfo {
  final String schemeTypeId;
  final String schemeTypeName;

  SchemeTypeDetailInfo({
    required this.schemeTypeId,
    required this.schemeTypeName,
  });

  factory SchemeTypeDetailInfo.fromJson(Map<String, dynamic> json) {
    return SchemeTypeDetailInfo(
      schemeTypeId: json['schemeTypeId'] as String,
      schemeTypeName: json['schemeTypeName'] as String,
    );
  }
}

class SchemeGroupDetailInfo {
  final String schemeGroupId;
  final String schemeGroupName;

  SchemeGroupDetailInfo({
    required this.schemeGroupId,
    required this.schemeGroupName,
  });

  factory SchemeGroupDetailInfo.fromJson(Map<String, dynamic> json) {
    return SchemeGroupDetailInfo(
      schemeGroupId: json['schemeGroupId'] as String,
      schemeGroupName: json['schemeGroupName'] as String,
    );
  }
}

class ProgressDetailInfo {
  final double totalPaid;
  final double totalAccumulatedGoldWeight;
  final double remainingAmount;
  final double percentComplete;
  final int numberOfInstallmentsPaid;
  final int numberOfInstallmentsRemaining;

  ProgressDetailInfo({
    required this.totalPaid,
    required this.totalAccumulatedGoldWeight,
    required this.remainingAmount,
    required this.percentComplete,
    required this.numberOfInstallmentsPaid,
    required this.numberOfInstallmentsRemaining,
  });

  factory ProgressDetailInfo.fromJson(Map<String, dynamic> json) {
    return ProgressDetailInfo(
      totalPaid: toDouble(json['totalPaid']),
      totalAccumulatedGoldWeight: toDouble(json['totalAccumulatedGoldWeight']),
      remainingAmount: toDouble(json['remainingAmount']),
      percentComplete: toDouble(json['percentComplete']),
      numberOfInstallmentsPaid: toInt(json['numberOfInstallmentsPaid']),
      numberOfInstallmentsRemaining: toInt(
        json['numberOfInstallmentsRemaining'],
      ),
    );
  }
}

class LastPaymentDetailInfo {
  final String? paymentDate;
  final double? paymentAmount;
  final String? paymentMode;

  LastPaymentDetailInfo({
    this.paymentDate,
    this.paymentAmount,
    this.paymentMode,
  });

  factory LastPaymentDetailInfo.fromJson(Map<String, dynamic> json) {
    return LastPaymentDetailInfo(
      paymentDate: json['paymentDate'] as String?,
      paymentAmount: toDoubleOrNull(json['paymentAmount']),
      paymentMode: json['paymentMode'] as String?,
    );
  }
}

class NomineeDetailInfo {
  final String nomineeId;
  final String nomineeName;
  final String nomineeRelationId;
  final String nomineeRelationName;
  final String? nomineeMobile;

  NomineeDetailInfo({
    required this.nomineeId,
    required this.nomineeName,
    required this.nomineeRelationId,
    required this.nomineeRelationName,
    this.nomineeMobile,
  });

  factory NomineeDetailInfo.fromJson(Map<String, dynamic> json) {
    return NomineeDetailInfo(
      nomineeId: json['nomineeId'] as String,
      nomineeName: json['nomineeName'] as String,
      nomineeRelationId: json['nomineeRelationId'] as String,
      nomineeRelationName: json['nomineeRelationName'] as String,
      nomineeMobile: json['nomineeMobile'] as String?,
    );
  }
}

class CustomerDetailInfo {
  final String customerId;
  final String customerName;
  final String customerPhone;

  CustomerDetailInfo({
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
  });

  factory CustomerDetailInfo.fromJson(Map<String, dynamic> json) {
    return CustomerDetailInfo(
      customerId: json['customerId'] as String,
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String,
    );
  }
}
