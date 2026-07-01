class BranchSocialMediaModel {
  final String id;
  final String branchId;
  final String platformName;
  final String profileUrl;
  final String handle;
  final String? iconUrl;

  BranchSocialMediaModel({
    required this.id,
    required this.branchId,
    required this.platformName,
    required this.profileUrl,
    required this.handle,
    this.iconUrl,
  });

  factory BranchSocialMediaModel.fromJson(Map<String, dynamic> json) {
    return BranchSocialMediaModel(
      id: (json['id'] ?? '').toString(),
      branchId: (json['branchId'] ?? '').toString(),
      platformName: (json['platformName'] ?? '').toString(),
      profileUrl: (json['profileUrl'] ?? '').toString(),
      handle: (json['handle'] ?? '').toString(),
      iconUrl: json['iconUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branchId': branchId,
      'platformName': platformName,
      'profileUrl': profileUrl,
      'handle': handle,
      'iconUrl': iconUrl,
    };
  }
}
