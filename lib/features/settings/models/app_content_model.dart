class AppContentModel {
  final String id;
  final String contentKey;
  final String? title;
  final String content;
  final String contentType;
  final String platform;
  final int version;

  AppContentModel({
    required this.id,
    required this.contentKey,
    required this.title,
    required this.content,
    required this.contentType,
    required this.platform,
    required this.version,
  });

  factory AppContentModel.fromJson(Map<String, dynamic> json) {
    return AppContentModel(
      id: (json['id'] ?? '').toString(),
      contentKey: (json['contentKey'] ?? '').toString(),
      title: json['title'] as String?,
      content: (json['content'] ?? '').toString(),
      contentType: (json['contentType'] ?? '').toString(),
      platform: (json['platform'] ?? '').toString(),
      version: _parseVersion(json['version']),
    );
  }

  static int _parseVersion(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contentKey': contentKey,
      'title': title,
      'content': content,
      'contentType': contentType,
      'platform': platform,
      'version': version,
    };
  }
}
