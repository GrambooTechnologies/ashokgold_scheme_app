import 'package:ashokgold_scheme_app/core/custom_dialogs/customDialogeBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/scheme_joining_service.dart';
import '../utils/page_navigation_helper.dart';
import '../utils/validation_helper.dart';

/// Coordinates the step-by-step navigation flow in scheme joining
class SchemeJoiningFlowCoordinator {
  final WidgetRef ref;
  final PageNavigationHelper navigationHelper;
  final SchemeJoiningValidationHelper validationHelper;
  final String schemeId;

  SchemeJoiningFlowCoordinator({
    required this.ref,
    required this.navigationHelper,
    required this.validationHelper,
    required this.schemeId,
  });

  /// Handles the "Next" button action based on current step
  Future<void> handleNext(int currentPage, BuildContext context) async {
    if (currentPage == 0) {
      _handleStep1Next();
    } else if (currentPage == 1) {
      _handleStep2Next();
    } else if (currentPage == 2) {
      await _handleStep3Next(context);
    } else if (currentPage == 3) {
      final isConfirm = await context.showConfirmationDialog(
        title: 'Are you sure?',
        message: 'Do you want to submit the scheme joining request?',
      );
      if (isConfirm == true) {
        await _handleStep4Next(context);
      }
    }
  }

  /// Handles the "Back" button action
  void handleBack() {
    navigationHelper.navigateToPrevious();
  }

  // Private methods for each step
  void _handleStep1Next() {
    // Step 1: Branch selection - validate and proceed
    if (validationHelper.validateStep1()) {
      navigationHelper.navigateToNext();
    }
  }

  void _handleStep2Next() {
    // Step 2: Billing address - validate and proceed
    if (validationHelper.validateStep2()) {
      navigationHelper.navigateToNext();
    }
  }

  Future<void> _handleStep3Next(BuildContext context) async {
    // Step 3: Amount selection - validate installment amount with API
    if (!validationHelper.validateStep3()) return;

    final service = ref.read(schemeJoiningServiceProvider);
    final isValid = await service.validateInitialInstallmentAmount(
      schemeId: schemeId,
      context: context,
    );

    if (isValid) {
      navigationHelper.navigateToNext();
    }
  }

  Future<void> _handleStep4Next(BuildContext context) async {
    // Step 4: Overview/Confirmation - submit the scheme joining request
    final service = ref.read(schemeJoiningServiceProvider);
    final success = await service.submitJoinScheme(
      schemeId: schemeId,
      context: context,
    );

    // If successful, the service will navigate to payment webview
    // The payment webview will handle the navigation after payment completion
    // So we don't need to navigate here
    if (!success && context.mounted) {
      // Only show error if submission failed
      // Navigation is handled by the service for successful submissions
    }
  }
}
