import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../theme/theme.dart';

class CustomSearchableDropdown<T> extends StatefulWidget {
  final String label;
  final List<T> items;
  final T? value;
  final String Function(T item) displayText;
  final String? hint;
  final String? searchHint;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final Widget? prefixIcon;
  final bool enabled;
  final DropdownStyle style;
  final int maxVisibleItems;

  const CustomSearchableDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.displayText,
    this.value,
    this.hint,
    this.searchHint,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.enabled = true,
    this.style = DropdownStyle.outlined,
    this.maxVisibleItems = 6,
  });

  @override
  State<CustomSearchableDropdown<T>> createState() =>
      _CustomSearchableDropdownState<T>();
}

class _CustomSearchableDropdownState<T>
    extends State<CustomSearchableDropdown<T>> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<T>(
      value: widget.value,
      items: _buildDropdownItems(),
      onChanged: widget.enabled ? widget.onChanged : null,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: _buildInputDecoration(),
      isExpanded: true,
      hint: widget.hint != null
          ? Text(
              widget.hint!,
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 14,
                color: Palette.hintTextColor,
              ),
            )
          : null,
      buttonStyleData: _buildButtonStyle(),
      dropdownStyleData: _buildDropdownStyle(),
      menuItemStyleData: _buildMenuItemStyle(),
      dropdownSearchData: _buildSearchData(),
      onMenuStateChange: (isOpen) {
        if (!isOpen) {
          _searchController.clear();
        }
      },
    );
  }

  List<DropdownMenuItem<T>> _buildDropdownItems() {
    return widget.items.map((item) {
      return DropdownMenuItem<T>(
        value: item,
        child: Text(
          widget.displayText(item),
          style: TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).brightness == Brightness.dark
                ? Palette.whiteColor
                : Palette.blackColor,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      );
    }).toList();
  }

  InputDecoration _buildInputDecoration() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (widget.style) {
      case DropdownStyle.filled:
        return _buildFilledDecoration(isDark);
      case DropdownStyle.outlined:
        return _buildOutlinedDecoration(isDark);
      case DropdownStyle.underlined:
        return _buildUnderlinedDecoration(isDark);
    }
  }

  InputDecoration _buildFilledDecoration(bool isDark) {
    return InputDecoration(
      labelText: widget.label,
      prefixIcon: widget.prefixIcon,
      filled: true,
      fillColor: isDark ? Colors.white.withOpacity(0.1) : Colors.grey.shade50,
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
        borderSide: BorderSide(
          color: Palette.primaryColor,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Palette.redColor,
          width: 2,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Palette.redColor,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      labelStyle: const TextStyle(
        fontFamily: 'Urbanist',
        fontSize: 14,
        color: Palette.primaryColor,
      ),
    );
  }

  InputDecoration _buildOutlinedDecoration(bool isDark) {
    return InputDecoration(
      labelText: widget.label,
      prefixIcon: widget.prefixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Palette.primaryColor,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Palette.redColor,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Palette.redColor,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      labelStyle: const TextStyle(
        fontFamily: 'Urbanist',
        fontSize: 14,
        color: Palette.primaryColor,
      ),
    );
  }

  InputDecoration _buildUnderlinedDecoration(bool isDark) {
    return InputDecoration(
      labelText: widget.label,
      prefixIcon: widget.prefixIcon,
      border: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Palette.primaryColor,
          width: 2,
        ),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Palette.redColor,
          width: 1,
        ),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Palette.redColor,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 16,
      ),
      labelStyle: const TextStyle(
        fontFamily: 'Urbanist',
        fontSize: 14,
        color: Palette.primaryColor,
      ),
    );
  }

  ButtonStyleData _buildButtonStyle() {
    return ButtonStyleData(
      height: 56,
      padding: const EdgeInsets.only(right: 8),
    );
  }

  DropdownStyleData _buildDropdownStyle() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DropdownStyleData(
      maxHeight: 56.0 * widget.maxVisibleItems,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
      ),
      offset: const Offset(0, -4),
      scrollbarTheme: ScrollbarThemeData(
        radius: const Radius.circular(40),
        thickness: WidgetStateProperty.all(6),
        thumbVisibility: WidgetStateProperty.all(true),
      ),
    );
  }

  MenuItemStyleData _buildMenuItemStyle() {
    return MenuItemStyleData(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  DropdownSearchData<T> _buildSearchData() {
    return DropdownSearchData<T>(
      searchController: _searchController,
      searchInnerWidgetHeight: 56,
      searchInnerWidget: Container(
        height: 56,
        padding: const EdgeInsets.all(8),
        child: TextFormField(
          controller: _searchController,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            hintText:
                widget.searchHint ?? 'Search ${widget.label.toLowerCase()}...',
            hintStyle: const TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 14,
              color: Palette.hintTextColor,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Palette.primaryColor,
                width: 2,
              ),
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: Palette.hintTextColor,
              size: 20,
            ),
          ),
        ),
      ),
      searchMatchFn: (item, searchValue) {
        return widget
            .displayText(item.value as T)
            .toLowerCase()
            .contains(searchValue.toLowerCase());
      },
    );
  }
}

enum DropdownStyle { filled, outlined, underlined }

// Helper class for common data models
class DropdownItem<T> {
  final T value;
  final String label;
  final Widget? icon;

  const DropdownItem({
    required this.value,
    required this.label,
    this.icon,
  });

  @override
  String toString() => label;
}
