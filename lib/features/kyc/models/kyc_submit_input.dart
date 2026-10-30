import 'dart:io';
import 'id_proof_type.dart';

class KycSubmitInput {
  final String customerId;
  final String customerName;
  final String phoneNumber;
  final IdProofType idProofType;
  final String idNumber;
  final File frontDocument;
  final File? backDocument;
  final bool consentGiven;
  final bool isResubmission;
  final String? previousReferenceId;

  KycSubmitInput({
    required this.customerId,
    required this.customerName,
    required this.phoneNumber,
    required this.idProofType,
    required this.idNumber,
    required this.frontDocument,
    this.backDocument,
    required this.consentGiven,
    this.isResubmission = false,
    this.previousReferenceId,
  });
}
