import 'dart:io';

import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/core/custom_dialogs/customDialogeBox.dart';
import 'package:ashokgold_scheme_app/core/custom_widgets/custom_snackBar.dart';
import 'package:ashokgold_scheme_app/core/utilities/gender_constants.dart';
import 'package:ashokgold_scheme_app/core/utilities/global_util_functions.dart';
import 'package:ashokgold_scheme_app/core/utilities/overlay_loader.dart';
import 'package:ashokgold_scheme_app/features/auth/models/customer_model.dart';
import 'package:ashokgold_scheme_app/features/profile/controllers/profile_controller.dart';
import 'package:ashokgold_scheme_app/features/profile/models/update_customer_input.dart';
import 'package:ashokgold_scheme_app/features/common/repository/pincode_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileView extends ConsumerStatefulWidget {
  static const String routeName = '/edit-profile';

  final CustomerModel customer;

  const EditProfileView({super.key, required this.customer});

  @override
  ConsumerState<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView>
    with SingleTickerProviderStateMixin {
  // Personal
  late final TextEditingController _nameController;
  late final TextEditingController _dobController;
  late final TextEditingController _genderController;

  // Contact
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _mobileController;

  // Address
  late final TextEditingController _houseNameController;
  late final TextEditingController _addressLine1Controller;
  late final TextEditingController _addressLine2Controller;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _postalCodeController;
  late final TextEditingController _countryController;

  final _formKey = GlobalKey<FormState>();
  File? _pickedImage;
  bool _isPincodeLoading = false;

  late AnimationController _animController;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    final c = widget.customer;

    _nameController = TextEditingController(text: c.fullName);
    _dobController = TextEditingController(text: formatDob(c.dateOfBirth));
    _genderController = TextEditingController(text: c.gender ?? '');

    _emailController = TextEditingController(text: c.email ?? '');
    _phoneController = TextEditingController(text: c.phoneNumber);
    _mobileController = TextEditingController(text: c.mobileNumber2 ?? '');

    _houseNameController = TextEditingController(text: c.houseName ?? '');
    _addressLine1Controller = TextEditingController(text: c.addressLine1 ?? '');
    _addressLine2Controller = TextEditingController(text: c.addressLine2 ?? '');
    _cityController = TextEditingController(text: c.city ?? '');
    _stateController = TextEditingController(text: c.state ?? '');
    _postalCodeController = TextEditingController(text: c.postalCode ?? '');
    _countryController = TextEditingController(text: c.country ?? '');

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
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
    _nameController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _mobileController.dispose();
    _houseNameController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    _animController.dispose();
    super.dispose();
  }

  String? _formatDobForApi(String? dob) {
    if (dob == null || dob.isEmpty) return null;
    try {
      // Input can be "DD / MM / YYYY" or "DD-MM-YYYY"
      String cleanDob = dob.replaceAll(' ', '');
      List<String> parts = [];
      if (cleanDob.contains('/')) {
        parts = cleanDob.split('/');
      } else if (cleanDob.contains('-')) {
        parts = cleanDob.split('-');
      }

      if (parts.length == 3) {
        // Ensure parts are padded
        String day = parts[0].padLeft(2, '0');
        String month = parts[1].padLeft(2, '0');
        String year = parts[2];
        return '$year-$month-$day';
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  String formatDob(String? dob) {
    if (dob == null || dob.isEmpty) return '';

    try {
      final date = DateTime.parse(dob).toLocal();
      return '${date.day.toString().padLeft(2, '0')}-'
          '${date.month.toString().padLeft(2, '0')}-'
          '${date.year}';
    } catch (e) {
      return '';
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Change Photo',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 8),
              _photoOption(
                icon: Icons.camera_alt_rounded,
                label: 'Take a photo',
                onTap: () async {
                  context.pop();
                  final XFile? file = await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );
                  if (file != null) {
                    setState(() => _pickedImage = File(file.path));
                  }
                },
              ),
              _photoOption(
                icon: Icons.photo_library_rounded,
                label: 'Choose from gallery',
                onTap: () async {
                  context.pop();
                  final XFile? file = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (file != null) {
                    setState(() => _pickedImage = File(file.path));
                  }
                },
              ),
              if (_pickedImage != null || widget.customer.profilePhoto != null)
                _photoOption(
                  icon: Icons.delete_outline_rounded,
                  label: 'Remove photo',
                  color: const Color(0xFFE63946),
                  onTap: () {
                    context.pop();
                    setState(() => _pickedImage = null);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _photoOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    final c = color ?? const Color(0xFF1A1A2E);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: c.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: c, size: 20),
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                color: c,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final bool? confirmed = await AppDialog.showSaveConfirmation(
      context: context,
    );

    if (confirmed != true) return;

    final input = UpdateCustomerInput(
      fullName: getTextOrNullController(_nameController),
      gender: getTextOrNullController(_genderController),
      dateOfBirth: _formatDobForApi(getTextOrNullController(_dobController)),
      email: getTextOrNullController(_emailController),
      mobileNumber2: getTextOrNullController(_mobileController),
      houseName: getTextOrNullController(_houseNameController),
      addressLine1: getTextOrNullController(_addressLine1Controller),
      addressLine2: getTextOrNullController(_addressLine2Controller),
      city: getTextOrNullController(_cityController),
      state: getTextOrNullController(_stateController),
      postalCode: getTextOrNullController(_postalCodeController),
      country: getTextOrNullController(_countryController),
    );

    await ref
        .read(profileControllerProvider.notifier)
        .updateCustomer(
          customerId: widget.customer.customerId,
          input: input,
          context: context,
        );
  }

  Future<void> _fetchPincodeDetails(String pincode) async {
    setState(() {
      _isPincodeLoading = true;
    });

    final result = await ref
        .read(pincodeRepositoryProvider)
        .getPincodeDetails(pincode);

    setState(() {
      _isPincodeLoading = false;
    });

    result.fold(
      (failure) {
        _cityController.clear();
        _stateController.clear();
        _countryController.clear();
        if (mounted) {
          context.showErrorSnackBar('Invalid pincode');
        }
      },
      (pincodeData) {
        _cityController.text = pincodeData.district;
        _stateController.text = pincodeData.state;
        _countryController.text = pincodeData.country;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final photo = widget.customer.profilePhoto;

    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      appBar: AppBar(
        backgroundColor: Palette.backgroundColor,
        forceMaterialTransparency: true,
        elevation: 0,
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: w * 0.05,
            fontWeight: FontWeight.w700,
            fontFamily: 'Urbanist',
            color: const Color(0xFF1A1A2E),
            letterSpacing: -0.4,
          ),
        ),
      ),
      body: Stack(
        children: [
          FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.045),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: h * 0.01),

                        // ── Avatar Picker ──────────────────────────────────
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      Palette.primaryColor,
                                      Palette.primaryColor.withValues(
                                        alpha: 0.4,
                                      ),
                                    ],
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: w * 0.13,
                                  backgroundColor: const Color(0xFF16213E),
                                  backgroundImage: _pickedImage != null
                                      ? FileImage(_pickedImage!)
                                            as ImageProvider
                                      : (photo != null
                                            ? NetworkImage(photo)
                                            : null),
                                  child: (_pickedImage == null && photo == null)
                                      ? Icon(
                                          Icons.person_rounded,
                                          size: w * 0.16,
                                          color: Colors.white54,
                                        )
                                      : null,
                                ),
                              ),
                              Positioned(
                                right: 2,
                                bottom: 2,
                                child: GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Palette.primaryColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Palette.primaryColor
                                              .withValues(alpha: 0.4),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt_rounded,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: h * 0.005),
                        Center(
                          child: TextButton(
                            onPressed: _pickImage,
                            child: Text(
                              'Change Profile Photo',
                              style: TextStyle(
                                color: Palette.primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: h * 0.018),

                        // ── Personal Information ───────────────────────────
                        _sectionHeader('Personal Information'),
                        SizedBox(height: h * 0.01),
                        _buildCard(
                          children: [
                            _buildField(
                              controller: _nameController,
                              label: 'Full Name',
                              hint: 'Enter your full name',
                              icon: Icons.person_outline_rounded,
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Name is required'
                                  : null,
                            ),
                            _cardDivider(),
                            _buildField(
                              controller: _dobController,
                              label: 'Date of Birth',
                              hint: 'DD / MM / YYYY',
                              icon: Icons.cake_outlined,
                              readOnly: true,
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime(1990),
                                  firstDate: DateTime(1920),
                                  lastDate: DateTime.now(),
                                  builder: (context, child) => Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.light(
                                        primary: Palette.primaryColor,
                                      ),
                                    ),
                                    child: child!,
                                  ),
                                );
                                if (picked != null) {
                                  _dobController.text =
                                      '${picked.day.toString().padLeft(2, '0')} / '
                                      '${picked.month.toString().padLeft(2, '0')} / '
                                      '${picked.year}';
                                }
                              },
                            ),
                            _cardDivider(),
                            _buildDropdownField(
                              controller: _genderController,
                              label: 'Gender',
                              icon: Icons.wc_outlined,
                              items: GenderConstants.all,
                            ),
                          ],
                        ),

                        SizedBox(height: h * 0.022),

                        // ── Contact Details ────────────────────────────────
                        _sectionHeader('Contact Details'),
                        SizedBox(height: h * 0.01),
                        _buildCard(
                          children: [
                            _buildField(
                              controller: _emailController,
                              label: 'Email Address',
                              hint: 'your@email.com',
                              icon: Icons.mail_outline_rounded,
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return null;
                                if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(v)) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),
                            _cardDivider(),
                            _buildField(
                              controller: _phoneController,
                              label: 'Primary Phone',
                              hint: '+91 00000 00000',
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              validator: (v) =>
                                  (v == null || v.trim().length < 10)
                                  ? 'Enter valid phone number'
                                  : null,
                            ),
                            _cardDivider(),
                            _buildField(
                              controller: _mobileController,
                              label: 'Alternate Mobile',
                              hint: 'Optional',
                              icon: Icons.phone_android_outlined,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: h * 0.022),

                        // ── Address ────────────────────────────────────────
                        _sectionHeader('Address'),
                        SizedBox(height: h * 0.01),
                        _buildCard(
                          children: [
                            _buildField(
                              controller: _houseNameController,
                              label: 'House Name',
                              hint: 'e.g. Green Villa',
                              icon: Icons.home_outlined,
                            ),
                            _cardDivider(),
                            _buildField(
                              controller: _addressLine1Controller,
                              label: 'Address Line 1',
                              hint: 'Street / Locality',
                              icon: Icons.location_on_outlined,
                            ),
                            _cardDivider(),
                            _buildField(
                              controller: _addressLine2Controller,
                              label: 'Address Line 2',
                              hint: 'Landmark (optional)',
                              icon: Icons.add_location_alt_outlined,
                            ),
                            _cardDivider(),
                            _buildField(
                              controller: _cityController,
                              label: 'City',
                              hint: 'Enter city',
                              icon: Icons.location_city_outlined,
                            ),
                            _cardDivider(),
                            _buildField(
                              controller: _stateController,
                              label: 'State',
                              hint: 'Enter state',
                              icon: Icons.map_outlined,
                            ),
                            _cardDivider(),
                            _buildField(
                              controller: _postalCodeController,
                              label: 'Postal Code',
                              hint: '000000',
                              icon: Icons.markunread_mailbox_outlined,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(6),
                              ],
                              onChanged: (v) {
                                if (v.length == 6) {
                                  _fetchPincodeDetails(v);
                                }
                              },
                            ),
                            _cardDivider(),
                            _buildField(
                              controller: _countryController,
                              label: 'Country',
                              hint: 'Enter country',
                              icon: Icons.flag_outlined,
                            ),
                          ],
                        ),

                        SizedBox(height: h * 0.04),

                        // ── Save Button ────────────────────────────────────
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: ref.watch(profileControllerProvider)
                                ? null
                                : _saveProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Palette.primaryColor,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Palette.primaryColor
                                  .withValues(alpha: 0.6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: ref.watch(profileControllerProvider)
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : const Text(
                                    'Save Changes',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.3,
                                    ),
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
          if (_isPincodeLoading) const LoadingOverlay(),
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

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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

  Widget _cardDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 54),
      child: Divider(height: 1, color: Colors.grey.shade100),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1A2E),
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade300, fontSize: 13),
        labelStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 16, right: 12),
          child: Icon(icon, size: 18, color: Colors.grey.shade400),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        errorStyle: const TextStyle(fontSize: 11, color: Color(0xFFE63946)),
      ),
    );
  }

  Widget _buildDropdownField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required List<String> items,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: items.contains(controller.text) ? controller.text : null,
      onChanged: (val) {
        if (val != null) controller.text = val;
      },
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A1A2E),
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Select',
        hintStyle: TextStyle(color: Colors.grey.shade300, fontSize: 13),
        labelStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 16, right: 12),
          child: Icon(icon, size: 18, color: Colors.grey.shade400),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
