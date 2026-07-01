import 'package:ashokgold_scheme_app/core/utilities/global_util_functions.dart';
import 'package:ashokgold_scheme_app/features/schemes/models/scheme_model.dart';

class PaymentRulesModel {
  final String ruleId;
  final double minAmount;
  final double maxAmount;
  final int allowedAdvanceMonths;
  final int gracePeriodDays;
  final double penaltyRate;
  final String paymentFrequency;
  final String status;
  final double amountInterval;

  PaymentRulesModel({
    required this.ruleId,
    required this.minAmount,
    required this.maxAmount,
    required this.allowedAdvanceMonths,
    required this.gracePeriodDays,
    required this.penaltyRate,
    required this.paymentFrequency,
    required this.status,
    required this.amountInterval,
  });

  factory PaymentRulesModel.fromJson(Map<String, dynamic> json) {
    return PaymentRulesModel(
      ruleId: json['ruleId'] as String,
      minAmount: toDouble(json['minAmount']),
      maxAmount: toDouble(json['maxAmount']),
      allowedAdvanceMonths: json['allowedAdvanceMonths'] as int,
      gracePeriodDays: json['gracePeriodDays'] as int,
      penaltyRate: toDouble(json['penaltyRate']),
      paymentFrequency: json['paymentFrequency'] as String,
      status: json['status'] as String,
      amountInterval: toDouble(json['amountInterval']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ruleId': ruleId,
      'minAmount': minAmount,
      'maxAmount': maxAmount,
      'allowedAdvanceMonths': allowedAdvanceMonths,
      'gracePeriodDays': gracePeriodDays,
      'penaltyRate': penaltyRate,
      'paymentFrequency': paymentFrequency,
      'status': status,
      'amountInterval': amountInterval,
    };
  }
}

class SchemeDetailByIdResponseModel {
  final String schemeId;
  final String name;
  final String? imageUrl;
  final List<SchemeImageModel> images;
  final String schemeCode;
  final SchemeTypeModel schemeType;
  final String? startDate;
  final String? description;
  final SchemeGroupModel schemeGroup;
  final SchemeDetailsModel schemeDetails;
  final PaymentRulesModel? paymentRules;
  final List<BenefitPointModel> benefitPoints;
  final List<TermConditionModel> termsAndConditions;

  SchemeDetailByIdResponseModel({
    required this.schemeId,
    required this.name,
    this.imageUrl,
    required this.images,
    required this.schemeCode,
    required this.schemeType,
    this.startDate,
    this.description,
    required this.schemeGroup,
    required this.schemeDetails,
    this.paymentRules,
    required this.benefitPoints,
    required this.termsAndConditions,
  });
  SchemeDetailByIdResponseModel copyWith({
    String? name,
    String? description,
    List<SchemeImageModel>? images,
    List<BenefitPointModel>? benefitPoints,
    List<TermConditionModel>? termsAndConditions,
  }) {
    return SchemeDetailByIdResponseModel(
      schemeId: schemeId,
      name: name ?? this.name,
      imageUrl: imageUrl,
      images: images ?? this.images,
      schemeCode: schemeCode,
      schemeType: schemeType,
      startDate: startDate,
      description: description ?? this.description,
      schemeGroup: schemeGroup,
      schemeDetails: schemeDetails,
      paymentRules: paymentRules,
      benefitPoints: benefitPoints ?? this.benefitPoints,
      termsAndConditions: termsAndConditions ?? this.termsAndConditions,
    );
  }

  factory SchemeDetailByIdResponseModel.fromJson(Map<String, dynamic> json) {
    return SchemeDetailByIdResponseModel(
      schemeId: json['schemeId'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      images: (json['images'] as List<dynamic>? ?? [])
          .map((img) => SchemeImageModel.fromJson(img as Map<String, dynamic>))
          .toList(),
      schemeCode: json['schemeCode'] as String,
      schemeType: SchemeTypeModel.fromJson(
        json['schemeType'] as Map<String, dynamic>,
      ),
      startDate: json['startDate'] as String?,
      description: json['description'] as String?,
      schemeGroup: SchemeGroupModel.fromJson(
        json['schemeGroup'] as Map<String, dynamic>,
      ),
      schemeDetails: SchemeDetailsModel.fromJson(
        json['schemeDetails'] as Map<String, dynamic>,
      ),
      paymentRules: json['paymentRules'] != null
          ? PaymentRulesModel.fromJson(
              json['paymentRules'] as Map<String, dynamic>,
            )
          : null,
      benefitPoints: (json['benefitPoints'] as List<dynamic>)
          .map(
            (point) =>
                BenefitPointModel.fromJson(point as Map<String, dynamic>),
          )
          .toList(),
      termsAndConditions: (json['termsAndConditions'] as List<dynamic>? ?? [])
          .map((tc) => TermConditionModel.fromJson(tc as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'schemeId': schemeId,
      'name': name,
      'imageUrl': imageUrl,
      'images': images.map((img) => img.toJson()).toList(),
      'schemeCode': schemeCode,
      'schemeType': schemeType.toJson(),
      'startDate': startDate,
      'description': description,
      'schemeGroup': schemeGroup.toJson(),
      'schemeDetails': schemeDetails.toJson(),
      'paymentRules': paymentRules?.toJson(),
      'benefitPoints': benefitPoints.map((point) => point.toJson()).toList(),
      'termsAndConditions': termsAndConditions
          .map((tc) => tc.toJson())
          .toList(),
    };
  }
}
