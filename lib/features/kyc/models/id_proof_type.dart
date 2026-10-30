enum IdProofType {
  aadhaar,
  pan,
  passport,
  voterId,
  drivingLicense;

  String get value {
    switch (this) {
      case IdProofType.aadhaar:
        return 'aadhaar';
      case IdProofType.pan:
        return 'pan';
      case IdProofType.passport:
        return 'passport';
      case IdProofType.voterId:
        return 'voter_id';
      case IdProofType.drivingLicense:
        return 'driving_license';
    }
  }

  String get title {
    switch (this) {
      case IdProofType.aadhaar:
        return 'Aadhaar Card';
      case IdProofType.pan:
        return 'PAN Card';
      case IdProofType.passport:
        return 'Passport';
      case IdProofType.voterId:
        return 'Voter ID';
      case IdProofType.drivingLicense:
        return 'Driving License';
    }
  }

  bool get requiresBackImage {
    switch (this) {
      case IdProofType.pan:
        return false;
      default:
        return true;
    }
  }

  String get idNumberHint {
    switch (this) {
      case IdProofType.aadhaar:
        return '12-digit Aadhaar number';
      case IdProofType.pan:
        return '10-character PAN (e.g. ABCDE1234F)';
      case IdProofType.passport:
        return '8-character Passport number';
      case IdProofType.voterId:
        return 'EPIC / Voter ID number';
      case IdProofType.drivingLicense:
        return 'Driving License number';
    }
  }

  String? validate(String? input) {
    if (input == null || input.trim().isEmpty) {
      return 'Please enter your $title number';
    }
    final clean = input.replaceAll(' ', '').trim();
    switch (this) {
      case IdProofType.aadhaar:
        if (!RegExp(r'^\d{12}$').hasMatch(clean)) {
          return 'Aadhaar must be exactly 12 digits';
        }
        break;
      case IdProofType.pan:
        if (!RegExp(
          r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$',
        ).hasMatch(clean.toUpperCase())) {
          return 'Enter a valid 10-character PAN (e.g. ABCDE1234F)';
        }
        break;
      case IdProofType.passport:
        if (!RegExp(r'^[A-Z][0-9]{7}$').hasMatch(clean.toUpperCase())) {
          return 'Passport must start with a letter followed by 7 digits';
        }
        break;
      case IdProofType.voterId:
        if (clean.length < 8 || clean.length > 12) {
          return 'Enter a valid Voter ID number';
        }
        break;
      case IdProofType.drivingLicense:
        if (clean.length < 10 || clean.length > 16) {
          return 'Enter a valid Driving License number';
        }
        break;
    }
    return null;
  }

  static IdProofType fromString(String? value) {
    if (value == null) return IdProofType.aadhaar;
    switch (value.toLowerCase().replaceAll('-', '_')) {
      case 'pan':
        return IdProofType.pan;
      case 'passport':
        return IdProofType.passport;
      case 'voter_id':
      case 'voterid':
        return IdProofType.voterId;
      case 'driving_license':
      case 'drivinglicense':
      case 'dl':
        return IdProofType.drivingLicense;
      case 'aadhaar':
      default:
        return IdProofType.aadhaar;
    }
  }
}
