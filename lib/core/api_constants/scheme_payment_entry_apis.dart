class SchemePaymentEntryApis {
  static String verifyPaymentStatus(String orderId) {
    return '/scheme-payment-entry/payment-status/$orderId';
  }

  static const String createInstallmentPayment =
      '/scheme-payment-entry/installment';

  static String getInstallmentHistory(String joinId) {
    return '/scheme-payment-entry/installment-history/$joinId';
  }

  static String getNextInstallmentDetails(String joinId) {
    return '/scheme-payment-entry/next-installment-details?joinId=$joinId';
  }

  static String getPaymentTries(String joinId) {
    return '/scheme-payment-entry/payment-tries/$joinId';
  }
}
