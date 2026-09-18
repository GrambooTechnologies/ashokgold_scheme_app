import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/core/utilities/scale_size_utils.dart';
import 'package:flutter/material.dart';

class LoginRequiredWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;

  const LoginRequiredWidget({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.lock_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Palette.backgroundColor,
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.w(context, 20),
          ),
        ),
        centerTitle: false,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.w(context, 32)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: SizeConfig.w(context, 80),
                color: Palette.primaryColor.withValues(alpha: 0.5),
              ),
              SizedBox(height: SizeConfig.h(context, 24)),
              Text(
                'Login Required',
                style: TextStyle(
                  fontSize: SizeConfig.w(context, 22),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Urbanist',
                  color: Palette.blackColor,
                ),
              ),
              SizedBox(height: SizeConfig.h(context, 12)),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: SizeConfig.w(context, 16),
                  fontFamily: 'Urbanist',
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
