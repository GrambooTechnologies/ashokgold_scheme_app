import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/core/utilities/scale_size_utils.dart';
import 'package:ashokgold_scheme_app/core/utilities/url_launcher_custom.dart';
import 'package:ashokgold_scheme_app/features/common/models/branch_model.dart';
import 'package:ashokgold_scheme_app/features/common/providers/branches_list_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactSupportView extends ConsumerWidget {
  static const String routeName = '/contact-support';
  static const String _defaultWhatsappMessage =
      'Hello, I want to enquire about your scheme plans';

  const ContactSupportView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchesAsync = ref.watch(branchesListProvider);

    return Scaffold(
      backgroundColor: Palette.backgroundColor,

      // ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: Palette.backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Palette.blackColor,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Contact Support',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Palette.blackColor,
            fontSize: SizeConfig.w(context, 18),
          ),
        ),
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(context, 18)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: SizeConfig.h(context, 20)),

              // ---------- HERO BANNER ----------
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.h(context, 24),
                  horizontal: SizeConfig.w(context, 20),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Palette.primaryColor.withValues(alpha: 0.15),
                      Palette.primaryColor.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Palette.primaryColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How can we help you?',
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: SizeConfig.w(context, 20),
                        fontWeight: FontWeight.bold,
                        color: Palette.blackColor,
                      ),
                    ),
                    SizedBox(height: SizeConfig.h(context, 6)),
                    Text(
                      'Our customer support team is available to assist you with your queries.',
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: SizeConfig.w(context, 13),
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: SizeConfig.h(context, 24)),

              // ---------- CONTACT DETAILS ----------
              branchesAsync.when(
                data: (branches) {
                  BranchModel? mainBranch;
                  try {
                    mainBranch = branches.firstWhere(
                      (branch) => branch.isMainBranch,
                    );
                  } catch (e) {
                    mainBranch = null;
                  }

                  final phoneNumber = mainBranch?.branchPhone ?? '';
                  final formattedPhone = mainBranch?.branchPhone ?? '--';
                  final branchEmail = mainBranch?.branchEmail ?? '--';
                  final availabilityText =
                      mainBranch?.availabilityText ?? '---';

                  return Column(
                    children: [
                      _supportChannelCard(
                        context,
                        icon: CupertinoIcons.chat_bubble_2_fill,
                        title: 'Chat with us',
                        value: formattedPhone,
                        subtitle: availabilityText,
                        iconColor: const Color(0xFF25D366),
                        iconBg: const Color(0xFF25D366).withValues(alpha: 0.1),
                        onTap: () => _openWhatsApp(
                          context: context,
                          phone: phoneNumber,
                          message: _defaultWhatsappMessage,
                        ),
                      ),
                      _supportChannelCard(
                        context,
                        icon: CupertinoIcons.phone_fill,
                        title: 'Call us directly',
                        value: formattedPhone,
                        subtitle: availabilityText,
                        iconColor: Palette.primaryColor,
                        iconBg: Palette.primaryColor.withValues(alpha: 0.1),
                        onTap: () =>
                            _call(context: context, number: phoneNumber),
                      ),
                      _supportChannelCard(
                        context,
                        icon: CupertinoIcons.mail_solid,
                        title: 'Email support',
                        value: branchEmail,
                        subtitle: 'Available 24/7, we reply within 24 hours',
                        iconColor: const Color(0xFFFF9800),
                        iconBg: const Color(0xFFFF9800).withValues(alpha: 0.1),
                        onTap: () =>
                            _email(context: context, email: branchEmail),
                      ),
                    ],
                  );
                },
                loading: () => Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: CircularProgressIndicator(color: Palette.primaryColor),
                  ),
                ),
                error: (error, stackTrace) => const SizedBox.shrink(),
              ),
              SizedBox(height: SizeConfig.h(context, 20)),

              // ---------- MAIN OFFICE ----------
              branchesAsync.when(
                data: (branches) {
                  BranchModel? mainBranch;
                  try {
                    mainBranch = branches.firstWhere(
                      (branch) => branch.isMainBranch,
                    );
                  } catch (e) {
                    mainBranch = null;
                  }

                  if (mainBranch == null) {
                    return SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Head Office',
                        style: TextStyle(
                          fontSize: SizeConfig.w(context, 16),
                          fontWeight: FontWeight.bold,
                          color: Palette.blackColor,
                        ),
                      ),
                      SizedBox(height: SizeConfig.h(context, 12)),
                      _officeCard(
                        context,
                        title: mainBranch.branchName,
                        address: mainBranch.branchAddress ?? '--',
                      ),
                    ],
                  );
                },
                loading: () => SizedBox.shrink(),
                error: (error, stackTrace) => SizedBox.shrink(),
              ),

              SizedBox(height: SizeConfig.h(context, 40)),
            ],
          ),
        ),
      ),
    );
  }

  // ================= OFFICE CARD =================

  Widget _officeCard(
    BuildContext context, {
    required String title,
    required String address,
  }) {
    final w = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SizeConfig.w(context, 16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                color: Palette.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Palette.primaryColor,
                  fontFamily: 'Urbanist',
                  fontSize: w * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Text(
              address,
              style: TextStyle(
                fontFamily: 'Urbanist',
                color: Colors.grey.shade700,
                height: 1.5,
                fontSize: w * 0.033,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= SUPPORT CHANNEL CARD =================

  Widget _supportChannelCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required Color iconColor,
    required Color iconBg,
    required VoidCallback onTap,
  }) {
    final w = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.h(context, 16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: w * 0.038,
                          fontWeight: FontWeight.bold,
                          color: Palette.blackColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        value,
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: w * 0.035,
                          fontWeight: FontWeight.w600,
                          color: Palette.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: w * 0.028,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey.shade400,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  // ================= ACTIONS =================

  Future<void> _call({
    required BuildContext context,
    required String number,
  }) async {
    if (number.isEmpty || number == '--') return;
    await UrlLauncherCustom().makePhoneCall(
      phoneNumber: number,
      context: context,
    );
  }

  Future<void> _email({
    required BuildContext context,
    required String email,
  }) async {
    if (email.isEmpty || email == '--') return;
    await UrlLauncherCustom().sendEmail(email: email, context: context);
  }

  Future<void> _openWhatsApp({
    required BuildContext context,
    required String phone,
    required String message,
  }) async {
    if (phone.isEmpty || phone == '--') return;
    await UrlLauncherCustom().whatsapp(
      phoneNum: phone,
      message: message,
      context: context,
    );
  }
}
