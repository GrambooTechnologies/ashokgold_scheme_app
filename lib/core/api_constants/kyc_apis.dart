class KycApis {
  static const String submitKyc = '/kyc/submit';
  static String getKycStatus(String customerId) => '/kyc/status/$customerId';
  static String resubmitKyc(String referenceId) => '/kyc/resubmit/$referenceId';
  static String adminReview(String referenceId) => '/kyc/admin/review/$referenceId';
}
