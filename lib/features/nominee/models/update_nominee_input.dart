class UpdateNomineeInput {
  final String nomineeId;
  final String? nomineeName;
  final String? nomineeRelationId;
  final String? nomineeMobile;

  UpdateNomineeInput({
    required this.nomineeId,
    required this.nomineeName,
    required this.nomineeRelationId,
    required this.nomineeMobile,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'nomineeId': nomineeId};

    if (nomineeName != null && nomineeName!.isNotEmpty) {
      data['nomineeName'] = nomineeName;
    }
    if (nomineeRelationId != null && nomineeRelationId!.isNotEmpty) {
      data['nomineeRelationId'] = nomineeRelationId;
    }
    if (nomineeMobile != null && nomineeMobile!.isNotEmpty) {
      data['nomineeMobile'] = nomineeMobile;
    }

    return data;
  }
}
