class BenefitCalculationParams {
  final String schemeId;
  final double installmentAmount;

  BenefitCalculationParams({
    required this.schemeId,
    required this.installmentAmount,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BenefitCalculationParams &&
          runtimeType == other.runtimeType &&
          schemeId == other.schemeId &&
          installmentAmount == other.installmentAmount;

  @override
  int get hashCode => schemeId.hashCode ^ installmentAmount.hashCode;
}
