class PreferredBranchModel {
  final int branchId;
  final String branchName;
  final String? branchCode;
  final String? branchPhone;
  final String? branchAddress;
  final String? branchImageUrl;

  PreferredBranchModel({
    required this.branchId,
    required this.branchName,
    required this.branchCode,
    required this.branchPhone,
    required this.branchAddress,
    required this.branchImageUrl,
  });

  factory PreferredBranchModel.fromJson(Map<String, dynamic> json) {
    return PreferredBranchModel(
      branchId: json['branchId'] as int,
      branchName: json['branchName'] as String,
      branchCode: json['branchCode'] as String?,
      branchPhone: json['branchPhone'] as String?,
      branchAddress: json['branchAddress'] as String?,
      branchImageUrl: json['branchImageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branchId': branchId,
      'branchName': branchName,
      'branchCode': branchCode,
      'branchPhone': branchPhone,
      'branchAddress': branchAddress,
      'branchImageUrl': branchImageUrl,
    };
  }

  @override
  String toString() {
    return 'PreferredBranchModel(branchId: $branchId, branchName: $branchName, branchCode: $branchCode, branchPhone: $branchPhone, branchAddress: $branchAddress, branchImageUrl: $branchImageUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PreferredBranchModel &&
        other.branchId == branchId &&
        other.branchName == branchName &&
        other.branchCode == branchCode &&
        other.branchPhone == branchPhone &&
        other.branchAddress == branchAddress &&
        other.branchImageUrl == branchImageUrl;
  }

  @override
  int get hashCode {
    return branchId.hashCode ^
        branchName.hashCode ^
        branchCode.hashCode ^
        branchPhone.hashCode ^
        branchAddress.hashCode ^
        branchImageUrl.hashCode;
  }
}
