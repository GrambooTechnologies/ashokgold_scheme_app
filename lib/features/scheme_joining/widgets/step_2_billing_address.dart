import 'package:ashokgold_scheme_app/core/custom_widgets/custom_snackBar.dart';
import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/core/utilities/overlay_loader.dart';
import 'package:ashokgold_scheme_app/core/utilities/scale_size_utils.dart';
import 'package:ashokgold_scheme_app/features/auth/providers/customer_provider.dart';
import 'package:ashokgold_scheme_app/features/common/providers/pincode_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Step2BillingAddress extends ConsumerStatefulWidget {
  final TextEditingController addressLine1Controller;
  final TextEditingController addressLine2Controller;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController postalCodeController;
  final TextEditingController countryController;
  final GlobalKey<FormState> formKey;

  const Step2BillingAddress({
    super.key,
    required this.addressLine1Controller,
    required this.addressLine2Controller,
    required this.cityController,
    required this.stateController,
    required this.postalCodeController,
    required this.countryController,
    required this.formKey,
  });

  @override
  ConsumerState<Step2BillingAddress> createState() =>
      _Step2BillingAddressState();
}

class _Step2BillingAddressState extends ConsumerState<Step2BillingAddress> {
  bool _isPincodeLoading = false;
  bool _pincodeValid = false;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final customer = ref.watch(customerProvider);

    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            SizeConfig.w(context, 16),
            SizeConfig.h(context, 20),
            SizeConfig.w(context, 16),
            SizeConfig.h(context, 20),
          ),
          child: Form(
            key: widget.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Step Header ──
                _StepHeader(
                  stepNumber: '02',
                  title: 'Billing Address',
                  subtitle: 'Enter the address for billing and correspondence',
                ),
                SizedBox(height: h * 0.025),

                // ── Saved Address Banner ──
                if (customer != null && _hasAddress(customer))
                  _SavedAddressBanner(
                    w: w,
                    onLoad: () => _loadDefaultAddress(customer),
                  ),

                SizedBox(height: h * 0.018),

                // ── Postal Code ──
                _buildFieldLabel(
                  context,
                  'Postal Code',
                  Icons.pin_drop_outlined,
                ),
                SizedBox(height: h * 0.008),
                TextFormField(
                  controller: widget.postalCodeController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  decoration: _fieldDecoration(
                    context,
                    hint: 'Enter 6-digit postal code',
                    prefixIcon: Icons.pin_drop_outlined,
                    suffixIcon: _pincodeValid
                        ? Icon(
                            Icons.check_circle_rounded,
                            color: Colors.green[600],
                            size: 20,
                          )
                        : null,
                  ),
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Postal code is required';
                    }
                    if (value!.length != 6) {
                      return 'Enter a valid 6-digit postal code';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (value.length == 6) {
                      _fetchPincodeDetails(value);
                    } else {
                      setState(() => _pincodeValid = false);
                      widget.cityController.clear();
                      widget.stateController.clear();
                      widget.countryController.clear();
                    }
                  },
                ),
                SizedBox(height: h * 0.015),

                // ── Pincode loading hint ──
                if (_isPincodeLoading) _AutoFillHint(w: w),

                // ── Info note: editable after auto-fill ──
                _AutoFillInfoNote(w: w),
                SizedBox(height: h * 0.015),

                // ── City / State row ──
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel(
                            context,
                            'City',
                            Icons.location_city_outlined,
                          ),
                          SizedBox(height: h * 0.008),
                          _EditableAutoField(
                            controller: widget.cityController,
                            hint: 'City',
                            icon: Icons.location_city_outlined,
                            validator: (value) => value?.isEmpty == true
                                ? 'City is required'
                                : null,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: SizeConfig.w(context, 10)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel(
                            context,
                            'State',
                            Icons.map_outlined,
                          ),
                          SizedBox(height: h * 0.008),
                          _EditableAutoField(
                            controller: widget.stateController,
                            hint: 'State',
                            icon: Icons.map_outlined,
                            validator: (value) => value?.isEmpty == true
                                ? 'State is required'
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: h * 0.015),

                // ── Country ──
                _buildFieldLabel(context, 'Country', Icons.public_rounded),
                SizedBox(height: h * 0.008),
                _EditableAutoField(
                  controller: widget.countryController,
                  hint: 'Country',
                  icon: Icons.public_rounded,
                  validator: (value) =>
                      value?.isEmpty == true ? 'Country is required' : null,
                ),
                SizedBox(height: h * 0.015),

                // ── Section divider ──
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey[200])),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.w(context, 10),
                      ),
                      child: Text(
                        'Address Details',
                        style: TextStyle(
                          fontSize: w * 0.032,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey[200])),
                  ],
                ),
                SizedBox(height: h * 0.015),

                // ── Address Line 1 ──
                _buildFieldLabel(
                  context,
                  'Address Line 1',
                  Icons.home_outlined,
                ),
                SizedBox(height: h * 0.008),
                TextFormField(
                  controller: widget.addressLine1Controller,
                  textCapitalization: TextCapitalization.words,
                  decoration: _fieldDecoration(
                    context,
                    hint: 'House/Flat no., Street name',
                    prefixIcon: Icons.home_outlined,
                  ),
                  validator: (value) => value?.isEmpty == true
                      ? 'Address Line 1 is required'
                      : null,
                ),
                SizedBox(height: h * 0.015),

                // ── Address Line 2 ──
                _buildFieldLabel(
                  context,
                  'Address Line 2',
                  Icons.home_work_outlined,
                ),
                SizedBox(height: h * 0.008),
                TextFormField(
                  controller: widget.addressLine2Controller,
                  textCapitalization: TextCapitalization.words,
                  decoration: _fieldDecoration(
                    context,
                    hint: 'Landmark, Area (optional)',
                    prefixIcon: Icons.home_work_outlined,
                  ),
                ),
                SizedBox(height: h * 0.02),
              ],
            ),
          ),
        ),
        if (_isPincodeLoading) const LoadingOverlay(),
      ],
    );
  }

  Widget _buildFieldLabel(BuildContext context, String label, IconData icon) {
    final w = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Icon(icon, size: 14, color: Palette.primaryColor),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: w * 0.036,
            fontWeight: FontWeight.w600,
            color: Palette.blackColor.withOpacity(0.75),
          ),
        ),
      ],
    );
  }

  Future<void> _fetchPincodeDetails(String pincode) async {
    setState(() {
      _isPincodeLoading = true;
      _pincodeValid = false;
    });

    try {
      final pincodeData = await ref.read(
        pincodeDetailsProvider(pincode).future,
      );

      if (mounted) {
        setState(() {
          _isPincodeLoading = false;
          _pincodeValid = true;
        });
        widget.cityController.text = pincodeData.district;
        widget.stateController.text = pincodeData.state;
        widget.countryController.text = pincodeData.country;
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isPincodeLoading = false;
          _pincodeValid = false;
        });
        widget.cityController.clear();
        widget.stateController.clear();
        widget.countryController.clear();
        context.showErrorSnackBar('Invalid pincode or unable to fetch details');
      }
    }
  }

  bool _hasAddress(customer) {
    return customer.addressLine1 != null ||
        customer.city != null ||
        customer.state != null ||
        customer.postalCode != null ||
        customer.country != null;
  }

  void _loadDefaultAddress(customer) {
    setState(() {
      if (customer.addressLine1 != null) {
        widget.addressLine1Controller.text = customer.addressLine1!;
      }
      if (customer.addressLine2 != null) {
        widget.addressLine2Controller.text = customer.addressLine2!;
      }
      if (customer.city != null) {
        widget.cityController.text = customer.city!;
      }
      if (customer.state != null) {
        widget.stateController.text = customer.state!;
      }
      if (customer.postalCode != null) {
        widget.postalCodeController.text = customer.postalCode!;
        _pincodeValid = true;
      }
      if (customer.country != null) {
        widget.countryController.text = customer.country!;
      }
    });
  }
}

