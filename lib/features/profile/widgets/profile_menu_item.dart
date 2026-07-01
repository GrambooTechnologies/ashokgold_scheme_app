import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileMenuItem extends StatelessWidget {
  final double width;
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.width,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(
          top: width * 0.04,
          right: width * 0.07,
          left: width * 0.075,
          bottom: width * 0.04,
        ),
        child: Row(
          children: [
            SizedBox(width: width * 0.01),
            Icon(icon, size: width * 0.045),
            SizedBox(width: width * 0.03),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.036,
                    color: Colors.grey.shade800,
                  ),
            ),
            const Spacer(),
            Icon(CupertinoIcons.right_chevron, size: width * 0.03),
            SizedBox(width: width * 0.02),
          ],
        ),
      ),
    );
  }
}
