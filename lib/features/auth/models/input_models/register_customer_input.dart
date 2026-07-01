class RegisterCustomerInput {
  final String phoneNumber;
  final String fullName;
  final String gender;
  final String? dateOfBirth;
  final String? mobileNumber2;
  final String? email;
  final String addressLine1;
  final String? addressLine2;
  final String? houseName;
  final String? city;
  final String? state;
  final String postalCode;
  final String? country;
  final String? profilePhoto;

  RegisterCustomerInput({
    required this.phoneNumber,
    required this.fullName,
    required this.gender,
    required this.dateOfBirth,
    required this.mobileNumber2,
    required this.email,
    required this.addressLine1,
    required this.addressLine2,
    required this.houseName,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.profilePhoto,
  });

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'fullName': fullName,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'mobileNumber2': mobileNumber2,
      'email': email,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'houseName': houseName,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
      'profilePhoto': profilePhoto,
    };
  }
}
