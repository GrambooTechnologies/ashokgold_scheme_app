import 'package:flutter/material.dart';
import 'package:ashokgold_scheme_app/core/theme/theme.dart';
import 'package:ashokgold_scheme_app/core/utilities/scale_size_utils.dart';

class NoItemsWidget extends StatelessWidget {
  final String? message;
  const NoItemsWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: SizeConfig.h(context, 32)),
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.h(context, 18),
          horizontal: SizeConfig.w(context, 24),
        ),
        decoration: BoxDecoration(
          color: Palette.cardColor,
          borderRadius: BorderRadius.circular(SizeConfig.w(context, 16)),
          boxShadow: [
            BoxShadow(
              color: Palette.shadowColor.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          message ?? 'No items to display',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Palette.primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: SizeConfig.h(context, 16),
          ),
        ),
      ),
    );
  }
}
