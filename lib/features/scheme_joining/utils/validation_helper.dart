import 'package:flutter/material.dart';

/// Handles form validation logic for scheme joining steps
class SchemeJoiningValidationHelper {
  final GlobalKey<FormState> step1FormKey;
  final GlobalKey<FormState> step2FormKey;
  final GlobalKey<FormState> step3FormKey;

  SchemeJoiningValidationHelper({
    required this.step1FormKey,
    required this.step2FormKey,
    required this.step3FormKey,
  });

  /// Validates step 1 form (branch selection)
  bool validateStep1() {
    return step1FormKey.currentState?.validate() ?? false;
  }

  /// Validates step 2 form (billing address)
  bool validateStep2() {
    return step2FormKey.currentState?.validate() ?? false;
  }

  /// Validates step 3 form (amount selection)
  bool validateStep3() {
    return step3FormKey.currentState?.validate() ?? false;
  }

  /// Checks if current step can proceed
  bool canProceedFromStep(int currentStep) {
    switch (currentStep) {
      case 0:
        return validateStep1(); // Step 1 (index 0): Branch selection
      case 1:
        return validateStep2(); // Step 2 (index 1): Address
      case 2:
        return validateStep3(); // Step 3 (index 2): Amount
      case 3:
        return true; // Step 4 (index 3): Review/Confirm - no validation needed
      default:
        return false;
    }
  }
}
