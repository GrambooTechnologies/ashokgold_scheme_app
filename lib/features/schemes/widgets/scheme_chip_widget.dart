import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:flutter/material.dart';

class SchemeChipWidget extends StatelessWidget {
  final String text;
  final Color color;

  const SchemeChipWidget({
    super.key,
    required this.text,
    this.color = Palette.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: w * 0.035, vertical: h * 0.008),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(w * 0.02),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontSize: w * 0.031,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
