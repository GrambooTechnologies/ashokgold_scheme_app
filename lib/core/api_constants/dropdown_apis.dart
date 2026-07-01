class DropdownApis {
  static const String getNomineeRelations = '/dropdown/nominee-relations';
  static String getPincodeLookup(String pincode) {
    return '/dropdown/pincode/$pincode';
  }
}
