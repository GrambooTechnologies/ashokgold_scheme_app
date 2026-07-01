import 'package:flutter/material.dart';

import '../utilities/scale_size_utils.dart';

class FieldValueRow extends StatelessWidget {
  final String field;
  final String value;
  final EdgeInsets? padding;
  final Color? fieldColor;
  final Color? valueColor;
  final bool showDivider;

  const FieldValueRow({
    super.key,
    required this.field,
    required this.value,
    this.padding,
    this.fieldColor,
    this.valueColor,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Padding(
          padding: padding ??
              EdgeInsets.symmetric(
                horizontal: w * 0.05,
                vertical: h * 0.015,
              ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// FIELD
              Text(
                field,
                style: TextStyle(
                  fontSize: SizeConfig.w(context, 15),
                  fontWeight: FontWeight.w400,
                  color: fieldColor ?? Colors.black87,
                ),
              ),

              /// VALUE
              Text(
                value,
                style: TextStyle(
                  fontSize: SizeConfig.w(context, 15),
                  fontWeight: FontWeight.w700,
                  color: valueColor ?? Colors.black,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          CustomPaint(
            size: Size(w, 1),
            painter: const DottedDivider(),
          ),
      ],
    );
  }
}

class DottedDivider extends CustomPainter {
  const DottedDivider();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[400]!
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    const dashWidth = 5;
    const dashSpace = 5;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
