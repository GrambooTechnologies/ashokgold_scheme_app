import 'package:ashokgold_scheme_app/core/utilities/global_util_functions.dart';

class NextInstallmentDetailsResponse {
  final double nextInstallmentAmount;
  final double minAmount;
  final double maxAmount;
  final bool isEditable;
  final String description;

  NextInstallmentDetailsResponse({
    required this.nextInstallmentAmount,
    required this.minAmount,
    required this.maxAmount,
    required this.isEditable,
    required this.description,
  });

  factory NextInstallmentDetailsResponse.fromJson(Map<String, dynamic> json) {
    return NextInstallmentDetailsResponse(
      nextInstallmentAmount: toDouble(json['nextInstallmentAmount']),
      minAmount: toDouble(json['minAmount']),
      maxAmount: toDouble(json['maxAmount']),
      isEditable: json['isEditable'] as bool,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nextInstallmentAmount': nextInstallmentAmount,
      'minAmount': minAmount,
      'maxAmount': maxAmount,
      'isEditable': isEditable,
      'description': description,
    };
  }

  NextInstallmentDetailsResponse copyWith({
    double? nextInstallmentAmount,
    double? minAmount,
    double? maxAmount,
    bool? isEditable,
    String? description,
  }) {
    return NextInstallmentDetailsResponse(
      nextInstallmentAmount:
          nextInstallmentAmount ?? this.nextInstallmentAmount,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
      isEditable: isEditable ?? this.isEditable,
      description: description ?? this.description,
    );
  }
}
