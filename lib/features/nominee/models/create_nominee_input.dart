class CreateNomineeInput {
  final String customerId;
  final String nomineeName;
  final String nomineeRelationId;
  final String? nomineeMobile;

  CreateNomineeInput({
    required this.customerId,
    required this.nomineeName,
    required this.nomineeRelationId,
    required this.nomineeMobile,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'nomineeName': nomineeName,
      'nomineeRelationId': nomineeRelationId,
      if (nomineeMobile != null && nomineeMobile!.isNotEmpty)
        'nomineeMobile': nomineeMobile,
    };
  }
}
