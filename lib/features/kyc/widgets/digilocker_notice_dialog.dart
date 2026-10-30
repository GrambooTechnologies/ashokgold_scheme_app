import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:flutter/material.dart';

class DigilockerNoticeDialog extends StatelessWidget {
  final VoidCallback onProceedManual;

  const DigilockerNoticeDialog({super.key, required this.onProceedManual});

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onProceedManual,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DigilockerNoticeDialog(
        onProceedManual: () {
          Navigator.of(ctx).pop();
          onProceedManual();
        },
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
        w * 0.06,
        14,
        w * 0.06,
        MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Drag handle
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 22),

          // DigiLocker Icon with official styling
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF003366).withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.account_balance_rounded,
                size: 34,
                color: Color(0xFF003366),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFDBA74)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timelapse_rounded,
                  size: 14,
                  color: Color(0xFFC2410C),
                ),
                SizedBox(width: 6),
                Text(
                  'API Approval In Progress',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFC2410C),
                    fontFamily: 'Urbanist',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Title
          const Text(
            'DigiLocker Verification',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
              fontFamily: 'Urbanist',
            ),
          ),
          const SizedBox(height: 10),

          // Explanation
          Text(
            'Government DigiLocker API integration is currently awaiting final regulatory credentials & security audit approval.\n\nTo ensure compliant and secure scheme enrollment without delays, please proceed with our simple Manual Document Verification. Your submission will be reviewed quickly within 24–48 hours.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.45,
              color: Colors.grey.shade700,
              fontFamily: 'Urbanist',
            ),
          ),
          const SizedBox(height: 24),

          // Primary Button: Proceed with Manual Verification
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Palette.primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: onProceedManual,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.upload_file_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Proceed with Manual Verification',
                    style: TextStyle(
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
          const SizedBox(height: 10),

          // Secondary Cancel Button
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Urbanist',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
