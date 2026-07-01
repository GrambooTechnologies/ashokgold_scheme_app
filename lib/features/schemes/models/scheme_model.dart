import 'package:ashokgold_scheme_app/core/utilities/global_util_functions.dart';

class SchemeTypeModel {
  final String schemeTypeId;
  final String schemeTypeName;

  SchemeTypeModel({required this.schemeTypeId, required this.schemeTypeName});

  factory SchemeTypeModel.fromJson(Map<String, dynamic> json) {
    return SchemeTypeModel(
      schemeTypeId: json['schemeTypeId'] as String,
      schemeTypeName: json['schemeTypeName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'schemeTypeId': schemeTypeId, 'schemeTypeName': schemeTypeName};
  }
}

class SchemeImageModel {
  final String schemeImageId;
  final String s3Bucket;
  final String s3ObjectKey;
  final String? imageUrl;
  final int priority;

  SchemeImageModel({
    required this.schemeImageId,
    required this.s3Bucket,
    required this.s3ObjectKey,
    this.imageUrl,
    required this.priority,
  });

  factory SchemeImageModel.fromJson(Map<String, dynamic> json) {
    return SchemeImageModel(
      schemeImageId: json['schemeImageId'] as String,
      s3Bucket: json['s3Bucket'] as String,
      s3ObjectKey: json['s3ObjectKey'] as String,
      imageUrl: json['imageUrl'] as String?,
      priority: json['priority'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'schemeImageId': schemeImageId,
      's3Bucket': s3Bucket,
      's3ObjectKey': s3ObjectKey,
      'imageUrl': imageUrl,
      'priority': priority,
    };
  }
}

class BenefitPointModel {
  final String benefitPointId;
  final String benefitPointDescription;
  final int benefitPointPriority;

  BenefitPointModel({
    required this.benefitPointId,
    required this.benefitPointDescription,
    required this.benefitPointPriority,
  });
  BenefitPointModel copyWith({
    String? benefitPointId,
    String? benefitPointDescription,
    int? benefitPointPriority,
  }) {
    return BenefitPointModel(
      benefitPointId: benefitPointId ?? this.benefitPointId,
      benefitPointDescription:
          benefitPointDescription ?? this.benefitPointDescription,
      benefitPointPriority: benefitPointPriority ?? this.benefitPointPriority,
    );
  }

  factory BenefitPointModel.fromJson(Map<String, dynamic> json) {
    return BenefitPointModel(
      benefitPointId: json['benefitPointId'] as String,
      benefitPointDescription: json['benefitPointDescription'] as String,
      benefitPointPriority: json['benefitPointPriority'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'benefitPointId': benefitPointId,
      'benefitPointDescription': benefitPointDescription,
      'benefitPointPriority': benefitPointPriority,
    };
  }
}

class SchemeGroupModel {
  final String schemeGroupId;
  final String schemeGroupName;

  SchemeGroupModel({
    required this.schemeGroupId,
    required this.schemeGroupName,
  });

  factory SchemeGroupModel.fromJson(Map<String, dynamic> json) {
    return SchemeGroupModel(
      schemeGroupId: json['schemeGroupId'] as String,
      schemeGroupName: json['schemeGroupName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'schemeGroupId': schemeGroupId, 'schemeGroupName': schemeGroupName};
  }
}

class SchemeDetailsModel {
  final double totalAmount;
  final double installmentAmount;
  final int installmentCount;
  final double? benefitAmount;
  final int? minBeneficialMonth;
  final int? minBeneficialInstallment;
  final double cancellationCharge;
  final double refundAmount;
  final bool convWt;
  final String? benefitType;

  SchemeDetailsModel({
    required this.totalAmount,
    required this.installmentAmount,
    required this.installmentCount,
    this.benefitAmount,
    this.minBeneficialMonth,
    this.minBeneficialInstallment,
    required this.cancellationCharge,
    required this.refundAmount,
    required this.convWt,
    this.benefitType,
  });

  factory SchemeDetailsModel.fromJson(Map<String, dynamic> json) {
    return SchemeDetailsModel(
      totalAmount: toDouble(json['totalAmount']),
      installmentAmount: toDouble(json['installmentAmount']),
      installmentCount: json['installmentCount'] as int,
      benefitAmount: toDoubleOrNull(json['benefitAmount']),
      minBeneficialMonth: json['minBeneficialMonth'] as int?,
      minBeneficialInstallment: json['minBeneficialInstallment'] as int?,
      cancellationCharge: toDouble(json['cancellationCharge']),
      refundAmount: toDouble(json['refundAmount']),
      convWt: json['convWt'] as bool,
      benefitType: json['benefitType'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalAmount': totalAmount,
      'installmentAmount': installmentAmount,
      'installmentCount': installmentCount,
      'benefitAmount': benefitAmount,
      'minBeneficialMonth': minBeneficialMonth,
      'minBeneficialInstallment': minBeneficialInstallment,
      'cancellationCharge': cancellationCharge,
      'refundAmount': refundAmount,
      'convWt': convWt,
      'benefitType': benefitType,
    };
  }
}

class TermConditionModel {
  final String termConditionId;
  final String termConditionDescription;
  final int termConditionPriority;

  TermConditionModel({
    required this.termConditionId,
    required this.termConditionDescription,
    required this.termConditionPriority,
  });
  TermConditionModel copyWith({
    String? termConditionId,
    String? termConditionDescription,
    int? termConditionPriority,
  }) {
    return TermConditionModel(
      termConditionId: termConditionId ?? this.termConditionId,
      termConditionDescription:
          termConditionDescription ?? this.termConditionDescription,
      termConditionPriority:
          termConditionPriority ?? this.termConditionPriority,
    );
  }

  factory TermConditionModel.fromJson(Map<String, dynamic> json) {
    return TermConditionModel(
      termConditionId: json['termConditionId'] as String,
      termConditionDescription: json['termConditionDescription'] as String,
      termConditionPriority: json['termConditionPriority'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'termConditionId': termConditionId,
      'termConditionDescription': termConditionDescription,
      'termConditionPriority': termConditionPriority,
    };
  }
}

class SchemeModel {
  final String schemeId;
  final String name;
  final String schemeCode;
  final String? imageUrl;
  final SchemeImageModel? images;
  final SchemeTypeModel schemeType;
  final String? startDate;
  final String? description;
  final SchemeGroupModel schemeGroup;
  final SchemeDetailsModel schemeDetails;
  final List<BenefitPointModel> benefitPoints;

  SchemeModel({
    required this.schemeId,
    required this.name,
    required this.schemeCode,
    this.imageUrl,
    this.images,
    required this.schemeType,
    this.startDate,
    this.description,
    required this.schemeGroup,
    required this.schemeDetails,
    required this.benefitPoints,
  });

  factory SchemeModel.fromJson(Map<String, dynamic> json) {
    return SchemeModel(
      schemeId: json['schemeId'] as String,
      name: json['name'] as String,
      schemeCode: json['schemeCode'] as String,
      imageUrl: json['imageUrl'] as String?,
      images: json['images'] != null
          ? SchemeImageModel.fromJson(json['images'] as Map<String, dynamic>)
          : null,
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
      benefitPoints: (json['benefitPoints'] as List<dynamic>)
          .map(
            (point) =>
                BenefitPointModel.fromJson(point as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'schemeId': schemeId,
      'name': name,
      'schemeCode': schemeCode,
      'imageUrl': imageUrl,
      'images': images?.toJson(),
      'schemeType': schemeType.toJson(),
      'startDate': startDate,
      'description': description,
      'schemeGroup': schemeGroup.toJson(),
      'schemeDetails': schemeDetails.toJson(),
      'benefitPoints': benefitPoints.map((point) => point.toJson()).toList(),
    };
  }

  // Helper getters for backward compatibility
  double get installmentAmount => schemeDetails.installmentAmount;
  int get noofInstallment => schemeDetails.installmentCount;
  double get totalAmount => schemeDetails.totalAmount;
  double get cancelationCharge => schemeDetails.cancellationCharge;
  int? get minBenMonths => schemeDetails.minBeneficialMonth;
  int? get minBenInst => schemeDetails.minBeneficialInstallment;
  double get refund => schemeDetails.refundAmount;
  double? get benefitAmount => schemeDetails.benefitAmount;
  double? get maxAmount => null;
  double get benefit => schemeDetails.benefitAmount ?? 0.0;
  String get benefitType => schemeType.schemeTypeName;
  List<BenefitPointModel> get benefitsPoints => benefitPoints;
}
