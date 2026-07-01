import 'package:ashokgold_scheme_app/core/custom_widgets/custom_snackBar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherCustom {
  String _normalizePhoneForWhatsApp(String phoneNum) {
    final digits = phoneNum.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return '';

    // India local mobile format: 0XXXXXXXXXX -> 91XXXXXXXXXX
    if (digits.length == 11 && digits.startsWith('0')) {
      return '91${digits.substring(1)}';
    }

    // India mobile without country code: XXXXXXXXXX -> 91XXXXXXXXXX
    if (digits.length == 10) {
      return '91$digits';
    }

    return digits;
  }

  /// Launches a phone call to the given [phoneNumber].
  /// Throws an error if the device does not support phone calls.
  Future<void> makePhoneCall({
    required String phoneNumber,
    bool showError = true,
    BuildContext? context,
  }) async {
    final sanitizedPhone = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    if (sanitizedPhone.isEmpty) {
      if (showError && context != null) {
        context.showErrorSnackBar('Invalid phone number');
      }
      return;
    }

    final Uri launchUri = Uri(scheme: 'tel', path: sanitizedPhone);
    final launched = await launchUrl(launchUri);
    if (!launched && showError && context != null) {
      context.showErrorSnackBar('Could not call this phone number');
    }
  }

  /// Launches WhatsApp with the given [phoneNum] and [message].
  /// Falls back to WhatsApp web if the app is not installed.
  Future<void> whatsapp({
    required String phoneNum,
    String message = '',
    BuildContext? context,
    bool showError = true,
  }) async {
    final String contact = _normalizePhoneForWhatsApp(phoneNum);
    if (contact.isEmpty) {
      if (showError && context != null) {
        context.showErrorSnackBar('Invalid WhatsApp number');
      }
      return;
    }

    final String encodedText = Uri.encodeComponent(message);
    final Uri appUri = Uri.parse(
      'whatsapp://send?phone=$contact&text=$encodedText',
    );
    final Uri waMeUri = Uri.parse('https://wa.me/$contact?text=$encodedText');
    final Uri webUri = Uri.parse(
      'https://api.whatsapp.com/send/?phone=$contact&text=$encodedText',
    );

    final launchedInApp = await launchUrl(
      appUri,
      mode: LaunchMode.externalApplication,
    );
    if (launchedInApp) return;

    final launchedWaMe = await launchUrl(
      waMeUri,
      mode: LaunchMode.externalApplication,
    );
    if (launchedWaMe) return;

    final launchedWeb = await launchUrl(
      webUri,
      mode: LaunchMode.externalApplication,
    );
    if (!launchedWeb && showError && context != null) {
      context.showErrorSnackBar('Could not open WhatsApp');
    }
  }

  /// Launches the SMS app with the given [phoneNum] and [message].
  Future<void> sendSMS({
    required String phoneNum,
    String message = '',
    BuildContext? context,
    bool showError = true,
  }) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNum,
      query: message.isNotEmpty ? 'body=${Uri.encodeComponent(message)}' : null,
    );
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      if (showError && context != null) {
        context.showErrorSnackBar('Could not send SMS');
      }
      throw 'Could not send SMS';
    }
  }

  /// Launches the default email app to compose an email.
  Future<void> sendEmail({
    required String email,
    String? subject,
    String? body,
    BuildContext? context,
    bool showError = true,
  }) async {
    final sanitizedEmail = email.trim();
    if (sanitizedEmail.isEmpty) {
      if (showError && context != null) {
        context.showErrorSnackBar('Invalid email address');
      }
      return;
    }

    final uri = Uri(
      scheme: 'mailto',
      path: sanitizedEmail,
      queryParameters: {
        if (subject != null && subject.isNotEmpty) 'subject': subject,
        if (body != null && body.isNotEmpty) 'body': body,
      },
    );

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && showError && context != null) {
      context.showErrorSnackBar('Could not open email app');
    }
  }
}
