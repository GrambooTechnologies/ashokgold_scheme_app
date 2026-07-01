import 'package:flutter/material.dart';

class ProfileDivider extends StatelessWidget {
  final double width;

  const ProfileDivider({
    super.key,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.084),
      child: Divider(color: Colors.grey.shade300, height: 1),
    );
  }
}
