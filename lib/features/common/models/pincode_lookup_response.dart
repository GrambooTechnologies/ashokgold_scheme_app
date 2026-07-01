class PincodeLookupResponse {
  final String pincode;
  final String state;
  final String district;
  final String country;

  PincodeLookupResponse({
    required this.pincode,
    required this.state,
    required this.district,
    required this.country,
  });

  factory PincodeLookupResponse.fromJson(Map<String, dynamic> json) {
    return PincodeLookupResponse(
      pincode: json['pincode'] as String,
      state: json['state'] as String,
      district: json['district'] as String,
      country: json['country'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pincode': pincode,
      'state': state,
      'district': district,
      'country': country,
    };
  }
}
