import 'package:ashokgold_scheme_app/core/custom_widgets/custom_floating_button.dart';
import 'package:ashokgold_scheme_app/core/custom_widgets/custom_snackBar.dart';
import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/features/scheme_payment_entry/providers/next_installment_details_provider.dart';
import 'package:ashokgold_scheme_app/features/scheme_payment_entry/services/installment_payment_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utilities/scale_size_utils.dart';

class InstallmentPaymentPage extends ConsumerStatefulWidget {
  static const String routeName = '/installment-payment';
  final String joinId;
  final String schemeName;
  final String installmentAmount;

  const InstallmentPaymentPage({
    super.key,
    required this.joinId,
    required this.schemeName,
    required this.installmentAmount,
  });

  @override
  ConsumerState<InstallmentPaymentPage> createState() =>
      _InstallmentPaymentPageState();
}

class _InstallmentPaymentPageState
    extends ConsumerState<InstallmentPaymentPage> {
  late TextEditingController _amountController;
  late FocusNode _focusNode;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final installmentDetailsAsync = ref.watch(
      nextInstallmentDetailsProvider(widget.joinId),
    );

    return installmentDetailsAsync.when(
      data: (installmentDetails) {
        return _buildContent(
          context,
          installmentDetails.nextInstallmentAmount,
          installmentDetails.minAmount,
          installmentDetails.maxAmount,
          installmentDetails.isEditable,
          installmentDetails.description,
        );
      },
      loading: () => Scaffold(
        backgroundColor: Palette.backgroundColor,
        appBar: AppBar(
          title: Text(
            'Pay Installment',
            style: TextStyle(
              fontSize: SizeConfig.w(context, 17),
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          forceMaterialTransparency: true,
          backgroundColor: Palette.backgroundColor,
          elevation: 0,
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        backgroundColor: Palette.backgroundColor,
        appBar: AppBar(
          title: Text(
            'Pay Installment',
            style: TextStyle(
              fontSize: SizeConfig.w(context, 17),
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          forceMaterialTransparency: true,
          backgroundColor: Palette.backgroundColor,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Failed to load installment details',
                style: TextStyle(
                  fontSize: SizeConfig.w(context, 16),
                  color: Colors.red,
                ),
              ),
              SizedBox(height: SizeConfig.h(context, 16)),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(
                        nextInstallmentDetailsProvider(widget.joinId).notifier,
                      )
                      .refresh();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    double nextInstallmentAmount,
    double minAmount,
    double maxAmount,
    bool isEditable,
    String description,
  ) {
    // Initialize controller with fetched amount if not already set
    // if (_amountController.text.isEmpty) {
    //   _amountController.text = nextInstallmentAmount.toStringAsFixed(2);
    // }

    final amount = _amountController.text.isEmpty
        ? "0"
        : _amountController.text;

    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Pay Installment',
          style: TextStyle(
            fontSize: SizeConfig.w(context, 17),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        forceMaterialTransparency: true,
        backgroundColor: Palette.backgroundColor,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(_focusNode),
        child: Column(
          children: [
            SizedBox(height: SizeConfig.h(context, 40)),

            /// Scheme Name
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.w(context, 24),
              ),
              child: Text(
                widget.schemeName,
                style: TextStyle(
                  fontSize: SizeConfig.w(context, 18),
                  fontWeight: FontWeight.w600,
                  color: Palette.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: SizeConfig.h(context, 40)),

            /// Big Amount Input
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.w(context, 32),
              ),
              child: TextField(
                controller: _amountController,
                focusNode: _focusNode,
                enabled: isEditable,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textAlign: TextAlign.center,
                autofocus: isEditable,
                style: TextStyle(
                  fontSize: SizeConfig.w(context, 48),
                  fontWeight: FontWeight.w600,
                  color: isEditable
                      ? Palette.primaryColor
                      : Palette.primaryColor.withOpacity(0.6),
                  letterSpacing: SizeConfig.w(context, 1),
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixText: "₹",
                  prefixStyle: TextStyle(
                    fontSize: SizeConfig.w(context, 48),
                    fontWeight: FontWeight.w600,
                    color: isEditable
                        ? Palette.primaryColor
                        : Palette.primaryColor.withOpacity(0.6),
                  ),
                ),
                onChanged: isEditable ? (_) => setState(() {}) : null,
              ),
            ),

            SizedBox(height: SizeConfig.h(context, 8)),

            // Description text
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.w(context, 32),
              ),
              child: Text(
                description,
                style: TextStyle(
                  fontSize: SizeConfig.w(context, 14),
                  color: Palette.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            if (isEditable)
              Padding(
                padding: EdgeInsets.only(top: SizeConfig.h(context, 8)),
                child: Text(
                  'Min: ₹${minAmount.toStringAsFixed(2)}  •  Max: ₹${maxAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: SizeConfig.w(context, 12),
                    color: Palette.primaryColor.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            if (!isEditable)
              Padding(
                padding: EdgeInsets.only(top: SizeConfig.h(context, 8)),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.w(context, 16),
                    vertical: SizeConfig.h(context, 8),
                  ),
                  decoration: BoxDecoration(
                    color: Palette.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: SizeConfig.w(context, 16),
                        color: Palette.primaryColor,
                      ),
                      SizedBox(width: SizeConfig.w(context, 8)),
                      Text(
                        'Amount is fixed for this installment',
                        style: TextStyle(
                          fontSize: SizeConfig.w(context, 12),
                          color: Palette.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const Spacer(),

            /// Pay Button
            Padding(
              padding: EdgeInsets.fromLTRB(
                SizeConfig.w(context, 16),
                SizeConfig.h(context, 16),
                SizeConfig.w(context, 16),
                SizeConfig.h(context, 42),
              ),
              child: CustomFloatingButton(
                text: "Pay ₹$amount",
                onPressed: _isProcessing ? null : _handlePayment,
                isLoading: _isProcessing,
                width: double.infinity,
                height: SizeConfig.h(context, 52),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePayment() async {
    final value = _amountController.text;

    if (value.isEmpty ||
        double.tryParse(value) == null ||
        double.parse(value) <= 0) {
      context.showErrorSnackBar("Enter valid amount");
      return;
    }

    final installmentDetails = ref
        .read(nextInstallmentDetailsProvider(widget.joinId))
        .valueOrNull;
    if (installmentDetails != null && installmentDetails.isEditable) {
      final parsed = double.parse(value);
      if (parsed < installmentDetails.minAmount) {
        context.showErrorSnackBar(
          'Minimum amount is ₹${installmentDetails.minAmount.toStringAsFixed(2)}',
        );
        return;
      }
      if (parsed > installmentDetails.maxAmount) {
        context.showErrorSnackBar(
          'Maximum amount is ₹${installmentDetails.maxAmount.toStringAsFixed(2)}',
        );
        return;
      }
    }

    setState(() => _isProcessing = true);

    try {
      await ref
          .read(installmentPaymentServiceProvider)
          .initiatePayment(
            joinId: widget.joinId,
            amount: double.parse(value),
            schemeName: widget.schemeName,
            context: context,
          );
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar('Payment initiation failed: $e');
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }
}
