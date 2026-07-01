class NomineeRelationModel {
  final String relationId;
  final String relationName;

  NomineeRelationModel({required this.relationId, required this.relationName});

  factory NomineeRelationModel.fromJson(Map<String, dynamic> json) {
    return NomineeRelationModel(
      relationId: json['relationId'] as String,
      relationName: json['relationName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'relationId': relationId, 'relationName': relationName};
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NomineeRelationModel &&
        other.relationId == relationId &&
        other.relationName == relationName;
  }

  @override
  int get hashCode => Object.hash(relationId, relationName);
}

class CustomerNomineeModel {
  final String nomineeId;
  final String customerId;
  final String nomineeName;
  final NomineeRelationModel nomineeRelation;
  final String? nomineeMobile;
  final String? createdAt;
  final String? updatedBy;
  final String? updatedAt;
  final bool isActive;

  CustomerNomineeModel({
    required this.nomineeId,
    required this.customerId,
    required this.nomineeName,
    required this.nomineeRelation,
    this.nomineeMobile,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    required this.isActive,
  });

  factory CustomerNomineeModel.fromJson(Map<String, dynamic> json) {
    return CustomerNomineeModel(
      nomineeId: json['nomineeId'] as String,
      customerId: json['customerId'] as String,
      nomineeName: json['nomineeName'] as String,
      nomineeRelation: NomineeRelationModel.fromJson(
        json['nomineeRelation'] as Map<String, dynamic>,
      ),
      nomineeMobile: json['nomineeMobile'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedBy: json['updatedBy'] as String?,
      updatedAt: json['updatedAt'] as String?,
      isActive: json['isActive'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nomineeId': nomineeId,
      'customerId': customerId,
      'nomineeName': nomineeName,
      'nomineeRelation': nomineeRelation.toJson(),
      'nomineeMobile': nomineeMobile,
      'createdAt': createdAt,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
      'isActive': isActive,
    };
  }

  CustomerNomineeModel copyWith({
    String? nomineeId,
    String? customerId,
    String? nomineeName,
    NomineeRelationModel? nomineeRelation,
    String? nomineeMobile,
    String? createdAt,
    String? updatedBy,
    String? updatedAt,
    bool? isActive,
  }) {
    return CustomerNomineeModel(
      nomineeId: nomineeId ?? this.nomineeId,
      customerId: customerId ?? this.customerId,
      nomineeName: nomineeName ?? this.nomineeName,
      nomineeRelation: nomineeRelation ?? this.nomineeRelation,
      nomineeMobile: nomineeMobile ?? this.nomineeMobile,
      createdAt: createdAt ?? this.createdAt,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CustomerNomineeModel &&
        other.nomineeId == nomineeId &&
        other.customerId == customerId &&
        other.nomineeName == nomineeName &&
        other.nomineeRelation == nomineeRelation &&
        other.nomineeMobile == nomineeMobile &&
        other.createdAt == createdAt &&
        other.updatedBy == updatedBy &&
        other.updatedAt == updatedAt &&
        other.isActive == isActive;
  }

  @override
  int get hashCode => Object.hash(
        nomineeId,
        customerId,
        nomineeName,
        nomineeRelation,
        nomineeMobile,
        createdAt,
        updatedBy,
        updatedAt,
        isActive,
      );
}
