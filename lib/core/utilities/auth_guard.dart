import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/features/auth/providers/customer_provider.dart';
import 'package:ashokgold_scheme_app/features/auth/views/phone_number_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AuthGuard {
  /// Checks if user is authenticated.
  /// If not, shows login dialog AFTER build completes.
  static bool requireAuth(BuildContext context, WidgetRef ref) {
    final customer = ref.read(customerProvider);

    if (customer == null) {
      // Delay dialog until after build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          _showLoginRequiredDialog(context);
        }
      });

      return false;
    }

    return true;
  }

  static void _showLoginRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // optional: force user choice
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Login Required',
          style: TextStyle(color: Palette.primaryColor),
        ),
        content: const Text(
          'You need to login to access this feature. Please login to continue.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();

              // Navigate after dialog closes
              Future.microtask(() {
                if (context.mounted) {
                  context.push(PhoneNumberView.routeName);
                }
              });
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
