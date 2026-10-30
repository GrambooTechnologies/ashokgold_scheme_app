import 'dart:io';
import 'package:ashokgold_scheme_app/core/custom_widgets/custom_snackBar.dart';
import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/core/utilities/auth_guard.dart';
import 'package:ashokgold_scheme_app/features/auth/providers/customer_provider.dart';
import 'package:ashokgold_scheme_app/features/kyc/models/customer_kyc_model.dart';
import 'package:ashokgold_scheme_app/features/kyc/models/id_proof_type.dart';
import 'package:ashokgold_scheme_app/features/kyc/models/kyc_status.dart';
import 'package:ashokgold_scheme_app/features/kyc/models/kyc_submit_input.dart';
import 'package:ashokgold_scheme_app/features/kyc/providers/kyc_provider.dart';
import 'package:ashokgold_scheme_app/features/kyc/services/kyc_ocr_service.dart';
import 'package:ashokgold_scheme_app/features/kyc/views/kyc_status_view.dart';
import 'package:ashokgold_scheme_app/features/kyc/widgets/document_upload_card.dart';
import 'package:ashokgold_scheme_app/features/kyc/widgets/kyc_id_proof_dropdown.dart';
import 'package:ashokgold_scheme_app/features/settings/views/privacy_policy_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class KycSelectionView extends ConsumerStatefulWidget {
  static const String routeName = '/kyc-selection';

  final bool isResubmission;
  final CustomerKycModel? existingKyc;
  final String? targetSchemeId;
  final double? targetAmount;

  const KycSelectionView({
    super.key,
    this.isResubmission = false,
    this.existingKyc,
    this.targetSchemeId,
    this.targetAmount,
  });

  @override
  ConsumerState<KycSelectionView> createState() => _KycSelectionViewState();
}

class _KycSelectionViewState extends ConsumerState<KycSelectionView> {
  final _formKey = GlobalKey<FormState>();
  late IdProofType _selectedIdType;
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  File? _frontDocument;
  File? _backDocument;
  bool _consentGiven = false;
  bool _isSubmitting = false;

  bool _isFrontOcrScanning = false;
  bool _isBackOcrScanning = false;
  bool _isIdNumberAutoFilled = false;
  bool _isNameAutoFilled = false;
  String? _ocrSummaryBanner;

  @override
  void initState() {
    super.initState();
    final customer = ref.read(customerProvider);
    final previous =
        widget.existingKyc ?? ref.read(kycControllerProvider).value;

    _selectedIdType = previous?.idProofType ?? IdProofType.aadhaar;
    _idNumberController.text = previous?.idNumber ?? '';
    _nameController.text = customer?.fullName ?? previous?.customerName ?? '';

    // If existing local files exist, restore preview
    if (previous?.frontDocumentPath != null) {
      final f = File(previous!.frontDocumentPath!);
      if (f.existsSync()) _frontDocument = f;
    }
    if (previous?.backDocumentPath != null) {
      final f = File(previous!.backDocumentPath!);
      if (f.existsSync()) _backDocument = f;
    }
  }

  @override
  void dispose() {
    _idNumberController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _processImageOcr(File file, {bool isFront = true}) async {
    setState(() {
      if (isFront) {
        _isFrontOcrScanning = true;
      } else {
        _isBackOcrScanning = true;
      }
    });

    try {
      final ocrService = ref.read(kycOcrServiceProvider);
      final result = await ocrService.processDocumentImage(
        imageFile: file,
        expectedType: _selectedIdType,
      );

      if (!mounted) return;

      bool foundAny = false;
      final List<String> extractedFields = [];

      // Auto-adapt ID type if a distinct match was found for another ID type
      if (result.detectedType != null &&
          result.detectedType != _selectedIdType &&
          result.hasDocumentNumber) {
        setState(() {
          _selectedIdType = result.detectedType!;
        });
      }

      if (result.hasDocumentNumber) {
        _idNumberController.text = result.documentNumber!;
        _isIdNumberAutoFilled = true;
        foundAny = true;
        extractedFields.add(
          '${_selectedIdType.title} No: ${result.documentNumber}',
        );
      }

      if (result.hasFullName) {
        _nameController.text = result.fullName!;
        _isNameAutoFilled = true;
        foundAny = true;
        extractedFields.add('Name: ${result.fullName}');
      }

      setState(() {
        if (foundAny) {
          _ocrSummaryBanner =
              '✨ OCR Auto-filled: ${extractedFields.join(' • ')}';
        } else {
          _ocrSummaryBanner =
              'Photo uploaded. Could not auto-detect ID number/name clearly; please enter or verify manually below.';
        }
      });

      if (foundAny && mounted) {
        context.showSuccessSnackBar(
          'Document details auto-extracted via OCR! Please review them.',
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _ocrSummaryBanner =
              'Could not scan text automatically. Please enter details manually.';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          if (isFront) {
            _isFrontOcrScanning = false;
          } else {
            _isBackOcrScanning = false;
          }
        });
      }
    }
  }

