import 'package:ashokgold_scheme_app/core/custom_widgets/error_retry_widget.dart';
import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/core/utilities/loader.dart';
import 'package:ashokgold_scheme_app/core/utilities/scale_size_utils.dart';
import 'package:ashokgold_scheme_app/features/nominee/models/nominee_model.dart';
import 'package:ashokgold_scheme_app/features/nominee/providers/nominee_provider.dart';
import 'package:ashokgold_scheme_app/features/nominee/views/add_edit_nominee_view.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/models/preferred_branch_model.dart';
import 'package:ashokgold_scheme_app/features/scheme_joining/providers/preferred_branches_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Step1BranchSelection extends StatelessWidget {
  final CustomerNomineeModel? selectedNominee;
  final PreferredBranchModel? selectedBranch;
  final ValueChanged<CustomerNomineeModel?> onNomineeChanged;
  final ValueChanged<PreferredBranchModel?> onBranchChanged;
  final GlobalKey<FormState> formKey;
  final String schemeId;

  const Step1BranchSelection({
    super.key,
    this.selectedNominee,
    this.selectedBranch,
    required this.onNomineeChanged,
    required this.onBranchChanged,
    required this.formKey,
    required this.schemeId,
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
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StepHeader(
              stepNumber: '01',
              title: 'Branch & Nominee',
              subtitle:
                  'Choose your preferred branch and nominee for this scheme',
            ),
            SizedBox(height: h * 0.03),

            // ── Nominee Section ──
            _SectionLabel(
              icon: Icons.person_outline_rounded,
              label: 'Select Nominee',
            ),
            SizedBox(height: h * 0.012),
            NomineeDropdownSection(
              selectedNominee: selectedNominee,
              onNomineeChanged: onNomineeChanged,
            ),
            SizedBox(height: h * 0.03),

            // ── Branch Section ──
            _SectionLabel(icon: Icons.store_outlined, label: 'Select Branch'),
            SizedBox(height: h * 0.012),
            BranchDropdownSection(
              selectedBranch: selectedBranch,
              onBranchChanged: onBranchChanged,
              schemeId: schemeId,
            ),
            SizedBox(height: h * 0.02),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Shared sub-widgets
// ─────────────────────────────────────────────

class _StepHeader extends StatelessWidget {
  final String stepNumber;
  final String title;
  final String subtitle;

  const _StepHeader({
    required this.stepNumber,
    required this.title,
    required this.subtitle,
  });

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
            stepNumber,
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
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: w * 0.052,
                  fontWeight: FontWeight.w800,
                  color: Palette.primaryColor,
                ),
              ),
              SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: w * 0.035,
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

class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SectionLabel({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Icon(icon, size: 17, color: Palette.primaryColor),
        SizedBox(width: SizeConfig.w(context, 6)),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: w * 0.04,
            fontWeight: FontWeight.w700,
            color: Palette.blackColor,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Nominee Dropdown
// ─────────────────────────────────────────────

class NomineeDropdownSection extends ConsumerWidget {
  final CustomerNomineeModel? selectedNominee;
  final ValueChanged<CustomerNomineeModel?> onNomineeChanged;

  const NomineeDropdownSection({
    super.key,
    required this.selectedNominee,
    required this.onNomineeChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nomineesAsync = ref.watch(nomineeListProvider);
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return nomineesAsync.when(
      data: (nominees) {
        if (nominees.isEmpty) {
          return _EmptyNomineeCard(context: context, w: w, h: h);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<CustomerNomineeModel>(
              initialValue: selectedNominee,
              decoration: _fieldDecoration(
                context,
                hint: 'Select a nominee',
                prefixIcon: Icons.person_outline_rounded,
              ),
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Palette.primaryColor,
              ),
              items: nominees.map((nominee) {
                return DropdownMenuItem(
                  value: nominee,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: Palette.primaryColor.withOpacity(0.1),
                        child: Text(
                          nominee.nomineeName.isNotEmpty
                              ? nominee.nomineeName[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Palette.primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(width: SizeConfig.w(context, 10)),
                      Expanded(
                        child: Text(
                          nominee.nomineeName,
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onNomineeChanged,
              validator: (value) =>
                  value == null ? 'Please select a nominee' : null,
            ),
            SizedBox(height: h * 0.01),
            // Add another nominee shortcut
            GestureDetector(
              onTap: () => context.push(AddEditNomineeView.routeName),
              child: Row(
                children: [
                  Icon(
                    Icons.add_circle_outline_rounded,
                    size: 15,
                    color: Palette.primaryColor,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Add another nominee',
                    style: TextStyle(
                      fontSize: w * 0.033,
                      color: Palette.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      loading: () => const Loader(),
      error: (error, stack) => ErrorRetryWidget(
        message: 'Failed to load nominees',
        onRetry: () => ref.invalidate(nomineeListProvider),
      ),
    );
  }
}

class _EmptyNomineeCard extends StatelessWidget {
  final BuildContext context;
  final double w;
  final double h;

  const _EmptyNomineeCard({
    required this.context,
    required this.w,
    required this.h,
  });

  @override
  Widget build(BuildContext _) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: w * 0.06, vertical: h * 0.03),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Palette.primaryColor.withOpacity(0.06), Colors.white],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Palette.primaryColor.withOpacity(0.18),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: w * 0.16,
            height: w * 0.16,
            decoration: BoxDecoration(
              color: Palette.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_add_alt_1_rounded,
              size: w * 0.09,
              color: Palette.primaryColor,
            ),
          ),
          SizedBox(height: h * 0.016),
          Text(
            'No Nominees Found',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: w * 0.045,
              fontWeight: FontWeight.w700,
              color: Palette.blackColor,
            ),
          ),
          SizedBox(height: h * 0.006),
          Text(
            'Add a nominee to proceed with\nscheme enrollment',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: w * 0.034,
              color: Palette.blackColor.withOpacity(0.55),
              height: 1.5,
            ),
          ),
          SizedBox(height: h * 0.022),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                await context.push(AddEditNomineeView.routeName);
              },
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(
                'Create Nominee',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: w * 0.038,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Palette.primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: h * 0.016),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Branch Dropdown
// ─────────────────────────────────────────────

class BranchDropdownSection extends ConsumerWidget {
  final String schemeId;
  final PreferredBranchModel? selectedBranch;
  final ValueChanged<PreferredBranchModel?> onBranchChanged;

  const BranchDropdownSection({
    super.key,
    required this.schemeId,
    required this.selectedBranch,
    required this.onBranchChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchesAsync = ref.watch(
      preferredBranchesListForJoiningProvider(schemeId),
    );

    return branchesAsync.when(
      data: (branches) {
        if (branches.isEmpty) {
          return Container(
            padding: EdgeInsets.all(SizeConfig.w(context, 16)),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange[700],
                  size: 20,
                ),
                SizedBox(width: SizeConfig.w(context, 10)),
                Expanded(
                  child: Text(
                    'No branches available for this scheme',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.orange[800],
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return DropdownButtonFormField<PreferredBranchModel>(
          initialValue: selectedBranch,
          decoration: _fieldDecoration(
            context,
            hint: 'Select a branch',
            prefixIcon: Icons.store_outlined,
          ),
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Palette.primaryColor,
          ),
          items: branches.map((branch) {
            return DropdownMenuItem(
              value: branch,
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Palette.primaryColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.store_outlined,
                      size: 15,
                      color: Palette.primaryColor,
                    ),
                  ),
                  SizedBox(width: SizeConfig.w(context, 10)),
                  Expanded(
                    child: Text(
                      branch.branchName,
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onBranchChanged,
          validator: (value) => value == null ? 'Please select a branch' : null,
        );
      },
      loading: () => const Loader(),
      error: (error, stack) => ErrorRetryWidget(
        message: 'Failed to load branches',
        onRetry: () {
          ref.invalidate(preferredBranchesListForJoiningProvider(schemeId));
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Shared helper
// ─────────────────────────────────────────────

InputDecoration _fieldDecoration(
  BuildContext context, {
  required String hint,
  required IconData prefixIcon,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      color: Colors.grey[400],
      fontSize: MediaQuery.of(context).size.width * 0.037,
    ),
    prefixIcon: Padding(
      padding: const EdgeInsets.only(left: 12, right: 8),
      child: Icon(prefixIcon, color: Palette.primaryColor, size: 20),
    ),
    prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Palette.primaryColor, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 1),
    ),
    filled: true,
    fillColor: Colors.grey[50],
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
  );
}
