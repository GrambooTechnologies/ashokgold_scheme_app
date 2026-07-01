import 'package:ashokgold_scheme_app/core/utilities/global_util_functions.dart';

class SchemeBenefitCalculationModel {
  final String schemeName;
  final String schemeType;
  final int installmentCount;
  final double installmentAmount;
  final double totalAmountPaid;
  final double benefitOffered;
  final double redemptionValue;
  final String benefitDescription;

  SchemeBenefitCalculationModel({
    required this.schemeName,
    required this.schemeType,
    required this.installmentCount,
    required this.installmentAmount,
    required this.totalAmountPaid,
    required this.benefitOffered,
    required this.redemptionValue,
    required this.benefitDescription,
  });

  factory SchemeBenefitCalculationModel.fromJson(Map<String, dynamic> json) {
    return SchemeBenefitCalculationModel(
      schemeName: json['schemeName'] as String,
      schemeType: json['schemeType'] as String,
      installmentCount: json['installmentCount'] ?? 00,
      installmentAmount: toDouble(json['installmentAmount']),
      totalAmountPaid: toDouble(json['totalAmountPaid']),
      benefitOffered: toDouble(json['benefitOffered']),
      redemptionValue: toDouble(json['redemptionValue']),
      benefitDescription: json['benefitDescription'] ?? "--",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'schemeName': schemeName,
      'schemeType': schemeType,
      'installmentCount': installmentCount,
      'installmentAmount': installmentAmount,
      'totalAmountPaid': totalAmountPaid,
      'benefitOffered': benefitOffered,
      'redemptionValue': redemptionValue,
      'benefitDescription': benefitDescription,
    };
  }

  List<String> get benefitPoints {
    return benefitDescription
        .split('\\n')
        .where((point) => point.trim().isNotEmpty)
        .map((point) => point.trim())
        .toList();
  }
}
