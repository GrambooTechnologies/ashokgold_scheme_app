import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/features/kyc/models/id_proof_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KycIdProofDropdown extends StatelessWidget {
  final IdProofType selectedType;
  final ValueChanged<IdProofType> onTypeChanged;
  final bool enabled;

  const KycIdProofDropdown({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
    this.enabled = true,
  });

  IconData _getIconForType(IdProofType type) {
    switch (type) {
      case IdProofType.aadhaar:
        return Icons.fingerprint_rounded;
      case IdProofType.pan:
        return Icons.credit_card_rounded;
      case IdProofType.passport:
        return Icons.menu_book_rounded;
      case IdProofType.voterId:
        return Icons.how_to_vote_rounded;
      case IdProofType.drivingLicense:
        return Icons.drive_eta_rounded;
    }
  }

  Color _getIconBgColor(IdProofType type) {
    switch (type) {
      case IdProofType.aadhaar:
        return const Color(0xFFEFF6FF);
      case IdProofType.pan:
        return const Color(0xFFFEF3C7);
      case IdProofType.passport:
        return const Color(0xFFECFDF5);
      case IdProofType.voterId:
        return const Color(0xFFF3E8FF);
      case IdProofType.drivingLicense:
        return const Color(0xFFFFF1F2);
    }
  }

  Color _getIconColor(IdProofType type) {
    switch (type) {
      case IdProofType.aadhaar:
        return const Color(0xFF2563EB);
      case IdProofType.pan:
        return const Color(0xFFD97706);
      case IdProofType.passport:
        return const Color(0xFF059669);
      case IdProofType.voterId:
        return const Color(0xFF9333EA);
      case IdProofType.drivingLicense:
        return const Color(0xFFE11D48);
    }
  }

  void _showSelectionSheet(BuildContext context) {
    if (!enabled) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Sheet Header
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select ID Proof Document',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A2E),
                              fontFamily: 'Urbanist',
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Choose an official government ID for verification',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontFamily: 'Urbanist',
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      color: Colors.grey.shade600,
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Divider(height: 1, color: Colors.grey.shade200),
                const SizedBox(height: 10),

                // List of options
                ...IdProofType.values.map((type) {
                  final isSelected = type == selectedType;
                  return InkWell(
                    onTap: () {
                      Navigator.of(ctx).pop();
                      onTypeChanged(type);
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Palette.primaryColor.withValues(alpha: 0.06)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? Palette.primaryColor.withValues(alpha: 0.4)
                              : Colors.grey.shade200,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: _getIconBgColor(type),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getIconForType(type),
                              color: _getIconColor(type),
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  type.title,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                    color: const Color(0xFF1A1A2E),
                                    fontFamily: 'Urbanist',
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  type.requiresBackImage
                                      ? '${type.idNumberHint} • Front & Back'
                                      : '${type.idNumberHint} • Front Only',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: Colors.grey.shade500,
                                    fontFamily: 'Urbanist',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Palette.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                            )
                          else
                            Icon(
                              CupertinoIcons.circle,
                              size: 18,
                              color: Colors.grey.shade300,
                            ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? () => _showSelectionSheet(context) : null,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: _getIconBgColor(selectedType),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getIconForType(selectedType),
                size: 20,
                color: _getIconColor(selectedType),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Selected ID Proof',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                      fontFamily: 'Urbanist',
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    selectedType.title,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                      fontFamily: 'Urbanist',
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                selectedType.requiresBackImage ? 'Front & Back' : 'Front Only',
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4B5563),
                  fontFamily: 'Urbanist',
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: enabled ? Palette.primaryColor : Colors.grey.shade400,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
