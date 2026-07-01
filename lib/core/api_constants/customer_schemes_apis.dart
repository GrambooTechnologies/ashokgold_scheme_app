class CustomerSchemesApis {
  static const String getCustomerJoinedActiveSchemes = '/customer-schemes';
  static String getCustomerJoinedActiveSchemeDetail(String joinId) {
    return '/customer-schemes/$joinId';
  }

  static const String getCustomerClosedSchemes =
      '/customer-schemes/closed/list';
  static String getCustomerClosedSchemeDetailByClosingId(String closingId) {
    return '/customer-schemes/closed/$closingId';
  }
}
