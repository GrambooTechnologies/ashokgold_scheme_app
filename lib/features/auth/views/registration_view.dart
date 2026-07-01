import 'package:ashokgold_scheme_app/core/custom_dialogs/customDialogeBox.dart';
import 'package:ashokgold_scheme_app/core/custom_widgets/custom_floating_button.dart';
import 'package:ashokgold_scheme_app/core/custom_widgets/custom_snackBar.dart';
import 'package:ashokgold_scheme_app/core/custom_widgets/custom_textfiled.dart';
import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/core/utilities/formatting/formatDate/format_dateTime.dart';
import 'package:ashokgold_scheme_app/core/utilities/gender_constants.dart';
import 'package:ashokgold_scheme_app/core/utilities/global_util_functions.dart';
import 'package:ashokgold_scheme_app/core/utilities/overlay_loader.dart';
import 'package:ashokgold_scheme_app/core/utilities/scale_size_utils.dart';
import 'package:ashokgold_scheme_app/core/utilities/shared_preference_constants.dart';
import 'package:ashokgold_scheme_app/features/auth/controllers/auth_controller.dart';
import 'package:ashokgold_scheme_app/features/auth/models/input_models/register_customer_input.dart';
import 'package:ashokgold_scheme_app/features/common/repository/pincode_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/custom_widgets/custom_dropdown_normal.dart';

class RegistrationView extends ConsumerStatefulWidget {
  static const String routeName = '/registration';
  const RegistrationView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RegistrationViewState();
}

