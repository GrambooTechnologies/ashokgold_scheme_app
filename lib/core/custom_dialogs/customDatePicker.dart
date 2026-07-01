import 'package:ashokgold_scheme_app/core/utilities/formatting/formatDate/format_dateTime.dart';
import 'package:flutter/material.dart';
import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/core/utilities/scale_size_utils.dart';

class CustomDatePicker extends StatefulWidget {
  final String label;
  final DateTime? selectedDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime?> onDateSelected;

  const CustomDatePicker({
    super.key,
    required this.label,
    required this.onDateSelected,
    required this.selectedDate,
    this.firstDate,
    this.lastDate,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  @override
  Widget build(BuildContext context) {
    final w = SizeConfig.w(context, 1);
    final h = SizeConfig.h(context, 1);

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                barrierDismissible: false,
                context: context,
                initialDate: widget.selectedDate ?? DateTime.now(),
                firstDate: widget.firstDate ?? DateTime(2000),
                lastDate: widget.lastDate ?? DateTime(2100),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: Palette.primaryColor,
                        onPrimary: Colors.white,
                        onSurface: Colors.black,
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: Palette.primaryColor,
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              widget.onDateSelected(picked);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: h * 14,
                horizontal: w * 16,
              ),
              decoration: BoxDecoration(
                color: Palette.backgroundColor,
                borderRadius: BorderRadius.circular(w * 12),
                border: Border.all(
                  color: widget.selectedDate != null
                      ? Palette.primaryColor
                      : Colors.grey.shade300,
                  width: 1.2,
                ),
                boxShadow: [
                  if (widget.selectedDate != null)
                    BoxShadow(
                      color: Palette.primaryColor.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    color: Palette.primaryColor,
                    size: w * 18,
                  ),
                  SizedBox(width: w * 12),
                  Expanded(
                    child: Text(
                      widget.selectedDate != null
                          ? FormatDateTime.dateTimeToDDMMYYYY(
                              widget.selectedDate!,
                            )
                          : widget.label,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: w * 16,
                        color: widget.selectedDate != null
                            ? Colors.black
                            : Colors.grey.shade600,
                        fontWeight: widget.selectedDate != null
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (widget.selectedDate != null)
          Padding(
            padding: EdgeInsets.only(left: w * 8),
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => widget.onDateSelected(null),
                child: Padding(
                  padding: EdgeInsets.all(w * 4),
                  child: Icon(
                    Icons.clear_rounded,
                    color: Palette.primaryColor,
                    size: w * 20,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
