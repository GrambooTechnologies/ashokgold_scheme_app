import 'package:ashokgold_scheme_app/core/utilities/global_util_functions.dart';
import 'package:flutter/foundation.dart';

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
    this.priority = 0,
  });

  factory SchemeImageModel.fromJson(Map<String, dynamic> json) {
    return SchemeImageModel(
      schemeImageId: (json['schemeImageId'] ?? json['scheme_image_id'] ?? '')
          .toString(),
      s3Bucket: (json['s3Bucket'] ?? json['s3_bucket'] ?? '').toString(),
      s3ObjectKey:
          (json['s3ObjectKey'] ?? json['s3_object_key'] ?? '').toString(),
      imageUrl: (json['imageUrl'] ?? json['image_url'] ?? json['url'])
          ?.toString(),
      priority: json['priority'] != null
          ? (int.tryParse(json['priority'].toString()) ?? 0)
          : 0,
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
  final List<SchemeImageModel> imageList;
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
    this.imageList = const [],
    required this.schemeType,
    this.startDate,
    this.description,
    required this.schemeGroup,
    required this.schemeDetails,
    required this.benefitPoints,
  });

  factory SchemeModel.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'] ??
        json['schemeImages'] ??
        json['scheme_images'] ??
        json['scheme_image'] ??
        json['schemeImage'] ??
        json['image'];

    List<SchemeImageModel> parsedImagesList = [];
    SchemeImageModel? firstImage;
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
      for (final item in rawImages) {
        if (item is Map<String, dynamic>) {
          parsedImagesList.add(SchemeImageModel.fromJson(item));
        } else if (item is String && item.trim().isNotEmpty) {
          String url = item.trim();
          if (!url.startsWith('http://') && !url.startsWith('https://')) {
            url =
                'https://gramboo-scheme-storage.s3.ap-south-1.amazonaws.com/$url';
          }
          parsedImagesList.add(
            SchemeImageModel(
              schemeImageId: '',
              s3Bucket: 'gramboo-scheme-storage',
              s3ObjectKey: item,
              imageUrl: url,
              priority: 0,
            ),
          );
        }
      }
      if (parsedImagesList.isNotEmpty) {
        firstImage = parsedImagesList.first;
      }
    } else if (rawImages is Map<String, dynamic>) {
      firstImage = SchemeImageModel.fromJson(rawImages);
      parsedImagesList = [firstImage];
    } else if (rawImages is String && rawImages.trim().isNotEmpty) {
      directImageUrl ??= rawImages.trim();
      if (!directImageUrl.startsWith('http://') &&
          !directImageUrl.startsWith('https://')) {
        directImageUrl =
            'https://gramboo-scheme-storage.s3.ap-south-1.amazonaws.com/$directImageUrl';
      }
    }

    if (firstImage == null &&
        directImageUrl != null &&
        directImageUrl.isNotEmpty) {
      firstImage = SchemeImageModel(
        schemeImageId: (json['schemeImageId'] ??
                json['scheme_image_id'] ??
                '')
            ?.toString() ??
            '',
        s3Bucket: topBucket,
        s3ObjectKey: topKey,
        imageUrl: directImageUrl,
        priority: 0,
      );
      parsedImagesList.add(firstImage);
    }

    final rawType = json['schemeType'] ?? json['scheme_type'] ?? {};
    final rawGroup = json['schemeGroup'] ?? json['scheme_group'] ?? {};
    final rawDetails =
        json['schemeDetails'] ?? json['scheme_details'] ?? json;
    final rawBenefits = json['benefitPoints'] ??
        json['benefit_points'] ??
        json['benefits'] ??
        [];

    final resolvedUrl = directImageUrl ?? firstImage?.imageUrl;
    debugPrint(
      '--> [SchemeModel.fromJson] schemeId: ${json['schemeId'] ?? json['scheme_id']}, name: ${json['name'] ?? json['schemeName']}, resolvedUrl: "$resolvedUrl", imagesCount: ${parsedImagesList.length}',
    );

    return SchemeModel(
      schemeId:
          (json['schemeId'] ?? json['scheme_id'] ?? '').toString(),
      name: (json['name'] ??
              json['schemeName'] ??
              json['scheme_name'] ??
              '')
          .toString(),
      schemeCode:
          (json['schemeCode'] ?? json['scheme_code'] ?? '').toString(),
      imageUrl: resolvedUrl,
      images: firstImage,
      imageList: parsedImagesList,
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
      benefitPoints: rawBenefits is List
          ? rawBenefits
              .whereType<Map<String, dynamic>>()
              .map((point) => BenefitPointModel.fromJson(point))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'schemeId': schemeId,
      'name': name,
      'schemeCode': schemeCode,
      'imageUrl': imageUrl,
      'images': images?.toJson(),
      'imageList': imageList.map((img) => img.toJson()).toList(),
      'schemeType': schemeType.toJson(),
      'startDate': startDate,
      'description': description,
      'schemeGroup': schemeGroup.toJson(),
      'schemeDetails': schemeDetails.toJson(),
      'benefitPoints': benefitPoints.map((point) => point.toJson()).toList(),
    };
  }

  // Helper getters for backward compatibility
  String? get displayImageUrl {
    if (imageUrl != null && imageUrl!.trim().isNotEmpty) {
      return imageUrl!.trim();
    }
    if (images?.imageUrl != null && images!.imageUrl!.trim().isNotEmpty) {
      return images!.imageUrl!.trim();
    }
    for (final img in imageList) {
      if (img.imageUrl != null && img.imageUrl!.trim().isNotEmpty) {
        return img.imageUrl!.trim();
      }
    }
    return null;
  }

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
