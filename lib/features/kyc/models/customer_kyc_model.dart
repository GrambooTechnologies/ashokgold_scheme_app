import 'id_proof_type.dart';
import 'kyc_status.dart';

class CustomerKycModel {
  final String referenceId;
  final String customerId;
  final String customerName;
  final String phoneNumber;
  final IdProofType idProofType;
  final String idNumber;
  final String? frontDocumentPath;
  final String? backDocumentPath;
  final KycStatus status;
  final String? adminNote;
  final DateTime submittedAt;
  final DateTime? reviewedAt;
  final String? reviewedBy;
  final bool consentGiven;
  final bool isResubmission;

  CustomerKycModel({
    required this.referenceId,
    required this.customerId,
    required this.customerName,
    required this.phoneNumber,
    required this.idProofType,
    required this.idNumber,
    this.frontDocumentPath,
    this.backDocumentPath,
    required this.status,
    this.adminNote,
    required this.submittedAt,
    this.reviewedAt,
    this.reviewedBy,
    this.consentGiven = true,
    this.isResubmission = false,
  });

  bool get isApproved => status == KycStatus.approved;
  bool get isPending => status == KycStatus.pending;
  bool get isActionRequired => status == KycStatus.actionRequired;
  bool get isRejected => status == KycStatus.rejected;
  bool get isNotSubmitted => status == KycStatus.notSubmitted;

  Map<String, dynamic> toJson() {
    return {
      'referenceId': referenceId,
      'customerId': customerId,
      'customerName': customerName,
      'phoneNumber': phoneNumber,
      'idProofType': idProofType.value,
      'idNumber': idNumber,
      'frontDocumentPath': frontDocumentPath,
      'backDocumentPath': backDocumentPath,
      'status': status.value,
      'adminNote': adminNote,
      'submittedAt': submittedAt.toIso8601String(),
      'reviewedAt': reviewedAt?.toIso8601String(),
      'reviewedBy': reviewedBy,
      'consentGiven': consentGiven,
      'isResubmission': isResubmission,
    };
  }

  factory CustomerKycModel.fromJson(Map<String, dynamic> json) {
    return CustomerKycModel(
      referenceId:
          json['referenceId'] as String? ??
          'AG-KYC-${DateTime.now().millisecondsSinceEpoch % 1000000}',
      customerId: json['customerId'] as String? ?? '',
      customerName: json['customerName'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      idProofType: IdProofType.fromString(json['idProofType'] as String?),
      idNumber: json['idNumber'] as String? ?? '',
      frontDocumentPath: json['frontDocumentPath'] as String?,
      backDocumentPath: json['backDocumentPath'] as String?,
      status: KycStatus.fromString(json['status'] as String?),
      adminNote: json['adminNote'] as String?,
      submittedAt: json['submittedAt'] != null
          ? DateTime.tryParse(json['submittedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      reviewedAt: json['reviewedAt'] != null
          ? DateTime.tryParse(json['reviewedAt'] as String)
          : null,
      reviewedBy: json['reviewedBy'] as String?,
      consentGiven: json['consentGiven'] as bool? ?? true,
      isResubmission: json['isResubmission'] as bool? ?? false,
    );
  }

  CustomerKycModel copyWith({
    String? referenceId,
    String? customerId,
    String? customerName,
    String? phoneNumber,
    IdProofType? idProofType,
    String? idNumber,
    String? frontDocumentPath,
    String? backDocumentPath,
    KycStatus? status,
    String? adminNote,
    DateTime? submittedAt,
    DateTime? reviewedAt,
    String? reviewedBy,
    bool? consentGiven,
    bool? isResubmission,
  }) {
    return CustomerKycModel(
      referenceId: referenceId ?? this.referenceId,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      idProofType: idProofType ?? this.idProofType,
      idNumber: idNumber ?? this.idNumber,
      frontDocumentPath: frontDocumentPath ?? this.frontDocumentPath,
      backDocumentPath: backDocumentPath ?? this.backDocumentPath,
      status: status ?? this.status,
      adminNote: adminNote ?? this.adminNote,
      submittedAt: submittedAt ?? this.submittedAt,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      consentGiven: consentGiven ?? this.consentGiven,
      isResubmission: isResubmission ?? this.isResubmission,
    );
  }
}
