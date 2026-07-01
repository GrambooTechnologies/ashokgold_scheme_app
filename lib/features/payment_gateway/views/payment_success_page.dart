import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/features/customer_schemes/providers/customer_active_schemes_provider.dart';
import 'package:ashokgold_scheme_app/features/home/views/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PaymentSuccessPage extends ConsumerStatefulWidget {
  static const String routeName = '/payment-success';
  final String orderId;
  final String? joinId;
  final bool isSchemeJoining;
  final String? schemeName;
  final String? amount;

  const PaymentSuccessPage({
    super.key,
    required this.orderId,
    this.joinId,
    this.isSchemeJoining = false,
    this.schemeName,
    this.amount,
  });

  @override
  ConsumerState<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends ConsumerState<PaymentSuccessPage> {
  @override
  void initState() {
    super.initState();
    // Verify payment status on page load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ref
      //     .read(paymentProvider.notifier)
      //     .verifyPaymentStatus(orderId: widget.orderId);

      // If this is scheme joining payment, invalidate customer schemes to refresh the list
      if (widget.isSchemeJoining) {
        ref.invalidate(customerJoinedActiveSchemesProvider);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 80,
                ),
              ),
              const SizedBox(height: 32),

              // Success Title
              const Text(
                'Payment Successful!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 16),

              // Success Message
              Text(
                widget.isSchemeJoining
                    ? 'You have successfully joined ${widget.schemeName ?? "the scheme"}!'
                    : 'Your payment has been processed successfully',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Navigate to Home Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    context.go(BottomNav.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Go to Home',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
