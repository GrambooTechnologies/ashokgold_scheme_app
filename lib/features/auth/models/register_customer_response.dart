import 'package:ashokgold_scheme_app/features/auth/models/customer_model.dart';

class RegisterCustomerResponse {
  final String phoneNumber;
  final String accessToken;
  final String refreshToken;
  final CustomerModel customer;

  RegisterCustomerResponse({
    required this.phoneNumber,
    required this.accessToken,
    required this.refreshToken,
    required this.customer,
  });

  factory RegisterCustomerResponse.fromJson(Map<String, dynamic> json) {
    return RegisterCustomerResponse(
      phoneNumber: json['phoneNumber'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      customer: CustomerModel.fromJson(
        json['customer'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'customer': customer.toJson(),
    };
  }
}
