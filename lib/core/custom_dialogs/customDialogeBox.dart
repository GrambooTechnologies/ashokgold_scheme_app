import 'package:flutter/material.dart';

import '../theme/theme.dart';

enum DialogType { info, success, warning, destructive }

class AppDialog {
  AppDialog._();

  // ================= MAIN CONFIRMATION =================

  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool showCancelButton = true,
    bool barrierDismissible = true,
    DialogType type = DialogType.info,
    Widget? icon,
  }) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: "Dialog",
      barrierColor: Colors.black.withValues(alpha: 0.45),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (_, _, _) => const SizedBox(),
      transitionBuilder: (context, anim, _, _) {
        return Transform.scale(
          scale: Curves.easeOutBack.transform(anim.value),
          child: Opacity(
            opacity: anim.value,
            child: _DialogCard(
              title: title,
              message: message,
              confirmText: confirmText,
              cancelText: cancelText,
              showCancelButton: showCancelButton,
              type: type,
              icon: icon,
            ),
          ),
        );
      },
    );
  }

  // ================= QUICK METHODS =================

  static Future<bool?> showDeleteAccount({required BuildContext context}) {
    return showConfirmation(
      context: context,
      title: 'Delete Account',
      message:
          'Your account will be deleted within 30 days. You can log back in anytime during this period to cancel the request. After that, all your data will be permanently removed.',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      type: DialogType.destructive,
    );
  }

  static Future<bool?> showDeleteConfirmation({
    required BuildContext context,
    required String itemName,
    String? customMessage,
  }) {
    return showConfirmation(
      context: context,
      title: 'Delete $itemName',
      message:
          customMessage ??
          'This action cannot be undone. Do you want to continue?',
      confirmText: 'Delete',
      type: DialogType.destructive,
    );
  }

  static Future<bool?> showLogoutConfirmation({required BuildContext context}) {
    return showConfirmation(
      context: context,
      title: 'Logout',
      message: 'Are you sure you want to logout from your account?',
      confirmText: 'Logout',
      type: DialogType.warning,
    );
  }

  static Future<bool?> showSaveConfirmation({
    required BuildContext context,
    String? customMessage,
  }) {
    return showConfirmation(
      context: context,
      title: 'Save Changes',
      message: customMessage ?? 'Do you want to save your changes?',
      confirmText: 'Save',
      type: DialogType.success,
    );
  }

  static Future<bool?> showInfo({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
    Widget? icon,
  }) {
    return showConfirmation(
      context: context,
      title: title,
      message: message,
      confirmText: buttonText,
      showCancelButton: false,
      type: DialogType.info,
      icon: icon,
    );
  }
}

// ================= DIALOG UI =================

class _DialogCard extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final bool showCancelButton;
  final DialogType type;
  final Widget? icon;

  const _DialogCard({
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.showCancelButton,
    required this.type,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getColor(type);

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 28,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ================= ICON =================
              _DialogIcon(color: color, type: type, customIcon: icon),

              const SizedBox(height: 18),

              // ================= TITLE =================
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Palette.blackColor,
                ),
              ),

              const SizedBox(height: 10),

              // ================= MESSAGE =================
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 26),

              // ================= BUTTONS =================
              _DialogButtons(
                confirmText: confirmText,
                cancelText: cancelText,
                showCancelButton: showCancelButton,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= ICON =================

class _DialogIcon extends StatelessWidget {
  final Color color;
  final DialogType type;
  final Widget? customIcon;

  const _DialogIcon({required this.color, required this.type, this.customIcon});

  @override
  Widget build(BuildContext context) {
    if (customIcon != null) return customIcon!;

    IconData icon;

    switch (type) {
      case DialogType.success:
        icon = Icons.check_circle_rounded;
        break;
      case DialogType.warning:
        icon = Icons.warning_amber_rounded;
        break;
      case DialogType.destructive:
        icon = Icons.delete_forever_rounded;
        break;
      case DialogType.info:
      default:
        icon = Icons.info_rounded;
    }

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(child: Icon(icon, size: 32, color: color)),
    );
  }
}

// ================= BUTTONS =================

class _DialogButtons extends StatelessWidget {
  final String confirmText;
  final String cancelText;
  final bool showCancelButton;
  final Color color;

  const _DialogButtons({
    required this.confirmText,
    required this.cancelText,
    required this.showCancelButton,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showCancelButton) ...[
          Expanded(
            child: _SecondaryButton(
              text: cancelText,
              onTap: () => Navigator.pop(context, false),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: _PrimaryButton(
            text: confirmText,
            color: color,
            onTap: () => Navigator.pop(context, true),
          ),
        ),
      ],
    );
  }
}

// ================= PRIMARY BUTTON =================

class _PrimaryButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;

  const _PrimaryButton({
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// ================= SECONDARY BUTTON =================

class _SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _SecondaryButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

// ================= COLOR HELPER =================

Color _getColor(DialogType type) {
  switch (type) {
    case DialogType.success:
      return Colors.green;
    case DialogType.warning:
      return Colors.orange;
    case DialogType.destructive:
      return Colors.red;
    case DialogType.info:
    default:
      return Palette.primaryColor;
  }
}

// ================= EXTENSION =================

extension DialogExtension on BuildContext {
  Future<bool?> showConfirmationDialog({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool showCancelButton = true,
    DialogType type = DialogType.info,
    Widget? icon,
  }) {
    return AppDialog.showConfirmation(
      context: this,
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      showCancelButton: showCancelButton,
      type: type,
      icon: icon,
    );
  }

  Future<bool?> showDeleteDialog(String itemName, {String? customMessage}) {
    return AppDialog.showDeleteConfirmation(
      context: this,
      itemName: itemName,
      customMessage: customMessage,
    );
  }

  Future<bool?> showLogoutDialog() {
    return AppDialog.showLogoutConfirmation(context: this);
  }

  Future<bool?> showInfoDialog({
    required String title,
    required String message,
    String buttonText = 'OK',
    Widget? icon,
  }) {
    return AppDialog.showInfo(
      context: this,
      title: title,
      message: message,
      buttonText: buttonText,
      icon: icon,
    );
  }
}