  Future<void> _handleSubmit() async {
    final customer = ref.read(customerProvider);
    if (customer == null) {
      context.showErrorSnackBar(
        'Please log in to submit identity verification',
      );
      AuthGuard.requireAuth(context, ref);
      return;
    }

    // Check if customer already has a pending submission to prevent duplicates
    final currentKyc = ref.read(kycControllerProvider).value;
    if (currentKyc != null &&
        currentKyc.status == KycStatus.pending &&
        !widget.isResubmission) {
      context.showErrorSnackBar(
        'You already have an application under review. Please wait for admin approval.',
      );
      context.pushReplacement(KycStatusView.routeName);
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_frontDocument == null) {
      context.showErrorSnackBar(
        'Please upload the front photo of your ID proof',
      );
      return;
    }

    if (_selectedIdType.requiresBackImage && _backDocument == null) {
      context.showErrorSnackBar(
        'Please upload the back photo of your ${_selectedIdType.title}',
      );
      return;
    }

    if (!_consentGiven) {
      context.showErrorSnackBar(
        'Please confirm your consent to submit documents for verification',
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final input = KycSubmitInput(
      customerId: customer.customerId,
      customerName: _nameController.text.trim(),
      phoneNumber: customer.phoneNumber,
      idProofType: _selectedIdType,
      idNumber: _idNumberController.text.trim().toUpperCase(),
      frontDocument: _frontDocument!,
      backDocument: _backDocument,
      consentGiven: _consentGiven,
      isResubmission: widget.isResubmission,
      previousReferenceId:
          widget.existingKyc?.referenceId ?? currentKyc?.referenceId,
    );

    final result = await ref
        .read(kycControllerProvider.notifier)
        .submitKyc(input: input, context: context);

    setState(() => _isSubmitting = false);

    if (result != null && mounted) {
      context.pushReplacement(
        KycStatusView.routeName,
        extra: {
          'targetSchemeId': widget.targetSchemeId,
          'targetAmount': widget.targetAmount,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final kycAsync = ref.watch(kycControllerProvider);
    final currentKyc = widget.existingKyc ?? kycAsync.value;
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    final bool isActionRequired =
        currentKyc?.status == KycStatus.actionRequired;
    final hasExistingSubmission =
        currentKyc != null && currentKyc.status != KycStatus.notSubmitted;

    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      appBar: AppBar(
        backgroundColor: Palette.backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Palette.blackColor,
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.isResubmission || isActionRequired
              ? 'Resubmit Identity Proof'
              : 'Identity Verification',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Palette.blackColor,
            fontSize: 18,
            fontFamily: 'Urbanist',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: w * 0.05),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: h * 0.015),

              // Top Hero Card
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                        255,
                        0,
                        0,
                        0,
                      ).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_user_rounded,
                          size: 14,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        SizedBox(width: 6),
                        Text(
                          'One-Time Verification',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Urbanist',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: h * 0.015),
                  const Text(
                    'Verify Your Identity to Join Schemes',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Urbanist',
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: h * 0.008),
                  Text(
                    'Government regulations require identity verification before scheme enrollment. Complete it once and unlock all current and future gold schemes under your account.',
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.8),
                      fontSize: 12,
                      fontFamily: 'Urbanist',
                      height: 1.4,
                    ),
                  ),
                ],
              ),

              // Resubmission Alert Card if Admin requested action
              if ((widget.isResubmission || isActionRequired) &&
                  currentKyc?.adminNote != null &&
                  currentKyc!.adminNote!.isNotEmpty) ...[
                SizedBox(height: h * 0.018),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFFDBA74),
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.feedback_outlined,
                            color: Color(0xFFC2410C),
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Admin Feedback / Required Action:',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFC2410C),
                              fontFamily: 'Urbanist',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentKyc.adminNote!,
                        style: const TextStyle(
                          fontSize: 12.5,
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF7C2D12),
                          fontFamily: 'Urbanist',
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (hasExistingSubmission &&
                  !widget.isResubmission &&
                  !isActionRequired) ...[
                SizedBox(height: h * 0.018),
                GestureDetector(
                  onTap: () {
                    context.push(KycStatusView.routeName);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFFDE68A)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          color: Color(0xFFD97706),
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Existing Application: ${currentKyc.status.displayName}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: Color(0xFF92400E),
                                  fontFamily: 'Urbanist',
                                ),
                              ),
                              Text(
                                'Ref: ${currentKyc.referenceId} • Tap to view tracking status',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade700,
                                  fontFamily: 'Urbanist',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          CupertinoIcons.right_chevron,
                          size: 14,
                          color: Color(0xFFD97706),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              SizedBox(height: h * 0.024),

              // Step 1: Select ID Proof Type
              const Text(
                '1. SELECT ID PROOF TYPE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: Colors.grey,
                  fontFamily: 'Urbanist',
                ),
              ),
              SizedBox(height: h * 0.01),

              KycIdProofDropdown(
                selectedType: _selectedIdType,
                onTypeChanged: (newType) {
                  setState(() {
                    _selectedIdType = newType;
                    _isIdNumberAutoFilled = false;
                    if (_idNumberController.text.isNotEmpty &&
                        newType.validate(_idNumberController.text) != null) {
                      _idNumberController.clear();
                    }
                  });
                },
              ),

              SizedBox(height: h * 0.024),

              // Step 2: Upload Document Photos (Auto-extracts with OCR)
              Row(
                children: [
                  const Text(
                    '2. UPLOAD DOCUMENT PHOTOS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: Colors.grey,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFA7F3D0)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_awesome_rounded,
                          size: 12,
                          color: Color(0xFF059669),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Auto-fills via OCR',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF059669),
                            fontFamily: 'Urbanist',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: h * 0.01),

              // Front Document Card
              DocumentUploadCard(
                title: 'Front Side of ${_selectedIdType.title}',
                subtitle:
                    'Ensure all details, photo, and ID number are clearly visible.',
                isRequired: true,
                selectedFile: _frontDocument,
                isProcessingOcr: _isFrontOcrScanning,
                onRescanOcr: _frontDocument != null
                    ? () => _processImageOcr(_frontDocument!, isFront: true)
                    : null,
                onFileSelected: (file) {
                  setState(() => _frontDocument = file);
                  if (file != null) {
                    _processImageOcr(file, isFront: true);
                  }
                },
              ),

              SizedBox(height: h * 0.014),

              // Back Document Card (if applicable)
              DocumentUploadCard(
                title: 'Back Side of ${_selectedIdType.title}',
                subtitle: _selectedIdType.requiresBackImage
                    ? 'Showing official address or barcode details.'
                    : 'Not required for PAN Card.',
                isRequired: _selectedIdType.requiresBackImage,
                selectedFile: _backDocument,
                isProcessingOcr: _isBackOcrScanning,
                onRescanOcr: _backDocument != null
                    ? () => _processImageOcr(_backDocument!, isFront: false)
                    : null,
                onFileSelected: (file) {
                  setState(() => _backDocument = file);
                  if (file != null && _frontDocument == null) {
                    _processImageOcr(file, isFront: false);
                  }
                },
              ),

              SizedBox(height: h * 0.024),

              // Step 3: Document Details
              Row(
                children: [
                  const Text(
                    '3. DOCUMENT DETAILS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: Colors.grey,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                  const Spacer(),
                  if (_isIdNumberAutoFilled || _isNameAutoFilled)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFBFDBFE)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: 12,
                            color: Color(0xFF2563EB),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'OCR Extracted',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2563EB),
                              fontFamily: 'Urbanist',
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              SizedBox(height: h * 0.01),

              // OCR Scanning & Summary Banner
              if (_isFrontOcrScanning || _isBackOcrScanning)
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: h * 0.014),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: const Row(
                    children: [
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Scanning document details with on-device OCR...',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1D4ED8),
                            fontFamily: 'Urbanist',
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else if (_ocrSummaryBanner != null)
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: h * 0.014),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: (_isIdNumberAutoFilled || _isNameAutoFilled)
                        ? const Color(0xFFF0FDF4)
                        : const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: (_isIdNumberAutoFilled || _isNameAutoFilled)
                          ? const Color(0xFFBBF7D0)
                          : const Color(0xFFFDE68A),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        (_isIdNumberAutoFilled || _isNameAutoFilled)
                            ? Icons.auto_awesome_rounded
                            : Icons.info_outline_rounded,
                        size: 16,
                        color: (_isIdNumberAutoFilled || _isNameAutoFilled)
                            ? const Color(0xFF16A34A)
                            : const Color(0xFFD97706),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _ocrSummaryBanner!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: (_isIdNumberAutoFilled || _isNameAutoFilled)
                                ? const Color(0xFF166534)
                                : const Color(0xFF92400E),
                            fontFamily: 'Urbanist',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // ID Number TextField
              TextFormField(
                controller: _idNumberController,
                textCapitalization: TextCapitalization.characters,
                onChanged: (_) {
                  if (_isIdNumberAutoFilled) {
                    setState(() => _isIdNumberAutoFilled = false);
                  }
                },
                style: const TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  labelText: '${_selectedIdType.title} Number *',
                  hintText: _selectedIdType.idNumberHint,
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade400,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.numbers_rounded, size: 20),
                  suffixIcon: _isIdNumberAutoFilled
                      ? Tooltip(
                          message: 'Auto-filled via OCR',
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.auto_awesome,
                                  size: 12,
                                  color: Color(0xFF059669),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'OCR',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF059669),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: _isIdNumberAutoFilled
                          ? const Color(0xFF10B981).withValues(alpha: 0.5)
                          : Colors.grey.shade200,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Palette.primaryColor,
                      width: 1.5,
                    ),
                  ),
                ),
                validator: (val) => _selectedIdType.validate(val),
              ),

