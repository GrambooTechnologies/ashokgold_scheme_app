import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:flutter/material.dart';

enum ButtonSize { small, medium, large }

class CustomFloatingButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Widget? icon;
  final bool isLoading;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? textColor;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;
  final ButtonSize size;

  /// NEW: Border customization
  final Color borderColor;
  final double borderWidth;

  const CustomFloatingButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius = 12,
    this.margin,
    this.size = ButtonSize.medium,
    this.textColor,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final buttonHeight = height ?? _getHeightForSize(size);
    final buttonWidth = width ?? screenWidth * 0.9;
    final fontSize = _getFontSizeForSize(size, screenWidth);
    final iconSize = _getIconSizeForSize(size, screenWidth);

    final effectiveTextColor = textColor ?? foregroundColor ?? Colors.white;

    return Container(
      width: buttonWidth,
      height: buttonHeight,
      margin: margin,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            backgroundColor ?? Palette.primaryColor,
          ),
          foregroundColor: WidgetStateProperty.all(effectiveTextColor),
          elevation: WidgetStateProperty.all(0),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 20),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              side: BorderSide(color: borderColor, width: borderWidth),
            ),
          ),
        ),
        child: _buildButtonContent(fontSize, iconSize, effectiveTextColor),
      ),
    );
  }

  Widget _buildButtonContent(
    double fontSize,
    double iconSize,
    Color textColor,
  ) {
    if (isLoading) {
      return SizedBox(
        width: iconSize,
        height: iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(textColor),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconTheme(
            data: IconThemeData(size: iconSize, color: textColor),
            child: icon!,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
                fontFamily: 'Urbanist',
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        fontFamily: 'Urbanist',
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  double _getHeightForSize(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return 40;
      case ButtonSize.medium:
        return 48;
      case ButtonSize.large:
        return 56;
    }
  }

  double _getFontSizeForSize(ButtonSize size, double screenWidth) {
    switch (size) {
      case ButtonSize.small:
        return screenWidth * 0.035;
      case ButtonSize.medium:
        return screenWidth * 0.042;
      case ButtonSize.large:
        return screenWidth * 0.048;
    }
  }

  double _getIconSizeForSize(ButtonSize size, double screenWidth) {
    switch (size) {
      case ButtonSize.small:
        return screenWidth * 0.04;
      case ButtonSize.medium:
        return screenWidth * 0.05;
      case ButtonSize.large:
        return screenWidth * 0.06;
    }
  }
}
