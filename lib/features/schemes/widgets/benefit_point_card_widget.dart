import 'package:flutter/material.dart';


// class BenefitPointCardWidget extends StatelessWidget {
//   final String description;
//   final int? priority;
//
//   const BenefitPointCardWidget({
//     super.key,
//     required this.description,
//     this.priority,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final w = MediaQuery.of(context).size.width;
//     final h = MediaQuery.of(context).size.height;
//
//     return Container(
//       padding: EdgeInsets.only(
//           right: w * 0.03, left: w * 0.03, bottom: h * 0.016, top: h * 0.02),
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(13), color: Color(0xFF203558)),
//       child: Center(
//         child: Text(
//           description,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: SizeConfig.w(context, 15),
//             height: 1.2,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }
// }
///
///
class BenefitPointListTile extends StatelessWidget {
  final String description;
  final int index;

  const BenefitPointListTile({
    super.key,
    required this.description,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              Icons.check_circle_outline_rounded,
              color: primaryColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          // Description Text
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 14.5,
                height: 1.4,
                fontWeight: FontWeight.w500,
                color: isDark 
                    ? Colors.white.withValues(alpha: 0.9) 
                    : Colors.black.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}