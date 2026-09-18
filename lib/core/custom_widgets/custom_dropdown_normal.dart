import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final String? label;
  final String? hint;
  final ValueChanged<T?>? onChanged;
  final Widget? prefixIcon;
  final bool enabled;
  final DropdownStyle style;
  final FormFieldValidator<T>? validator;

  const CustomDropdown({
    super.key,
    required this.items,
    this.value,
    this.label,
    this.hint,
    this.onChanged,
    this.prefixIcon,
    this.enabled = true,
    this.style = DropdownStyle.outlined,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: enabled ? onChanged : null,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: _buildInputDecoration(context),
      style: TextStyle(
        fontFamily: 'Urbanist',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).brightness == Brightness.dark
            ? Palette.whiteColor
            : Palette.blackColor,
      ),
      dropdownColor: _getDropdownColor(context),
      borderRadius: BorderRadius.circular(12),
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: enabled ? Palette.primaryColor : Palette.hintTextColor,
      ),
      isExpanded: true,
    );
  }

  InputDecoration _buildInputDecoration(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (style) {
      case DropdownStyle.filled:
        return _buildFilledDecoration(context, isDark);
      case DropdownStyle.outlined:
        return _buildOutlinedDecoration(context, isDark);
      case DropdownStyle.underlined:
        return _buildUnderlinedDecoration(context, isDark);
    }
  }

  InputDecoration _buildFilledDecoration(BuildContext context, bool isDark) {
    return InputDecoration(
      labelText: label,
      hintText: hint ?? label,
      prefixIcon: prefixIcon,
      filled: true,
      fillColor: isDark
          ? Colors.white.withValues(alpha: 0.1)
          : Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Palette.primaryColor, width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Palette.redColor, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Palette.redColor, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: TextStyle(
        fontFamily: 'Urbanist',
        fontSize: 14,
        color: Palette.primaryColor,
      ),
      hintStyle: TextStyle(
        fontFamily: 'Urbanist',
        fontSize: 14,
        color: Palette.hintTextColor,
      ),
    );
  }

  InputDecoration _buildOutlinedDecoration(BuildContext context, bool isDark) {
    return InputDecoration(
      labelText: label,
      hintText: hint ?? label,
      prefixIcon: prefixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Palette.primaryColor, width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Palette.redColor, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Palette.redColor, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: TextStyle(
        fontFamily: 'Urbanist',
        fontSize: 14,
        color: Palette.primaryColor,
      ),
      hintStyle: TextStyle(
        fontFamily: 'Urbanist',
        fontSize: 14,
        color: Palette.hintTextColor,
      ),
    );
  }

  InputDecoration _buildUnderlinedDecoration(
    BuildContext context,
    bool isDark,
  ) {
    return InputDecoration(
      labelText: label,
      hintText: hint ?? label,
      prefixIcon: prefixIcon,
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Palette.primaryColor, width: 1),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Palette.redColor, width: 1),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Palette.redColor, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
      labelStyle: TextStyle(
        fontFamily: 'Urbanist',
        fontSize: 14,
        color: Palette.primaryColor,
      ),
      hintStyle: TextStyle(
        fontFamily: 'Urbanist',
        fontSize: 14,
        color: Palette.hintTextColor,
      ),
    );
  }

  Color _getDropdownColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (style) {
      case DropdownStyle.filled:
        return isDark ? const Color(0xFF2A2A2A) : Colors.white;
      case DropdownStyle.outlined:
      case DropdownStyle.underlined:
        return isDark ? const Color(0xFF1E1E1E) : Colors.white;
    }
  }
}

enum DropdownStyle { filled, outlined, underlined }

// Helper widget for creating dropdown items easily
class DropdownHelper {
  static List<DropdownMenuItem<T>> buildItems<T>(
    Map<T, String> itemMap, {
    TextStyle? textStyle,
  }) {
    return itemMap.entries.map((entry) {
      return DropdownMenuItem<T>(
        value: entry.key,
        child: Text(
          entry.value,
          style:
              textStyle ??
              const TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
        ),
      );
    }).toList();
  }
}
