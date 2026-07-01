import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

String nullString = "null";

String? getTextOrNullController(TextEditingController controller) {
  return controller.text.isNotEmpty ? controller.text : null;
}

String? stringOrNull(String? value) {
  if (value == null || value == "null") return null;
  return value;
}

String actionUserNameFormatted({required String id, required String? name}) {
  if (id == "999") {
    return "System";
  }
  return name ?? "--";
}

/// Converts a dynamic value to double or returns null if conversion fails
/// Handles num, String, and double types
double? toDoubleOrNull(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

/// Converts a dynamic value to double with a default value if conversion fails
/// Handles num, String, and double types
double toDouble(dynamic value, {double defaultValue = 0.0}) {
  return toDoubleOrNull(value) ?? defaultValue;
}

/// Converts a dynamic value to int or returns null if conversion fails
/// Handles num, String, and int types
int? toIntOrNull(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

/// Converts a dynamic value to int with a default value if conversion fails
/// Handles num, String, and int types
int toInt(dynamic value, {int defaultValue = 0}) {
  return toIntOrNull(value) ?? defaultValue;
}

/// Formats a number as Indian currency with rupee symbol
/// Returns formatted string like '₹1,23,456.00'
String formatCurrency(double amount) {
  return '₹${NumberFormat('#,##,##0.00', 'en_IN').format(amount)}';
}
