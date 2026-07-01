import 'package:flutter/material.dart';

class PaymentMode {
  static const String card = 'CARD';
  static const String cash = 'CASH';
  static const String upi = 'UPI';
  static const String rtgs = 'RTGS';
  static const String bankTransfer = 'BANK TRANSFER';

  // Get color based on payment mode
  static Color getPaymentModeColor(String paymentMode) {
    switch (paymentMode.toUpperCase()) {
      case card:
        return Colors.purple;
      case cash:
        return Colors.green;
      case upi:
        return Colors.blue;
      case rtgs:
      case bankTransfer:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
