import 'package:flutter/material.dart';
import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/core/utilities/scale_size_utils.dart';

class CustomTimePicker extends StatelessWidget {
  final String label;
  final TimeOfDay? selectedTime;
  final ValueChanged<TimeOfDay?> onTimeSelected;

  const CustomTimePicker({
    super.key,
    required this.label,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final w = SizeConfig.w(context, 1);
    final h = SizeConfig.h(context, 1);

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: selectedTime ?? TimeOfDay.now(),
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
              onTimeSelected(picked);
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
                  color: selectedTime != null
                      ? Palette.primaryColor
                      : Colors.grey.shade300,
                  width: 1.2,
                ),
                boxShadow: [
                  if (selectedTime != null)
                    BoxShadow(
                      color: Palette.primaryColor.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    color: Palette.primaryColor,
                    size: w * 18,
                  ),
                  SizedBox(width: w * 12),
                  Expanded(
                    child: Text(
                      selectedTime != null
                          ? selectedTime!.format(context)
                          : label,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: w * 16,
                        color: selectedTime != null
                            ? Colors.black
                            : Colors.grey.shade600,
                        fontWeight: selectedTime != null
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
        if (selectedTime != null)
          Padding(
            padding: EdgeInsets.only(left: w * 8),
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => onTimeSelected(null),
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
