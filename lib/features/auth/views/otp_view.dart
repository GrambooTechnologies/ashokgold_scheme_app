import 'dart:async';

import 'package:ashokgold_scheme_app/core/custom_dialogs/customDialogeBox.dart';
import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/core/utilities/scale_size_utils.dart';
import 'package:ashokgold_scheme_app/features/auth/controllers/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OtpView extends ConsumerStatefulWidget {
  static const String routeName = '/otp';

  final String phoneNumber;

  const OtpView({super.key, required this.phoneNumber});

  @override
  ConsumerState<OtpView> createState() => _OtpViewState();
}

class _OtpViewState extends ConsumerState<OtpView> with CodeAutoFill {
  String otpCode = '';

  final TextEditingController _otpController = TextEditingController();

  // ================= TIMER =================
  int _secondsRemaining = 60;
  bool _canResend = false;
  Timer? _timer;

  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    listenForCode();
    _startTimer();
  }

  @override
  void dispose() {
    cancel();
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  // ================= TIMER FUNCTION =================

  void _startTimer() {
    _canResend = false;
    _secondsRemaining = 60;

    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
        setState(() {
          _canResend = true;
        });
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  // ================= AUTO OTP =================

  @override
  void codeUpdated() {
    setState(() {
      otpCode = code ?? '';
      _otpController.text = otpCode;
    });

    if (otpCode.length == 4) {
      verifyOtp();
    }
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: Palette.backgroundColor,

      appBar: AppBar(
        backgroundColor: Palette.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'OTP Verification',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: SizeConfig.w(context, 18),
          ),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(context, 24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: SizeConfig.h(context, 28)),

            Text(
              'Enter Verification Code',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: SizeConfig.w(context, 22),
              ),
            ),

            SizedBox(height: SizeConfig.h(context, 4)),

            Text(
              'We have sent the verification code to ${widget.phoneNumber}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: SizeConfig.w(context, 14),
              ),
            ),

            SizedBox(height: SizeConfig.h(context, 20)),

            // ================= OTP FIELD =================
            Pinput(
              length: 4,
              controller: _otpController,
              onChanged: (value) {
                setState(() {
                  otpCode = value;
                });
              },
              onCompleted: (value) {
                otpCode = value;
                verifyOtp(); // auto verify
              },
              defaultPinTheme: PinTheme(
                width: SizeConfig.w(context, 55),
                height: SizeConfig.h(context, 55),
                textStyle: TextStyle(
                  fontSize: SizeConfig.w(context, 22),
                  fontWeight: FontWeight.w700,
                  color: Palette.primaryColor,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    SizeConfig.w(context, 12),
                  ),
                  border: Border.all(color: Colors.grey.shade300),
                ),
              ),
              focusedPinTheme: PinTheme(
                width: SizeConfig.w(context, 55),
                height: SizeConfig.h(context, 55),
                textStyle: TextStyle(
                  fontSize: SizeConfig.w(context, 22),
                  fontWeight: FontWeight.w600,
                  color: Palette.primaryColor,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    SizeConfig.w(context, 12),
                  ),
                  border: Border.all(color: Colors.grey.shade600),
                ),
              ),
              submittedPinTheme: PinTheme(
                width: SizeConfig.w(context, 55),
                height: SizeConfig.h(context, 55),
                textStyle: TextStyle(
                  fontSize: SizeConfig.w(context, 22),
                  fontWeight: FontWeight.w600,
                  color: Palette.primaryColor,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    SizeConfig.w(context, 12),
                  ),
                  border: Border.all(color: Palette.primaryColor, width: 1.5),
                ),
              ),
              autofillHints: const [AutofillHints.oneTimeCode],
            ),

            SizedBox(height: SizeConfig.h(context, 10)),

            // ================= RESEND =================
            Row(
              children: [
                Text(
                  "You didn't receive the code? ",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: SizeConfig.w(context, 14),
                  ),
                ),
                GestureDetector(
                  onTap: (_canResend && !isLoading)
                      ? () async {
                          await ref
                              .read(authControllerProvider.notifier)
                              .sendOtp(
                                phoneNumber: widget.phoneNumber,
                                context: context,
                              );

                          _startTimer();
                        }
                      : null,
                  child: Text(
                    _canResend
                        ? "Resend Code"
                        : "Resend in $_secondsRemaining s",
                    style: TextStyle(
                      color: _canResend ? Palette.primaryColor : Colors.grey,
                      fontWeight: FontWeight.w700,
                      fontSize: SizeConfig.w(context, 14),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: SizeConfig.h(context, 24)),
          ],
        ),
      ),

      // ================= BOTTOM =================
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

              Expanded(
                child: Text(
                  "We never share this with anyone.",
                  style: TextStyle(
                    fontSize: SizeConfig.w(context, 13),
                    color: Colors.grey.shade600,
                  ),
                ),
              ),

              GestureDetector(
                onTap: isLoading
                    ? null
                    : () {
                        if (otpCode.length != 4) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Enter valid OTP")),
                          );
                          return;
                        }
                        verifyOtp();
                      },
                child: CircleAvatar(
                  radius: SizeConfig.w(context, 33),
                  backgroundColor: isLoading
                      ? Colors.grey
                      : Palette.primaryColor,
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                      : const Icon(
                          Icons.chevron_right_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= VERIFY =================

  Future<void> verifyOtp() async {
    if (otpCode.length != 4 || _isVerifying) return;

    _isVerifying = true;

    final shouldVerify = await context.showConfirmationDialog(
      title: 'Verify OTP',
      message: 'Verify OTP for ${widget.phoneNumber}?',
    );

    if (shouldVerify == true) {
      await ref
          .read(authControllerProvider.notifier)
          .verifyOtp(
            phoneNumber: widget.phoneNumber,
            otp: otpCode,
            context: context,
          );
    }

    _isVerifying = false;
  }
}
