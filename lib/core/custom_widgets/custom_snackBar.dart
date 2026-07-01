import 'package:flutter/material.dart';
import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:flutter/services.dart';

class AppSnackBar {
  AppSnackBar._();

  static void show(
    BuildContext context,
    String message, {
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    bool dismissPrevious = true,
    Widget? icon,
    VoidCallback? action,
    String? actionLabel,
  }) {
    if (dismissPrevious) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }

    final snackBar = SnackBar(
      content: _buildContent(message, icon, type),
      backgroundColor: _getBackgroundColor(type),
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      elevation: 4,
      action: action != null && actionLabel != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: Colors.white,
              onPressed: action,
            )
          : null,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void success(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    show(
      context,
      message,
      type: SnackBarType.success,
      duration: duration ?? const Duration(seconds: 3),
      icon: const Icon(
        Icons.check_circle_outline,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  static void error(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    show(
      context,
      message,
      type: SnackBarType.error,
      duration: duration ?? const Duration(seconds: 4),
      icon: const Icon(Icons.error_outline, color: Colors.white, size: 20),
    );
  }

  static void warning(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    show(
      context,
      message,
      type: SnackBarType.warning,
      duration: duration ?? const Duration(seconds: 3),
      icon: const Icon(
        Icons.warning_amber_outlined,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  static void info(BuildContext context, String message, {Duration? duration}) {
    show(
      context,
      message,
      type: SnackBarType.info,
      duration: duration ?? const Duration(seconds: 3),
      icon: const Icon(Icons.info_outline, color: Colors.white, size: 20),
    );
  }

  static Widget _buildContent(String message, Widget? icon, SnackBarType type) {
    return Row(
      children: [
        if (icon != null) ...[icon, const SizedBox(width: 12)],
        Expanded(
          child: GestureDetector(
            onLongPress: () {
              Clipboard.setData(ClipboardData(text: message));
            },
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  static Color _getBackgroundColor(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return const Color(0xFF4CAF50);
      case SnackBarType.error:
        return const Color(0xFFE53935);
      case SnackBarType.warning:
        return const Color(0xFFFF9800);
      case SnackBarType.info:
        return Palette.primaryColor;
    }
  }
}

enum SnackBarType { success, error, warning, info }

extension SnackBarExtension on BuildContext {
  void showSuccessSnackBar(String message, {Duration? duration}) {
    AppSnackBar.success(this, message, duration: duration);
  }

  void showErrorSnackBar(String message, {Duration? duration}) {
    AppSnackBar.error(this, message, duration: duration);
  }

  void showWarningSnackBar(String message, {Duration? duration}) {
    AppSnackBar.warning(this, message, duration: duration);
  }

  void showInfoSnackBar(String message, {Duration? duration}) {
    AppSnackBar.info(this, message, duration: duration);
  }

  void showSnackBar(
    String message, {
    SnackBarType type = SnackBarType.info,
    Duration? duration,
    Widget? icon,
    VoidCallback? action,
    String? actionLabel,
  }) {
    AppSnackBar.show(
      this,
      message,
      type: type,
      duration: duration ?? const Duration(seconds: 3),
      icon: icon,
      action: action,
      actionLabel: actionLabel,
    );
  }
}
