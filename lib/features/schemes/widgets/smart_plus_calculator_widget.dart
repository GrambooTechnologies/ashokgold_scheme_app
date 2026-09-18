import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/features/common/providers/metal_rate_provider.dart';

class SmartPlusCalculatorWidget extends ConsumerStatefulWidget {
  final String schemeId;
  final String schemeName;

  const SmartPlusCalculatorWidget({
    super.key,
    required this.schemeId,
    required this.schemeName,
  });

  @override
  ConsumerState<SmartPlusCalculatorWidget> createState() =>
      _SmartPlusCalculatorWidgetState();
}

class _SmartPlusCalculatorWidgetState extends ConsumerState<SmartPlusCalculatorWidget> {
  double _monthlyAmount = 5000.0; // default value
  final double _minAmount = 500.0;
  final double _maxAmount = 50000.0; // maximum amount capped at 50000
  final int _months = 11;
  double _makingChargePercent = 8.0; // default ornament making charge
  
  late TextEditingController _amountController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: _monthlyAmount.toInt().toString());
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      final parsed = double.tryParse(_amountController.text);
      if (parsed == null) {
        _updateAmount(_monthlyAmount);
      } else {
        // Round to nearest 500 and clamp between min and max
        final rounded = ((parsed / 500.0).round() * 500.0).clamp(_minAmount, _maxAmount);
        _updateAmount(rounded);
      }
    }
  }

  void _updateAmount(double newAmount) {
    setState(() {
      _monthlyAmount = newAmount;
    });
    final intValue = newAmount.toInt();
    if (_amountController.text != intValue.toString()) {
      _amountController.text = intValue.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    // Watch latest metal rate
    final metalRateAsync = ref.watch(latestMetalRateProvider);
    final double goldRate = metalRateAsync.maybeWhen(
      data: (rate) => rate.rates.metalRate,
      orElse: () => 14280.0, // fallback gold price from user screenshot
    );

    // Calculations:
    final double totalAccumulated = _monthlyAmount * _months;
    
    // 5 percentage-point reduction benefit on making charges:
    // If making charge <= 5%, new rate is 0% (discount rate = making charge rate).
    // If making charge > 5%, new rate is making charge rate - 5% (discount rate = 5%).
    final double discountPercent = _makingChargePercent <= 5.0 ? _makingChargePercent : 5.0;
    final double netMakingChargePercent = _makingChargePercent - discountPercent;
    
    final double originalMakingChargeAmount = totalAccumulated * (_makingChargePercent / 100.0);
    final double netMakingChargeAmount = totalAccumulated * (netMakingChargePercent / 100.0);
    final double makingChargeSavings = totalAccumulated * (discountPercent / 100.0);
    
    // Final purchase value = Gold value + Net Making Charges
    final double finalPurchaseValue = totalAccumulated + netMakingChargeAmount;
    // GST (3%) applicable on final purchase value
    final double gstAmount = finalPurchaseValue * 0.03;
    final double grandTotalWithScheme = finalPurchaseValue + gstAmount;
    
    // Normal purchase outflow without scheme:
    final double normalPurchaseValue = totalAccumulated + originalMakingChargeAmount;
    final double normalGstAmount = normalPurchaseValue * 0.03;
    final double grandTotalWithoutScheme = normalPurchaseValue + normalGstAmount;
    
    // Total savings (Making charge discount + GST savings)
    final double totalSavings = grandTotalWithoutScheme - grandTotalWithScheme;
    
    // Gold weight calculation: Total contribution divided by gold rate per gram
    final double accumulatedWeight = goldRate > 0 ? totalAccumulated / goldRate : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Center(
          child: Text(
            '${widget.schemeName} Benefits Calculator',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w700,
              color: isDark ? Palette.whiteColor : Palette.blackColor,
            ),
          ),
        ),
        const SizedBox(height: 8),

        // 22KT Gold rate badge
        Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isDark 
                  ? Palette.primaryColor.withValues(alpha: 0.1) 
                  : Palette.primaryColor.withValues(alpha: 0.05),
              border: Border.all(
                color: Palette.primaryColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            child: Text(
              '22 KT Gold Current Price: ₹${goldRate.toStringAsFixed(0)}/gm',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w700,
                color: Palette.primaryColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Input advance amount planned
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Input your advance amount planned',
                style: TextStyle(
                  fontSize: 13.5,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w600,
                  color: isDark ? Palette.whiteColor.withValues(alpha: 0.9) : Palette.blackColor.withValues(alpha: 0.8),
                ),
              ),
            ),
            Container(
              width: 100,
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? Palette.whiteColor.withValues(alpha: 0.08) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      '₹',
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      focusNode: _focusNode,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        border: InputBorder.none,
                      ),
                      onChanged: (val) {
                        final parsed = double.tryParse(val);
                        if (parsed != null) {
                          // Snaps to nearest 500 step for the internal slider value
                          final rounded = ((parsed / 500.0).round() * 500.0).clamp(_minAmount, _maxAmount);
                          setState(() {
                            _monthlyAmount = rounded;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),

        // Slider for monthly amount - increments in steps of 500 (Maximizing horizontal drag length)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Palette.redColor,
              inactiveTrackColor: Colors.grey.shade300,
              thumbColor: Palette.redColor,
              overlayColor: Palette.redColor.withValues(alpha: 0.2),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              trackShape: const RectangularSliderTrackShape(), // Extends track to full width
            ),
            child: Slider(
              min: _minAmount,
              max: _maxAmount,
              divisions: 99, // ((50000 - 500) / 500) = 99 divisions for perfect multiples of 500
              value: _monthlyAmount,
              onChanged: (value) {
                _updateAmount(value);
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Min ₹${_minAmount.toInt()}',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
              ),
              Text(
                'Max ₹${_maxAmount.toInt()}',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Selection of Ornament Making Charge Percentage
        Text(
          'Select Ornament Making Charge',
          style: TextStyle(
            fontSize: 13.5,
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.w600,
            color: isDark ? Palette.whiteColor.withValues(alpha: 0.9) : Palette.blackColor.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [5.0, 8.0, 10.0, 12.0].map((rate) {
            final isSelected = _makingChargePercent == rate;
            final netRate = (rate - (rate <= 5.0 ? rate : 5.0)).toInt();
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: ChoiceChip(
                  showCheckmark: false,
                  label: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${rate.toInt()}% MC',
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? Palette.whiteColor.withValues(alpha: 0.8) : Palette.blackColor.withValues(alpha: 0.8)),
                        ),
                      ),
                      Text(
                        netRate == 0 ? '0% net' : '$netRate% net',
                        style: TextStyle(
                          fontSize: 9,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.8)
                              : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  selected: isSelected,
                  selectedColor: Palette.primaryColor,
                  backgroundColor: isDark ? Palette.whiteColor.withValues(alpha: 0.05) : Colors.grey.shade100,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _makingChargePercent = rate;
                      });
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: isSelected
                          ? Palette.primaryColor
                          : (isDark ? Colors.white24 : Colors.grey.shade300),
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),

        // Calculations Card with Dashed Border
        CustomPaint(
          painter: DashedBorderPainter(
            color: Palette.primaryColor.withValues(alpha: 0.6),
            borderRadius: 16,
            strokeWidth: 1.2,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark 
                  ? Palette.whiteColor.withValues(alpha: 0.02) 
                  : Palette.primaryColor.withValues(alpha: 0.02),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCardRow('Total Contribution (11 Months)', '₹ ${totalAccumulated.toStringAsFixed(0)}', isDark),
                const SizedBox(height: 8),
                _buildCardRow('Ornament Making Charge (${_makingChargePercent.toStringAsFixed(0)}%)', '₹ ${originalMakingChargeAmount.toStringAsFixed(0)}', isDark),
                const SizedBox(height: 8),
                _buildCardRow(
                  'Scheme MC Benefit (5% reduction)',
                  '-₹ ${makingChargeSavings.toStringAsFixed(0)}',
                  isDark,
                  valueColor: Colors.green.shade600,
                  isBold: true,
                ),
                const SizedBox(height: 8),
                _buildCardRow('Net Making Charge Payable (${netMakingChargePercent.toStringAsFixed(0)}%)', '₹ ${netMakingChargeAmount.toStringAsFixed(0)}', isDark),
                const SizedBox(height: 8),
                _buildCardRow('Applicable GST (3%)', '₹ ${gstAmount.toStringAsFixed(0)}', isDark),
                const SizedBox(height: 12),
                
                const Divider(height: 1, thickness: 0.5),
                const SizedBox(height: 12),
                
                _buildCardRow('Grand Total (Estimated Outflow)', '₹ ${grandTotalWithScheme.toStringAsFixed(0)}', isDark, isBold: true),
                const SizedBox(height: 8),
                _buildCardRow(
                  'Total Scheme Savings',
                  '₹ ${totalSavings.toStringAsFixed(0)}',
                  isDark,
                  valueColor: Colors.green.shade600,
                  isBold: true,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Accumulated Weight',
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Palette.whiteColor.withValues(alpha: 0.7) : Palette.blackColor.withValues(alpha: 0.7),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.circle, size: 10, color: Colors.amber.shade700),
                        const SizedBox(width: 4),
                        Text(
                          '${accumulatedWeight.toStringAsFixed(2)}g',
                          style: TextStyle(
                            fontFamily: 'Urbanist',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Palette.whiteColor : Palette.blackColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Donut Chart + Legend Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Donut Chart
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: CustomPaint(
                        painter: DonutChartPainter(
                          paidFraction: grandTotalWithScheme / grandTotalWithoutScheme,
                          paidColor: Palette.primaryColor,
                          benefitColor: Colors.green.shade600.withValues(alpha: 0.25),
                          strokeWidth: 8,
                        ),
                        child: Center(
                          child: Text(
                            'Time Period\n11 Months',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Urbanist',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Palette.whiteColor.withValues(alpha: 0.7) : Palette.blackColor.withValues(alpha: 0.6),
                              height: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // Legend
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLegendItem(
                            color: Palette.primaryColor,
                            title: 'Estimated Outflow',
                            subtitle: '₹${grandTotalWithScheme.toStringAsFixed(0)}',
                            isDark: isDark,
                          ),
                          const SizedBox(height: 8),
                          _buildLegendItem(
                            color: Colors.green.shade600,
                            title: 'Scheme Savings',
                            subtitle: '₹${totalSavings.toStringAsFixed(0)}',
                            isDark: isDark,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Separated Red Note (GST & Scheme Benefits Details)
                Text(
                  'Note: Pay the fixed amount every month for 11 months. On successful completion, receive a 5 percentage-point reduction in making charges. If you miss even one monthly payment, you will not be eligible for the scheme benefit. GST (3%) will be applicable on the final purchase value as per prevailing government regulations.',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 10,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                    color: Palette.redColor, // Styled in Red
                  ),
                ),
                const SizedBox(height: 8),
                
                // Separated Standard Disclaimer Note (Grey)
                Text(
                  'Note: The benefits calculator serves for illustrative purposes only. The accumulated gold weight is calculated using today\'s gold price; actual weight is accumulated based on the prevailing gold rate on the date of each monthly payment.',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 9.5,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Palette.whiteColor.withValues(alpha: 0.45) : Palette.blackColor.withValues(alpha: 0.45),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardRow(
    String label,
    String value,
    bool isDark, {
    Color? valueColor,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isDark 
                  ? Palette.whiteColor.withValues(alpha: isBold ? 0.95 : 0.7) 
                  : Palette.blackColor.withValues(alpha: isBold ? 0.95 : 0.7),
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Urbanist',
            fontSize: isBold ? 15 : 13.5,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? (isDark ? Palette.whiteColor : Palette.blackColor),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Palette.whiteColor.withValues(alpha: 0.5) : Palette.blackColor.withValues(alpha: 0.5),
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Palette.whiteColor.withValues(alpha: 0.9) : Palette.blackColor.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Painter for Dashed Rectangle border
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dashLength;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.gap = 4.0,
    this.dashLength = 6.0,
    this.borderRadius = 12.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(borderRadius),
      ));

    final dashPath = Path();
    double distance = 0.0;
    for (final pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashLength),
          Offset.zero,
        );
        distance += dashLength + gap;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) =>
      color != oldDelegate.color ||
      strokeWidth != oldDelegate.strokeWidth ||
      gap != oldDelegate.gap ||
      dashLength != oldDelegate.dashLength ||
      borderRadius != oldDelegate.borderRadius;
}

// Painter for Donut Chart
class DonutChartPainter extends CustomPainter {
  final double paidFraction;
  final Color paidColor;
  final Color benefitColor;
  final double strokeWidth;

  DonutChartPainter({
    required this.paidFraction,
    required this.paidColor,
    required this.benefitColor,
    this.strokeWidth = 8.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    final bgPaint = Paint()
      ..color = benefitColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = paidColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw full background / benefit circle
    canvas.drawArc(rect, 0, 2 * 3.14159265, false, bgPaint);

    // Draw paid portion starting from top (-pi/2)
    final sweepAngle = 2 * 3.14159265 * paidFraction;
    canvas.drawArc(rect, -3.14159265 / 2, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant DonutChartPainter oldDelegate) =>
      paidFraction != oldDelegate.paidFraction ||
      paidColor != oldDelegate.paidColor ||
      benefitColor != oldDelegate.benefitColor ||
      strokeWidth != oldDelegate.strokeWidth;
}
