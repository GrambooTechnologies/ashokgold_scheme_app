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

              // ---------- CONTACT US ----------
              Text(
                '  Contact Us',
                style: TextStyle(
                  fontSize: SizeConfig.w(context, 20),
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: SizeConfig.h(context, 10)),

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
                    children: [
                      _officeCard(
                        context,
                        title: mainBranch.branchName,
                        address: mainBranch.branchAddress ?? '--',
                      ),
                      SizedBox(height: SizeConfig.h(context, 20)),
                    ],
                  );
                },
                loading: () => SizedBox.shrink(),
                error: (error, stackTrace) => SizedBox.shrink(),
              ),

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
                      _contactTile(
                        context,
                        icon: CupertinoIcons.chat_bubble_text_fill,
                        title: 'Chat with us',
                        value: formattedPhone,
                        subtitle: availabilityText,
                        onTap: () => _openWhatsApp(
                          context: context,
                          phone: phoneNumber,
                          message: _defaultWhatsappMessage,
                        ),
                      ),
                      _contactTile(
                        context,
                        icon: CupertinoIcons.phone_fill,
                        title: 'Call us',
                        value: formattedPhone,
                        subtitle: availabilityText,
                        onTap: () =>
                            _call(context: context, number: phoneNumber),
                      ),
                      _contactTile(
                        context,
                        icon: CupertinoIcons.mail_solid,
                        title: 'Email',
                        value: branchEmail,
                        onTap: () =>
                            _email(context: context, email: branchEmail),
                        subtitle: 'Available 24/7, we reply within 24 hours',
                      ),
                    ],
                  );
                },
                loading: () => SizedBox.shrink(),
                error: (error, stackTrace) => SizedBox.shrink(),
              ),

              SizedBox(height: SizeConfig.h(context, 10)),

              Divider(color: Colors.grey.shade300),

              SizedBox(height: SizeConfig.h(context, 10)),

              // ---------- BRANCHES ----------
              Text(
                'Our Branches',
                style: TextStyle(
                  fontSize: SizeConfig.w(context, 20),
                  fontWeight: FontWeight.w700,
                ),
              ),

              SizedBox(height: SizeConfig.h(context, 15)),

              // Dynamic Branches from Provider
              branchesAsync.when(
                data: (branches) {
                  return Column(
                    children: [
                      ...branches.where((branch) => !branch.isMainBranch).map((
                        branch,
                      ) {
                        return Column(
                          children: [
                            _branchTile(
                              context,
                              () => _call(
                                context: context,
                                number: branch.branchPhone ?? '',
                              ),
                              branch.branchName,
                              branch.branchAddress ?? '--',
                              branch.branchPhone ?? '--',
                            ),
                            SizedBox(height: SizeConfig.h(context, 10)),
                          ],
                        );
                      }),
                    ],
                  );
                },
                loading: () {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Palette.primaryColor,
                    ),
                  );
                },
                error: (error, stackTrace) {
                  return Center(child: Text('Failed to load branches'));
                },
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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SizeConfig.w(context, 16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SizeConfig.w(context, 14)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: SizeConfig.w(context, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Palette.primaryColor,
              fontSize: SizeConfig.w(context, 16),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: SizeConfig.h(context, 3)),
          Text(
            address,
            style: TextStyle(
              color: Colors.grey.shade700,
              height: 1.5,
              fontSize: SizeConfig.w(context, 14),
            ),
          ),
        ],
      ),
    );
  }

  // ================= CONTACT TILE =================

  Widget _contactTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.h(context, 20)),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: Palette.backgroundColor,
          child: Row(
            children: [
              SizedBox(width: SizeConfig.w(context, 3)),
              Icon(
                icon,
                color: Palette.primaryColor,
                size: SizeConfig.w(context, 20),
              ),
              SizedBox(width: SizeConfig.w(context, 11)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$title: $value",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: SizeConfig.w(context, 15),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: SizeConfig.w(context, 11),
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= BRANCH TILE =================

  Widget _branchTile(
    BuildContext context,
    VoidCallback onTap,
    String title,
    String address,
    String phone,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(SizeConfig.w(context, 13)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(context, 13)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.h(context, 11)),
              Row(
                children: [
                  Icon(
                    Icons.store,
                    color: Palette.primaryColor,
                    size: SizeConfig.w(context, 24),
                  ),
                  SizedBox(width: SizeConfig.w(context, 8)),
                  SizedBox(
                    width: SizeConfig.w(context, 315),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: SizeConfig.w(context, 14),
                          ),
                        ),
                        Text(
                          address,
                          style: TextStyle(fontSize: SizeConfig.w(context, 12)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.h(context, 11)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.phone,
                    color: Palette.primaryColor,
                    size: SizeConfig.w(context, 17),
                  ),
                  SizedBox(width: SizeConfig.w(context, 15)),
                  Text(
                    phone,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: SizeConfig.w(context, 15),
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.h(context, 11)),
            ],
          ),
        ),
      ),
    );
    // return Card(
    //   color: Colors.white,
    //   margin: EdgeInsets.symmetric(
    //     vertical: SizeConfig.h(context, 6),
    //   ),
    //   elevation: 0,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(
    //       SizeConfig.w(context, 12),
    //     ),
    //   ),
    //   child: ListTile(
    //     leading: Icon(
    //       Icons.store,
    //       color: Palette.primaryColor,
    //       size: SizeConfig.w(context, 22),
    //     ),
    //     title: Text(
    //       title,
    //       style: TextStyle(
    //         fontWeight: FontWeight.w600,
    //         fontSize: SizeConfig.w(context, 14),
    //       ),
    //     ),
    //     subtitle: Text(
    //       address,
    //       style: TextStyle(
    //         fontSize: SizeConfig.w(context, 12),
    //       ),
    //     ),
    //   ),
    // );
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
