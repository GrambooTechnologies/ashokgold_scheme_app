import 'package:ashokgold_scheme_app/core/utilities/global_util_functions.dart';

class SchemePaymentRuleModel {
  final String ruleId;
  final String schemeId;
  final double minAmount;
  final double maxAmount;
  final int allowedAdvanceMonths;
  final int gracePeriodDays;
  final double amountInterval;
  final double penaltyRate;
  final String paymentFrequency;
  final String status;
  final String? createdAt;
  final String? updatedAt;

  SchemePaymentRuleModel({
    required this.ruleId,
    required this.schemeId,
    required this.minAmount,
    required this.maxAmount,
    required this.amountInterval,
    required this.allowedAdvanceMonths,
    required this.gracePeriodDays,
    required this.penaltyRate,
    required this.paymentFrequency,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory SchemePaymentRuleModel.fromJson(Map<String, dynamic> json) {
    return SchemePaymentRuleModel(
      ruleId: json['ruleId'] as String,
      schemeId: json['schemeId'] as String,
      minAmount: toDouble(json['minAmount']),
      maxAmount: toDouble(json['maxAmount']),
      allowedAdvanceMonths: json['allowedAdvanceMonths'] as int,
      gracePeriodDays: json['gracePeriodDays'] as int,
      amountInterval: toDouble(json['amountInterval']),
      penaltyRate: toDouble(json['penaltyRate']),
      paymentFrequency: json['paymentFrequency'] ?? "---",
      status: json['status'] as String,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ruleId': ruleId,
      'schemeId': schemeId,
      'minAmount': minAmount,
      'maxAmount': maxAmount,
      'allowedAdvanceMonths': allowedAdvanceMonths,
      'gracePeriodDays': gracePeriodDays,
      'penaltyRate': penaltyRate,
      'paymentFrequency': paymentFrequency,
      'amountInterval': amountInterval,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  SchemePaymentRuleModel copyWith({
    String? ruleId,
    String? schemeId,
    double? minAmount,
    double? maxAmount,
    int? allowedAdvanceMonths,
    int? gracePeriodDays,
    double? penaltyRate,
    String? paymentFrequency,
    double? amountInterval,
    String? status,
    String? createdAt,
    String? updatedAt,
  }) {
    return SchemePaymentRuleModel(
      ruleId: ruleId ?? this.ruleId,
      schemeId: schemeId ?? this.schemeId,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
      allowedAdvanceMonths: allowedAdvanceMonths ?? this.allowedAdvanceMonths,
      gracePeriodDays: gracePeriodDays ?? this.gracePeriodDays,
      penaltyRate: penaltyRate ?? this.penaltyRate,
      paymentFrequency: paymentFrequency ?? this.paymentFrequency,
      amountInterval: amountInterval ?? this.amountInterval,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
