class JoinSchemeInput {
  final String schemeId;
  final double installmentAmount;
  final String paymentMethod;
  final int preferredBranchId;
  final String nomineeId;
  final Address billingAddress;

  JoinSchemeInput({
    required this.schemeId,
    required this.installmentAmount,
    required this.paymentMethod,
    required this.preferredBranchId,
    required this.nomineeId,
    required this.billingAddress,
  });

  Map<String, dynamic> toJson() {
    return {
      'schemeId': schemeId,
      'installmentAmount': installmentAmount,
      'paymentMethod': paymentMethod,
      'preferredBranchId': preferredBranchId,
      'nomineeId': nomineeId,
      'billingAddress': billingAddress.toJson(),
    };
  }
}

class Address {
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String postalCode;
  final String country;

  Address({
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });

  Map<String, dynamic> toJson() {
    return {
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
    };
  }

  factory Address.fromCustomerAddress({
    required String addressLine1,
    required String addressLine2,
    required String city,
    required String state,
    required String postalCode,
    required String country,
  }) {
    return Address(
      addressLine1: addressLine1,
      addressLine2: addressLine2,
      city: city,
      state: state,
      postalCode: postalCode,
      country: country,
    );
  }
}
