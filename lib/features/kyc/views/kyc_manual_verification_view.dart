import 'package:ashokgold_scheme_app/features/kyc/models/customer_kyc_model.dart';
import 'package:ashokgold_scheme_app/features/kyc/views/kyc_selection_view.dart';
import 'package:flutter/material.dart';

/// Manual verification is now unified directly into [KycSelectionView].
/// This widget acts as a compatibility wrapper for any existing routes or callers.
class KycManualVerificationView extends StatelessWidget {
  static const String routeName = '/kyc-manual-verification';

  final bool isResubmission;
  final CustomerKycModel? existingKyc;
  final String? targetSchemeId;
  final double? targetAmount;

  const KycManualVerificationView({
    super.key,
    this.isResubmission = false,
    this.existingKyc,
    this.targetSchemeId,
    this.targetAmount,
  });

  @override
  Widget build(BuildContext context) {
    return KycSelectionView(
      isResubmission: isResubmission,
      existingKyc: existingKyc,
      targetSchemeId: targetSchemeId,
      targetAmount: targetAmount,
    );
  }
}
