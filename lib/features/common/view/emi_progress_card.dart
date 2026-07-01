import 'package:flutter/material.dart';

class EmiProgressCard extends StatelessWidget {
  final int totalMonths;
  final int completedMonths;
  final Color activeColor;
  final Color inactiveColor;

  const EmiProgressCard({
    super.key,
    required this.totalMonths,
    required this.completedMonths,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Row(
      children: List.generate(totalMonths, (index) {
        final isCompleted = index < completedMonths;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.003),
            child: Container(
              height: w * 0.015,
              decoration: BoxDecoration(
                color: isCompleted ? activeColor : inactiveColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        );
      }),
    );
  }
}
