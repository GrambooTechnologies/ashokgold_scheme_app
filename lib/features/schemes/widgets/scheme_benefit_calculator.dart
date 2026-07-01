import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/core/utilities/scale_size_utils.dart';
import 'package:ashokgold_scheme_app/features/schemes/models/benefit_calculation_params.dart';
import 'package:ashokgold_scheme_app/features/schemes/models/scheme_benefit_calculation_model.dart';
import 'package:ashokgold_scheme_app/features/schemes/providers/benefit_calculation_provider.dart';
import 'package:ashokgold_scheme_app/features/schemes/providers/payment_rules_provider.dart';
import 'package:ashokgold_scheme_app/features/schemes/providers/selected_payment_amount_provider.dart';
import 'package:ashokgold_scheme_app/features/schemes/widgets/payment_amount_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../common/providers/metal_rate_provider.dart';

class SchemeBenefitCalculator extends ConsumerStatefulWidget {
  final String schemeId;
  final String schemeName;
  final double initialAmount;

  const SchemeBenefitCalculator({
    super.key,
    required this.schemeId,
    required this.schemeName,
    required this.initialAmount,
  });

  @override
  ConsumerState<SchemeBenefitCalculator> createState() =>
      _SchemeBenefitCalculatorState();
}

class _SchemeBenefitCalculatorState
    extends ConsumerState<SchemeBenefitCalculator> {
  late double _currentAmount;

  @override
  void initState() {
    super.initState();

    _currentAmount = widget.initialAmount == 0.0 ? 0 : widget.initialAmount;
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final paymentRulesAsync = ref.watch(paymentRulesProvider(widget.schemeId));
    final benefitAsync = ref.watch(
      benefitCalculationProvider(
        BenefitCalculationParams(
          schemeId: widget.schemeId,
          installmentAmount: _currentAmount,
        ),
      ),
    );
    final metalRateAsync = ref.watch(latestMetalRateProvider); // ⭐ ADD THIS

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: h * .04),
        Center(
          child: Text(
            '${widget.schemeName} Calculator',
            style: TextStyle(
              fontSize: w * 0.042,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w700,
              color: Palette.blackColor,
            ),
          ),
        ),
        SizedBox(height: h * 0.01),
        Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(w * 0.02),
              color: Colors.yellow.withOpacity(0.1),
              border: Border.all(color: Colors.yellow.shade800, width: 1),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: h * 0.004,
                horizontal: w * 0.04,
              ),
              child: metalRateAsync.when(
                data: (metalRate) => Text(
                  '22K Gold Current Rate : ₹${metalRate.rates.metalRate.toStringAsFixed(0)}/g',
                  style: TextStyle(
                    fontSize: w * 0.03,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w700,
                    color: Colors.yellow.shade900,
                  ),
                ),
                loading: () => Text(
                  'Fetching latest gold rate...',
                  style: TextStyle(
                    fontSize: w * 0.03,
                    fontWeight: FontWeight.w600,
                    color: Colors.yellow.shade700,
                  ),
                ),
                error: (_, _) => Text(
                  'Gold rate unavailable',
                  style: TextStyle(
                    fontSize: w * 0.03,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade400,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: h * 0.012),
        paymentRulesAsync.when(
          data: (paymentRule) => PaymentAmountSlider(
            paymentRule: paymentRule,
            initialAmount: widget.initialAmount,
            onAmountChanged: (amount) {
              setState(() {
                _currentAmount = amount;
              });
              ref
                  .read(selectedPaymentAmountProvider.notifier)
                  .setAmount(amount);
            },
          ),
          loading: () => Padding(
            padding: EdgeInsets.symmetric(vertical: SizeConfig.h(context, 16)),
            child: const Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => Padding(
            padding: EdgeInsets.symmetric(vertical: SizeConfig.h(context, 16)),
            child: Column(
              children: [
                Text(
                  'Could not load payment rules',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: SizeConfig.w(context, 14),
                  ),
                ),
                SizedBox(height: SizeConfig.h(context, 8)),
                TextButton(
                  onPressed: () =>
                      ref.invalidate(paymentRulesProvider(widget.schemeId)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: h * 0.02),
        // Benefit Calculation Card
        benefitAsync.when(
          data: (benefit) => metalRateAsync.when(
            data: (metalRate) =>
                _buildBenefitCard(context, benefit, metalRate.rates.metalRate),
            loading: () => _buildShimmerCard(context),
            error: (_, _) => _buildBenefitCard(context, benefit, null),
          ),
          loading: () => _buildShimmerCard(context),
          error: (error, stack) => _buildErrorCard(context),
        ),
      ],
    );
  }

  Widget _buildBenefitCard(
    BuildContext context,
    SchemeBenefitCalculationModel benefit,
    double? goldRatePerGram,
  ) {
    print(benefit.toJson());
    final accumulated = benefit.totalAmountPaid;
    final benefitAmount = benefit.benefitOffered;
    final jewelleryValue = benefit.redemptionValue;

    final accumulatedWeight = goldRatePerGram != null && goldRatePerGram > 0
        ? accumulated / goldRatePerGram
        : null;

    final benefitWeight = goldRatePerGram != null && goldRatePerGram > 0
        ? benefitAmount / goldRatePerGram
        : null;

    final jewelleryWeight = goldRatePerGram != null && goldRatePerGram > 0
        ? jewelleryValue / goldRatePerGram
        : null;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SizeConfig.w(context, 18)),
      decoration: BoxDecoration(
        color: Palette.cardBackgroundColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(SizeConfig.w(context, 18)),
        border: Border.all(
          color: Palette.primaryColor.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ===== TOTAL ACCUMULATED =====
          _calcRow(
            context,
            'Total Amount Paid',
            '₹${accumulated.toStringAsFixed(0)}',
          ),

          SizedBox(height: SizeConfig.h(context, 6)),

          /// ===== BENEFIT OFFERED =====
          _calcRow(
            context,
            'Benefit Offered',
            benefitWeight == null
                ? '₹${benefitAmount.toStringAsFixed(0)}'
                : '₹${benefitAmount.toStringAsFixed(0)} (${benefitWeight.toStringAsFixed(2)}g)',
          ),

          SizedBox(height: SizeConfig.h(context, 6)),

          /// ===== REDEMPTION VALUE =====
          _calcRow(
            context,
            'Redemption Value',
            jewelleryWeight == null
                ? '₹${jewelleryValue.toStringAsFixed(0)}'
                : '₹${jewelleryValue.toStringAsFixed(0)} (${jewelleryWeight.toStringAsFixed(2)}g)',
            bold: true,
          ),

          SizedBox(height: SizeConfig.h(context, 18)),

          /// ===== DONUT + DETAILS =====
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildDonut(context),
              SizedBox(width: SizeConfig.w(context, 14)),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _dotText(
                      context,
                      'Total Paid',
                      accumulatedWeight == null
                          ? '₹${accumulated.toStringAsFixed(0)}'
                          : '₹${accumulated.toStringAsFixed(0)} (${accumulatedWeight.toStringAsFixed(2)}g)',
                    ),
                    SizedBox(height: SizeConfig.h(context, 11)),
                    _dotText(
                      context,
                      'Benefit',
                      benefitWeight == null
                          ? '₹${benefitAmount.toStringAsFixed(0)}'
                          : '₹${benefitAmount.toStringAsFixed(0)} (${benefitWeight.toStringAsFixed(2)}g)',
                    ),
                    SizedBox(height: SizeConfig.h(context, 11)),
                    _dotText(
                      context,
                      'You Get Worth',
                      jewelleryWeight == null
                          ? '₹${jewelleryValue.toStringAsFixed(0)}'
                          : '₹${jewelleryValue.toStringAsFixed(0)} (${jewelleryWeight.toStringAsFixed(2)}g)',
                    ),
                    SizedBox(height: SizeConfig.h(context, 1)),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: SizeConfig.h(context, 16)),

          /// ===== BENEFIT DESCRIPTION =====
          if (benefit.benefitDescription.isNotEmpty &&
              benefit.benefitDescription != '--')
            Text(
              benefit.benefitDescription,
              style: TextStyle(
                fontSize: SizeConfig.w(context, 11),
                height: 1.4,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
        ],
      ),
    );
  }

  Widget _calcRow(
    BuildContext context,
    String label,
    String value, {
    bool bold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: SizeConfig.w(context, 13),
            color: Colors.black.withOpacity(0.7),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: SizeConfig.w(context, 14),
            fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
            color: Palette.blackColor,
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerCard(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;

    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(w * 0.045),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(w * 0.055),
          color: Colors.white.withOpacity(0.8),
        ),
        child: Column(
          children: List.generate(
            8,
            (index) => Container(
              margin: EdgeInsets.only(bottom: h * 0.015),
              height: h * 0.02,
              width: index == 0 ? w * 0.55 : w * (0.25 + (index % 4) * 0.15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.all(w * 0.045),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(w * 0.055),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        children: [
          Icon(
            Icons.warning_rounded,
            size: w * 0.08,
            color: Colors.red.shade400,
          ),
          SizedBox(height: h * 0.01),
          Text(
            'Unable to Calculate Benefits',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: w * 0.04,
              color: Colors.red.shade700,
            ),
          ),
          SizedBox(height: h * 0.01),
          TextButton(
            onPressed: () {
              ref.invalidate(
                benefitCalculationProvider(
                  BenefitCalculationParams(
                    schemeId: widget.schemeId,
                    installmentAmount: _currentAmount,
                  ),
                ),
              );
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _dotText(BuildContext context, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: SizeConfig.w(context, 6),
          height: SizeConfig.w(context, 6),
          margin: EdgeInsets.only(top: SizeConfig.h(context, 4)),
          decoration: BoxDecoration(
            color: Palette.primaryColor,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: SizeConfig.w(context, 8)),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: RichText(
              maxLines: 1,
              text: TextSpan(
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: SizeConfig.w(context, 12.5),
                  color: Colors.black.withOpacity(0.75),
                ),
                children: [
                  TextSpan(text: '$title '),
                  TextSpan(
                    text: value,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDonut(BuildContext context) {
    final size = SizeConfig.w(context, 110);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Palette.primaryColor.withOpacity(0.4),
          width: SizeConfig.w(context, 7),
        ),
      ),
      child: Center(
        child: Text(
          'Installment\nAmount\n₹${_currentAmount.toStringAsFixed(0)}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: SizeConfig.w(context, 11),
            color: Colors.black.withOpacity(0.7),
          ),
        ),
      ),
    );
  }
}
