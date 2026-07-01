class CustomerModel {
  final String customerId;
  final String phoneNumber;
  final String fullName;
  final String? gender;
  final String? dateOfBirth;
  final String? mobileNumber2;
  final String? email;
  final String? addressLine1;
  final String? addressLine2;
  final String? houseName;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? country;
  final String? profilePhoto;
  final String? updatedAt;

  CustomerModel({
    required this.customerId,
    required this.phoneNumber,
    required this.fullName,
    this.gender,
    this.dateOfBirth,
    this.mobileNumber2,
    this.email,
    this.addressLine1,
    this.addressLine2,
    this.houseName,
    this.city,
    this.state,
    this.postalCode,
    this.country,
    this.profilePhoto,
    this.updatedAt,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      customerId: json['customerId'] as String,
      phoneNumber: json['phoneNumber'] as String,
      fullName: json['fullName'] as String,
      gender: json['gender'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      mobileNumber2: json['mobileNumber2'] as String?,
      email: json['email'] as String?,
      addressLine1: json['addressLine1'] as String?,
      addressLine2: json['addressLine2'] as String?,
      houseName: json['houseName'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      postalCode: json['postalCode'] as String?,
      country: json['country'] as String?,
      profilePhoto: json['profilePhoto'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
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
      'updatedAt': updatedAt,
    };
  }

  CustomerModel copyWith({
    String? customerId,
    String? phoneNumber,
    String? fullName,
    String? gender,
    String? dateOfBirth,
    String? mobileNumber2,
    String? email,
    String? addressLine1,
    String? addressLine2,
    String? houseName,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    String? profilePhoto,
    String? updatedAt,
  }) {
    return CustomerModel(
      customerId: customerId ?? this.customerId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      fullName: fullName ?? this.fullName,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      mobileNumber2: mobileNumber2 ?? this.mobileNumber2,
      email: email ?? this.email,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      houseName: houseName ?? this.houseName,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
