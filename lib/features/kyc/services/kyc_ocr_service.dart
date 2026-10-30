import 'dart:io';
import 'package:ashokgold_scheme_app/features/kyc/models/id_proof_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

final kycOcrServiceProvider = Provider<KycOcrService>((ref) {
  return KycOcrService();
});

class KycOcrResult {
  final String? documentNumber;
  final String? fullName;
  final IdProofType? detectedType;
  final String rawText;
  final List<String> extractedLines;

  bool get hasDocumentNumber =>
      documentNumber != null && documentNumber!.trim().isNotEmpty;

  bool get hasFullName => fullName != null && fullName!.trim().isNotEmpty;

  bool get hasAnyData => hasDocumentNumber || hasFullName;

  const KycOcrResult({
    this.documentNumber,
    this.fullName,
    this.detectedType,
    required this.rawText,
    this.extractedLines = const [],
  });

  @override
  String toString() {
    return 'KycOcrResult(docNumber: $documentNumber, name: $fullName, type: $detectedType)';
  }
}

class KycOcrService {
  /// Extract identity document details (document number and full name) from an image file.
  Future<KycOcrResult> processDocumentImage({
    required File imageFile,
    required IdProofType expectedType,
  }) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      final inputImage = InputImage.fromFilePath(imageFile.path);
      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );

      final fullRawText = recognizedText.text;
      final List<String> lines = [];

      for (final block in recognizedText.blocks) {
        for (final line in block.lines) {
          final trimmed = line.text.trim();
          if (trimmed.isNotEmpty) {
            lines.add(trimmed);
          }
        }
      }

      // 1. Detect Document Number
      String? documentNumber = _extractDocumentNumber(
        lines: lines,
        rawText: fullRawText,
        type: expectedType,
      );

      // Check if another document type matches strongly if expected type wasn't found
      IdProofType detectedType = expectedType;
      if (documentNumber == null) {
        for (final altType in IdProofType.values) {
          if (altType == expectedType) continue;
          final altNum = _extractDocumentNumber(
            lines: lines,
            rawText: fullRawText,
            type: altType,
          );
          if (altNum != null) {
            documentNumber = altNum;
            detectedType = altType;
            break;
          }
        }
      }

      // 2. Extract Full Name
      final String? fullName = _extractFullName(
        lines: lines,
        rawText: fullRawText,
        type: detectedType,
      );

      return KycOcrResult(
        documentNumber: documentNumber,
        fullName: fullName,
        detectedType: detectedType,
        rawText: fullRawText,
        extractedLines: lines,
      );
    } finally {
      await textRecognizer.close();
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // DOCUMENT NUMBER EXTRACTION
  // ─────────────────────────────────────────────────────────────────────────

  String? _extractDocumentNumber({
    required List<String> lines,
    required String rawText,
    required IdProofType type,
  }) {
    switch (type) {
      case IdProofType.aadhaar:
        return _extractAadhaarNumber(lines, rawText);
      case IdProofType.pan:
        return _extractPanNumber(lines, rawText);
      case IdProofType.passport:
        return _extractPassportNumber(lines, rawText);
      case IdProofType.voterId:
        return _extractVoterIdNumber(lines, rawText);
      case IdProofType.drivingLicense:
        return _extractDrivingLicenseNumber(lines, rawText);
    }
  }

  /// Aadhaar: 12 digits, often formatted as XXXX XXXX XXXX
  String? _extractAadhaarNumber(List<String> lines, String rawText) {
    // 1. Try formatted 4-4-4 pattern: e.g. 2345 6789 0123
    final formattedRegex = RegExp(r'\b[2-9]\d{3}\s\d{4}\s\d{4}\b');
    final formattedMatch = formattedRegex.firstMatch(rawText);
    if (formattedMatch != null) {
      return formattedMatch.group(0)!.replaceAll(' ', '');
    }

    // 2. Try hyphenated pattern: 2345-6789-0123
    final hyphenRegex = RegExp(r'\b[2-9]\d{3}-\d{4}-\d{4}\b');
    final hyphenMatch = hyphenRegex.firstMatch(rawText);
    if (hyphenMatch != null) {
      return hyphenMatch.group(0)!.replaceAll('-', '');
    }

    // 3. Try continuous 12 digits starting with 2-9
    final continuousRegex = RegExp(r'\b[2-9]\d{11}\b');
    final continuousMatch = continuousRegex.firstMatch(rawText);
    if (continuousMatch != null) {
      return continuousMatch.group(0);
    }

    // 4. Line by line fallback: check if any line has 12 digits after stripping spaces
    for (final line in lines) {
      final digitsOnly = line.replaceAll(RegExp(r'\D'), '');
      if (digitsOnly.length == 12 && digitsOnly.startsWith(RegExp(r'[2-9]'))) {
        return digitsOnly;
      }
    }

    return null;
  }

  /// PAN: 5 uppercase letters + 4 digits + 1 uppercase letter: [A-Z]{5}[0-9]{4}[A-Z]
  String? _extractPanNumber(List<String> lines, String rawText) {
    final panRegex = RegExp(r'\b[A-Z]{5}[0-9]{4}[A-Z]\b');

    // 1. Check in lines directly
    for (final line in lines) {
      final clean = line.toUpperCase().replaceAll(' ', '');
      final match = panRegex.firstMatch(clean);
      if (match != null) {
        return match.group(0);
      }
    }

    // 2. Check full text
    final match = panRegex.firstMatch(rawText.toUpperCase());
    if (match != null) {
      return match.group(0);
    }

    return null;
  }

  /// Passport: 1 uppercase letter followed by 7 digits: [A-Z][0-9]{7}
  String? _extractPassportNumber(List<String> lines, String rawText) {
    final passportRegex = RegExp(r'\b[A-Z][0-9]{7}\b');

    // Look for lines containing "Passport" or "No" first
    for (final line in lines) {
      final upper = line.toUpperCase();
      if (upper.contains('PASSPORT') || upper.contains('NO')) {
        final match = passportRegex.firstMatch(upper);
        if (match != null) return match.group(0);
      }
    }

    // General match
    for (final line in lines) {
      final upper = line.toUpperCase().replaceAll(' ', '');
      final match = passportRegex.firstMatch(upper);
      if (match != null) return match.group(0);
    }

    return null;
  }

  /// Voter ID (EPIC): 3 letters followed by 7 digits: [A-Z]{3}[0-9]{7}
  String? _extractVoterIdNumber(List<String> lines, String rawText) {
    final epicRegex = RegExp(r'\b[A-Z]{3}[0-9]{7}\b');

    for (final line in lines) {
      final upper = line.toUpperCase().replaceAll(' ', '');
      final match = epicRegex.firstMatch(upper);
      if (match != null) return match.group(0);
    }

    // Secondary format: 10-12 alphanumeric characters
    final altRegex = RegExp(r'\b[A-Z]{2,4}[0-9]{6,8}\b');
    for (final line in lines) {
      final upper = line.toUpperCase().replaceAll(' ', '');
      final match = altRegex.firstMatch(upper);
      if (match != null) return match.group(0);
    }

    return null;
  }

  /// Driving License: state code + digits (e.g. KL-0820180001234 or DL1420110012345)
  String? _extractDrivingLicenseNumber(List<String> lines, String rawText) {
    // Standard format: [A-Z]{2}[- ]?[0-9]{2}[- ]?[0-9]{4}[- ]?[0-9]{7}
    final dlRegex = RegExp(
      r'\b[A-Z]{2}[- ]?[0-9]{2}[- ]?[0-9]{4}[- ]?[0-9]{7}\b',
    );
    final match = dlRegex.firstMatch(rawText.toUpperCase());
    if (match != null) {
      return match.group(0)!.replaceAll(' ', '').replaceAll('-', '');
    }

    // Continuous 15-16 alphanumeric chars starting with state code
    final altDlRegex = RegExp(r'\b[A-Z]{2}[0-9]{13,14}\b');
    for (final line in lines) {
      final clean = line.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
      final altMatch = altDlRegex.firstMatch(clean);
      if (altMatch != null) return altMatch.group(0);
    }

    return null;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // FULL NAME EXTRACTION
  // ─────────────────────────────────────────────────────────────────────────

  String? _extractFullName({
    required List<String> lines,
    required String rawText,
    required IdProofType type,
  }) {
    switch (type) {
      case IdProofType.pan:
        return _extractPanName(lines);
      case IdProofType.aadhaar:
        return _extractAadhaarName(lines);
      case IdProofType.passport:
        return _extractPassportName(lines);
      case IdProofType.drivingLicense:
      case IdProofType.voterId:
        return _extractGenericName(lines);
    }
  }

  /// PAN card name extraction
  String? _extractPanName(List<String> lines) {
    // Look for line containing 'NAME' or 'नाम'
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      final upper = line.toUpperCase();

      // Ensure this is not 'Father's Name'
      if ((upper.contains('NAME') || upper.contains('नाम')) &&
          !upper.contains('FATHER') &&
          !upper.contains('DEPARTMENT') &&
          !upper.contains('ACCOUNT')) {
        // If the name is after colon on same line: e.g. "Name : RAHUL SHARMA"
        if (line.contains(':')) {
          final candidate = line.split(':').last.trim();
          if (_isValidName(candidate)) return _cleanName(candidate);
        }

        // Otherwise check the next line
        if (i + 1 < lines.length) {
          final nextLine = lines[i + 1].trim();
          if (_isValidName(nextLine)) return _cleanName(nextLine);
        }
      }
    }

    // Heuristic: On PAN Card, cardholder's name usually appears after "INCOME TAX DEPARTMENT" / "GOVT. OF INDIA"
    // and before "Father's Name" or DOB
    bool passedHeader = false;
    for (int i = 0; i < lines.length; i++) {
      final upper = lines[i].toUpperCase();
      if (upper.contains('INCOME') ||
          upper.contains('TAX') ||
          upper.contains('GOVT') ||
          upper.contains('INDIA')) {
        passedHeader = true;
        continue;
      }

      if (passedHeader) {
        if (upper.contains('FATHER') ||
            upper.contains('DATE OF BIRTH') ||
            upper.contains('DOB') ||
            upper.contains('PERMANENT')) {
          break;
        }

        if (_isValidName(lines[i])) {
          return _cleanName(lines[i]);
        }
      }
    }

    return null;
  }

  /// Aadhaar name extraction
  String? _extractAadhaarName(List<String> lines) {
    // 1. Look for DOB or Year of Birth line, name is usually 1 or 2 lines above it
    for (int i = 0; i < lines.length; i++) {
      final upper = lines[i].toUpperCase();
      if (upper.contains('DOB') ||
          upper.contains('DATE OF BIRTH') ||
          upper.contains('YEAR OF BIRTH') ||
          upper.contains('YOB') ||
          upper.contains('जन्म')) {
        // Look backwards for first valid name line
        for (int j = i - 1; j >= 0 && j >= i - 3; j--) {
          final candidate = lines[j].trim();
          if (_isValidName(candidate)) {
            return _cleanName(candidate);
          }
        }
      }
    }

    // 2. Fallback: find any line with 2-4 clean alphabetic words not in blacklist
    return _findFirstValidNameLine(lines);
  }

  /// Passport name extraction (Given Name + Surname)
  String? _extractPassportName(List<String> lines) {
    String? givenName;
    String? surname;

    for (int i = 0; i < lines.length; i++) {
      final upper = lines[i].toUpperCase();

      if (upper.contains('GIVEN NAME') || upper.contains('GIVEN NAMES')) {
        if (lines[i].contains(':')) {
          givenName = lines[i].split(':').last.trim();
        } else if (i + 1 < lines.length) {
          givenName = lines[i + 1].trim();
        }
      }

      if (upper.contains('SURNAME')) {
        if (lines[i].contains(':')) {
          surname = lines[i].split(':').last.trim();
        } else if (i + 1 < lines.length) {
          surname = lines[i + 1].trim();
        }
      }
    }

    if (givenName != null && surname != null) {
      return _cleanName('$givenName $surname');
    }
    if (givenName != null && _isValidName(givenName)) {
      return _cleanName(givenName);
    }

    return _extractGenericName(lines);
  }

  /// Generic label-based name extractor (Name: / Holder's Name: / Elector's Name:)
  String? _extractGenericName(List<String> lines) {
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      final upper = line.toUpperCase();

      if ((upper.contains('NAME') ||
              upper.contains('ELECTOR') ||
              upper.contains('HOLDER')) &&
          !upper.contains('FATHER') &&
          !upper.contains('HUSBAND') &&
          !upper.contains('MOTHER')) {
        if (line.contains(':')) {
          final candidate = line.split(':').last.trim();
          if (_isValidName(candidate)) return _cleanName(candidate);
        }

        if (i + 1 < lines.length) {
          final nextLine = lines[i + 1].trim();
          if (_isValidName(nextLine)) return _cleanName(nextLine);
        }
      }
    }

    return _findFirstValidNameLine(lines);
  }

  String? _findFirstValidNameLine(List<String> lines) {
    for (final line in lines) {
      if (_isValidName(line)) {
        return _cleanName(line);
      }
    }
    return null;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // VALIDATION & HELPERS
  // ─────────────────────────────────────────────────────────────────────────

  static const List<String> _blacklist = [
    'GOVERNMENT',
    'GOVT',
    'INDIA',
    'INCOME',
    'TAX',
    'DEPARTMENT',
    'PERMANENT',
    'ACCOUNT',
    'NUMBER',
    'CARD',
    'FATHER',
    'FATHER\'S',
    'MOTHER',
    'HUSBAND',
    'DATE',
    'BIRTH',
    'MALE',
    'FEMALE',
    'TRANSGENDER',
    'DOB',
    'UIDAI',
    'UNIQUE',
    'IDENTIFICATION',
    'AUTHORITY',
    'ENROLMENT',
    'HELP',
    'LINE',
    'WWW',
    'HTTP',
    'SIGNATURE',
    'REPUBLIC',
    'PASSPORT',
    'DRIVING',
    'LICENCE',
    'LICENSE',
    'UNION',
    'ELECTION',
    'COMMISSION',
    'EPIC',
    'IDENTITY',
    'ADDRESS',
    'PIN',
    'STATE',
    'VALIDITY',
    'ISSUE',
    'EXPIRY',
  ];

  bool _isValidName(String candidate) {
    final text = candidate.trim();

    // Must be between 3 and 40 characters
    if (text.length < 3 || text.length > 40) return false;

    // Must not contain numbers
    if (RegExp(r'\d').hasMatch(text)) return false;

    // Must consist mostly of alphabetic characters, spaces, and dots
    if (!RegExp(r'^[A-Za-z. ]+$').hasMatch(text)) return false;

    // Must have at least 1 letter
    if (!RegExp(r'[A-Za-z]').hasMatch(text)) return false;

    final upper = text.toUpperCase();

    // Check if the whole string or major words are in the blacklist
    final words = upper.split(RegExp(r'\s+'));
    int blacklistedCount = 0;
    for (final word in words) {
      if (_blacklist.contains(word)) {
        blacklistedCount++;
      }
    }

    if (blacklistedCount > 0) return false;

    return true;
  }

  String _cleanName(String raw) {
    // Remove unwanted symbols, excessive spaces, and normalize
    String cleaned = raw.replaceAll(RegExp(r'[^A-Za-z. ]'), '').trim();
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ');

    // Title case if ALL CAPS
    if (cleaned == cleaned.toUpperCase() && cleaned.length > 3) {
      cleaned = cleaned
          .split(' ')
          .map(
            (w) => w.isEmpty
                ? ''
                : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}',
          )
          .join(' ');
    }

    return cleaned;
  }
}
