import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/form_controllers_provider.dart';
import '../providers/scheme_joining_form_provider.dart';

/// Handles initialization of the scheme joining flow
class SchemeJoiningInitializer {
  final WidgetRef ref;
  final double initialAmount;

  SchemeJoiningInitializer({required this.ref, required this.initialAmount});

  /// Initialize all form states and controllers
  void initialize() {
    // Initialize form state first
    _initializeFormState();
    // Then initialize controllers after the form state is ready
    _initializeControllers();
  }

  void _initializeFormState() {
    // Use read since we're initializing, not watching for changes
    ref
        .read(schemeJoiningFormProvider.notifier)
        .initialize(initialAmount: initialAmount);
  }

  void _initializeControllers() {
    // Use read to get the provider instance and initialize it
    ref
        .read(formControllersProvider)
        .initializeWithDefaults(initialAmount, 'India');
  }
}
