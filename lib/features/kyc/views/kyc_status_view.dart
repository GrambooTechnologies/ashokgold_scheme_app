import 'package:ashokgold_scheme_app/core/custom_widgets/custom_snackBar.dart';
import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/core/utilities/url_launcher_custom.dart';
import 'package:ashokgold_scheme_app/features/common/providers/branches_list_provider.dart';
import 'package:ashokgold_scheme_app/features/home/views/bottom_nav.dart';
import 'package:ashokgold_scheme_app/features/kyc/models/customer_kyc_model.dart';
import 'package:ashokgold_scheme_app/features/kyc/models/kyc_status.dart';
import 'package:ashokgold_scheme_app/features/kyc/providers/kyc_provider.dart';
import 'package:ashokgold_scheme_app/features/kyc/views/kyc_selection_view.dart';
import 'package:ashokgold_scheme_app/features/kyc/widgets/admin_review_dialog.dart';
import 'package:ashokgold_scheme_app/features/kyc/widgets/kyc_status_badge.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/views/scheme_joining_view.dart';
import 'package:ashokgold_scheme_app/features/schemes/views/schemes_list_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class KycStatusView extends ConsumerWidget {
  static const String routeName = '/kyc-status';

  final String? targetSchemeId;
  final double? targetAmount;

  const KycStatusView({super.key, this.targetSchemeId, this.targetAmount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kycAsync = ref.watch(kycControllerProvider);
    final branchesAsync = ref.watch(branchesListProvider);
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    // Resolve support phone number
    String supportPhone = '+919447012345';
    branchesAsync.whenData((branches) {
      try {
        final mainBranch = branches.firstWhere((b) => b.isMainBranch);
        final phone = mainBranch.branchPhone;
        if (phone != null && phone.isNotEmpty) {
          supportPhone = phone;
        }
      } catch (_) {
        if (branches.isNotEmpty) {
          final firstPhone = branches.first.branchPhone;
          if (firstPhone != null && firstPhone.isNotEmpty) {
            supportPhone = firstPhone;
          }
        }
      }
    });

    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      appBar: AppBar(
        backgroundColor: Palette.backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Palette.blackColor,
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(BottomNav.routeName);
            }
          },
        ),
        title: const Text(
          'Verification Status',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Palette.blackColor,
            fontSize: 18,
            fontFamily: 'Urbanist',
          ),
        ),
      ),
      body: kycAsync.when(
        data: (kyc) {
          if (kyc == null || kyc.status == KycStatus.notSubmitted) {
            return _buildNoSubmission(context, w, h);
          }
          return _buildStatusBody(context, ref, kyc, supportPhone, w, h);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 12),
                Text(
                  'Failed to load verification status: $err',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontFamily: 'Urbanist'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoSubmission(BuildContext context, double w, double h) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * 0.08),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Palette.primaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shield_outlined,
                size: 56,
                color: Palette.primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No KYC Submitted Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E),
                fontFamily: 'Urbanist',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Identity verification is required before joining gold schemes. Submit your government ID proof in a few simple steps.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                height: 1.4,
                fontFamily: 'Urbanist',
              ),
            ),
            const SizedBox(height: 26),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  context.pushReplacement(
                    KycSelectionView.routeName,
                    extra: {
                      'targetSchemeId': targetSchemeId,
                      'targetAmount': targetAmount,
                    },
                  );
                },
                child: const Text(
                  'Start Identity Verification',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    fontFamily: 'Urbanist',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBody(
    BuildContext context,
    WidgetRef ref,
    CustomerKycModel kyc,
    String supportPhone,
    double w,
    double h,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: w * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: h * 0.012),

          // Main Status Header Card
          _buildHeroStatusCard(context, kyc, w, h),

          SizedBox(height: h * 0.02),

          // Reference & Application Details Card
          _buildApplicationDetailsCard(context, kyc, w),

          SizedBox(height: h * 0.02),

          // Timeline / Journey Stepper
          _buildJourneyCard(kyc, w),

          SizedBox(height: h * 0.02),

          // Contextual Action Buttons
          if (kyc.status == KycStatus.approved) ...[
            // APPROVED ACTION
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF047857),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  if (targetSchemeId != null) {
                    context.pushReplacement(
                      SchemeJoiningView.routePath(
                        schemeId: targetSchemeId!,
                        amount: targetAmount,
                      ),
                    );
                  } else {
                    context.push(SchemesListView.routeName);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.stars_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      targetSchemeId != null
                          ? 'Continue Scheme Enrollment'
                          : 'Explore & Join Schemes',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ] else if (kyc.status == KycStatus.actionRequired ||
              kyc.status == KycStatus.rejected) ...[
            // ACTION REQUIRED OR REJECTED RESUBMISSION
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kyc.status == KycStatus.actionRequired
                      ? const Color(0xFFEA580C)
                      : Palette.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  context.push(
                    KycSelectionView.routeName,
                    extra: {
                      'isResubmission': true,
                      'existingKyc': kyc,
                      'targetSchemeId': targetSchemeId,
                      'targetAmount': targetAmount,
                    },
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.refresh_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      kyc.status == KycStatus.actionRequired
                          ? 'Resubmit Corrected Documents'
                          : 'Submit Fresh Verification Application',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Prominent Contact Us Button (Requirement 4)
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: Palette.primaryColor.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                backgroundColor: Colors.white,
              ),
              onPressed: () async {
                await UrlLauncherCustom().makePhoneCall(
                  phoneNumber: supportPhone,
                  context: context,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.phone_fill,
                    size: 18,
                    color: Palette.primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Contact Us ($supportPhone)',
                    style: TextStyle(
                      color: Palette.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: h * 0.025),

          // Admin Review Tool Simulator (Requirement 7)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.admin_panel_settings_outlined,
                  size: 22,
                  color: Color(0xFF475569),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Admin Review Simulator',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                          fontFamily: 'Urbanist',
                        ),
                      ),
                      Text(
                        'Test Approve, Reject, or Request Resubmission.',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    backgroundColor: Palette.primaryColor.withValues(
                      alpha: 0.1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    AdminReviewDialog.show(context, kyc: kyc);
                  },
                  child: Text(
                    'Open Review',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Palette.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: h * 0.04),
        ],
      ),
    );
  }

  Widget _buildHeroStatusCard(
    BuildContext context,
    CustomerKycModel kyc,
    double w,
    double h,
  ) {
    Color cardBg;
    Color iconBg;
    Color iconColor;
    IconData icon;
    String title;
    String subtitle;

    switch (kyc.status) {
      case KycStatus.approved:
        cardBg = const Color(0xFF064E3B);
        iconBg = const Color(0xFF10B981);
        iconColor = Colors.white;
        icon = Icons.verified_user_rounded;
        title = 'Identity Verified';
        subtitle =
            'Your identity verification is approved! You can now freely join any gold savings scheme.';
        break;
      case KycStatus.pending:
        cardBg = const Color(0xFF78350F);
        iconBg = const Color(0xFFF59E0B);
        iconColor = Colors.white;
        icon = Icons.hourglass_top_rounded;
        title = 'Verification Under Review';
        subtitle =
            'Your submitted documents are currently being verified by our compliance team. Turnaround time is usually within 24–48 hours.';
        break;
      case KycStatus.actionRequired:
        cardBg = const Color(0xFF9A3412);
        iconBg = const Color(0xFFEA580C);
        iconColor = Colors.white;
        icon = Icons.warning_amber_rounded;
        title = 'Action Required on Documents';
        subtitle =
            kyc.adminNote ??
            'Please review feedback and resubmit corrected documents.';
        break;
      case KycStatus.rejected:
        cardBg = const Color(0xFF7F1D1D);
        iconBg = const Color(0xFFEF4444);
        iconColor = Colors.white;
        icon = Icons.cancel_rounded;
        title = 'Verification Rejected';
        subtitle =
            kyc.adminNote ??
            'Verification was unsuccessful. Please check document quality and submit again.';
        break;
      case KycStatus.notSubmitted:
        cardBg = Palette.primaryColor;
        iconBg = Colors.grey;
        iconColor = Colors.white;
        icon = Icons.shield_outlined;
        title = 'Not Submitted';
        subtitle =
            'Identity verification is required before scheme enrollment.';
        break;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(w * 0.05),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: cardBg.withValues(alpha: 0.3),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KycStatusBadge(status: kyc.status, compact: true),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: h * 0.015),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12.5,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.4,
              fontFamily: 'Urbanist',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationDetailsCard(
    BuildContext context,
    CustomerKycModel kyc,
    double w,
  ) {
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');
    final formattedDate = dateFormat.format(kyc.submittedAt);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reference Number Highlight Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FE),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'APPLICATION REFERENCE NO.',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade500,
                          letterSpacing: 0.8,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        kyc.referenceId,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A2E),
                          letterSpacing: 0.5,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: kyc.referenceId));
                    context.showSuccessSnackBar(
                      'Reference Number copied to clipboard!',
                    );
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Palette.primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.copy_rounded,
                      size: 16,
                      color: Palette.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          _detailRow('Customer Name', kyc.customerName),
          const Divider(height: 16),
          _detailRow('Phone Number', kyc.phoneNumber),
          const Divider(height: 16),
          _detailRow('Document Type', kyc.idProofType.title),
          const Divider(height: 16),
          _detailRow('Document ID', _maskIdNumber(kyc.idNumber)),
          const Divider(height: 16),
          _detailRow('Submitted On', formattedDate),
          if (kyc.reviewedAt != null) ...[
            const Divider(height: 16),
            _detailRow('Reviewed On', dateFormat.format(kyc.reviewedAt!)),
          ],
        ],
      ),
    );
  }

  Widget _buildJourneyCard(CustomerKycModel kyc, double w) {
    final bool step1Done = true;
    final bool step2Done = kyc.status == KycStatus.approved;
    final bool step2Active = kyc.status == KycStatus.pending;
    final bool step2ActionReq = kyc.status == KycStatus.actionRequired;
    final bool step2Rejected = kyc.status == KycStatus.rejected;
    final bool step3Unlocked = kyc.status == KycStatus.approved;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Verification Journey',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
              fontFamily: 'Urbanist',
            ),
          ),
          const SizedBox(height: 14),

          // Step 1: Submission
          _timelineStep(
            stepNumber: '1',
            title: 'Documents Submitted',
            desc: 'Details & photos uploaded securely.',
            isDone: step1Done,
            isActive: false,
          ),

          // Connector
          _timelineConnector(isDone: step1Done),

          // Step 2: Admin Review
          _timelineStep(
            stepNumber: '2',
            title: step2Done
                ? 'Admin Review Approved'
                : step2ActionReq
                ? 'Action Required on Documents'
                : step2Rejected
                ? 'Verification Rejected'
                : 'Admin Review in Progress',
            desc: step2Done
                ? 'Identity verified by compliance.'
                : step2ActionReq
                ? 'Please review comments and resubmit.'
                : step2Rejected
                ? 'Document review could not be approved.'
                : 'Reviewing against government guidelines.',
            isDone: step2Done,
            isActive: step2Active || step2ActionReq || step2Rejected,
            customColor: step2Done
                ? const Color(0xFF10B981)
                : step2ActionReq
                ? const Color(0xFFEA580C)
                : step2Rejected
                ? const Color(0xFFEF4444)
                : const Color(0xFFF59E0B),
          ),

          // Connector
          _timelineConnector(isDone: step2Done),

          // Step 3: Scheme Enrollment
          _timelineStep(
            stepNumber: '3',
            title: 'Gold Scheme Enrollment',
            desc: step3Unlocked
                ? 'Unlocked! You can now join any scheme.'
                : 'Locked until identity verification is approved.',
            isDone: step3Unlocked,
            isActive: false,
          ),
        ],
      ),
    );
  }

  Widget _timelineStep({
    required String stepNumber,
    required String title,
    required String desc,
    required bool isDone,
    required bool isActive,
    Color? customColor,
  }) {
    Color circleColor = Colors.grey.shade300;
    Color textColor = Colors.grey.shade500;
    Widget iconChild = Text(
      stepNumber,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    );

    if (isDone) {
      circleColor = const Color(0xFF10B981);
      textColor = const Color(0xFF1A1A2E);
      iconChild = const Icon(Icons.check, size: 14, color: Colors.white);
    } else if (isActive) {
      circleColor = customColor ?? const Color(0xFFF59E0B);
      textColor = const Color(0xFF1A1A2E);
      iconChild = const Icon(Icons.pending, size: 14, color: Colors.white);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle),
          child: Center(child: iconChild),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                  fontFamily: 'Urbanist',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                  fontFamily: 'Urbanist',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _timelineConnector({required bool isDone}) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Container(
        width: 2,
        height: 18,
        color: isDone ? const Color(0xFF10B981) : Colors.grey.shade300,
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontFamily: 'Urbanist',
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A2E),
            fontFamily: 'Urbanist',
          ),
        ),
      ],
    );
  }

  String _maskIdNumber(String id) {
    if (id.length <= 4) return id;
    final visible = id.substring(id.length - 4);
    final masked = '*' * (id.length - 4);
    return '$masked$visible';
  }
}
