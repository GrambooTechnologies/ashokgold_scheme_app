import 'package:ashokgold_scheme_app/core/utilities/scale_size_utils.dart';
import 'package:flutter/material.dart';

class ErrorRetryWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorRetryWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red.shade300),
          SizedBox(height: SizeConfig.h(context, 16)),
          Text(
            message,
            style: TextStyle(
              fontSize: SizeConfig.w(context, 16),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: SizeConfig.h(context, 16)),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
