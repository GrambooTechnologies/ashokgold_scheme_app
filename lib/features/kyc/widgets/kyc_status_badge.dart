import 'package:ashokgold_scheme_app/features/kyc/models/kyc_status.dart';
import 'package:flutter/material.dart';

class KycStatusBadge extends StatelessWidget {
  final KycStatus status;
  final bool compact;

  const KycStatusBadge({super.key, required this.status, this.compact = false});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color border;
    Color text;
    IconData icon;
    String label;

    switch (status) {
      case KycStatus.approved:
        bg = const Color(0xFFE8FAF1);
        border = const Color(0xFF10B981);
        text = const Color(0xFF047857);
        icon = Icons.verified_rounded;
        label = compact ? 'Verified' : 'Identity Verified';
        break;
      case KycStatus.pending:
        bg = const Color(0xFFFFFBEB);
        border = const Color(0xFFF59E0B);
        text = const Color(0xFFB45309);
        icon = Icons.hourglass_top_rounded;
        label = compact ? 'Pending' : 'Under Review';
        break;
      case KycStatus.actionRequired:
        bg = const Color(0xFFFFF7ED);
        border = const Color(0xFFEA580C);
        text = const Color(0xFFC2410C);
        icon = Icons.error_outline_rounded;
        label = compact ? 'Action Req.' : 'Action Required';
        break;
      case KycStatus.rejected:
        bg = const Color(0xFFFFEEEF);
        border = const Color(0xFFEF4444);
        text = const Color(0xFFB91C1C);
        icon = Icons.cancel_outlined;
        label = compact ? 'Rejected' : 'Verification Rejected';
        break;
      case KycStatus.notSubmitted:
        bg = const Color(0xFFF3F4F6);
        border = const Color(0xFFD1D5DB);
        text = const Color(0xFF4B5563);
        icon = Icons.shield_outlined;
        label = compact ? 'Unverified' : 'Not Verified';
        break;
    }

    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: border.withValues(alpha: 0.4), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: text),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: text,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                fontFamily: 'Urbanist',
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border, width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: text),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: text,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              fontFamily: 'Urbanist',
            ),
          ),
        ],
      ),
    );
  }
}
