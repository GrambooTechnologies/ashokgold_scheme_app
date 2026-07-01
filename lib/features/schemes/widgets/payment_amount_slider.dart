import 'dart:async';

import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/features/schemes/models/scheme_payment_rule_model.dart';
import 'package:flutter/material.dart';

class PaymentAmountSlider extends StatefulWidget {
  final SchemePaymentRuleModel paymentRule;
  final double? initialAmount;
  final ValueChanged<double> onAmountChanged;

  const PaymentAmountSlider({
    super.key,
    required this.paymentRule,
    this.initialAmount,
    required this.onAmountChanged,
  });

  @override
  State<PaymentAmountSlider> createState() => _PaymentAmountSliderState();
}

class _PaymentAmountSliderState extends State<PaymentAmountSlider> {
  late double _currentAmount;
  late double _minAmount;
  late double _maxAmount;
  late double _interval;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _minAmount = widget.paymentRule.minAmount;
    _maxAmount = widget.paymentRule.maxAmount;
    _interval = widget.paymentRule.amountInterval;
    _currentAmount = widget.initialAmount ?? _minAmount;

    // Ensure current amount is within bounds
    if (_currentAmount < _minAmount) _currentAmount = _minAmount;
    if (_currentAmount > _maxAmount) _currentAmount = _maxAmount;
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Amount Display Card

        // Slider
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Palette.primaryColor,
            inactiveTrackColor: Palette.cardBackgroundColor.withOpacity(0.2),
            thumbColor: Palette.primaryColor,
            overlayColor: Palette.cardBackgroundColor.withOpacity(0.2),
            trackHeight: 6.0,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: w * 0.03),
            overlayShape: RoundSliderOverlayShape(overlayRadius: w * 0.01),
          ),
          child: Slider(
            value: _currentAmount,
            min: _minAmount,
            max: _maxAmount,
            divisions: ((_maxAmount - _minAmount) / _interval).round(),
            onChanged: (value) {
              setState(() {
                _currentAmount = value;
              });

              // Cancel previous timer
              _debounceTimer?.cancel();

              // Start new timer - only call API after 500ms of no changes
              _debounceTimer = Timer(const Duration(milliseconds: 500), () {
                widget.onAmountChanged(value);
              });
            },
          ),
        ),
        // Min and Max Labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '₹${_minAmount.toStringAsFixed(0)}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: w * 0.028,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '₹${_maxAmount.toStringAsFixed(0)}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: w * 0.028,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: h * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Monthly EMA Amount',
              style: TextStyle(
                color: Palette.primaryColor,
                fontSize: w * 0.04,
                fontWeight: FontWeight.w700,
              ),
            ),
            Container(
              height: h * 0.04,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(w * 0.02),
                color: Palette.backgroundColor,
                border: Border.all(
                  color: Palette.primaryColor.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * .02),
                child: Center(
                  child: Text(
                    '₹${_currentAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: w * 0.045,
                      color: Palette.primaryColor,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: h * 0.01),

        // Payment Rules Section
        Text(
          'Select your monthly EMA amount within the allowed range from ₹${_minAmount.toStringAsFixed(0)} to ₹${_maxAmount.toStringAsFixed(0)} to see the benefits you can receive under this scheme.',
          style: TextStyle(
            height: 1.1,
            fontSize: w * 0.027,
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
