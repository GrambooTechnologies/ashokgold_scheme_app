class BannerModel {
  final String bannerId;
  final String bannerUrl;
  final String platform;
  final int priority;

  BannerModel({
    required this.bannerId,
    required this.bannerUrl,
    required this.platform,
    required this.priority,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      bannerId: json['bannerId'] as String,
      bannerUrl: json['bannerUrl'] as String,
      platform: json['platform'] as String,
      priority: json['priority'] as int,
    );
  }
}