              SizedBox(height: h * 0.014),

              // Full Name on ID
              TextFormField(
                controller: _nameController,
                onChanged: (_) {
                  if (_isNameAutoFilled) {
                    setState(() => _isNameAutoFilled = false);
                  }
                },
                style: const TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  labelText: 'Full Name (as on document) *',
                  hintText: 'Enter name printed on ID',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(
                    Icons.person_outline_rounded,
                    size: 20,
                  ),
                  suffixIcon: _isNameAutoFilled
                      ? Tooltip(
                          message: 'Auto-filled via OCR',
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.auto_awesome,
                                  size: 12,
                                  color: Color(0xFF059669),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'OCR',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF059669),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: _isNameAutoFilled
                          ? const Color(0xFF10B981).withValues(alpha: 0.5)
                          : Colors.grey.shade200,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Palette.primaryColor,
                      width: 1.5,
                    ),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter the full name on the document';
                  }
                  return null;
                },
              ),

              SizedBox(height: h * 0.024),

              // Consent Checkbox
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _consentGiven
                        ? Palette.primaryColor.withValues(alpha: 0.3)
                        : Colors.grey.shade200,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _consentGiven,
                      activeColor: Palette.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (val) {
                        setState(() => _consentGiven = val ?? false);
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, right: 6),
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _consentGiven = !_consentGiven);
                          },
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                                fontFamily: 'Urbanist',
                                height: 1.4,
                              ),
                              children: [
                                const TextSpan(
                                  text:
                                      'I hereby confirm that the document submitted belongs to me and all information provided is accurate. I authorize Ashok Gold to verify my identity in accordance with the ',
                                ),
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () => context.push(
                                      PrivacyPolicyView.routeName,
                                    ),
                                    child: const Text(
                                      'Privacy Policy & KYC Guidelines',
                                      style: TextStyle(
                                        color: Palette.primaryColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                                const TextSpan(
                                  text: ' for gold scheme participation.',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: h * 0.03),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.primaryColor,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _isSubmitting ? null : _handleSubmit,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check_circle_outline_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.isResubmission || isActionRequired
                                  ? 'Resubmit for Admin Review'
                                  : 'Submit for Verification',
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

              SizedBox(height: h * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}
