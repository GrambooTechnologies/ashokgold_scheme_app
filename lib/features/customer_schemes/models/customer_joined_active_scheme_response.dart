import 'package:ashokgold_scheme_app/core/utilities/global_util_functions.dart';

class CustomerJoinedActiveSchemeResponse {
  final String joinId;
  final String joinNo;
  final String joinDate;
  final String matureDate;
  final SchemeInfo scheme;
  final ProgressInfo progress;
  final String? nextDueDate;
  final LastPaymentInfo lastPayment;
  final String? remarks;
  final bool isActive;

  CustomerJoinedActiveSchemeResponse({
    required this.joinId,
    required this.joinNo,
    required this.joinDate,
    required this.matureDate,
    required this.scheme,
    required this.progress,
    this.nextDueDate,
    required this.lastPayment,
    this.remarks,
    required this.isActive,
  });

  factory CustomerJoinedActiveSchemeResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return CustomerJoinedActiveSchemeResponse(
      joinId: json['joinId'] as String,
      joinNo: json['joinNo'] as String,
      joinDate: json['joinDate'] as String,
      matureDate: json['matureDate'] as String,
      scheme: SchemeInfo.fromJson(json['scheme'] as Map<String, dynamic>),
      progress: ProgressInfo.fromJson(json['progress'] as Map<String, dynamic>),
      nextDueDate: json['nextDueDate'] as String?,
      lastPayment: LastPaymentInfo.fromJson(
        json['lastPayment'] as Map<String, dynamic>,
      ),
      remarks: json['remarks'] as String?,
      isActive: json['isActive'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'joinId': joinId,
      'joinNo': joinNo,
      'joinDate': joinDate,
      'matureDate': matureDate,
      'scheme': scheme.toJson(),
      'progress': progress.toJson(),
      'nextDueDate': nextDueDate,
      'lastPayment': lastPayment.toJson(),
      'remarks': remarks,
      'isActive': isActive,
    };
  }
}

class SchemeInfo {
  final String schemeId;
  final String schemeName;
  final String schemeCode;
  final SchemeTypeInfo schemeType;
  final SchemeGroupInfo schemeGroup;
  final String? imageUrl;
  final String paymentFrequency;
  final int totalInstallments;
  final double totalSchemeAmount;
  final double benefitAmount;
  final bool convWt;

  SchemeInfo({
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

  factory SchemeInfo.fromJson(Map<String, dynamic> json) {
    return SchemeInfo(
      schemeId: json['schemeId'] as String,
      schemeName: json['schemeName'] as String,
      schemeCode: json['schemeCode'] as String,
      schemeType: SchemeTypeInfo.fromJson(
        json['schemeType'] as Map<String, dynamic>,
      ),
      schemeGroup: SchemeGroupInfo.fromJson(
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

  Map<String, dynamic> toJson() {
    return {
      'schemeId': schemeId,
      'schemeName': schemeName,
      'schemeCode': schemeCode,
      'schemeType': schemeType.toJson(),
      'schemeGroup': schemeGroup.toJson(),
      'imageUrl': imageUrl,
      'paymentFrequency': paymentFrequency,
      'totalInstallments': totalInstallments,
      'totalSchemeAmount': totalSchemeAmount,
      'benefitAmount': benefitAmount,
      'convWt': convWt,
    };
  }
}

class SchemeTypeInfo {
  final String schemeTypeId;
  final String schemeTypeName;

  SchemeTypeInfo({required this.schemeTypeId, required this.schemeTypeName});

  factory SchemeTypeInfo.fromJson(Map<String, dynamic> json) {
    return SchemeTypeInfo(
      schemeTypeId: json['schemeTypeId'] as String,
      schemeTypeName: json['schemeTypeName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'schemeTypeId': schemeTypeId, 'schemeTypeName': schemeTypeName};
  }
}

class SchemeGroupInfo {
  final String schemeGroupId;
  final String schemeGroupName;

  SchemeGroupInfo({required this.schemeGroupId, required this.schemeGroupName});

  factory SchemeGroupInfo.fromJson(Map<String, dynamic> json) {
    return SchemeGroupInfo(
      schemeGroupId: json['schemeGroupId'] as String,
      schemeGroupName: json['schemeGroupName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'schemeGroupId': schemeGroupId, 'schemeGroupName': schemeGroupName};
  }
}

class ProgressInfo {
  final double totalPaid;
  final double totalAccumulatedGoldWeight;
  final double remainingAmount;
  final double percentComplete;
  final int numberOfInstallmentsPaid;
  final int numberOfInstallmentsRemaining;

  ProgressInfo({
    required this.totalPaid,
    required this.totalAccumulatedGoldWeight,
    required this.remainingAmount,
    required this.percentComplete,
    required this.numberOfInstallmentsPaid,
    required this.numberOfInstallmentsRemaining,
  });

  factory ProgressInfo.fromJson(Map<String, dynamic> json) {
    return ProgressInfo(
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

  Map<String, dynamic> toJson() {
    return {
      'totalPaid': totalPaid,
      'totalAccumulatedGoldWeight': totalAccumulatedGoldWeight,
      'remainingAmount': remainingAmount,
      'percentComplete': percentComplete,
      'numberOfInstallmentsPaid': numberOfInstallmentsPaid,
      'numberOfInstallmentsRemaining': numberOfInstallmentsRemaining,
    };
  }
}

class LastPaymentInfo {
  final String? paymentDate;
  final double? paymentAmount;
  final String? paymentMode;

  LastPaymentInfo({this.paymentDate, this.paymentAmount, this.paymentMode});

  factory LastPaymentInfo.fromJson(Map<String, dynamic> json) {
    return LastPaymentInfo(
      paymentDate: json['paymentDate'] as String?,
      paymentAmount: toDoubleOrNull(json['paymentAmount']),
      paymentMode: json['paymentMode'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentDate': paymentDate,
      'paymentAmount': paymentAmount,
      'paymentMode': paymentMode,
    };
  }
}
