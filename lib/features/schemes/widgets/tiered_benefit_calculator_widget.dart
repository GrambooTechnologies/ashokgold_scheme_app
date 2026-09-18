import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/features/common/providers/metal_rate_provider.dart';

class TieredBenefitCalculatorWidget extends ConsumerStatefulWidget {
  final String schemeId;
  final String schemeName;

  const TieredBenefitCalculatorWidget({
    super.key,
    required this.schemeId,
    required this.schemeName,
  });

  @override
  ConsumerState<TieredBenefitCalculatorWidget> createState() =>
      _TieredBenefitCalculatorWidgetState();
}

class _TieredBenefitCalculatorWidgetState
    extends ConsumerState<TieredBenefitCalculatorWidget> {
  int _selectedDay = 1; // default day (1 to 330)
  double _inputWeight = 0.0;
  double _inputAmount = 0.0;

  late TextEditingController _weightController;
  late TextEditingController _amountController;
  final FocusNode _weightFocusNode = FocusNode();
  final FocusNode _amountFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _weightController = TextEditingController(text: '0');
    _amountController = TextEditingController(text: '0');

    _weightFocusNode.addListener(_onWeightFocusChange);
    _amountFocusNode.addListener(_onAmountFocusChange);
  }

  @override
  void dispose() {
    _weightController.dispose();
    _amountController.dispose();
    _weightFocusNode.removeListener(_onWeightFocusChange);
    _amountFocusNode.removeListener(_onAmountFocusChange);
    _weightFocusNode.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  void _onWeightFocusChange() {
    if (!_weightFocusNode.hasFocus) {
      setState(() {
        final val = double.tryParse(_weightController.text) ?? 0.0;
        _inputWeight = val;
        _weightController.text = val == 0.0 ? '0' : val.toStringAsFixed(3);
      });
    }
  }

  void _onAmountFocusChange() {
    if (!_amountFocusNode.hasFocus) {
      setState(() {
        final val = double.tryParse(_amountController.text) ?? 0.0;
        _inputAmount = val;
        _amountController.text = val == 0.0 ? '0' : val.toStringAsFixed(0);
      });
    }
  }

  double _getBenefitPercent(int day) {
    if (day <= 75) return 5.0;
    if (day <= 150) return 3.75;
    if (day <= 225) return 2.0;
    if (day <= 300) return 0.75;
    return 0.0;
  }

  void _updateFromWeight(String text, double goldRate) {
    if (goldRate <= 0) return;
    setState(() {
      final weight = double.tryParse(text) ?? 0.0;
      _inputWeight = weight;
      _inputAmount = weight * goldRate;

      // Update amount text field in real-time
      final amountStr = _inputAmount == 0.0 ? '0' : _inputAmount.toStringAsFixed(0);
      if (_amountController.text != amountStr) {
        _amountController.text = amountStr;
      }
    });
  }

  void _updateFromAmount(String text, double goldRate) {
    if (goldRate <= 0) return;
    setState(() {
      final amount = double.tryParse(text) ?? 0.0;
      _inputAmount = amount;
      _inputWeight = amount / goldRate;

      // Update weight text field in real-time
      final weightStr = _inputWeight == 0.0 ? '0' : _inputWeight.toStringAsFixed(3);
      if (_weightController.text != weightStr) {
        _weightController.text = weightStr;
      }
    });
  }

  void _incrementWeight(double goldRate) {
    setState(() {
      _inputWeight = _inputWeight + 1.0;
      _inputAmount = _inputWeight * goldRate;
      _weightController.text = _inputWeight.toStringAsFixed(3);
      _amountController.text = _inputAmount.toStringAsFixed(0);
    });
  }

  void _decrementWeight(double goldRate) {
    if (_inputWeight <= 0) return;
    setState(() {
      _inputWeight = (_inputWeight - 1.0).clamp(0.0, double.infinity);
      _inputAmount = _inputWeight * goldRate;
      _weightController.text = _inputWeight == 0.0 ? '0' : _inputWeight.toStringAsFixed(3);
      _amountController.text = _inputAmount == 0.0 ? '0' : _inputAmount.toStringAsFixed(0);
    });
  }

  void _incrementAmount(double goldRate) {
    if (goldRate <= 0) return;
    setState(() {
      _inputAmount = _inputAmount + 1000.0;
      _inputWeight = _inputAmount / goldRate;
      _amountController.text = _inputAmount.toStringAsFixed(0);
      _weightController.text = _inputWeight.toStringAsFixed(3);
    });
  }

  void _decrementAmount(double goldRate) {
    if (_inputAmount <= 0) return;
    if (goldRate <= 0) return;
    setState(() {
      _inputAmount = (_inputAmount - 1000.0).clamp(0.0, double.infinity);
      _inputWeight = _inputAmount / goldRate;
      _amountController.text = _inputAmount == 0.0 ? '0' : _inputAmount.toStringAsFixed(0);
      _weightController.text = _inputWeight == 0.0 ? '0' : _inputWeight.toStringAsFixed(3);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final metalRateAsync = ref.watch(latestMetalRateProvider);
    final double goldRate = metalRateAsync.maybeWhen(
      data: (rate) => rate.rates.metalRate,
      orElse: () => 12380.0, // fallback gold price from user screenshot
    );

    final double benefitPercent = _getBenefitPercent(_selectedDay);

    // Dynamic calculations
    final double benefitWeight = _inputWeight * (benefitPercent / 100);
    final double totalWeight = _inputWeight + benefitWeight;

    final double benefitAmount = _inputAmount * (benefitPercent / 100);
    final double totalAmount = _inputAmount + benefitAmount;

    // Segment widths
    const double maxDays = 330.0;
    const int orangeAccentColorVal = 0xFFEE7C11;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 22KT Gold price badge
        Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFFFFB300).withValues(alpha: 0.08),
              border: Border.all(
                color: const Color(0xFFFFB300).withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Text(
              '22 KT Gold Current Price: ₹${goldRate.toStringAsFixed(0)}/gm',
              style: const TextStyle(
                fontSize: 13,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w700,
                color: Color(0xFFFF8F00),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Header text for benefit
        Center(
          child: Text(
            'This transaction will earn you the following benefit',
            style: TextStyle(
              fontSize: 13.5,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Palette.blackColor.withValues(alpha: 0.8),
            ),
          ),
        ),
        const SizedBox(height: 6),

        // Large bold benefit percent indicator
        Center(
          child: Text(
            benefitPercent % 1 == 0
                ? '${benefitPercent.toInt()}%*'
                : '${benefitPercent.toStringAsFixed(2)}%*',
            style: TextStyle(
              fontSize: 22,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : Palette.blackColor,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Segmented Progress Bar Stack
        LayoutBuilder(
          builder: (context, constraints) {
            final double barWidth = constraints.maxWidth;
            // day positions map (1 to 330)
            final double pointerFraction = (_selectedDay - 1) / (maxDays - 1);
            final double pointerX = pointerFraction * barWidth;

            // Segments sizes in flex or layout
            return Column(
              children: [
                // Pointer arrow (Stack)
                SizedBox(
                  height: 12,
                  width: barWidth,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: (pointerX - 6).clamp(0.0, barWidth - 12),
                        top: 2,
                        child: const Icon(
                          Icons.arrow_drop_down,
                          size: 14,
                          color: Color(0xFFFFB300),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),

                // Segmented bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Row(
                    children: [
                      // 5% (Day 1 - 75)
                      Expanded(
                        flex: 75,
                        child: Container(
                          height: 22,
                          color: const Color(0xFF1B5E20),
                          alignment: Alignment.center,
                          child: const Text(
                            '5%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      // 3.75% (Day 76 - 150)
                      Expanded(
                        flex: 75,
                        child: Container(
                          height: 22,
                          color: const Color(0xFF2E7D32),
                          alignment: Alignment.center,
                          child: const Text(
                            '3.75%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      // 2% (Day 151 - 225)
                      Expanded(
                        flex: 75,
                        child: Container(
                          height: 22,
                          color: const Color(0xFF4CAF50),
                          alignment: Alignment.center,
                          child: const Text(
                            '2%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      // 0.75% (Day 226 - 300)
                      Expanded(
                        flex: 75,
                        child: Container(
                          height: 22,
                          color: const Color(0xFF81C784),
                          alignment: Alignment.center,
                          child: const Text(
                            '0.75%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      // 0% (Day 301 - 330)
                      Expanded(
                        flex: 30,
                        child: Container(
                          height: 22,
                          color: const Color(0xFFC8E6C9),
                          alignment: Alignment.center,
                          child: const Text(
                            '0%',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),

                // Labels line
                SizedBox(
                  height: 18,
                  width: barWidth,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        child: Text(
                          '1',
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Positioned(
                        left: barWidth * (75 / 330) - 6,
                        child: Text(
                          '76',
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Positioned(
                        left: barWidth * (150 / 330) - 8,
                        child: Text(
                          '151',
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Positioned(
                        left: barWidth * (225 / 330) - 8,
                        child: Text(
                          '226',
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Positioned(
                        left: barWidth * (300 / 330) - 8,
                        child: Text(
                          '301',
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: Text(
                          '330',
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 16),

        // Slider to change days
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Select Day of Payment:',
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Palette.blackColor.withValues(alpha: 0.8),
              ),
            ),
            Text(
              'Day $_selectedDay',
              style: TextStyle(
                fontSize: 13.5,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.bold,
                color: Color(orangeAccentColorVal),
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Color(orangeAccentColorVal),
            inactiveTrackColor: Colors.grey.shade300,
            thumbColor: Color(orangeAccentColorVal),
            overlayColor: Color(orangeAccentColorVal).withValues(alpha: 0.2),
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
          ),
          child: Slider(
            min: 1.0,
            max: maxDays,
            divisions: 329,
            value: _selectedDay.toDouble(),
            onChanged: (value) {
              setState(() {
                _selectedDay = value.toInt();
              });
            },
          ),
        ),

        const SizedBox(height: 16),

        // Enter weight or amount text
        Center(
          child: Text(
            'Enter the Weight or Amount you wish to save',
            style: TextStyle(
              fontSize: 12.5,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white60 : Colors.black54,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // WEIGHT INPUT ROW
        Row(
          children: [
            // Left: input field with +/-
            Expanded(
              flex: 10,
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, width: 1.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Weight',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                'g',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: TextField(
                                  controller: _weightController,
                                  focusNode: _weightFocusNode,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (text) => _updateFromWeight(text, goldRate),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () => _incrementWeight(goldRate),
                          child: Container(
                            width: 32,
                            height: 22,
                            decoration: BoxDecoration(
                              color: Color(orangeAccentColorVal),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(Icons.add, color: Colors.white, size: 14),
                          ),
                        ),
                        InkWell(
                          onTap: () => _decrementWeight(goldRate),
                          child: Container(
                            width: 32,
                            height: 22,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(Icons.remove, color: Palette.blackColor.withValues(alpha: 0.8), size: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Right: You Get card
            Expanded(
              flex: 11,
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFFFB300).withValues(alpha: 0.3),
                    width: 1.2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFFFB300).withValues(alpha: 0.02),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'You Get',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '${totalWeight.toStringAsFixed(3)}g',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : Palette.blackColor.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Benefit',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          '${benefitWeight.toStringAsFixed(3)}g',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // Swap vertical arrow icon
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Icon(
              Icons.swap_vert_rounded,
              color: Colors.grey.shade400,
              size: 24,
            ),
          ),
        ),

        // AMOUNT INPUT ROW
        Row(
          children: [
            // Left: input field with +/-
            Expanded(
              flex: 10,
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, width: 1.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Amount',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '₹',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: TextField(
                                  controller: _amountController,
                                  focusNode: _amountFocusNode,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (text) => _updateFromAmount(text, goldRate),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () => _incrementAmount(goldRate),
                          child: Container(
                            width: 32,
                            height: 22,
                            decoration: BoxDecoration(
                              color: Color(orangeAccentColorVal),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(Icons.add, color: Colors.white, size: 14),
                          ),
                        ),
                        InkWell(
                          onTap: () => _decrementAmount(goldRate),
                          child: Container(
                            width: 32,
                            height: 22,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(Icons.remove, color: Palette.blackColor.withValues(alpha: 0.8), size: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Right: You Get card
            Expanded(
              flex: 11,
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFFFB300).withValues(alpha: 0.3),
                    width: 1.2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFFFB300).withValues(alpha: 0.02),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'You Get',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '₹${totalAmount.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : Palette.blackColor.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Benefit',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          '₹${benefitAmount.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
