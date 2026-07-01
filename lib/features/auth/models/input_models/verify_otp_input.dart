class VerifyOtpInput {
  final String mobile;
  final String otp;

  VerifyOtpInput({required this.mobile, required this.otp});

  Map<String, dynamic> toJson() {
    return {'mobile': mobile, 'otp': otp};
  }
}