class _RegistrationViewState extends ConsumerState<RegistrationView> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController mobileNumber2Controller = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController houseNameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String? selectedGender;
  bool _isPincodeLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPhoneNumber();
  }

  Future<void> _loadPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    final phoneNumber = prefs.getString(SharedPreferenceConstants.phoneNumber);
    if (phoneNumber != null) {
      phoneNumberController.text = phoneNumber;
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneNumberController.dispose();
    mobileNumber2Controller.dispose();
    emailController.dispose();
    dateOfBirthController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    houseNameController.dispose();
    cityController.dispose();
    stateController.dispose();
    postalCodeController.dispose();
    countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      appBar: AppBar(
        backgroundColor: Palette.backgroundColor,
        title: Text(
          'Complete Registration',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.w(context, 20),
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.w(context, 16),
            ),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: SizeConfig.h(context, 16)),
                    Text(
                      'Personal Information',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: SizeConfig.w(context, 18),
                      ),
                    ),
                    SizedBox(height: SizeConfig.h(context, 16)),
                    CustomTextField(
                      controller: fullNameController,
                      label: 'Full Name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Full name can't be empty";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: SizeConfig.h(context, 16)),
                    CustomTextField(
                      controller: emailController,
                      label: 'Email (Optional)',
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value != null &&
                            value.isNotEmpty &&
                            !value.contains('@')) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: SizeConfig.h(context, 16)),
                    CustomDropdown<String>(
                      label: 'Gender',
                      hint: 'Select Gender',
                      value: selectedGender,
                      items: GenderConstants.all
                          .map(
                            (gender) => DropdownMenuItem<String>(
                              value: gender,
                              child: Text(gender),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select gender";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: SizeConfig.h(context, 16)),
                    CustomTextField(
                      controller: dateOfBirthController,
                      label: 'Date of Birth (Optional)',
                      readOnly: true,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().subtract(
                            const Duration(days: 365 * 18),
                          ),
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          dateOfBirthController.text =
                              FormatDateTime.dateTimeToYYYYMMDD(date) ?? '';
                        }
                      },
                    ),
                    SizedBox(height: SizeConfig.h(context, 24)),
                    Text(
                      'Contact Information',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: SizeConfig.w(context, 18),
                      ),
                    ),
                    SizedBox(height: SizeConfig.h(context, 16)),
                    CustomTextField(
                      controller: phoneNumberController,
                      label: 'Phone Number',
                      keyboardType: TextInputType.phone,
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Phone number can't be empty";
                        }
                        if (value.length != 10) {
                          return "Enter a valid 10-digit phone number";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: SizeConfig.h(context, 16)),
                    CustomTextField(
                      controller: mobileNumber2Controller,
                      label: 'Alternate Mobile Number (Optional)',
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value != null &&
                            value.isNotEmpty &&
                            value.length != 10) {
                          return "Enter a valid 10-digit phone number";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: SizeConfig.h(context, 24)),
                    Text(
                      'Address Information',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: SizeConfig.w(context, 18),
                      ),
                    ),
                    SizedBox(height: SizeConfig.h(context, 16)),
                    CustomTextField(
                      controller: postalCodeController,
                      label: 'Postal Code',
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (value.length == 6) {
                          _fetchPincodeDetails(value);
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Postal code can't be empty";
                        }
                        if (value.length != 6) {
                          return "Enter a valid 6-digit postal code";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: SizeConfig.h(context, 16)),
                    CustomTextField(
                      controller: cityController,
                      label: 'City',
                      readOnly: true,
                    ),
                    SizedBox(height: SizeConfig.h(context, 16)),
                    CustomTextField(
                      controller: stateController,
                      label: 'State',
                      readOnly: true,
                    ),
                    SizedBox(height: SizeConfig.h(context, 16)),
                    CustomTextField(
                      controller: countryController,
                      label: 'Country',
                      readOnly: true,
                    ),
                    SizedBox(height: SizeConfig.h(context, 16)),
                    CustomTextField(
                      controller: addressLine1Controller,
                      label: 'Address Line 1',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Address can't be empty";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: SizeConfig.h(context, 16)),
                    CustomTextField(
                      controller: addressLine2Controller,
                      label: 'Address Line 2 (Optional)',
                    ),
                    SizedBox(height: SizeConfig.h(context, 16)),
                    CustomTextField(
                      controller: houseNameController,
                      label: 'House Name (Optional)',
                    ),
                    SizedBox(height: SizeConfig.h(context, 123)),
                  ],
                ),
              ),
            ),
          ),
          if (_isPincodeLoading) const LoadingOverlay(),
        ],
      ),
      floatingActionButton: CustomFloatingButton(
        isLoading: isLoading,
        text: "Register",
        onPressed: () async {
          await registerCustomer();
        },
      ),
    );
  }

  Future<void> _fetchPincodeDetails(String pincode) async {
    setState(() {
      _isPincodeLoading = true;
    });

    final result = await ref
        .read(pincodeRepositoryProvider)
        .getPincodeDetails(pincode);

    setState(() {
      _isPincodeLoading = false;
    });

    result.fold(
      (failure) {
        // Clear fields on error
        cityController.clear();
        stateController.clear();
        countryController.clear();
        if (mounted) {
          context.showErrorSnackBar(
            'Invalid pincode or unable to fetch details',
          );
        }
      },
      (pincodeData) {
        // Fill the fields with fetched data
        cityController.text = pincodeData.district;
        stateController.text = pincodeData.state;
        countryController.text = pincodeData.country;
      },
    );
  }

  Future<void> registerCustomer() async {
    if (!formKey.currentState!.validate()) return;

    final shouldRegister = await context.showConfirmationDialog(
      title: 'Complete Registration',
      message: 'Are you sure you want to register with this information?',
    );

    if (shouldRegister == true) {
      // Create RegisterCustomerInput
      final input = RegisterCustomerInput(
        phoneNumber: phoneNumberController.text.trim(),
        fullName: fullNameController.text.trim(),
        gender: selectedGender!,
        dateOfBirth: getTextOrNullController(dateOfBirthController),
        mobileNumber2: getTextOrNullController(mobileNumber2Controller),
        email: getTextOrNullController(emailController),
        addressLine1: addressLine1Controller.text.trim(),
        addressLine2: getTextOrNullController(addressLine2Controller),
        houseName: getTextOrNullController(houseNameController),
        city: getTextOrNullController(cityController),
        state: getTextOrNullController(stateController),
        postalCode: postalCodeController.text.trim(),
        country: getTextOrNullController(countryController),
        //TODO profile photo logic set later
        profilePhoto: null,
      );

      await ref
          .read(authControllerProvider.notifier)
          .registerCustomer(input: input, context: context);
    }
  }
}
