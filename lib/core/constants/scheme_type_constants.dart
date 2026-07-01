class SchemeType {
  static const int fixedId = 1;
  static const int variableId = 2;
  static const int dailyId = 3;

  static const String fixed = 'Fixed';
  static const String variable = 'Variable';
  static const String daily = 'Daily';

  static String getSchemeTypeName(int id) {
    switch (id) {
      case fixedId:
        return fixed;
      case variableId:
        return variable;
      case dailyId:
        return daily;
      default:
        return '';
    }
  }
}
