enum KycStatus {
  notSubmitted,
  pending,
  approved,
  rejected,
  actionRequired;

  String get value {
    switch (this) {
      case KycStatus.notSubmitted:
        return 'not_submitted';
      case KycStatus.pending:
        return 'pending';
      case KycStatus.approved:
        return 'approved';
      case KycStatus.rejected:
        return 'rejected';
      case KycStatus.actionRequired:
        return 'action_required';
    }
  }

  String get displayName {
    switch (this) {
      case KycStatus.notSubmitted:
        return 'Not Submitted';
      case KycStatus.pending:
        return 'Pending Verification';
      case KycStatus.approved:
        return 'Verified';
      case KycStatus.rejected:
        return 'Rejected';
      case KycStatus.actionRequired:
        return 'Action Required';
    }
  }

  static KycStatus fromString(String? value) {
    if (value == null) return KycStatus.notSubmitted;
    switch (value.toLowerCase().replaceAll('-', '_')) {
      case 'pending':
      case 'in_review':
      case 'under_review':
        return KycStatus.pending;
      case 'approved':
      case 'verified':
        return KycStatus.approved;
      case 'rejected':
        return KycStatus.rejected;
      case 'action_required':
      case 'actionrequired':
      case 'resubmit':
        return KycStatus.actionRequired;
      default:
        return KycStatus.notSubmitted;
    }
  }
}
