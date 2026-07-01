class GetNextInstallmentDetailsInput {
  final String joinId;

  GetNextInstallmentDetailsInput({
    required this.joinId,
  });

  Map<String, dynamic> toJson() {
    return {
      'joinId': joinId,
    };
  }
}
