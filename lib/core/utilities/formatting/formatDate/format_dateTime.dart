import 'package:intl/intl.dart';

class FormatDateTime {
  static String dateTimeToDDMMYYYY(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  static String? dateTimeToIsoString(DateTime? dateTime) {
    return dateTime?.toIso8601String();
  }

  static String dateTimeToDDMMMYYYY(DateTime dateTime) {
    return DateFormat('dd MMMM yyyy').format(dateTime);
  }

  static String isoStringToDDMMMYYYYWithTime(
    String? isoString,
    bool? showTime,
  ) {
    if (isoString == null) return "---";
    try {
      final dateTime = DateTime.parse(isoString).toLocal();
      if (showTime == true) {
        // Use 12-hour format for time
        return DateFormat('dd/MMM/yyyy hh:mm a').format(dateTime);
      }
      return DateFormat('dd/MMM/yyyy').format(dateTime);
    } catch (e) {
      return "----";
    }
  }

  // static String isoStringToLocalTimeOnly(String? isoString) {
  //   if (isoString == null) return "---";
  //   try {
  //     // If only time is provided, prepend a default date
  //     final input = isoString.length == 8 && isoString.contains(':')
  //         ? "1970-01-01T$isoString"
  //         : isoString;
  //     final dateTime = DateTime.parse(input).toLocal();
  //     return DateFormat('hh:mm a').format(dateTime);
  //   } catch (e) {
  //     return "----";
  //   }
  // }

  // static DateTime? localTimeStringToDateTime(String? timeString) {
  //   if (timeString == null) return null;
  //   try {
  //     // If only time is provided, prepend a default date
  //     final input = timeString.length == 8 && timeString.contains(':')
  //         ? "1970-01-01T$timeString"
  //         : timeString;
  //     final dateTime = DateTime.parse(input).toLocal();
  //     return dateTime;
  //   } catch (e) {
  //     return null;
  //   }
  // }

  // static DateTime? isoStringToLocalDateTime(String? isoString) {
  //   if (isoString == null) return null;
  //   try {
  //     final dateTime = DateTime.parse(isoString);
  //     return dateTime.toLocal();
  //   } catch (e) {
  //     return null;
  //   }
  // }

  static String? yyyymmddToDDMMMYYYY(String? input) {
    if (input == null || input.isEmpty) return null;
    try {
      final date = DateTime.parse(input);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return input;
    }
  }

  static String? dateTimeToYYYYMMDD(DateTime? dateTime) {
    if (dateTime == null) return null;
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  static DateTime? yyyyMMddToDateTime(String? input) {
    if (input == null || input.isEmpty) return null;
    try {
      return DateTime.parse(input);
    } catch (e) {
      return null;
    }
  }

  static String? dateTimeToTimeOnly(DateTime? dateTime) {
    if (dateTime == null) return null;
    return DateFormat('HH:mm').format(dateTime);
  }

  static String? dateTimeTo12HourTime(DateTime? dateTime) {
    if (dateTime == null) return '--';
    return DateFormat('hh:mm a').format(dateTime);
  }

  static String dateTimeStringTo12HourTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) return '----';
    try {
      // Accepts "HH:mm", "HH:mm:ss", or full ISO strings
      String input = timeString;
      if (RegExp(r'^\d{2}:\d{2}$').hasMatch(timeString)) {
        // "18:00"
        input = "1970-01-01T$timeString";
      } else if (RegExp(r'^\d{2}:\d{2}:\d{2}$').hasMatch(timeString)) {
        // "18:00:00"
        input = "1970-01-01T$timeString";
      }
      final dateTime = DateTime.parse(input);
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      return '--';
    }
  }

  static DateTime? timeStringToDateTime(String? timeString) {
    if (timeString == null || timeString.isEmpty) return null;
    try {
      // Accepts "HH:mm", "HH:mm:ss", or full ISO strings
      String input = timeString;
      if (RegExp(r'^\d{2}:\d{2}$').hasMatch(timeString)) {
        // "18:00"
        input = "1970-01-01T$timeString";
      } else if (RegExp(r'^\d{2}:\d{2}:\d{2}$').hasMatch(timeString)) {
        // "18:00:00"
        input = "1970-01-01T$timeString";
      }
      return DateTime.parse(input);
    } catch (e) {
      return null;
    }
  }
}
