import 'dart:io';
import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/features/kyc/models/customer_kyc_model.dart';
import 'package:ashokgold_scheme_app/features/kyc/models/kyc_status.dart';
import 'package:ashokgold_scheme_app/features/kyc/providers/kyc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminReviewDialog extends ConsumerStatefulWidget {
  final CustomerKycModel kyc;

  const AdminReviewDialog({super.key, required this.kyc});

  static Future<void> show(
    BuildContext context, {
    required CustomerKycModel kyc,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AdminReviewDialog(kyc: kyc),
    );
  }

  @override
  ConsumerState<AdminReviewDialog> createState() => _AdminReviewDialogState();
}

class _AdminReviewDialogState extends ConsumerState<AdminReviewDialog> {
  final TextEditingController _reasonController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _handleDecision(
    KycStatus status, {
    String? defaultReason,
  }) async {
    String? note = _reasonController.text.trim();
    if (note.isEmpty) {
      note = defaultReason;
    }

    if ((status == KycStatus.rejected || status == KycStatus.actionRequired) &&
        (note == null || note.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a reason for the customer.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final success = await ref
        .read(kycControllerProvider.notifier)
        .adminReview(
          customerId: widget.kyc.customerId,
          status: status,
          adminNote: note,
          reviewedBy: 'Compliance Admin',
          context: context,
        );

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.of(context).pop();
    }
  }

  void _showReasonDialog({
    required String title,
    required KycStatus status,
    required String hint,
    required List<String> quickReasons,
  }) {
    _reasonController.clear();
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
              fontFamily: 'Urbanist',
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select a common reason or type specific feedback for the customer:',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: quickReasons.map((reason) {
                    final isSelected = _reasonController.text == reason;
                    return InkWell(
                      onTap: () {
                        setDialogState(() {
                          _reasonController.text = reason;
                        });
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Palette.primaryColor
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          reason,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _reasonController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(fontSize: 13),
                    filled: true,
                    fillColor: const Color(0xFFF8F9FE),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Palette.primaryColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: status == KycStatus.rejected
                    ? const Color(0xFFEF4444)
                    : const Color(0xFFF97316),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                _handleDecision(status);
              },
              child: const Text(
                'Submit Decision',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        w * 0.05,
        14,
        w * 0.05,
        MediaQuery.of(context).viewInsets.bottom +
            MediaQuery.of(context).padding.bottom +
            20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Header Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Admin KYC Review',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A2E),
                          fontFamily: 'Urbanist',
                        ),
                      ),
                      Text(
                        'Compliance & Verification Review Portal',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Admin Tool',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4338CA),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Customer Submission Summary
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FE),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _infoRow(
                    'Reference ID',
                    widget.kyc.referenceId,
                    isBold: true,
                  ),
                  const Divider(height: 16),
                  _infoRow('Customer Name', widget.kyc.customerName),
                  const Divider(height: 16),
                  _infoRow('Phone Number', widget.kyc.phoneNumber),
                  const Divider(height: 16),
                  _infoRow('ID Proof Type', widget.kyc.idProofType.title),
                  const Divider(height: 16),
                  _infoRow('ID Number', widget.kyc.idNumber, isBold: true),
                  const Divider(height: 16),
                  _infoRow('Current Status', widget.kyc.status.displayName),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Uploaded Documents Preview
            const Text(
              'Submitted Documents:',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
                fontFamily: 'Urbanist',
              ),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                if (widget.kyc.frontDocumentPath != null)
                  Expanded(
                    child: _documentThumbnail(
                      title: 'Front Side',
                      filePath: widget.kyc.frontDocumentPath!,
                    ),
                  ),
                const SizedBox(width: 10),
                if (widget.kyc.backDocumentPath != null)
                  Expanded(
                    child: _documentThumbnail(
                      title: 'Back Side',
                      filePath: widget.kyc.backDocumentPath!,
                    ),
                  )
                else
                  Expanded(
                    child: Container(
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.kyc.idProofType.requiresBackImage
                            ? 'No back photo'
                            : 'Not required for ${widget.kyc.idProofType.title}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 22),

            // Admin Action Buttons
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Column(
                children: [
                  // 1. Approve
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => _handleDecision(
                        KycStatus.approved,
                        defaultReason: 'Verified by compliance admin.',
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Approve & Unlock Schemes',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              fontFamily: 'Urbanist',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 2. Request Resubmission (Action Required)
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFFF97316),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => _showReasonDialog(
                        title: 'Request Document Resubmission',
                        status: KycStatus.actionRequired,
                        hint:
                            'Specify what the customer needs to fix or re-upload...',
                        quickReasons: [
                          'Front image is blurred or illegible.',
                          'Back side photo was cut off or missing.',
                          'Name on document does not match account name.',
                          'ID card edges are cropped. Upload full photo.',
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.replay_rounded,
                            color: Color(0xFFF97316),
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Request Resubmission (Action Required)',
                            style: TextStyle(
                              color: Color(0xFFF97316),
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              fontFamily: 'Urbanist',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 3. Reject
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFFEF4444),
                      ),
                      onPressed: () => _showReasonDialog(
                        title: 'Reject KYC Application',
                        status: KycStatus.rejected,
                        hint: 'Specify rejection reason...',
                        quickReasons: [
                          'Invalid or expired government ID submitted.',
                          'Identity could not be verified by compliance.',
                          'Document appears forged or altered.',
                        ],
                      ),
                      child: const Text(
                        'Reject Application with Reason',
                        style: TextStyle(
                          color: Color(0xFFEF4444),
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool isBold = false}) {
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
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: const Color(0xFF1A1A2E),
            fontFamily: 'Urbanist',
          ),
        ),
      ],
    );
  }

  Widget _documentThumbnail({required String title, required String filePath}) {
    final file = File(filePath);
    final exists = file.existsSync();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Container(
          height: 90,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          clipBehavior: Clip.antiAlias,
          child: exists
              ? Image.file(file, fit: BoxFit.cover)
              : const Center(
                  child: Icon(Icons.description, size: 28, color: Colors.grey),
                ),
        ),
      ],
    );
  }
}