// ─────────────────────────────────────────────
// Local sub-widgets
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
                  fontWeight: FontWeight.w700,
                  color: Palette.primaryColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
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

class _SavedAddressBanner extends StatelessWidget {
  final double w;
  final VoidCallback onLoad;

  const _SavedAddressBanner({required this.w, required this.onLoad});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(context, 14),
        vertical: SizeConfig.h(context, 10),
      ),
      decoration: BoxDecoration(
        color: Palette.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Palette.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Palette.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.home_work_outlined,
              color: Palette.primaryColor,
              size: 17,
            ),
          ),
          SizedBox(width: SizeConfig.w(context, 10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Saved address available',
                  style: TextStyle(
                    fontSize: w * 0.036,
                    fontWeight: FontWeight.w600,
                    color: Palette.blackColor,
                  ),
                ),
                Text(
                  'Tap Load to auto-fill your address',
                  style: TextStyle(
                    fontSize: w * 0.03,
                    color: Palette.blackColor.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onLoad,
            style: TextButton.styleFrom(
              foregroundColor: Palette.primaryColor,
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.w(context, 10),
                vertical: 4,
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              children: [
                const Icon(Icons.download_rounded, size: 15),
                const SizedBox(width: 3),
                Text(
                  'Load',
                  style: TextStyle(
                    fontSize: w * 0.036,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AutoFillHint extends StatelessWidget {
  final double w;

  const _AutoFillHint({required this.w});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.h(context, 12)),
      child: Row(
        children: [
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Palette.primaryColor,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Fetching location details…',
            style: TextStyle(fontSize: w * 0.032, color: Palette.primaryColor),
          ),
        ],
      ),
    );
  }
}

/// Small banner that tells users they can edit auto-filled fields manually.
class _AutoFillInfoNote extends StatelessWidget {
  final double w;

  const _AutoFillInfoNote({required this.w});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(context, 10),
        vertical: SizeConfig.h(context, 8),
      ),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withOpacity(0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.edit_note_rounded, size: 15, color: Colors.blue[600]),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'City, State & Country are auto-filled from your pincode — you can still edit them manually if needed.',
              style: TextStyle(
                fontSize: w * 0.03,
                color: Colors.blue[700],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// An editable field that supports both pincode auto-fill and free manual typing.
/// The small pencil icon signals to the user that the field is editable.
class _EditableAutoField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final String? Function(String?)? validator;

  const _EditableAutoField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return TextFormField(
      controller: controller,
      // NOT readOnly — user can type freely
      textCapitalization: TextCapitalization.words,
      style: TextStyle(fontSize: w * 0.037, color: Palette.blackColor),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: w * 0.035),
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        isDense: true,
      ),
      validator: validator,
    );
  }
}

InputDecoration _fieldDecoration(
  BuildContext context, {
  required String hint,
  required IconData prefixIcon,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      color: Colors.grey[400],
      fontSize: MediaQuery.of(context).size.width * 0.035,
    ),
    prefixIcon: Icon(prefixIcon, color: Palette.primaryColor, size: 20),
    suffixIcon: suffixIcon,
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
