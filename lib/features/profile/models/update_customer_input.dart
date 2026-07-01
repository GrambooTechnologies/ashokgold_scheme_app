class UpdateCustomerInput {
  final String? fullName;
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

  UpdateCustomerInput({
    this.fullName,
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
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (fullName != null) data['fullName'] = fullName;
    if (gender != null) data['gender'] = gender;
    if (dateOfBirth != null) data['dateOfBirth'] = dateOfBirth;
    if (mobileNumber2 != null) data['mobileNumber2'] = mobileNumber2;
    if (email != null) data['email'] = email;
    if (addressLine1 != null) data['addressLine1'] = addressLine1;
    if (addressLine2 != null) data['addressLine2'] = addressLine2;
    if (houseName != null) data['houseName'] = houseName;
    if (city != null) data['city'] = city;
    if (state != null) data['state'] = state;
    if (postalCode != null) data['postalCode'] = postalCode;
    if (country != null) data['country'] = country;
    return data;
  }
}
