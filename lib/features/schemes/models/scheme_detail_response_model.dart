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
    final rawImages = json['images'] ??
        json['schemeImages'] ??
        json['scheme_images'] ??
        json['scheme_image'] ??
        json['schemeImage'] ??
        json['image'];

    List<SchemeImageModel> parsedImages = [];
    String? directImageUrl = (json['imageUrl'] ??
            json['image_url'] ??
            (json['image'] is String ? json['image'] : null))
        ?.toString()
        .trim();

    final topBucket =
        (json['s3Bucket'] ?? json['s3_bucket'] ?? json['bucket'] ?? '')
            .toString()
            .trim();
    final topKey = (json['s3ObjectKey'] ??
            json['s3_object_key'] ??
            json['key'] ??
            '')
        .toString()
        .trim();
    if ((directImageUrl == null || directImageUrl.isEmpty) &&
        topBucket.isNotEmpty &&
        topKey.isNotEmpty) {
      directImageUrl = 'https://$topBucket.s3.ap-south-1.amazonaws.com/$topKey';
    } else if (directImageUrl != null &&
        directImageUrl.isNotEmpty &&
        !directImageUrl.startsWith('http://') &&
        !directImageUrl.startsWith('https://')) {
      if (topBucket.isNotEmpty) {
        directImageUrl =
            'https://$topBucket.s3.ap-south-1.amazonaws.com/$directImageUrl';
      } else {
        directImageUrl =
            'https://gramboo-scheme-storage.s3.ap-south-1.amazonaws.com/$directImageUrl';
      }
    }

    if (rawImages is List) {
      for (final img in rawImages) {
        if (img is Map<String, dynamic>) {
          parsedImages.add(SchemeImageModel.fromJson(img));
        } else if (img is String && img.trim().isNotEmpty) {
          String url = img.trim();
          if (!url.startsWith('http://') && !url.startsWith('https://')) {
            url =
                'https://gramboo-scheme-storage.s3.ap-south-1.amazonaws.com/$url';
          }
          parsedImages.add(
            SchemeImageModel(
              schemeImageId: '',
              s3Bucket: 'gramboo-scheme-storage',
              s3ObjectKey: img,
              imageUrl: url,
              priority: 0,
            ),
          );
        }
      }
    } else if (rawImages is Map<String, dynamic>) {
      parsedImages.add(SchemeImageModel.fromJson(rawImages));
    }

    if (parsedImages.isEmpty &&
        directImageUrl != null &&
        directImageUrl.isNotEmpty) {
      parsedImages.add(
        SchemeImageModel(
          schemeImageId: (json['schemeImageId'] ??
                  json['scheme_image_id'] ??
                  '')
              ?.toString() ??
              '',
          s3Bucket: topBucket,
          s3ObjectKey: topKey,
          imageUrl: directImageUrl,
          priority: 0,
        ),
      );
    }

    final rawType = json['schemeType'] ?? json['scheme_type'] ?? {};
    final rawGroup = json['schemeGroup'] ?? json['scheme_group'] ?? {};
    final rawDetails =
        json['schemeDetails'] ?? json['scheme_details'] ?? json;
    final rawPaymentRules =
        json['paymentRules'] ?? json['payment_rules'];
    final rawBenefits = json['benefitPoints'] ??
        json['benefit_points'] ??
        json['benefits'] ??
        [];
    final rawTerms = json['termsAndConditions'] ??
        json['terms_and_conditions'] ??
        json['terms'] ??
        [];

    return SchemeDetailByIdResponseModel(
      schemeId:
          (json['schemeId'] ?? json['scheme_id'] ?? '').toString(),
      name: (json['name'] ??
              json['schemeName'] ??
              json['scheme_name'] ??
              '')
          .toString(),
      imageUrl: directImageUrl,
      images: parsedImages,
      schemeCode:
          (json['schemeCode'] ?? json['scheme_code'] ?? '').toString(),
      schemeType: rawType is Map<String, dynamic>
          ? SchemeTypeModel.fromJson(rawType)
          : SchemeTypeModel(
              schemeTypeId: '',
              schemeTypeName: rawType.toString(),
            ),
      startDate: (json['startDate'] ?? json['start_date'])?.toString(),
      description:
          (json['description'] ?? json['scheme_description'])?.toString(),
      schemeGroup: rawGroup is Map<String, dynamic>
          ? SchemeGroupModel.fromJson(rawGroup)
          : SchemeGroupModel(
              schemeGroupId: '',
              schemeGroupName: rawGroup.toString(),
            ),
      schemeDetails: rawDetails is Map<String, dynamic>
          ? SchemeDetailsModel.fromJson(rawDetails)
          : SchemeDetailsModel(
              totalAmount: 0,
              installmentAmount: 0,
              installmentCount: 0,
              cancellationCharge: 0,
              refundAmount: 0,
              convWt: false,
            ),
      paymentRules: rawPaymentRules != null &&
              rawPaymentRules is Map<String, dynamic>
          ? PaymentRulesModel.fromJson(rawPaymentRules)
          : null,
      benefitPoints: rawBenefits is List
          ? rawBenefits
              .whereType<Map<String, dynamic>>()
              .map((point) => BenefitPointModel.fromJson(point))
              .toList()
          : [],
      termsAndConditions: rawTerms is List
          ? rawTerms
              .whereType<Map<String, dynamic>>()
              .map((tc) => TermConditionModel.fromJson(tc))
              .toList()
          : [],
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
