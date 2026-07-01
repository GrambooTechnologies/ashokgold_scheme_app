class SchemeApis {
  static const String getAllSchemes = '/schemes';
  static String getSchemeById(String schemeId) => '/schemes/$schemeId';
  static String getPaymentRulesBySchemeId(String schemeId) =>
      '/schemes/payment-rules/$schemeId';
  static const String calculateBenefit = '/schemes/calculate-benefit';
}
