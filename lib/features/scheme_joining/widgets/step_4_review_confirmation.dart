import 'package:ashokgold_scheme_app/core/custom_widgets/error_retry_widget.dart';
import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/core/utilities/loader.dart';
import 'package:ashokgold_scheme_app/core/utilities/scale_size_utils.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/providers/form_controllers_provider.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/providers/scheme_joining_form_provider.dart';
import 'package:ashokgold_scheme_app/features/schemes/models/scheme_detail_response_model.dart';
import 'package:ashokgold_scheme_app/features/schemes/providers/scheme_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Step4ReviewConfirmation extends ConsumerWidget {
  final String schemeId;

  const Step4ReviewConfirmation({super.key, required this.schemeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(schemeJoiningFormProvider);
    final controllers = ref.watch(formControllersProvider);
    final schemeAsync = ref.watch(schemeDetailProvider(schemeId));

    return schemeAsync.when(
      data: (scheme) => _ReviewContent(
        scheme: scheme,
        formState: formState,
        controllers: controllers,
      ),
      loading: () => const Loader(),
      error: (error, _) => ErrorRetryWidget(
        message: 'Failed to load scheme details.',
        onRetry: () => ref.invalidate(schemeDetailProvider(schemeId)),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Main content widget
// ─────────────────────────────────────────────

class _ReviewContent extends StatelessWidget {
  final SchemeDetailByIdResponseModel scheme;
  final dynamic formState;
  final dynamic controllers;

  const _ReviewContent({
    required this.scheme,
    required this.formState,
    required this.controllers,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        SizeConfig.w(context, 16),
        SizeConfig.h(context, 20),
        SizeConfig.w(context, 16),
        SizeConfig.h(context, 20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Step Header ──
          _StepHeader(),
          SizedBox(height: h * 0.025),

          // ── Scheme Banner Card ──
          _SchemeBannerCard(scheme: scheme),
          SizedBox(height: h * 0.02),

          // ── Scheme Info Section ──
          _SectionHeading(title: 'Scheme Information'),
          SizedBox(height: h * 0.01),
          _InfoCard(
            children: [
              _InfoRow(
                label: 'Scheme Type',
                value: scheme.schemeType.schemeTypeName,
                icon: Icons.category_outlined,
              ),
              _InfoRow(
                label: 'Installments',
                value: '${scheme.schemeDetails.installmentCount} months',
                icon: Icons.calendar_month_outlined,
              ),
              _InfoRow(
                label: 'Scheme Code',
                value: scheme.schemeCode,
                icon: Icons.tag_rounded,
                valueColor: Palette.primaryColor,
              ),
            ],
          ),
          SizedBox(height: h * 0.018),

          // ── Branch & Nominee Section ──
          _SectionHeading(title: 'Branch & Nominee'),
          SizedBox(height: h * 0.01),
          _InfoCard(
            children: [
              _InfoRow(
                label: 'Selected Branch',
                value: formState.selectedBranch?.branchName ?? 'Not selected',
                icon: Icons.store_outlined,
                valueColor: formState.selectedBranch == null
                    ? Colors.red[400]
                    : null,
              ),
              _InfoRow(
                label: 'Nominee',
                value: formState.selectedNominee?.nomineeName ?? 'Not selected',
                icon: Icons.person_outline_rounded,
                valueColor: formState.selectedNominee == null
                    ? Colors.red[400]
                    : null,
              ),
            ],
          ),
          SizedBox(height: h * 0.018),

          // ── Payment Details Section ──
          _SectionHeading(title: 'Payment Details'),
          SizedBox(height: h * 0.01),
          _PaymentHighlightCard(
            installmentAmount: formState.installmentAmount,
            installmentCount: scheme.schemeDetails.installmentCount,
          ),
          SizedBox(height: h * 0.018),

          // ── Billing Address Section ──
          _SectionHeading(title: 'Billing Address'),
          SizedBox(height: h * 0.01),
          _AddressCard(controllers: controllers),
          SizedBox(height: h * 0.025),

          // ── Confirmation Checkbox/Notice ──
          _ConfirmationNotice(),
          SizedBox(height: h * 0.01),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────

class _StepHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: SizeConfig.w(context, 42),
          height: SizeConfig.w(context, 42),
          decoration: BoxDecoration(
            color: Palette.primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            '04',
            style: TextStyle(
              color: Colors.white,
              fontSize: SizeConfig.w(context, 13),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(width: SizeConfig.w(context, 12)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Review & Confirm',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: w * 0.052,
                  fontWeight: FontWeight.w800,
                  color: Palette.primaryColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Verify all details before proceeding to payment',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: w * 0.034,
                  color: Palette.blackColor.withOpacity(0.5),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SchemeBannerCard extends StatelessWidget {
  final SchemeDetailByIdResponseModel scheme;

  const _SchemeBannerCard({required this.scheme});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image or gradient banner
          if (scheme.imageUrl != null)
            SizedBox(
              height: h * 0.2,
              width: double.infinity,
              child: Image.network(
                scheme.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _GradientBanner(height: h * 0.2),
              ),
            )
          else
            _GradientBanner(height: h * 0.2),

          // Info below image
          Container(
            padding: EdgeInsets.all(w * 0.04),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scheme.name,
                  style: TextStyle(
                    fontSize: w * 0.052,
                    fontWeight: FontWeight.w800,
                    color: Palette.blackColor,
                  ),
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    _TagChip(
                      label: scheme.schemeCode,
                      color: Palette.primaryColor,
                      icon: Icons.tag_rounded,
                    ),
                    SizedBox(width: 8),
                    _TagChip(
                      label: scheme.schemeGroup.schemeGroupName,
                      color: Colors.blue[600]!,
                    ),
                  ],
                ),
                if (scheme.description != null &&
                    scheme.description!.isNotEmpty) ...[
                  SizedBox(height: 8),
                  Text(
                    scheme.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: w * 0.033,
                      color: Palette.blackColor.withOpacity(0.55),
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientBanner extends StatelessWidget {
  final double height;

  const _GradientBanner({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Palette.primaryColor, Palette.primaryColor.withOpacity(0.6)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            left: -10,
            bottom: -10,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Center(
            child: Icon(
              Icons.savings_outlined,
              size: 52,
              color: Colors.white.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const _TagChip({required this.label, required this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: w * 0.025, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: color),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: w * 0.03,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String title;

  const _SectionHeading({required this.title});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: Palette.primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: SizeConfig.w(context, 8)),
        Text(
          title,
          style: TextStyle(
            fontSize: w * 0.042,
            fontWeight: FontWeight.w800,
            color: Palette.blackColor,
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;

  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(context, 14),
        vertical: SizeConfig.h(context, 4),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(children.length * 2 - 1, (index) {
          if (index.isEven) return children[index ~/ 2];
          return Divider(color: Colors.grey[100], height: 1);
        }),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.h(context, 11)),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: Colors.grey[400]),
            SizedBox(width: SizeConfig.w(context, 8)),
          ],
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: w * 0.036, color: Colors.grey[600]),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: w * 0.036,
                fontWeight: FontWeight.w600,
                color: valueColor ?? Palette.blackColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentHighlightCard extends StatelessWidget {
  final double installmentAmount;
  final int installmentCount;

  const _PaymentHighlightCard({
    required this.installmentAmount,
    required this.installmentCount,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final total = installmentAmount * installmentCount;

    return Container(
      padding: EdgeInsets.all(w * 0.045),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Palette.primaryColor.withOpacity(0.08),
            Palette.primaryColor.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Palette.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Monthly
          Text(
            '₹${installmentAmount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: w * 0.056,
              fontWeight: FontWeight.w800,
              color: Palette.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final dynamic controllers;

  const _AddressCard({required this.controllers});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final addressLine1 = controllers.addressLine1Controller.text;
    final addressLine2 = controllers.addressLine2Controller.text;
    final city = controllers.cityController.text;
    final state = controllers.stateController.text;
    final postalCode = controllers.postalCodeController.text;
    final country = controllers.countryController.text;

    final hasAddress =
        addressLine1.isNotEmpty || city.isNotEmpty || state.isNotEmpty;

    if (!hasAddress) {
      return Container(
        padding: EdgeInsets.all(SizeConfig.w(context, 14)),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange[600],
              size: 18,
            ),
            SizedBox(width: 8),
            Text(
              'Billing address not provided',
              style: TextStyle(fontSize: w * 0.035, color: Colors.orange[800]),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(SizeConfig.w(context, 14)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Palette.primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.location_on_rounded,
              size: 16,
              color: Palette.primaryColor,
            ),
          ),
          SizedBox(width: SizeConfig.w(context, 10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (addressLine1.isNotEmpty)
                  Text(
                    addressLine1,
                    style: TextStyle(
                      fontSize: w * 0.038,
                      fontWeight: FontWeight.w600,
                      color: Palette.blackColor,
                    ),
                  ),
                if (addressLine2.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    addressLine2,
                    style: TextStyle(
                      fontSize: w * 0.034,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
                if (city.isNotEmpty || state.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    [
                      city,
                      state,
                      if (postalCode.isNotEmpty) postalCode,
                    ].where((s) => s.isNotEmpty).join(', '),
                    style: TextStyle(
                      fontSize: w * 0.034,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
                if (country.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    country,
                    style: TextStyle(
                      fontSize: w * 0.034,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfirmationNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(SizeConfig.w(context, 14)),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            color: Colors.green[600],
            size: 18,
          ),
          SizedBox(width: SizeConfig.w(context, 8)),
          Expanded(
            child: Text(
              'By proceeding, you confirm all the above details are correct. This will initiate the scheme enrollment and payment process.',
              style: TextStyle(
                fontSize: w * 0.031,
                color: Colors.green[800],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
