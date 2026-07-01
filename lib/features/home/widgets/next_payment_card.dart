import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:flutter/material.dart';

class NextPaymentCard extends StatelessWidget {
  final String amount;
  final String label;
  final String nextEmiDate;
  final VoidCallback onTap;

  const NextPaymentCard({
    super.key,
    required this.amount,
    required this.label,
    required this.nextEmiDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(left: w * 0.02, right: w * 0.02),
        child: Container(
          height: h * 0.14,
          width: w * 0.6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(w * 0.05),
            color: Palette.whiteColor,
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 8,
                spreadRadius: -5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.04,
              vertical: h * 0.01,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(top: h * 0.01, right: w * 0.01),
                    child: Icon(Icons.arrow_forward, size: w * 0.06),
                  ),
                ),
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: w * .045,
                    fontWeight: FontWeight.w800,
                    color: Palette.blackColor,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: w * .033,
                    fontFamily: 'Urbanist',
                    color: Palette.blackColor,
                  ),
                ),
                Text(
                  nextEmiDate,
                  style: TextStyle(
                    fontSize: w * .026,
                    fontFamily: 'Urbanist',
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
