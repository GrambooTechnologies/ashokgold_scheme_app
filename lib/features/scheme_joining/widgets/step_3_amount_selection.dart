import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/core/utilities/scale_size_utils.dart';
import 'package:ashokgold_scheme_app/features/schemes/providers/scheme_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Step3AmountSelection extends ConsumerStatefulWidget {
  final TextEditingController installmentController;
  final GlobalKey<FormState> formKey;
  final String schemeId;

  const Step3AmountSelection({
    super.key,
    required this.installmentController,
    required this.formKey,
    required this.schemeId,
  });

  @override
  ConsumerState<Step3AmountSelection> createState() =>
      _Step3AmountSelectionState();
}

class _Step3AmountSelectionState extends ConsumerState<Step3AmountSelection> {
  String _displayAmount = '';

  @override
  void initState() {
    super.initState();
    _displayAmount = widget.installmentController.text;
    widget.installmentController.addListener(_onAmountChanged);
  }

  void _onAmountChanged() {
    setState(() => _displayAmount = widget.installmentController.text);
  }

  @override
  void dispose() {
    widget.installmentController.removeListener(_onAmountChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final schemeAsync = ref.watch(schemeDetailProvider(widget.schemeId));

    return schemeAsync.when(
      data: (scheme) {
        final paymentRules = scheme.paymentRules;
        final minAmount = paymentRules?.minAmount.toInt() ?? 0;
        final maxAmount = paymentRules?.maxAmount.toInt() ?? 0;
        final amountInterval = paymentRules?.amountInterval.toInt() ?? 0;

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            SizeConfig.w(context, 16),
            SizeConfig.h(context, 20),
            SizeConfig.w(context, 16),
            SizeConfig.h(context, 20),
          ),
          child: Form(
            key: widget.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Step Header ──
                _StepHeader(
                  stepNumber: '03',
                  title: 'Installment Amount',
                  subtitle: 'Set the amount you wish to pay each month',
                ),
                SizedBox(height: h * 0.025),

                // ── Payment Rules Card ──
                if (paymentRules != null)
                  _PaymentRulesCard(
                    minAmount: minAmount,
                    maxAmount: maxAmount,
                    amountInterval: amountInterval,
                  ),
                SizedBox(height: h * 0.02),

                // ── Quick Amount Chips ──
                if (paymentRules != null && minAmount > 0)
                  _QuickAmountChips(
                    minAmount: minAmount,
                    maxAmount: maxAmount,
                    interval: amountInterval,
                    onSelected: (val) {
                      widget.installmentController.text = val.toString();
                    },
                  ),
                SizedBox(height: h * 0.018),

                // ── Amount Input ──
                Text(
                  'Enter Amount',
                  style: TextStyle(
                    fontSize: w * 0.036,
                    fontWeight: FontWeight.w600,
                    color: Palette.blackColor.withOpacity(0.75),
                  ),
                ),
                SizedBox(height: h * 0.008),
                TextFormField(
                  controller: widget.installmentController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: TextStyle(
                    fontSize: w * 0.042,
                    fontWeight: FontWeight.w600,
                    color: Palette.blackColor,
                  ),
                  decoration: InputDecoration(
                    hintText: 'e.g. 1000',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w400,
                      fontSize: w * 0.038,
                    ),
                    prefixIcon: Container(
                      margin: const EdgeInsets.all(10),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Palette.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          '₹',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Palette.primaryColor,
                        width: 1.5,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.red, width: 1),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an installment amount';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
                SizedBox(height: h * 0.02),

                // ── Validation Note ──
                _ValidationNote(),
              ],
            ),
          ),
        );
      },
      loading: () => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            CircularProgressIndicator(color: Palette.primaryColor),
            SizedBox(height: 16),
            Text(
              'Loading payment rules…',
              style: TextStyle(
                color: Palette.blackColor.withOpacity(0.5),
                fontSize: MediaQuery.of(context).size.width * 0.035,
              ),
            ),
          ],
        ),
      ),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Colors.red[300],
              ),
              const SizedBox(height: 12),
              Text(
                'Failed to load payment rules',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () =>
                    ref.invalidate(schemeDetailProvider(widget.schemeId)),
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Local sub-widgets
// ─────────────────────────────────────────────

class _StepHeader extends StatelessWidget {
  final String stepNumber;
  final String title;
  final String subtitle;

  const _StepHeader({
    required this.stepNumber,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: SizeConfig.w(context, 42),
          height: SizeConfig.w(context, 42),
          decoration: BoxDecoration(
            color: Palette.primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            stepNumber,
            style: TextStyle(
              color: Colors.white,
              fontSize: SizeConfig.w(context, 13),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(width: SizeConfig.w(context, 12)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: w * 0.052,
                  fontWeight: FontWeight.w800,
                  color: Palette.primaryColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: w * 0.034,
                  color: Palette.blackColor.withOpacity(0.5),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PaymentRulesCard extends StatelessWidget {
  final int minAmount;
  final int maxAmount;
  final int amountInterval;

  const _PaymentRulesCard({
    required this.minAmount,
    required this.maxAmount,
    required this.amountInterval,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: Palette.primaryColor.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Palette.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Palette.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.info_outline_rounded,
                  color: Palette.primaryColor,
                  size: 15,
                ),
              ),
              SizedBox(width: w * 0.025),
              Text(
                'Payment Rules',
                style: TextStyle(
                  fontSize: w * 0.04,
                  fontWeight: FontWeight.w700,
                  color: Palette.primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.015),
          _RuleRow(
            icon: Icons.arrow_downward_rounded,
            label: 'Minimum Amount',
            value: '₹$minAmount',
            context: context,
          ),
          const SizedBox(height: 6),
          _RuleRow(
            icon: Icons.arrow_upward_rounded,
            label: 'Maximum Amount',
            value: '₹$maxAmount',
            context: context,
          ),
          if (amountInterval > 0) ...[
            const SizedBox(height: 6),
            _RuleRow(
              icon: Icons.linear_scale_rounded,
              label: 'Amount Interval',
              value: '₹$amountInterval',
              context: context,
            ),
          ],
        ],
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final BuildContext context;

  const _RuleRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.context,
  });

  @override
  Widget build(BuildContext _) {
    final w = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Icon(icon, size: 14, color: Palette.primaryColor.withOpacity(0.6)),
        SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: w * 0.035,
              color: Palette.blackColor.withOpacity(0.6),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: Palette.primaryColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: w * 0.035,
              fontWeight: FontWeight.w700,
              color: Palette.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickAmountChips extends StatelessWidget {
  final int minAmount;
  final int maxAmount;
  final int interval;
  final ValueChanged<int> onSelected;

  const _QuickAmountChips({
    required this.minAmount,
    required this.maxAmount,
    required this.interval,
    required this.onSelected,
  });

  List<int> get _amounts {
    if (interval <= 0) return [minAmount, maxAmount ~/ 2, maxAmount];
    final List<int> amounts = [];
    int val = minAmount;
    while (val <= maxAmount && amounts.length < 4) {
      amounts.add(val);
      val += interval;
    }
    return amounts;
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final amounts = _amounts;
    if (amounts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Select',
          style: TextStyle(
            fontSize: w * 0.033,
            fontWeight: FontWeight.w600,
            color: Palette.blackColor.withOpacity(0.5),
          ),
        ),
        SizedBox(height: SizeConfig.h(context, 8)),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: amounts.map((amount) {
            return GestureDetector(
              onTap: () => onSelected(amount),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Palette.primaryColor.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Palette.primaryColor.withOpacity(0.25),
                    width: 1,
                  ),
                ),
                child: Text(
                  '₹$amount',
                  style: TextStyle(
                    fontSize: w * 0.036,
                    fontWeight: FontWeight.w600,
                    color: Palette.primaryColor,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: SizeConfig.h(context, 4)),
      ],
    );
  }
}

class _ValidationNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.w(context, 12),
        vertical: SizeConfig.h(context, 10),
      ),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Icon(Icons.verified_outlined, color: Colors.blue[600], size: 16),
          SizedBox(width: SizeConfig.w(context, 8)),
          Expanded(
            child: Text(
              'Your amount will be validated against payment rules before processing',
              style: TextStyle(
                fontSize: w * 0.032,
                color: Colors.blue[700],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
