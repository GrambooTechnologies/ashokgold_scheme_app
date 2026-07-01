import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/features/payment_gateway/models/payment_result_extras.dart';
import 'package:ashokgold_scheme_app/features/payment_gateway/views/payment_failure_page.dart';
import 'package:ashokgold_scheme_app/features/payment_gateway/views/payment_success_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentWebViewPage extends ConsumerStatefulWidget {
  static const String routeName = '/payment-webview';
  final String paymentUrl;
  final String orderId;
  final String? joinId;
  final bool isSchemeJoining;
  final String? schemeName;
  final String? amount;

  const PaymentWebViewPage({
    super.key,
    required this.paymentUrl,
    required this.orderId,
    this.joinId,
    this.isSchemeJoining = false,
    this.schemeName,
    this.amount,
  });

  @override
  ConsumerState<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends ConsumerState<PaymentWebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _paymentHandled = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: _onPageStarted,
          onPageFinished: _onPageFinished,
          onNavigationRequest: _handleNavigationRequest,
          onUrlChange: _handleUrlChange,
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _onPageStarted(String url) {
    setState(() => _isLoading = true);
  }

  void _onPageFinished(String url) {
    setState(() => _isLoading = false);
  }

  NavigationDecision _handleNavigationRequest(NavigationRequest request) {
    final uri = Uri.parse(request.url);

    // Handle external app schemes (UPI, GPay, PhonePe, Paytm, etc.)
    if (_isExternalScheme(uri)) {
      _launchExternalUrl(request.url);
      return NavigationDecision.prevent;
    }

    // Check if this is a payment result redirect
    if (_isPaymentResultUrl(uri)) {
      _handlePaymentCompletion(_isSuccessUrl(uri));
      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }

  void _handleUrlChange(UrlChange change) {
    if (change.url == null) return;

    final uri = Uri.parse(change.url!);

    // Check for payment result in URL changes (for form posts)
    if (_isPaymentResultUrl(uri)) {
      _handlePaymentCompletion(_isSuccessUrl(uri));
    }
  }

  bool _isExternalScheme(Uri uri) {
    return uri.scheme != 'http' && uri.scheme != 'https';
  }

  bool _isPaymentResultUrl(Uri uri) {
    return _isSuccessUrl(uri) || _isFailureUrl(uri);
  }

  bool _isSuccessUrl(Uri uri) {
    return uri.path.contains('/api/payment-gateway/success') ||
        uri.path.contains('/payment-success') ||
        uri.queryParameters.containsKey('success');
  }

  bool _isFailureUrl(Uri uri) {
    return uri.path.contains('/api/payment-gateway/failure') ||
        uri.path.contains('/payment-failed') ||
        uri.path.contains('/payment-failure') ||
        uri.queryParameters.containsKey('failed');
  }

  Future<void> _launchExternalUrl(String url) async {
    try {
      final uri = Uri.parse(url);

      // Try to launch directly - canLaunchUrl often returns false for custom schemes
      // even when the app is installed due to Android security restrictions
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        _showLaunchError(
          'Could not open payment app. Please make sure it is installed.',
        );
      }
    } catch (e) {
      final scheme = Uri.parse(url).scheme;
      _showLaunchError(
        'Payment app not found. Please install the required app ($scheme) and try again.',
      );
    }
  }

  void _showLaunchError(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  void _handlePaymentCompletion(bool isSuccess) {
    // Prevent duplicate handling
    if (_paymentHandled) return;
    _paymentHandled = true;

    // Verify payment status with backend
    // ref
    //     .read(paymentProvider.notifier)
    //     .verifyPaymentStatus(orderId: widget.orderId);

    if (isSuccess) {
      _navigateToSuccessPage();
    } else {
      _navigateToFailurePage();
    }
  }

  void _navigateToSuccessPage() {
    final extras = PaymentSuccessExtras(
      orderId: widget.orderId,
      joinId: widget.joinId ?? '',
      isSchemeJoining: widget.isSchemeJoining,
      schemeName: widget.schemeName ?? 'Scheme',
      amount: widget.amount ?? '0',
    );
    context.go(PaymentSuccessPage.routeName, extra: extras.toMap());
  }

  void _navigateToFailurePage() {
    final extras = PaymentFailureExtras(
      orderId: widget.orderId,
      message: 'Payment was not completed successfully',
    );
    context.go(PaymentFailurePage.routeName, extra: extras.toMap());
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Payment'),
        content: const Text('Are you sure you want to cancel this payment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Payment'),
        backgroundColor: Palette.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _showCancelDialog,
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
