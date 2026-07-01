// ignore_for_file: public_member_api_docs, sort_constructors_first

class FilterConfigModel {
  final String key;
  final String label;
  final String type;
  final List<FilterOptionModel>? options;
  final List<String>? keys;
  final String? fromLabel;
  final String? toLabel;

  FilterConfigModel({
    required this.key,
    required this.label,
    required this.type,
    this.options,
    this.keys,
    this.fromLabel,
    this.toLabel,
  });

  factory FilterConfigModel.fromJson(Map<String, dynamic> json) {
    return FilterConfigModel(
      key: json['key'] as String,
      label: json['label'] as String? ?? '',
      type: json['type'] as String,
      options: (json['options'] as List?)
          ?.map((e) => FilterOptionModel.fromJson(e))
          .toList(),
      keys: (json['keys'] as List?)?.map((e) => e as String).toList(),
      fromLabel: json['fromLabel'] as String?,
      toLabel: json['toLabel'] as String?,
    );
  }
}

class FilterOptionModel {
  final String value;
  final String label;

  FilterOptionModel({required this.value, required this.label});

  factory FilterOptionModel.fromJson(Map<String, dynamic> json) {
    return FilterOptionModel(
      value: json['value'] as String,
      label: json['label'] as String,
    );
  }

  //initial
  factory FilterOptionModel.initial() {
    return FilterOptionModel(value: '99999', label: 'Select');
  }

  @override
  bool operator ==(covariant FilterOptionModel other) {
    if (identical(this, other)) return true;

    return other.value == value && other.label == label;
  }

  @override
  int get hashCode => value.hashCode ^ label.hashCode;
}
