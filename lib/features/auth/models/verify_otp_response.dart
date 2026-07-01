import 'package:ashokgold_scheme_app/features/auth/models/customer_model.dart';

class VerifyOtpResponse {
  final String phoneNumber;
  final bool registered;
  final String registrationStatus;
  final String? accessToken;
  final String? refreshToken;
  final CustomerModel? customer;

  VerifyOtpResponse({
    required this.phoneNumber,
    required this.registered,
    required this.registrationStatus,
    this.accessToken,
    this.refreshToken,
    this.customer,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      phoneNumber: json['phoneNumber'] as String,
      registered: json['registered'] as bool,
      registrationStatus: json['registrationStatus'] as String,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      customer: json['customer'] != null
          ? CustomerModel.fromJson(json['customer'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'registered': registered,
      'registrationStatus': registrationStatus,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'customer': customer?.toJson(),
    };
  }
}
