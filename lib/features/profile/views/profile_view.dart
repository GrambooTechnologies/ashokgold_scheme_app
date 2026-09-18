import 'package:ashokgold_scheme_app/core/custom_dialogs/customDialogeBox.dart';
import 'package:ashokgold_scheme_app/core/custom_widgets/custom_floating_button.dart';
import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/core/utilities/auth_guard.dart';
import 'package:ashokgold_scheme_app/core/utilities/logger.dart';
import 'package:ashokgold_scheme_app/core/utilities/scale_size_utils.dart';
import 'package:ashokgold_scheme_app/features/auth/controllers/auth_controller.dart';
import 'package:ashokgold_scheme_app/features/auth/models/customer_model.dart';
import 'package:ashokgold_scheme_app/features/auth/providers/customer_provider.dart';
import 'package:ashokgold_scheme_app/features/nominee/models/nominee_model.dart';
import 'package:ashokgold_scheme_app/features/notifications/providers/notification_inbox_provider.dart';
import 'package:ashokgold_scheme_app/features/notifications/views/notification_inbox_view.dart';
import 'package:ashokgold_scheme_app/features/nominee/providers/nominee_provider.dart';
import 'package:ashokgold_scheme_app/features/nominee/views/nominee_list_view.dart';
import 'package:ashokgold_scheme_app/features/profile/views/appinfo.dart';
import 'package:ashokgold_scheme_app/features/profile/views/contact_support_view.dart';
import 'package:ashokgold_scheme_app/features/profile/views/edit_profile_view.dart';
import 'package:ashokgold_scheme_app/features/profile/views/social_media_view.dart';
import 'package:ashokgold_scheme_app/features/settings/views/privacy_policy_view.dart';
import 'package:ashokgold_scheme_app/features/settings/views/terms_and_conditions_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileView extends ConsumerStatefulWidget {
  static const String routeName = '/profile';

  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView>
    with SingleTickerProviderStateMixin {
  bool _nomineeExpanded = false;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();

    // Fetch unread notification count for the bell badge.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationUnreadCountProvider.notifier).fetchCount();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customer = ref.watch(customerProvider);
    final nomineesAsync = ref.watch(nomineeListProvider);
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    logger.i(customer?.toJson());

    final String name = customer?.fullName ?? 'Guest User';
    final String phone = customer?.phoneNumber ?? 'Not logged in';
    final String email = customer?.email ?? 'guest@example.com';
    final String? photo = customer?.profilePhoto;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Palette.backgroundColor,
        appBar: AppBar(
          backgroundColor: Palette.backgroundColor,
          forceMaterialTransparency: true,
          automaticallyImplyLeading: false,
          centerTitle: true,
          toolbarHeight: SizeConfig.h(context, 36),
        ),
        body: FadeTransition(
          opacity: _fadeAnim,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.045),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: SizeConfig.w(context, 4)),
                    child: Text(
                      'My Profile',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: SizeConfig.w(context, 18),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.h(context, 3)),
                  Padding(
                    padding: EdgeInsets.only(
                      left: SizeConfig.w(context, 4),
                      right: SizeConfig.w(context, 10),
                    ),
                    child: Text(
                      "Manage your personal details, nominee information, and account settings.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        height: 1.2,
                        fontSize: SizeConfig.w(context, 12),
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.h(context, 17)),

                  // ── Profile Hero Card ──
                  _buildProfileHeroCard(
                    context,
                    w,
                    h,
                    name,
                    phone,
                    email,
                    photo,
                    customer,
                  ),

                  SizedBox(height: h * 0.022),

                  _sectionLabel('Account'),
                  SizedBox(height: h * 0.008),

                  // ── Nominees ──
                  _buildNomineeSection(context, w, customer, nomineesAsync),

                  SizedBox(height: h * 0.022),

                  _sectionLabel('Support'),
                  SizedBox(height: h * 0.008),

                  // ── Support ──
                  _buildMenuCard(
                    w: w,
                    children: [
                      _buildMenuItem(
                        w: w,
                        icon: Icons.headset_mic_rounded,
                        iconColor: const Color(0xFF4361EE),
                        iconBg: const Color(0xFFEEF1FF),
                        title: 'Customer Support',
                        subtitle: 'We\'re here to help',
                        onTap: () => context.push(ContactSupportView.routeName),
                      ),
                      _divider(w),
                      _buildMenuItem(
                        w: w,
                        icon: Icons.campaign_outlined,
                        iconColor: const Color(0xFF047857),
                        iconBg: const Color(0xFFE8FAF1),
                        title: 'Social Media',
                        subtitle: 'Main branch social handles',
                        onTap: () => context.push(SocialMediaView.routeName),
                      ),
                    ],
                  ),

                  SizedBox(height: h * 0.022),

                  _sectionLabel('App Info & Legal'),
                  SizedBox(height: h * 0.008),

                  // ── App Info & Legal ──
                  _buildMenuCard(
                    w: w,
                    children: [
                      _buildMenuItem(
                        w: w,
                        icon: Icons.description_outlined,
                        iconColor: const Color(0xFF1D4ED8),
                        iconBg: const Color(0xFFEAF1FF),
                        title: 'Terms & Conditions',
                        subtitle: 'Read app usage terms',
                        onTap: () =>
                            context.push(TermsAndConditionsView.routeName),
                      ),
                      _divider(w),
                      _buildMenuItem(
                        w: w,
                        icon: Icons.privacy_tip_outlined,
                        iconColor: const Color(0xFF7209B7),
                        iconBg: const Color(0xFFF5EEFF),
                        title: 'Privacy Policy',
                        subtitle: 'How we use your data',
                        onTap: () => context.push(PrivacyPolicyView.routeName),
                      ),
                      _divider(w),
                      // ── App Info row ──
                      _buildMenuItem(
                        w: w,
                        icon: Icons.info_outline_rounded,
                        iconColor: Palette.primaryColor,
                        iconBg: Palette.primaryColor.withValues(alpha: 0.1),
                        title: 'About App',
                        subtitle: 'Version, developer info',
                        onTap: () => context.push(AppInfoView.routeName),
                      ),
                    ],
                  ),

                  SizedBox(height: h * 0.022),

                  // ── Auth ──
                  _buildMenuCard(
                    w: w,
                    children: [
                      if (customer != null)
                        Column(
                          children: [
                            _buildMenuItem(
                              w: w,
                              icon: Icons.delete_outline,
                              iconColor: const Color(0xFF7209B7),
                              iconBg: const Color(0xFFF5EEFF),
                              title: 'Delete',
                              subtitle: 'Delete your account',
                              onTap: () => _showDeleteAccountSheet(context),
                            ),
                            _buildMenuItem(
                              w: w,
                              icon: Icons.logout_rounded,
                              iconColor: const Color(0xFFE63946),
                              iconBg: const Color(0xFFFFEEEF),
                              title: 'Sign Out',
                              subtitle: 'See you soon!',
                              onTap: () async {
                                final shouldLogout =
                                    await AppDialog.showLogoutConfirmation(
                                      context: context,
                                    );
                                if (shouldLogout == true && context.mounted) {
                                  await ref
                                      .read(authControllerProvider.notifier)
                                      .logout(context: context);
                                }
                              },
                            ),
                          ],
                        )
                      else
                        _buildMenuItem(
                          w: w,
                          icon: Icons.login_rounded,
                          iconColor: Palette.primaryColor,
                          iconBg: Palette.primaryColor.withValues(alpha: 0.1),
                          title: 'Login',
                          subtitle: 'Access your account',
                          onTap: () => AuthGuard.requireAuth(context, ref),
                        ),
                    ],
                  ),

                  SizedBox(height: h * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: Colors.grey.shade500,
          fontFamily: 'Urbanist',
        ),
      ),
    );
  }

  Widget _buildProfileHeroCard(
    BuildContext context,
    double w,
    double h,
    String name,
    String phone,
    String email,
    String? photo,
    CustomerModel? customer,
  ) {
    ImageProvider? imageProvider;
    if (photo != null) imageProvider = NetworkImage(photo);

    Widget? avatarChild;
    if (photo == null) {
      avatarChild = Icon(
        Icons.person_rounded,
        size: w * 0.12,
        color: Colors.white70,
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Palette.primaryColor, Color(0xFF16213E)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1A2E).withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            right: -20,
            child: Container(
              width: w * 0.4,
              height: w * 0.4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Palette.primaryColor.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            left: -20,
            child: Container(
              width: w * 0.35,
              height: w * 0.35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(w * 0.055),
            child: Column(
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Palette.primaryColor,
                                Palette.primaryColor.withValues(alpha: 0.5),
                              ],
                            ),
                          ),
                          child: CircleAvatar(
                            radius: w * 0.09,
                            backgroundColor: const Color(0xFF0F3460),
                            backgroundImage: imageProvider,
                            child: avatarChild,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: w * 0.04),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: w * 0.048,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Urbanist',
                              letterSpacing: -0.3,
                            ),
                          ),
                          SizedBox(height: h * 0.005),
                          _infoChip(Icons.phone_rounded, phone, w),
                          SizedBox(height: h * 0.004),
                          _infoChip(Icons.mail_outline_rounded, email, w),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: h * 0.022),
                GestureDetector(
                  onTap: () {
                    if (customer != null) {
                      context.push(EditProfileView.routeName, extra: customer);
                    } else {
                      AuthGuard.requireAuth(context, ref);
                      setState(() {});
                      return;
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: h * 0.016),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.white.withValues(alpha: 0.1),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit_rounded,
                          size: w * 0.04,
                          color: Colors.white,
                        ),
                        SizedBox(width: w * 0.02),
                        Text(
                          'Edit Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: w * 0.036,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String text, double w) {
    return Row(
      children: [
        Icon(icon, size: w * 0.033, color: Colors.white38),
        SizedBox(width: w * 0.015),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white60,
              fontSize: w * 0.031,
              fontFamily: 'Urbanist',
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuCard({required double w, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _divider(double w) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.16),
      child: Divider(height: 1, color: Colors.grey.shade100),
    );
  }

  Widget _buildNomineeSection(
    BuildContext context,
    double w,
    CustomerModel? customer,
    AsyncValue<List<CustomerNomineeModel>> nomineesAsync,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(
            horizontal: w * 0.05,
            vertical: w * 0.01,
          ),
          initiallyExpanded: _nomineeExpanded,
          onExpansionChanged: (expanded) {
            if (customer == null) {
              AuthGuard.requireAuth(context, ref);
              return;
            }
            setState(() => _nomineeExpanded = expanded);
          },
          trailing: AnimatedRotation(
            turns: _nomineeExpanded ? 0.25 : 0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Palette.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                CupertinoIcons.right_chevron,
                size: 13,
                color: Palette.primaryColor,
              ),
            ),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF6FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.people_alt_rounded,
                  size: w * 0.045,
                  color: const Color(0xFF2176FF),
                ),
              ),
              SizedBox(width: w * 0.035),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Nominees',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: w * 0.038,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  Text(
                    'Manage beneficiaries',
                    style: TextStyle(
                      fontSize: w * 0.028,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          children: [
            if (customer == null) ...[
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Please login to view your nominees',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ),
            ] else ...[
              Divider(height: 1, color: Colors.grey.shade100),
              nomineesAsync.when(
                data: (list) {
                  if (list.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Icon(
                            Icons.person_add_alt_1_rounded,
                            size: 40,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No nominees added yet',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _addNomineeButton(context),
                        ],
                      ),
                    );
                  }
                  final preview = list.take(3).toList();
                  return Column(
                    children: [
                      const SizedBox(height: 8),
                      ...preview.map((n) => _nomineePreviewItem(n.nomineeName)),
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: _addNomineeButton(
                          context,
                          label: 'Add / View All Nominees',
                        ),
                      ),
                    ],
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(20),
                  child: CupertinoActivityIndicator(),
                ),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Failed to load nominees',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _addNomineeButton(
    BuildContext context, {
    String label = 'Add Nominee',
  }) {
    return GestureDetector(
      onTap: () => context.push(NomineeListView.routeName),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Palette.primaryColor.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Palette.primaryColor.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, size: 16, color: Palette.primaryColor),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Palette.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nomineePreviewItem(String name) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(context, 16),
        vertical: SizeConfig.h(context, 5),
      ),
      child: Container(
        height: SizeConfig.h(context, 48),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FE),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.w(context, 14)),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Palette.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_rounded,
                size: SizeConfig.w(context, 15),
                color: Palette.primaryColor,
              ),
            ),
            SizedBox(width: SizeConfig.w(context, 12)),
            Text(
              name,
              style: TextStyle(
                fontSize: SizeConfig.w(context, 15),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A2E),
              ),
            ),
            const Spacer(),
            Icon(
              CupertinoIcons.info_circle,
              size: 15,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required double w,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: w * 0.05,
          vertical: w * 0.038,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: w * 0.043, color: iconColor),
            ),
            SizedBox(width: w * 0.035),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: w * 0.037,
                      color: const Color(0xFF1A1A2E),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: w * 0.028,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              CupertinoIcons.right_chevron,
              size: 14,
              color: Colors.grey.shade300,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountSheet(BuildContext context) {
    final TextEditingController feedbackController = TextEditingController();
    String? selectedReason;

    final reasons = [
      "Completed my scheme plan",
      "Taking a break, will be back later",
      "Looking for something better",
      "Not satisfied with service",
      "Privacy concerns",
      "Found better option elsewhere",
      "Other",
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Center(
                            child: Text(
                              "Delete",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 40),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...reasons.map((reason) {
                      return GestureDetector(
                        onTap: () => setState(() => selectedReason = reason),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: selectedReason == reason
                                        ? Colors.black
                                        : Colors.grey.shade400,
                                    width: 2,
                                  ),
                                ),
                                child: selectedReason == reason
                                    ? Center(
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.black,
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  reason,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                    Text(
                      selectedReason == "Other"
                          ? "Tell us your reason"
                          : "Optional feedback",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        controller: feedbackController,
                        maxLines: selectedReason == "Other" ? 4 : 2,
                        decoration: InputDecoration(
                          hintText: selectedReason == "Other"
                              ? "Please specify your reason..."
                              : "Additional feedback (optional)",
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    CustomFloatingButton(
                      text: "Delete",
                      onPressed: selectedReason == null
                          ? null
                          : () async {
                              Navigator.pop(context);
                              final confirm = await AppDialog.showDeleteAccount(
                                context: context,
                              );
                              if (confirm == true) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Deletion request submitted"),
                                  ),
                                );
                              }
                            },
                    ),
                    const SizedBox(height: 13),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ── Notification bell with unread badge ──────────────────────────────────────

class _NotificationBell extends ConsumerWidget {
  final double w;
  const _NotificationBell({required this.w});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(notificationUnreadCountProvider);

    return GestureDetector(
      onTap: () => context.push(NotificationInboxView.routeName),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            Icons.notifications_rounded,
            color: const Color(0xFF1A1A2E),
            size: w * 0.065,
          ),
          if (unreadCount > 0)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                constraints: BoxConstraints(
                  minWidth: w * 0.042,
                  minHeight: w * 0.042,
                ),
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    unreadCount > 99 ? '99+' : '$unreadCount',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontSize: w * 0.022,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
