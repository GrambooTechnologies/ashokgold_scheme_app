import 'package:ashokgold_scheme_app/features/scheme_joining/models/billing_address_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final formControllersProvider =
    Provider.autoDispose<SchemeJoiningFormControllers>((ref) {
      final controllers = SchemeJoiningFormControllers();

      // Automatically dispose controllers when provider is disposed
      ref.onDispose(() {
        controllers.dispose();
      });

      return controllers;
    });

class SchemeJoiningFormControllers {
  final TextEditingController installmentController = TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  void initializeWithDefaults(double initialAmount, String country) {
    installmentController.text = initialAmount.toStringAsFixed(2);
    countryController.text = country;
  }

  BillingAddressData getBillingAddressData() {
    return BillingAddressData(
      addressLine1: addressLine1Controller.text,
      addressLine2: addressLine2Controller.text,
      city: cityController.text,
      state: stateController.text,
      postalCode: postalCodeController.text,
      country: countryController.text,
    );
  }

  double get installmentAmount {
    return double.tryParse(installmentController.text) ?? 0.0;
  }

  void dispose() {
    installmentController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    postalCodeController.dispose();
    countryController.dispose();
  }
}
