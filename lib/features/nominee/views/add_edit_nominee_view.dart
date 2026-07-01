import 'package:ashokgold_scheme_app/core/custom_dialogs/customDialogeBox.dart';
import 'package:ashokgold_scheme_app/core/custom_widgets/custom_textfiled.dart';
import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/core/utilities/formatting/inputFormatters/inputFormatters.dart';
import 'package:ashokgold_scheme_app/features/common/models/dropdown_model.dart';
import 'package:ashokgold_scheme_app/features/common/providers/nominee_dropdown_provider.dart';
import 'package:ashokgold_scheme_app/features/nominee/controllers/nominee_controller.dart';
import 'package:ashokgold_scheme_app/features/nominee/models/nominee_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/custom_widgets/custom_dropdown_normal.dart';

class AddEditNomineeView extends ConsumerStatefulWidget {
  static const String routeName = '/add-edit-nominee';
  final CustomerNomineeModel? nominee;

  const AddEditNomineeView({super.key, this.nominee});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddEditNomineeViewState();
}

class _AddEditNomineeViewState extends ConsumerState<AddEditNomineeView>
    with SingleTickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  CustomerNomineeModel? nomineeModel;

  late AnimationController _animController;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    if (widget.nominee != null) {
      nomineeModel = widget.nominee;
      nameController.text = nomineeModel!.nomineeName;
      mobileController.text = nomineeModel!.nomineeMobile ?? '';
    }

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(nomineeControllerProvider);
    final isEditing = widget.nominee != null;
    final relationsAsync = ref.watch(
      nomineeRelationsListProvider(widget.nominee),
    );
    final selectedRelation = ref.watch(selectedNomineeRelationProvider);
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      appBar: AppBar(
        backgroundColor: Palette.backgroundColor,
        forceMaterialTransparency: true,
        elevation: 0,
        title: Text(
          isEditing ? 'Edit Nominee' : 'Add Nominee',
          style: TextStyle(
            fontSize: w * 0.05,
            fontWeight: FontWeight.w700,
            fontFamily: 'Urbanist',
            color: const Color(0xFF1A1A2E),
            letterSpacing: -0.4,
          ),
        ),
      ),
      body: relationsAsync.when(
        data: (relations) => FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.045),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: h * 0.015),

                      // ── Header Banner ──────────────────────────────
                      _buildHeaderBanner(isEditing, w, h),

                      SizedBox(height: h * 0.025),

                      // ── Nominee Details Section ────────────────────
                      _sectionHeader('Nominee Details'),
                      SizedBox(height: h * 0.02),

                      Column(
                        children: [
                          // Name Field
                          _buildFormField(
                            child: CustomTextField(
                              controller: nameController,
                              label: 'Full Name',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Nominee name can't be empty";
                                }
                                return null;
                              },
                            ),
                          ),

                          _cardDivider(),

                          // Relation Dropdown
                          _buildFormField(
                            child: CustomDropdown<DropdownItemModel>(
                              label: 'Relation',
                              hint: 'Select a relation',
                              value: selectedRelation,
                              style: DropdownStyle.outlined,
                              prefixIcon: const Icon(Icons.people_alt_outlined),
                              items: relations
                                  .map(
                                    (item) =>
                                        DropdownMenuItem<DropdownItemModel>(
                                          value: item,
                                          child: Text(item.value),
                                        ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                ref
                                        .read(
                                          selectedNomineeRelationProvider
                                              .notifier,
                                        )
                                        .state =
                                    value;
                              },
                              validator: (value) {
                                if (value == null) {
                                  return "Please select a relation";
                                }
                                return null;
                              },
                            ),
                          ),

                          _cardDivider(),

                          // Mobile Field
                          _buildFormField(
                            child: CustomTextField(
                              controller: mobileController,
                              label: 'Mobile Number (Optional)',
                              keyboardType: TextInputType.phone,
                              inputFormatters:
                                  InputFormattersConstants.phoneNumberFormatter,
                              validator: (value) {
                                if (value != null &&
                                    value.isNotEmpty &&
                                    value.length != 10) {
                                  return "Enter a valid 10-digit mobile number";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: h * 0.018),

                      // ── Info tip ──────────────────────────────────
                      _buildInfoTip(w),

                      SizedBox(height: h * 0.04),

                      // ── Submit Button ──────────────────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async => await _submitForm(isEditing),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Palette.primaryColor,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Palette.primaryColor
                                .withOpacity(0.55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      isEditing
                                          ? Icons.check_rounded
                                          : Icons.person_add_rounded,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      isEditing
                                          ? 'Update Nominee'
                                          : 'Add Nominee',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),

                      SizedBox(height: h * 0.05),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: EdgeInsets.all(w * 0.08),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEEEF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error_outline_rounded,
                    size: 40,
                    color: Color(0xFFE63946),
                  ),
                ),
                SizedBox(height: h * 0.02),
                Text(
                  'Failed to load relations',
                  style: TextStyle(
                    fontSize: w * 0.042,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                SizedBox(height: h * 0.008),
                Text(
                  'Please check your connection and try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: w * 0.033,
                  ),
                ),
                SizedBox(height: h * 0.025),
                GestureDetector(
                  onTap: () => ref.invalidate(nomineeRelationsListProvider),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: w * 0.08,
                      vertical: h * 0.015,
                    ),
                    decoration: BoxDecoration(
                      color: Palette.primaryColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.refresh_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Retry',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Header Banner ─────────────────────────────────────────────────────────
  Widget _buildHeaderBanner(bool isEditing, double w, double h) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(w * 0.05),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isEditing
              ? [const Color(0xFF7209B7), const Color(0xFF560BAD)]
              : [const Color(0xFF1A1A2E), const Color(0xFF16213E)],
        ),
        boxShadow: [
          BoxShadow(
            color:
                (isEditing ? const Color(0xFF7209B7) : const Color(0xFF1A1A2E))
                    .withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circle
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: w * 0.3,
              height: w * 0.3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  isEditing
                      ? Icons.edit_rounded
                      : Icons.person_add_alt_1_rounded,
                  color: Colors.white,
                  size: w * 0.06,
                ),
              ),
              SizedBox(width: w * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEditing ? 'Update Nominee' : 'New Nominee',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: w * 0.045,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Urbanist',
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: h * 0.004),
                    Text(
                      isEditing
                          ? 'Modify nominee details below'
                          : 'Fill in the details to add a beneficiary',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: w * 0.029,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Info Tip ──────────────────────────────────────────────────────────────
  Widget _buildInfoTip(double w) {
    return Container(
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF6FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFBEDAFF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: Color(0xFF4361EE),
          ),
          SizedBox(width: w * 0.025),
          Expanded(
            child: Text(
              'A nominee is a person designated to receive benefits on your behalf. '
              'You can add multiple nominees across different schemes.',
              style: TextStyle(
                fontSize: w * 0.03,
                color: const Color(0xFF4361EE),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title.toUpperCase(),
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

  Widget _buildFormField({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: child,
    );
  }

  Widget _cardDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(height: 20, color: Colors.grey.shade100),
    );
  }

  // ── Submit ────────────────────────────────────────────────────────────────
  Future<void> _submitForm(bool isEditing) async {
    if (!formKey.currentState!.validate()) return;

    final selectedRelation = ref.read(selectedNomineeRelationProvider);
    if (selectedRelation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          backgroundColor: const Color(0xFFE63946),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: const Row(
            children: [
              Icon(Icons.warning_rounded, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Please select a relation',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
      return;
    }

    final shouldSubmit = await context.showConfirmationDialog(
      title: isEditing ? 'Update Nominee' : 'Add Nominee',
      message: isEditing
          ? 'Are you sure you want to update this nominee?'
          : 'Are you sure you want to add this nominee?',
    );

    if (shouldSubmit == true && mounted) {
      if (isEditing) {
        await ref
            .read(nomineeControllerProvider.notifier)
            .updateNominee(
              nomineeId: widget.nominee!.nomineeId,
              nomineeName: nameController.text.trim(),
              nomineeRelationId: selectedRelation.id,
              nomineeMobile: mobileController.text.trim().isEmpty
                  ? null
                  : mobileController.text.trim(),
              context: context,
            );
      } else {
        await ref
            .read(nomineeControllerProvider.notifier)
            .createNominee(
              nomineeName: nameController.text.trim(),
              nomineeRelationId: selectedRelation.id,
              nomineeMobile: mobileController.text.trim().isEmpty
                  ? null
                  : mobileController.text.trim(),
              context: context,
            );
      }
    }
  }
}
