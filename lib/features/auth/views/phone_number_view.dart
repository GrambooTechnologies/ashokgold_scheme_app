import 'package:ashokgold_scheme_app/core/custom_dialogs/customDialogeBox.dart';
import 'package:ashokgold_scheme_app/core/custom_widgets/custom_textfiled.dart';
import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/core/utilities/formatting/inputFormatters/inputFormatters.dart';
import 'package:ashokgold_scheme_app/core/utilities/scale_size_utils.dart';
import 'package:ashokgold_scheme_app/features/auth/controllers/auth_controller.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'otp_view.dart';

class PhoneNumberView extends ConsumerStatefulWidget {
  static const String routeName = '/phone-number';
  const PhoneNumberView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PhoneNumberViewState();
}

class _PhoneNumberViewState extends ConsumerState<PhoneNumberView> {
  final TextEditingController phoneController = TextEditingController();

  String selectedCountryCode = '+91';
  String selectedCountryFlag = 'IN';

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  // ------------------ ERROR BANNER ------------------

  void showErrorBanner(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.w(context, 12),
          ),
        ),
        backgroundColor: Colors.red.shade900,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.w(context, 16),
          vertical: SizeConfig.h(context, 12),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeConfig.w(context, 13)),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: Palette.backgroundColor,

      appBar: AppBar(backgroundColor: Palette.backgroundColor, elevation: 0),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(context, 16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: SizeConfig.h(context, 28)),

            // ------------------ TITLE ------------------
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.w(context, 4),
              ),
              child: Text(
                'Can we get your number, please?',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: SizeConfig.w(context, 22),
                ),
              ),
            ),

            SizedBox(height: SizeConfig.h(context, 6)),

            // ------------------ SUBTITLE ------------------
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.w(context, 4),
              ),
              child: Text(
                'Enter your phone number. We will send you an OTP to verify your number',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: SizeConfig.w(context, 14),
                ),
              ),
            ),

            SizedBox(height: SizeConfig.h(context, 20)),

            // ------------------ INPUT ROW ------------------
            Row(
              children: [
                // -------- Country Picker --------
                GestureDetector(
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      showPhoneCode: true,
                      onSelect: (country) {
                        setState(() {
                          selectedCountryCode = '+${country.phoneCode}';
                          selectedCountryFlag = country.flagEmoji;
                        });
                      },
                    );
                  },
                  child: Container(
                    width: SizeConfig.w(context, 90),
                    height: SizeConfig.h(context, 58),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        SizeConfig.w(context, 12),
                      ),
                      color: Palette.backgroundColor,
                      border: Border.all(color: Palette.primaryColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          selectedCountryFlag,
                          style: TextStyle(fontSize: SizeConfig.w(context, 16)),
                        ),
                        SizedBox(width: SizeConfig.w(context, 6)),
                        Text(
                          selectedCountryCode,
                          style: TextStyle(
                            fontSize: SizeConfig.w(context, 14),
                            color: Palette.primaryColor,
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          size: SizeConfig.w(context, 20),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: SizeConfig.w(context, 10)),

                // -------- Phone Field --------
                Expanded(
                  child: CustomTextField(
                    controller: phoneController,
                    label: 'Phone Number',
                    keyboardType: TextInputType.phone,
                    inputFormatters:
                        InputFormattersConstants.phoneNumberFormatter,
                    validator: (_) => null,
                  ),
                ),
              ],
            ),

            SizedBox(height: SizeConfig.h(context, 24)),
          ],
        ),
      ),

      // ------------------ BOTTOM BAR ------------------
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          left: SizeConfig.w(context, 33),
          bottom: SizeConfig.w(context, 3),
        ),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              Icon(
                CupertinoIcons.lock_shield,
                color: Colors.grey.shade500,
                size: SizeConfig.w(context, 29),
              ),

              SizedBox(width: SizeConfig.w(context, 6)),

              SizedBox(
                width: SizeConfig.w(context, 250),
                child: Text(
                  "We never share this with anyone and it won't be on your profile.",
                  style: TextStyle(
                    height: 1.1,
                    fontSize: SizeConfig.w(context, 13),
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(width: SizeConfig.w(context, 12)),

              // -------- Send Button --------
              GestureDetector(
                onTap: isLoading ? null : sendOtp,
                child: CircleAvatar(
                  radius: SizeConfig.w(context, 33),
                  backgroundColor: Palette.primaryColor,
                  child: isLoading
                      ? SizedBox(
                          width: SizeConfig.w(context, 18),
                          height: SizeConfig.w(context, 18),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          Icons.chevron_right_outlined,
                          color: Colors.white,
                          size: SizeConfig.w(context, 36),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendOtp() async {
    final phone = phoneController.text.trim();

    if (phone.isEmpty) {
      showErrorBanner("Phone number can't be empty");
      return;
    }

    if (phone.length != 10) {
      showErrorBanner("Please enter a valid 10-digit phone number");
      return;
    }

    // final fullNumber = "$selectedCountryCode$phone";
    final fullNumber = phone;

    final shouldSend = await context.showConfirmationDialog(
      title: 'Send OTP',
      message: 'Send OTP to $fullNumber?',
      icon: const Icon(Icons.email_outlined),
    );

    if (shouldSend == true) {
      await ref
          .read(authControllerProvider.notifier)
          .sendOtp(phoneNumber: fullNumber, context: context);

      // ✅ ADD THIS
      if (mounted) {
        context.push(OtpView.routeName, extra: fullNumber);
      }
    }
  }
}
