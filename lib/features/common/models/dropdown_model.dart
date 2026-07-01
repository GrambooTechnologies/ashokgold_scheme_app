class DropdownItemModel {
  final String id;
  final String value;

  DropdownItemModel({required this.id, required this.value});

  factory DropdownItemModel.fromJson(Map<String, dynamic> json) {
    return DropdownItemModel(
      id: json['id'] as String,
      value: json['value'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'value': value};
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DropdownItemModel && other.id == id && other.value == value;
  }

  @override
  int get hashCode => id.hashCode ^ value.hashCode;
}
