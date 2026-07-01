class BranchModel {
  final int branchId;
  final String branchName;
  final String branchCode;
  final String? branchPhone;
  final String? branchEmail;
  final String? branchAddress;
  final String? branchImageUrl;
  final bool isMainBranch;
  final String? availabilityText;

  BranchModel({
    required this.branchId,
    required this.branchName,
    required this.branchCode,
    this.branchPhone,
    this.branchEmail,
    this.branchAddress,
    this.branchImageUrl,
    required this.isMainBranch,
    this.availabilityText,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      branchId: json['branchId'] as int,
      branchName: json['branchName'] as String,
      branchCode: json['branchCode'] as String,
      branchPhone: json['branchPhone'] as String?,
      branchEmail: json['branchEmail'] as String?,
      branchAddress: json['branchAddress'] as String?,
      branchImageUrl: json['branchImageUrl'] as String?,
      isMainBranch: json['isMainBranch'] as bool? ?? false,
      availabilityText: json['availabilityText'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branchId': branchId,
      'branchName': branchName,
      'branchCode': branchCode,
      'branchPhone': branchPhone,
      'branchEmail': branchEmail,
      'branchAddress': branchAddress,
      'branchImageUrl': branchImageUrl,
      'isMainBranch': isMainBranch,
      'availabilityText': availabilityText,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BranchModel &&
        other.branchId == branchId &&
        other.branchName == branchName &&
        other.branchCode == branchCode &&
        other.branchPhone == branchPhone &&
        other.branchEmail == branchEmail &&
        other.branchAddress == branchAddress &&
        other.branchImageUrl == branchImageUrl &&
        other.availabilityText == availabilityText &&
        other.isMainBranch == isMainBranch;
  }

  @override
  int get hashCode => Object.hash(
        branchId,
        branchName,
        branchCode,
        branchPhone,
        branchEmail,
        branchAddress,
        branchImageUrl,
        isMainBranch,
        availabilityText,
      );
}
