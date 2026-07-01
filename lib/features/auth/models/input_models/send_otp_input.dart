class SendOtpInput {
  final String mobile;

  SendOtpInput({required this.mobile});

  Map<String, dynamic> toJson() {
    return {'mobile': mobile};
  }
}
