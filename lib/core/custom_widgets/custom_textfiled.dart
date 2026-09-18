import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum TextFieldStyle { filled, outlined, underlined }

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;
  final int maxLines;
  final int? maxLength;
  final TextFieldStyle style;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.onChanged,
    this.onTap,
    this.focusNode,
    this.keyboardType,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.maxLines = 1,
    this.maxLength,
    this.style = TextFieldStyle.outlined,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      readOnly: readOnly,
      enabled: enabled,
      autofocus: autofocus,
      maxLines: maxLines,
      maxLength: maxLength,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(
        fontFamily: 'Urbanist',
        fontSize: w * 0.038,
        fontWeight: FontWeight.w500,
        color: theme.brightness == Brightness.dark
            ? Palette.whiteColor
            : Palette.blackColor,
      ),
      decoration: _buildInputDecoration(context),
    );
  }

  InputDecoration _buildInputDecoration(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    switch (style) {
      case TextFieldStyle.filled:
        return _buildFilledDecoration(context, isDark);
      case TextFieldStyle.outlined:
        return _buildOutlinedDecoration(context, isDark);
      case TextFieldStyle.underlined:
        return _buildUnderlinedDecoration(context, isDark);
    }
  }

  InputDecoration _buildFilledDecoration(BuildContext context, bool isDark) {
    final w = MediaQuery.of(context).size.width;
    return InputDecoration(
      labelText: label,
      hintText: hint ?? label,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: isDark
          ? Colors.white.withValues(alpha: 0.1)
          : Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(w * 0.03),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(w * 0.03),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(w * 0.03),
        borderSide: BorderSide(color: Palette.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(w * 0.03),
        borderSide: BorderSide(color: Palette.redColor, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(w * 0.03),
        borderSide: BorderSide(color: Palette.redColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: TextStyle(
        fontFamily: 'Urbanist',
        fontSize: w * 0.038,
        color: Palette.primaryColor,
      ),
      hintStyle: TextStyle(
        fontFamily: 'Urbanist',
        fontSize: w * 0.038,
        color: Palette.hintTextColor,
      ),
      counterText: maxLength != null ? null : "",
    );
  }

  InputDecoration _buildOutlinedDecoration(BuildContext context, bool isDark) {
    final w = MediaQuery.of(context).size.width;
    return InputDecoration(
      labelText: label,
      hintText: hint ?? label,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(w * 0.03),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(w * 0.03),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(w * 0.03),
        borderSide: BorderSide(color: Palette.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(w * 0.03),
        borderSide: BorderSide(color: Palette.redColor, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(w * 0.03),
        borderSide: BorderSide(color: Palette.redColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: TextStyle(
        fontFamily: 'Urbanist',
        fontSize: w * 0.038,
        color: Palette.primaryColor,
      ),
      hintStyle: TextStyle(
        fontFamily: 'Urbanist',
        fontSize: w * 0.038,
        color: Palette.hintTextColor,
      ),
      counterText: maxLength != null ? null : "",
    );
  }

  InputDecoration _buildUnderlinedDecoration(
    BuildContext context,
    bool isDark,
  ) {
    final w = MediaQuery.of(context).size.width;
    return InputDecoration(
      labelText: label,
      hintText: hint ?? label,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Palette.primaryColor, width: 2),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Palette.redColor, width: 1),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Palette.redColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
      labelStyle: TextStyle(
        fontFamily: 'Urbanist',
        fontSize: w * 0.038,
        color: Palette.primaryColor,
      ),
      hintStyle: TextStyle(
        fontFamily: 'Urbanist',
        fontSize: w * 0.038,
        color: Palette.hintTextColor,
      ),
      counterText: maxLength != null ? null : "",
    );
  }
}
